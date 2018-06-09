//
//  DYAppDelegate.h
//  NewDeayou
//
//  Created by wayne on 14-6-18.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYMainTabBarController.h"
#import "FMDeviceManager.h"

@interface DYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DYMainTabBarController * mainTabBarVC;
@property (strong, nonatomic) UIAlertView *alert; // 跳转提示
@property (strong, nonatomic) NSString * TokenStr;
@property (strong, nonatomic) UIImageView *imageView;
//@property (nonatomic, strong) UIPageControl *page;
@property (nonatomic,assign) NSInteger allowRotation;
@property (nonatomic, strong) UIImageView *advImage;
// 版本更新
//- (void)UpdateProjectAuto:(BOOL)autoUpate;
+ (DYAppDelegate *)getAppDelegate;

@end
