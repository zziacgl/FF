//
//  ShellTabBarViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/7.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "ShellTabBarViewController.h"
#import "ShellHomeViewController.h"
#import "ShellSearchViewController.h"
#import "ShellOverViewController.h"
//#import "GKNavigationController.h"
@interface ShellTabBarViewController ()

@end

@implementation ShellTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configController];
    // Do any additional setup after loading the view.
}
- (void)configController {
    ShellHomeViewController *homeVC = [[ShellHomeViewController alloc] init];
    
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tab_home"] selectedImage:[[UIImage imageNamed:@"tab_home_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    ShellSearchViewController *investVC = [[ShellSearchViewController alloc] init];
    investVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"理财" image:[UIImage imageNamed:@"tab_licai"] selectedImage:[[UIImage imageNamed:@"tab_licai_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController *investNav = [[UINavigationController alloc] initWithRootViewController:investVC];
    
    ShellOverViewController *mineVC = [[ShellOverViewController alloc] init];
    mineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"tab_account"] selectedImage:[[UIImage imageNamed:@"tab_account_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController *mineVav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    
  
    
    
    self.viewControllers = @[homeNav, investNav, mineVav];
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kThemeColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} forState:UIControlStateSelected];
    
//    self.tabBar.barTintColor = kMainColor;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
