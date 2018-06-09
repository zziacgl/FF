//
//  DYMainTabBarController.m
//  NewDeayou
//
//  Created by wayne on 14-6-18.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYMainTabBarController.h"
#import "DYInvestmentMainVC.h" // 产品列表
//#import "DYUserCenterMainVC.h"
#import "DYBaseNVC.h"
#import "DDMyAccountViewController.h" // 我的多多
#import "DYMoreViewController.h" // 更多
#import "FFMyHomeViewController.h"
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "DDSmallWalletViewController.h"
#import "DYADDetailContentVC.h"
#import "FFMemberViewController.h"

@interface DYMainTabBarController ()
{
    NSTimer *countTimer;
    NSInteger secondCount;
    UIWebView *webView;
    
}
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) UIStoryboard *str;
@property (nonatomic, strong) UIImageView *myImage;
@end

@implementation DYMainTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self delayOpration];
    
    
    
}





- (void)delayOpration {
    //首页
    FFMyHomeViewController *personalPageVC = [[FFMyHomeViewController alloc] init];
    DYBaseNVC * personalPageNVC = [[DYBaseNVC alloc]initWithRootViewController:personalPageVC];
    personalPageNVC.tabBarItem =  [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tab_home"] selectedImage:[[UIImage imageNamed:@"tab_home_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

//    personalPageVC.tabBarItem.image = [[UIImage imageNamed:@c"tab_home"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
//    personalPageVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_home_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //产品列表,理财
    DYInvestmentMainVC * investmentVC = [[DYInvestmentMainVC alloc]initWithNibName:@"DYInvestmentMainVC" bundle:nil];
    DYBaseNVC * investmentNVC = [[DYBaseNVC alloc]initWithRootViewController:investmentVC];
    investmentNVC.tabBarItem.image = [[UIImage imageNamed:@"tab_licai"] imageWithRenderingMode : UIImageRenderingModeAlwaysOriginal];
    investmentNVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_licai_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //我的多多，账户
    DDMyAccountViewController * borrowVC = [[DDMyAccountViewController alloc]initWithNibName:@"DDMyAccountViewController" bundle:nil];
    DYBaseNVC * borrowNVC = [[DYBaseNVC alloc]initWithRootViewController:borrowVC];
//    borrowNVC.tabBarItem.image = [[UIImage imageNamed:@"tab_account"] imageWithRenderingMode : UIImageRenderingModeAlwaysOriginal];
//    borrowNVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_account_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    borrowVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"账户" image:[UIImage imageNamed:@"tab_account"] selectedImage:[[UIImage imageNamed:@"tab_account_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    //更多
//    DYMoreViewController *moreVC = [[DYMoreViewController alloc]init];
//    DYBaseNVC *moreNVC = [[DYBaseNVC alloc]initWithRootViewController:moreVC];
//    moreNVC.tabBarItem.image = [[UIImage imageNamed:@"tab_vip"] imageWithRenderingMode : UIImageRenderingModeAlwaysOriginal];
//    moreNVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_vip_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    FFMemberViewController *memberVC = [[FFMemberViewController alloc] init];
    DYBaseNVC *memberNvc = [[DYBaseNVC alloc] initWithRootViewController:memberVC];
    memberVC.tabBarItem =  [[UITabBarItem alloc] initWithTitle:@"会员" image:[UIImage imageNamed:@"tab_vip"] selectedImage:[[UIImage imageNamed:@"tab_vip_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    NSArray * viewControllers = [NSArray arrayWithObjects:personalPageNVC,investmentNVC,memberNvc,borrowNVC, nil];
    self.viewControllers = viewControllers;
    self.delegate=self;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"second" forKey:@"donghuagif"];
    
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    @try {
//        NSLog(@"SelectItem2:%lu",(unsigned long)self.Index);
        [super setSelectedIndex:self.Index];
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        [ud setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.Index] forKey:@"isBecomeBig"];
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)viewController popToRootViewControllerAnimated:YES];
        }

    } @catch (NSException *exception) {
//        NSLog(@"tabbar跳转异常:%@",exception);
    } @finally {
        
    }
    
    return NO;
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    self.Index=tabIndex;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
