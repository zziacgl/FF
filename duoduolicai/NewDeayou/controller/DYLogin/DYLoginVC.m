//
//  DYLoginVC.m
//  NewDeayou
//
//  Created by wayne on 14-7-8.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYLoginVC.h"
#import "DYAppDelegate.h"
#import "DYUpdateLoginPwdViewController.h"
#import "DYRegistViewController.h"
#import "CodeLoginViewController.h"
#import "DYMainTabBarController.h"
#define kUserInfoUserName       @"kUserInfoPhoneNumber"
#define kUserInfoUserPassword   @"kUserInfoUserPassword"

@interface DYLoginVC ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgIsRemenberPassword;//是否记住密码
//@property (strong, nonatomic) IBOutlet UIImageView *imgIsAutoLoad;//是否自动登陆

@property (nonatomic,retain) NSMutableDictionary * dicUserInfo;//记录账号和密码
@property (strong, nonatomic) IBOutlet UITextField *tfUserName;
@property (strong, nonatomic) IBOutlet UITextField *tfUserPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLoad; //登录按钮



@end

@implementation DYLoginVC



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor  = kBackColor;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor  = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"登录";
    [self viewDidAfterLoad];
    self.view.backgroundColor = kBackColor;
    
    //
    _btnLoad.layer.cornerRadius=22;
    _btnLoad.layer.masksToBounds=YES;
    _btnLoad.backgroundColor=kBtnColor;
    
    //初始化
    _dicUserInfo=[NSMutableDictionary new];
    
//    //设置账号，密码
//    NSArray * aryUserInfo=[DYUser loginGetUserNameAndPassword];
//    //    NSLog(@"记住密码%@", aryUserInfo);
//    _tfUserName.text=aryUserInfo[0];
//    _tfUserPassword.text=aryUserInfo[1];
//
//    //        设置是否记住密码，还自动登陆
//    _imgIsRemenberPassword.highlighted=[DYUser loginIsRemenberPassword];
    
    CGSize btnImageSize = CGSizeMake(44, 44);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"loginclose"] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    
}
-(void)exitAction{
    
    [DYUser loginExit];
    [self dismissViewControllerAnimated:YES completion:nil];
//    DYAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
//
//    [appDelegate.window addSubview:appDelegate.mainTabBarVC.view];
//    [appDelegate.window sendSubviewToBack:appDelegate.mainTabBarVC.view];
//
//    [UIView transitionFromView:appDelegate.window.rootViewController.view toView:appDelegate.mainTabBarVC.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished)
//     {
//         //改变rootViewController
//         appDelegate.window.rootViewController=appDelegate.mainTabBarVC;
//     }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(CAAnimation*)animationer
{
    CATransition * trans=[CATransition animation];
    trans.duration=1;
    trans.type=@"rippleEffect";
    return trans;
}


//注册成功的代理
-(void)registSuccessWithUserName:(NSString*)userName password:(NSString*)password
{
    _tfUserName.text=userName;
    _tfUserPassword.text=password;
}

#pragma mark- buttonActions


//注册新用户
- (IBAction)regist:(id)sender
{
    [MobClick event:@"register_click"];
    DYRegistViewController * registVC=[[DYRegistViewController alloc]initWithNibName:@"DYRegistViewController" bundle:nil];
    registVC.loginVC=self;
    registVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registVC animated:YES];
    
}

//忘记密码
- (IBAction)forgetPassword:(UIButton *)sender
{
    //    NSLog(@"忘记密码");
    DYUpdateLoginPwdViewController * updatePasswordVC=[[DYUpdateLoginPwdViewController alloc]initWithNibName:@"DYUpdateLoginPwdViewController" bundle:nil];
    updatePasswordVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:updatePasswordVC animated:YES];
}


// 登陆
- (IBAction)loginabc:(UIButton *)sender
{
     [MobClick event:@"Login_click"];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:_tfUserName.text forKey:@"UserName"];//保存用户名
    
    //    NSLog(@"%@", ud);
    sender.userInteractionEnabled=NO;
    [self.view endEditing:YES];
    
    //过滤信息是否填写完整
    if (_tfUserName.text.length<1||_tfUserPassword.text.length<1)
    {
        [MBProgressHUD hideAllHUDsForView:nil animated:YES];
        [LeafNotification showInController:self withText:@"请完善信息"];
        sender.userInteractionEnabled=YES;
        return;
    }
    
    [MBProgressHUD hudWithView:nil label:@"登录中..."];
    sender.userInteractionEnabled=YES;
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:_tfUserPassword.text forKey:@"password" atIndex:0];
    [diyouDic insertObject:[DYUtils stringToUnicode:_tfUserName.text] forKey:@"loginname" atIndex:0];
    [diyouDic insertObject:@"login" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         [MBProgressHUD hideAllHUDsForView:nil animated:YES];
         if (isSuccess)
         {
             NSLog(@"gggggggggg%@", object);
             //用户数据持久化
             [DYUser userIDPersistence:object];
             [DYUser DYUser].userName=_tfUserName.text;
             [DYUser loginRemenberUserName:_tfUserName.text password:_tfUserPassword.text];
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:@"1" forKey:@"isRefreshAcount"];
             [ud setObject:@"1" forKey:@"isRefreshTuiJian"];
             [ud setObject:@"1" forKey:@"isRefreshMain"];
             [ud setObject:@"1" forKey:@"isRefreshLingQianBao"];
             [ud setObject:@"1" forKey:@"isLoadingMain"];
             [ud setObject:@"1" forKey:@"isShowXW"];
             [ud setObject:@"1" forKey:@"登录"];
             [ud setObject:@"0" forKey:@"verifyNumber_loginVerify"];
             [self GetLingQingBao];
             
  
             
             NSMutableDictionary *dic=[NSMutableDictionary dictionary];
             dic[@"手机号"]=_tfUserName.text;
             dic[@"ID"]=[NSString stringWithFormat:@"%d",[DYUser GetUserID]];
             
             NSString *isShouShi=[NSString stringWithFormat:@"%@",[ud objectForKey:@"isShouShi"]];
             if ([isShouShi isEqualToString:@"1"]) {
                 [ud setObject:@"0" forKey:@"isShouShi"];
                 [ud setObject:@"0" forKey:Gesture_Password_Open];
                 
             }
             
             
         }
         else
         {
             NSMutableDictionary *dic=[NSMutableDictionary dictionary];
             dic[@"手机号"]=_tfUserName.text;
             dic[@"失败原因"]=errorMessage;
             
             [LeafNotification showInController:self withText:errorMessage];
         }
         
     } errorBlock:^(id error)
     {
         NSMutableDictionary *dic=[NSMutableDictionary dictionary];
         dic[@"手机号"]=_tfUserName.text;
         dic[@"失败原因"]=@"网络异常";
         
         [MBProgressHUD hideAllHUDsForView:nil animated:YES];
         [LeafNotification showInController:self withText:@"网络异常"];
         
     }];
    
}


-(void)GetLingQingBao
{
    __weak __typeof(self)weakSelf = self;

    [MBProgressHUD hudWithView:self.view label:@"数据请求中"];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"lqb" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_lqb_info" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (success==YES) {
             //可用信用额度数据填充
             NSDictionary *dataDic=object;
             float annual=[[dataDic objectForKey:@"annual"] floatValue];
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:[NSString stringWithFormat:@"%.2f",annual] forKey:@"annual"];
             [ud setObject:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"gotexpgold"]] forKey:@"gotexpgold"];
             //数据持久化
             
              [DYUser loginHiddenLoginView];
             [weakSelf dismissViewControllerAnimated:YES completion:^{
                 DYMainTabBarController *tabBarVC = (DYMainTabBarController *)[DYAppDelegate getAppDelegate].window.rootViewController ;
                 
                 tabBarVC.selectedIndex = 0;
                 
                 
                 
             }];
            
             
         }
         else
         {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
    
}

#pragma mark- textFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //如果当前是输入账号，就切换到输入密码
    if (textField==_tfUserName)
    {
        [_tfUserPassword becomeFirstResponder];
    }
    else
    {
        [textField endEditing:YES];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
#pragma mark -- 使用手机验证码登录
- (IBAction)useCodeLogin:(UIButton *)sender {
     [MobClick event:@"Login_phone"];
    CodeLoginViewController *codeVC = [[CodeLoginViewController alloc] initWithNibName:@"CodeLoginViewController" bundle:nil];
    [self.navigationController pushViewController:codeVC animated:YES];
}


#pragma mark- UIAlertViewDelegete
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    if (buttonIndex==1) {
        
        if ([DYUser showLockSecretViewForSetLockPasswordsWithCurrentViewcontroller:self.navigationController isReset:NO]) {
            [ud setObject:@"1" forKey:@"isLock"];
        }else{
            [ud setObject:@"0" forKey:@"isLock"];
        }
    }else{
        [ud setObject:@"0" forKey:@"isLock"];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

