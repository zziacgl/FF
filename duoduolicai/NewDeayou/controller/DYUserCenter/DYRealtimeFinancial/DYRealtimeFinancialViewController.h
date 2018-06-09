//
//  DYRealtimeFinancialViewController.h
//  NewDeayou
//
//  Created by diyou on 14-7-10.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DYMainTabBarController.h"

@interface DYRealtimeFinancialViewController : UIViewController
@property (nonatomic,strong)NSDictionary * dic;
@property (strong, nonatomic) DYMainTabBarController * mainTabBarVC;
@property (strong, nonatomic) UIWindow *window;
@end
