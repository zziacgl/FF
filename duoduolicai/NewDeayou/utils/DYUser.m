//
//  DYUser.m
//  NewDeayou
//
//  Created by wayne on 14-6-20.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYUser.h"
#import "DYAppDelegate.h"
#import "DYDrawPatternLockVC.h"
#import "DYLoginVC.h"
#import "DYMainTabBarController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "DYLoginVC.h"
#import "DYBaseNVC.h"
typedef void(^AnnimationFinishedBlock)(void);

@interface DYUser()

//@property(nonatomic,copy)AnnimationFinishedBlock  annimationBlockFinished;

@end

@implementation DYUser


static DYUser * user;


//创建单例
+(DYUser*)DYUser
{
    if (!user)
    {
        user = [[DYUser alloc]init];
        user.isRealNameApprove = NO;
        user.isPhoneApprove = NO;
        user.isEmailApprove = NO;
        user.isSetApprove = NO;
    }
    return user;
}

+(void)dropOutUser
{
    user=nil;
}

-(NSString*)userName
{
    if ([_userName isKindOfClass:[NSString class]] )
    {
        return _userName;
    }
    return @"";
}

-(NSString*)userId
{
    if (!_userId)
    {
        _userId=[NSString stringWithFormat:@"%d",[DYUser GetUserID]];
    }
    return _userId;
}
- (NSString *)loginkey {
    if (!_loginkey) {
        _loginkey = [NSString stringWithFormat:@"%@", [DYUser GetLoginKey]];
    }
    return _loginkey;
}
//获取用户信息
-(void)getUserData
{
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"dyp2p" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_users" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork2 operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success==YES)
         {
           
         }
         else
         {
            // [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
         }
         
     } errorBlock:^(id error)
     {
       //  [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
     }];
    
    
}

//-------------------锁屏视图-------------------
#pragma mark- ---LockView


#define kLockSecretPassWords   @"kLockSecretPassWords" //储存解锁密码

//判断是否有设置了密码
+(BOOL)isHasLock
{
    id password=[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",[DYUser DYUser].userId,kLockSecretPassWords]];
    if ([password isKindOfClass:[NSString class]])
    {
        if ([password length]>1)
        {
            return YES;
        }
    }
    return NO;
}

//检查手势密码是否输入正确
+(BOOL)isRightForLockPasswords:(NSString*)passwords
{
    id initialPassword=[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",[DYUser DYUser].userId,kLockSecretPassWords]];
    if ([initialPassword isKindOfClass:[NSString class]])
    {
        if ([initialPassword isEqualToString:passwords])
        {
            return YES;
        }
    }
    return NO;
}

//获取手势密码
+(NSString*)getLockViewPassword
{
    id initialPassword=[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",[DYUser DYUser].userId,kLockSecretPassWords]];
    if ([initialPassword isKindOfClass:[NSString class]])
    {
        return initialPassword;
    }
    return @"";
}

//设置锁屏密码
+(void)setLockSecretPasswords:(NSString*)passwords
{
    [[NSUserDefaults standardUserDefaults]setObject:passwords forKey:[NSString stringWithFormat:@"%@%@",[DYUser DYUser].userId,kLockSecretPassWords]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

//取消手势锁
+(void)cancelLockSecret
{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:[NSString stringWithFormat:@"%@%@",[DYUser DYUser].userId,kLockSecretPassWords]];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//显示解锁屏幕
+(BOOL)showLockSecretViewForDeblocking
{
    if (![DYUser loginIsLogin])
    {
        return NO;
    }
    
    if ([DYUser isHasLock])
    {
        DYDrawPatternLockVC *lockVC=[[DYDrawPatternLockVC alloc]initWithLockType:LockViewTypeDeblocking];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:lockVC];
        nav.view.tag=777;
        DYAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
        
        if (appDelegate.window.rootViewController.view.tag==777)
        {
            return YES;
        }
        else if(appDelegate.window.rootViewController)
        {
            if (!appDelegate.window.rootViewController.presentedViewController)
            {
                [appDelegate.window.rootViewController presentViewController:nav animated:NO completion:nil];
            }
        }
        else
        {
            appDelegate.window.rootViewController=nav;
        }
        
        
        return YES;
    }
    return NO;
}

////显示设置密码屏幕
+(BOOL)showLockSecretViewForSetLockPasswordsWithCurrentViewcontroller:(UIViewController*)currentVC isReset:(BOOL)reset
{
    
    if (!reset&&[DYUser isHasLock])
    {
        return NO;
    }
    
    DYDrawPatternLockVC *lockVC=[[DYDrawPatternLockVC alloc]initWithLockType:reset?LockViewTypeResetPasswords:LockViewTypeSetPasswords];
    if (reset)
    {
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:lockVC];
        
        [currentVC presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        UINavigationController * nvc=(UINavigationController*)currentVC;
        [nvc pushViewController:lockVC animated:YES];
  
    }
    
    return YES;
    
    
}

//设置TouchID指纹
+(BOOL)setTounchID{
    BOOL result = false;
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        result = true;
    }
    
    return result;
}


#pragma mark-

////设置支付密码
//+(void)shouDYPayPasswordVC:(UIViewController*)currentVC
//{
//    DYPayPasswordVC * bankVC=[[DYPayPasswordVC alloc]initWithNibName:@"DYPayPasswordVC" bundle:nil];
//    bankVC.hidesBottomBarWhenPushed=YES;
//    [currentVC.navigationController pushViewController:bankVC animated:YES];
//
//    
//    
//}




//--------------------自定义功能控件--------------------
#pragma mark- ---CustomBox


#define kCustomBoxIsNeedInit        @"isInitCustomBox"   //判断是否需要初始化自定义box
#define kCustomBoxUsedKey    @"kCustomBoxDefaultUsedKey"    //使用box的Key
#define kCustomBoxMoreValue     @"999"                      //更多的box
#define kCustomBoxDefaultUsedValue  @[/*@"0",@"1",@"2",@"5",*/@"3",@"4",@"6",kCustomBoxMoreValue] //默认使用的box
#define kCustomBoxAllValue          @[/*@"0",@"1",@"2",@"5",*/@"3",@"4",@"6",kCustomBoxMoreValue] //总的box
#define kCustomBoxMoreIsNeedHide  NO                   //是否需要隐藏更多按钮

//获取已设置的box包括"更多"
+(NSArray*)customBoxUsedAllValues
{
    [DYUser customBoxIsNeedInit];
    NSMutableArray * aryCustomBox=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:kCustomBoxUsedKey]];
    NSMutableArray * aryChoosed=[NSMutableArray arrayWithArray:aryCustomBox];
    for (NSString * box in aryCustomBox)
    {
        if (![kCustomBoxAllValue containsObject:box])
        {
            [aryChoosed removeObject:box];
        }
    }
    return aryChoosed;
}

//获取已设置的box
+(NSArray*)customBoxUsedValues
{
    
    NSMutableArray * boxUsed=[NSMutableArray arrayWithArray:[self customBoxUsedAllValues]];
    
    if(kCustomBoxMoreIsNeedHide)
    {
        if (boxUsed.count==kCustomBoxAllValue.count)
        {
            [boxUsed removeObject:kCustomBoxMoreValue];
        }
    }
    return boxUsed ;
}

//获取未设置的box
+(NSArray*)customBoxNotUsedValues
{
    NSMutableArray * boxAllValue=[NSMutableArray arrayWithArray:kCustomBoxAllValue];
    NSArray * boxUsedValue=[DYUser customBoxUsedValues];
    [boxAllValue removeObjectsInArray:boxUsedValue];
    [boxAllValue removeObject:kCustomBoxMoreValue];
    return boxAllValue;
}

//添加自定义box
+(void)insertUsedBoxWithValue:(NSString*)value
{
    NSMutableArray * usedBox=[NSMutableArray arrayWithArray:[DYUser customBoxUsedAllValues]];
    NSInteger  location=usedBox.count-1;
    if (location>=0)
    {
        [usedBox insertObject:value atIndex:location];
    }
    [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithArray:usedBox] forKey:kCustomBoxUsedKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [DYUser postNotificationCustomBoxAdd];
}

//移除自定义box
+(void)removeUsedBoxWithValue:(NSString*)value
{
    NSMutableArray * usedBox=[NSMutableArray arrayWithArray:[DYUser customBoxUsedAllValues]];
    [usedBox removeObject:value];
    [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithArray:usedBox] forKey:kCustomBoxUsedKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//判断是否需要初始化自定义box
+(void)customBoxIsNeedInit
{
    NSString * boxValue=@"CustomBox";
    NSString * customBox=[[NSUserDefaults standardUserDefaults]objectForKey:kCustomBoxIsNeedInit];
    if ([customBox isKindOfClass:[NSString class]])
    {
        if ([customBox isEqualToString:boxValue])
        {
            return;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:boxValue forKey:kCustomBoxIsNeedInit];
    [[NSUserDefaults standardUserDefaults] setObject:kCustomBoxDefaultUsedValue forKey:kCustomBoxUsedKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//发送添加自动以box的通知
+(void)postNotificationCustomBoxAdd
{
    [[NSNotificationCenter defaultCenter]postNotification:[[NSNotification alloc] initWithName:kNotificationCustomBoxAdd object:nil userInfo:nil]];
}



//------------------------登陆设置-----------------------
#pragma mark- loginSetting

#define kLoginIsRemenberPassword    @"kLoginIsRemenberPassword"
#define kLoginIsAutomaticLogin      @"kLoginIsAutomaticLogin"
#define kLoginUserName              @"fuckfuckfuck"
#define kLoginUserPassword          @"wawawahahaha"
#define kLoginIsLogin               @"kLoginIsLogin"
#define kUserID                     @"kUserID"
#define kLoginKey                   @"kLoginKey"
#define kXWStatus                   @"kXWStatus"


//判断是否记住密码
+(BOOL)loginIsRemenberPassword
{
    id   encodePassword=[[NSUserDefaults standardUserDefaults]objectForKey:kLoginUserPassword];
    if ([encodePassword isKindOfClass:[NSString class]])
    {
        NSString *password=encodePassword;
        if (password.length<1)
        {
            return NO;
        }
    }
    NSString * decodePassword=[[NSString alloc]initWithData:[encodePassword AES256DecryptWithKey:kDiyou_key] encoding:NSUTF8StringEncoding];
    if ([decodePassword isKindOfClass:[NSString class]])
    {
        if ([decodePassword length]>0)
        {
            return YES;
        }
    }
    return NO;
}

//记住密码
+(void)loginRemenberUserName:(NSString*)userName password:(NSString*)password
{
    NSData * encodeName=[[userName dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:kDiyou_key];
    NSData * encodePassword=[[password dataUsingEncoding:NSUTF8StringEncoding]AES256EncryptWithKey:kDiyou_key];
    
    [[NSUserDefaults standardUserDefaults]setObject:encodeName forKey:kLoginUserName];
    [[NSUserDefaults standardUserDefaults]setObject:encodePassword forKey:kLoginUserPassword];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//取消记住密码
+(void)loginCancelRemenberPassword
{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kLoginUserName];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kLoginUserPassword];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setObject:@"wangji" forKey:@"quxiao"];
}

//读取账号和密码
+(NSArray*)loginGetUserNameAndPassword
{
    id  encodeName=[[NSUserDefaults standardUserDefaults]objectForKey:kLoginUserName];
    id   encodePassword=[[NSUserDefaults standardUserDefaults]objectForKey:kLoginUserPassword];
    
    if ([encodeName isKindOfClass:[NSString class]])
    {
        NSString * name=(NSString*)encodeName;
        if (name.length<1)
        {
            NSArray * userInfo=@[@"",@""];
            return userInfo;
        }
    }
//    NSLog(@"%@",NSHomeDirectory());
    NSString * decodeName=[[NSString alloc]initWithData:[encodeName AES256DecryptWithKey:kDiyou_key] encoding:NSUTF8StringEncoding];
    NSString * decodePassword=[[NSString alloc]initWithData:[encodePassword AES256DecryptWithKey:kDiyou_key] encoding:NSUTF8StringEncoding];
    
    NSArray * userInfo=@[decodeName,decodePassword];
    return userInfo;
}

//判断是否已登录
+(BOOL)loginIsLogin
{
    id  isLogin=[[NSUserDefaults standardUserDefaults]objectForKey:kLoginIsLogin];
    if ([isLogin isKindOfClass:[NSString class]])
    {
        if ([isLogin isEqualToString:kLoginIsLogin])
        {
            return YES;
        }
    }
    return NO;
}

//设置已经登录
+(void)loginSetLogin
{
    [[NSUserDefaults standardUserDefaults]setObject:kLoginIsLogin forKey:kLoginIsLogin];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//注销登录
+(void)loginCancelLogin
{
    [DYUser dropOutUser];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kLoginIsLogin];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [DYUser loginShowLoginView];
}

//退出登录
+(void)loginExit{
    [DYUser dropOutUser];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kLoginIsLogin];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
//显示登陆界面
+(void)loginShowLoginView
{
    
    if ([DYUser loginIsLogin])
    {
        return;
    }
    
    UIApplication.sharedApplication.delegate.window.rootViewController = DYMainTabBarController.new;
    DYLoginVC *loginVC = [[DYLoginVC alloc] initWithNibName:@"DYLoginVC" bundle:nil];
    DYBaseNVC *nav = [[DYBaseNVC alloc] initWithRootViewController:loginVC];
    
    [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:nav animated:YES completion:NULL];
//    DYAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
//
//    DYLoginVC * loginVC=[[DYLoginVC alloc]initWithNibName:@"DYLoginVC" bundle:nil];
//    UINavigationController * loginNVC=[[UINavigationController alloc]initWithRootViewController:loginVC];
//
//    if (appDelegate.window.rootViewController)
//    {
//        [appDelegate.window addSubview:loginNVC.view];
//        [appDelegate.window sendSubviewToBack:loginNVC.view];
//
//        UIView * fromView=appDelegate.window.rootViewController.presentedViewController?appDelegate.window.rootViewController.presentedViewController.view:appDelegate.window.rootViewController.view;
//        [UIView transitionFromView:fromView toView:loginNVC.view duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished)
//         {
//             appDelegate.window.rootViewController=loginNVC;
//             appDelegate.mainTabBarVC=nil;
//         }];
//    }
//    else
//    {
//        appDelegate.window.rootViewController=loginNVC;
//        appDelegate.mainTabBarVC=nil;
//    }
//
    
}



//登录成功隐藏登陆界面
+(void)loginHiddenLoginView
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"1" forKey:@"isLock"];
    [ud synchronize];
    //设置已经登录
    [DYUser loginSetLogin];
    
//    DYAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
    
//    [appDelegate.window addSubview:appDelegate.mainTabBarVC.view];
//    [appDelegate.window sendSubviewToBack:appDelegate.mainTabBarVC.view];
//    
//    [UIView transitionFromView:appDelegate.window.rootViewController.view toView:appDelegate.mainTabBarVC.view duration:1 options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL finished)
//     {
//         //改变rootViewController
//         appDelegate.window.rootViewController=appDelegate.mainTabBarVC;
//     }];
    
//    appDelegate.window.rootViewController=appDelegate.mainTabBarVC;
}

//用户id持久化
+(void)userIDPersistence:(id)data{
    
     //用户id
    NSString * encodeUserID=[NSString stringWithFormat:@"%@",[data objectForKey:@"user_id"]];
    [DYUser DYUser].userId=encodeUserID;
    [[NSUserDefaults standardUserDefaults]setObject:encodeUserID forKey:kUserID];
    
    //登录key  loginkey
    NSString * loginKeyData=[NSString stringWithFormat:@"%@", [data objectForKey:@"login_key"]];
    [DYUser DYUser].loginkey = loginKeyData;
//    NSData * encodeLoginKey=[loginKeyData AES256EncryptWithKey:kDiyou_key];
    [[NSUserDefaults standardUserDefaults]setObject:loginKeyData forKey:kLoginKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

+ (NSString *)GetLoginKey {
    NSString *loginKey = @"";
    id myloginKey = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey];
    if (!myloginKey || [myloginKey isKindOfClass:[NSNull class]]) {
        myloginKey = @"";
    }
    loginKey = [NSString stringWithFormat:@"%@", myloginKey];
    return loginKey;
}
//设置新网状态
+(void)setXW_Status:(int)status{
    
    [DYUser DYUser].XWstatus = status;
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",status] forKey:kXWStatus];
    [[NSUserDefaults standardUserDefaults]synchronize];

}
//获得新网状态
+(NSString *)getXW_Status{
    
    NSString *XW_Status = @"";
    id XWStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kXWStatus];
    if (!XWStatus || [XWStatus isKindOfClass:[NSNull class]]) {
        XW_Status = @"";
    }
    XW_Status = [NSString stringWithFormat:@"%@", XWStatus];
    return XW_Status;

    
}
//获取用户id
+(int)GetUserID
{
    int userID;
    id  encodeUserID=[[NSUserDefaults standardUserDefaults]objectForKey:kUserID];
    if (!encodeUserID||[encodeUserID isKindOfClass:[NSNull class]])
    {
        encodeUserID=@"";
    }
    userID=[[NSString stringWithFormat:@"%@",encodeUserID]intValue];
//    userID=52232;
    return userID;
}



@end
