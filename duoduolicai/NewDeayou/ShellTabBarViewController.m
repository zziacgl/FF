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
    [UINavigationBar appearance].barTintColor = kMainColor;

    ShellHomeViewController *homeVC = [[ShellHomeViewController alloc] init];
    
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"记账" image:[UIImage imageNamed:@"jizhang"] selectedImage:[[UIImage imageNamed:@"jizhangsel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    ShellSearchViewController *investVC = [[ShellSearchViewController alloc] init];
    investVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"搜索" image:[UIImage imageNamed:@"shellsousuo"] selectedImage:[[UIImage imageNamed:@"shellsousuosel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController *investNav = [[UINavigationController alloc] initWithRootViewController:investVC];
    
    ShellOverViewController *mineVC = [[ShellOverViewController alloc] init];
    mineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"总览" image:[UIImage imageNamed:@"shellover"] selectedImage:[[UIImage imageNamed:@"shelloversel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController *mineVav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    
  
    
    
    self.viewControllers = @[homeNav, investNav, mineVav];
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kMainColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} forState:UIControlStateNormal];

    // 拿到整个导航控制器的外观
    UIBarButtonItem * item = [UIBarButtonItem appearance];
    item.tintColor = [UIColor whiteColor];
    // 设置字典的字体大小
    NSMutableDictionary * atts = [NSMutableDictionary dictionary];
    
    atts[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    atts[NSForegroundColorAttributeName] = [UIColor whiteColor];
    // 将字典给item
    [item setTitleTextAttributes:atts forState:UIControlStateNormal];
    
    self.tabBar.barTintColor = kCOLOR_R_G_B_A(243, 181, 58, 1);
    
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
