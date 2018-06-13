//
//  DYAppDelegate.m
//  NewDeayou
//
//  Created by wayne on 14-6-18.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYAppDelegate.h"
#import "DYUtils.h"
#import "DYLoginVC.h"

#import "versionModel.h"
#import "versionView.h"
#import "DYDrawPatternLockVC.h"
#import "AdvertiseView.h"
#import "JPUSHService.h"
#import "SCLoginVerifyView.h"
#import "SCSecureHelper.h"
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import "UMMobClick/MobClick.h"
#import "ShellTabBarViewController.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#define JPushAppKey @"9542079fc676edb92a818462"
#define Channel @"App Store"
#define isProduction 1
#define  kAlert @"kAlert"

#define kScreen_Width      [UIScreen mainScreen].bounds.size.width
#define kScreen_Height     [UIScreen mainScreen].bounds.size.height
#define kTimeInterval  2
@interface DYAppDelegate ()<UIScrollViewDelegate, JPUSHRegisterDelegate, UITabBarControllerDelegate>
@property (nonatomic, copy) NSString *updateUrl;
@property (nonatomic, strong) NSDictionary *updateDic;
@property (nonatomic) BOOL isImage;
@property (nonatomic, strong) versionModel *versionmodel;
@end

@implementation DYAppDelegate
{
    id data;
    UIBackgroundTaskIdentifier  bgTask;
    NSInteger timeIntervalLockView;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [self getVersionData];

    //友盟
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];

    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengAppkey];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppKey appSecret:WXAppSecret redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"https://www.fengfengjinrong.com"];


    [UMConfigure initWithAppkey:UmengAppkey channel:@"App Store"];
    [UMConfigure setLogEnabled:YES];
    [UMCommonLogManager setUpUMCommonLogManager];
    //    [MobClick startWithConfigure:UMConfigInstance];

    //极光推送
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:Channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];

  
    
     [NSThread sleepForTimeInterval:3.0];
  
//    //版本更新
    [self getVersion];
//    //广告页
    
    
  
    return YES;
}
- (void)getVersionData {
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"version" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"stock" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess) {
            NSLog(@"控制%@", object);
            
            NSString *storeVersion = [NSString stringWithFormat:@"%@", object[@"data"][@"code"]];
            NSLog(@"版本更新%@", storeVersion);
            NSString *lock = [NSString stringWithFormat:@"%@", object[@"data"][@"status"]];
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSLog(@"%@", version);
            if ([lock isEqualToString:@"1"]) {//1开
                if (![self needUpdateCurrentVersion:version appStoreVersion:storeVersion]) {
                     [self gotoshellTabbar];
                    
                    NSLog(@"111");
                }else {
                    NSLog(@"222");
                   
                     [self gotoFengFengTabbar];
                }
            }else {
                [self gotoFengFengTabbar];
            }
            
          
        }else {
           
             [self gotoshellTabbar];
        }
    } fail:^{
          [self gotoshellTabbar];
    }];
    
    
    
}
- (void)gotoshellTabbar {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ShellTabBarViewController *mineVC = [[ShellTabBarViewController alloc] init];
    self.window.rootViewController = mineVC;
    mineVC.delegate = self;
    [self.window makeKeyAndVisible];
}
- (void)gotoFengFengTabbar {
     [self appearanceCustom];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    DYMainTabBarController *mineVC = [[DYMainTabBarController alloc] init];
    self.window.rootViewController = mineVC;
    mineVC.delegate = self;
    [self.window makeKeyAndVisible];
   
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {// 图片存在
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
        advertiseView.filePath = filePath;
        [advertiseView show];
    }
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [self getAdvertisingImage];
    

}

+ (DYAppDelegate *)getAppDelegate {
    return (DYAppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark -- 广告页

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage
{
    
    // TODO 请求广告接口
    
    
    DYOrderedDictionary *diyouDic = [[DYOrderedDictionary alloc] init];
    [diyouDic insertObject:@"app" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_start_page" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
                NSLog(@"广告%@", object);
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@", [object objectForKey:@"img"]];
        //        imageUrl = nil;
        NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
        NSString *imageName = stringArr.lastObject;
        if (!(imageUrl.length > 0)) {
            [self deleteOldImage];
        }
        // 拼接沙盒路径
        NSString *filePath = [self getFilePathWithImageName:imageName];
        BOOL isExist = [self isFileExistWithFilePath:filePath];
        if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
            
            [self downloadAdImageWithUrl:imageUrl imageName:imageName];
            
        }
    } fail:^{
        
        
        
    }];
    
    
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            //            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            //            NSLog(@"保存失败");
        }
        
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}



#pragma mark  版本更新
- (void)getVersion{
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"update_info" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"app" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"ios" forKey:@"deviceType" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess) {
            NSLog(@"版本更新%@", object);
            self.versionmodel= [versionModel mj_objectWithKeyValues:[object objectForKey:@"data"]];
            NSString *storeVersion = self.versionmodel.version_name;
            NSLog(@"版本更新%@", storeVersion);
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if (storeVersion && version) {
                if ([self needUpdateCurrentVersion:version appStoreVersion:storeVersion]) {
                    BOOL isMandatory = NO;
                    if ([self.versionmodel.force_check isEqualToString:@"1"]) {
                        isMandatory = YES;
                    }else {
                        isMandatory = NO;
                    }
                    versionView *verView = [[versionView alloc] initWithTitle:self.versionmodel.version_name message:self.versionmodel.content versionType: isMandatory ];
                    
                    verView.resultIndex = ^(NSInteger index) {
                        NSString *iTunesString = self.versionmodel.download;
                        NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                        [[UIApplication sharedApplication] openURL:iTunesURL];
                    };
                    [verView showAlertView];
                    
                }
            }
        }else {
            
        }
    } fail:^{
    }];
    
    
}

/**
 *  判断当前版本号是否s低于AppStore的版本号
 *
 *  @param currentV  当前版本号
 *  @param appStoreV AppStore版本号
 *
 */
- (BOOL)needUpdateCurrentVersion:(NSString *)currentV appStoreVersion:(NSString *)appStoreV {
    NSArray *currentArr = [currentV componentsSeparatedByString:@"."];
    NSArray *appStoreArr = [appStoreV componentsSeparatedByString:@"."];
    
    NSInteger currentVersionCount = 0;
    NSInteger appStoreVersionCount = 0;
    
    for (NSString *string in currentArr) {
        currentVersionCount += string.integerValue;
    }
    for (NSString *string in appStoreArr) {
        appStoreVersionCount += string.integerValue;
    }
    
    NSInteger count = currentArr.count > appStoreArr.count ? appStoreArr.count : currentArr.count;
    for (int i = 0; i < count ; i++) {
        NSString *one = currentArr[i];
        NSString *two = appStoreArr[i];
        if (one.integerValue < two.integerValue) {
            return YES;
        }else if(one.integerValue > two.integerValue) {
            return NO;
        }
    }
    return currentVersionCount < appStoreVersionCount;
}
#pragma mark - 私有方法




#pragma mark 移除本地通知，在不需要此通知时记得移除
-(void)removeNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
    
    if (notificationSettings.types!=UIUserNotificationTypeNone) {
        
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //注册上报token
    [JPUSHService registerDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    //    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //        NSLog(@"推送1%@", userInfo);
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"推送2%@", userInfo);
        NSString *tuisongUrl = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"url"]];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if (tuisongUrl.length > 0) {
            [ud setObject:tuisongUrl forKey:@"tuisongUrl"];
        }
        
    }
    completionHandler();  // 系统要求执行这个方法
}


-(void)sendIosDeviceToken:(NSString *)Token{
    //将deviceToken保存到应用服务器数据库中
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    
    [JPUSHService handleRemoteNotification:userInfo];
    
}

//获取用户信息2
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    //    NSLog(@"推送3%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    timeIntervalLockView = 0;
    if ([DYUser loginIsLogin])
    {
        bgTask=[application beginBackgroundTaskWithExpirationHandler:^
                {
                    bgTask = UIBackgroundTaskInvalid;
                }];
        [self performSelector:@selector(backgroundTaskForLockView) withObject:nil];
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    [application endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
    if (timeIntervalLockView >= kTimeInterval)
    {
        
        if ([SCSecureHelper touchIDOpenStatus]) {
            
            SCLoginVerifyView *verifyView = [[SCLoginVerifyView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight) verifyType:SCLoginVerifyTypeTouchID];
            [verifyView showView];
            
        }else{
            //            [DYUser showLockSecretViewForDeblocking];
            if ([SCSecureHelper gestureOpenStatus]) {
                SCLoginVerifyView *verifyView = [[SCLoginVerifyView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight) verifyType:SCLoginVerifyTypeGesture];
                [verifyView showView];
            }
            
        }
    }
    timeIntervalLockView = 0;
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    
    /**
     *  关闭应用时调用此方法,记录时间
     */
    
}

#pragma mark- backgroundTask

-(void)backgroundTaskForLockView
{
    
    timeIntervalLockView++;
    if (timeIntervalLockView == 0 || timeIntervalLockView >= kTimeInterval)
    {
        return;
    }
    [self performSelector:@selector(backgroundTaskForLockView) withObject:nil afterDelay:1];
    
}

#pragma mark- appearance

-(void)appearanceCustom
{
    
    UIImage * backButtonImageNormal = [UIImage imageNamed:@"back_bar_normal"];
    backButtonImageNormal = [backButtonImageNormal resizableImageWithCapInsets:UIEdgeInsetsMake(17.5, 0, 0, 0) resizingMode:UIImageResizingModeTile];
 
    // tabbar  tabbar文字的颜色
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      kMainTabBarTitleColor,
                                                      NSForegroundColorAttributeName,
                                                      [UIFont fontWithName:@"Trebuchet MS" size:11],
                                                      NSFontAttributeName,
                                                      nil] forState:UIControlStateNormal];//tabbar标题栏字体颜色
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      kBtnColor,
                                                      NSForegroundColorAttributeName,
                                                      nil] forState:UIControlStateSelected];
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         kThemeColor,
                                                         NSForegroundColorAttributeName,
                                                         nil] forState:UIControlStateNormal];
    [[UITabBar appearance] setBarTintColor:kThemeColor];//修改tabbar底部的颜色
    [[UITabBar appearance] setBackgroundColor:kThemeColor];
    [UITabBar appearance] .translucent = NO;
    
}


- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler {
    
    return YES;
}
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {//当允许时，支持所有方向
        return UIInterfaceOrientationMaskAll;
    }
    //否则 就只有竖屏
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark -- 设置系统回调
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return YES;
}



@end


