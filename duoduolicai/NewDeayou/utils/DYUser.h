//
//  DYUser.h
//  NewDeayou
//
//  Created by wayne on 14-6-20.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Base64.h"
#import "DDBase.h"


#pragma mark- ---CustomBox

#define kNotificationCustomBoxAdd @"kNotificationCustomBoxAdd"

@interface DYUser : NSObject

@property(nonatomic,assign)NSInteger age;
@property(nonatomic,copy) NSString * userName;
@property(nonatomic,copy) NSString * accountBank;
@property(nonatomic,copy) NSString * accountBankAll;
@property(nonatomic,copy) NSString * phone;
@property(nonatomic,copy) NSString * bankID;
@property(nonatomic,copy) NSString * userId;
@property(nonatomic,copy) NSString * loginkey;
@property(nonatomic) int XWstatus;
@property(nonatomic,assign)BOOL isRealNameApprove;//实名认证
@property(nonatomic,assign)BOOL isPhoneApprove;//电话认证
@property(nonatomic,assign)BOOL isEmailApprove;//邮箱认证
@property(nonatomic,assign)BOOL isSetApprove;//密码设置认证

@property(nonatomic,assign)BOOL rel;//指纹解锁结果

//创建单例
+(DYUser*)DYUser;

//-------------------锁屏视图-------------------
#pragma mark- ---LockView

//检查手势密码是否输入正确
+(BOOL)isRightForLockPasswords:(NSString*)passwords;

//设置锁屏密码
+(void)setLockSecretPasswords:(NSString*)passwords;

//获取手势密码
+(NSString*)getLockViewPassword;

//取消手势锁
+(void)cancelLockSecret;

//显示解锁屏幕
+(BOOL)showLockSecretViewForDeblocking;

//显示设置密码屏幕
+(BOOL)showLockSecretViewForSetLockPasswordsWithCurrentViewcontroller:(UIViewController*)currentVC isReset:(BOOL)reset;

//设置TouchID指纹
+(BOOL)setTounchID;

//显示指纹解锁屏幕
+(void)showTouchID:(UIViewController *)vc;

+ (NSString *)GetLoginKey;
#pragma mark- --------
////显示手机绑定
//+(void)showPhoneVerificationWithCurrentViewcontroller:(UIViewController*)currentVC userData:(id)userData;
//
//
////显示邮箱激活界面
//+(void)showEmailActivationWithCurrentViewcontroller:(UIViewController*)currentVC  userData:(id)userData;

////显示实名制认证界面
//+(void)showNameSystemCertificationWithCurrentViewcontroller:(UIViewController*)currentVC userData:(id)userData;

////显示修改银行卡
//+(void)showModifyBankCardsWithCurrentViewcontroller:(UIViewController*)currentVC;

//显示支付密码
//+(void)shouDYPayPasswordVC:(UIViewController*)currentVC;




//--------------------自定义功能控件--------------------
#pragma mark- ---CustomBox

//获取已设置的box
+(NSArray*)customBoxUsedValues;

//获取未设置的box
+(NSArray*)customBoxNotUsedValues;

//添加自定义box
+(void)insertUsedBoxWithValue:(NSString*)value;

//移除自定义box
+(void)removeUsedBoxWithValue:(NSString*)value;



//------------------------登陆设置-----------------------
#pragma mark- loginSetting

//判断是否记住密码
+(BOOL)loginIsRemenberPassword;

//记住密码
+(void)loginRemenberUserName:(NSString*)userName password:(NSString*)password;

//取消记住密码
+(void)loginCancelRemenberPassword;

//读取账号和密码
+(NSArray*)loginGetUserNameAndPassword;


//判断是否已登录
+(BOOL)loginIsLogin;

//注销登录
+(void)loginCancelLogin;

//退出登录
+(void)loginExit;
//显示登陆界面
+(void)loginShowLoginView;

//隐藏登陆界面
+(void)loginHiddenLoginView;

//用户id持久化
+(void)userIDPersistence:(id)data;

//获取用户id
+(int)GetUserID;

//设置新网状态
+(void)setXW_Status:(int)status;

//获取新网状态
+(NSString *)getXW_Status;


+(void)loginSetLogin;
#pragma mark- 显示汇付认证界面
//
//+(void)showFundTrusteeshipViewControllerFromViewController:(UIViewController*)vc;


@end
