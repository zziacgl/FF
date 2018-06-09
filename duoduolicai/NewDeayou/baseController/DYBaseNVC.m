//
//  DYBaseNVC.m
//  NewDeayou
//
//  Created by wayne on 14/8/20.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYBaseNVC.h"
#import "DYBaseVC.h"

@interface DYBaseNVC ()<UINavigationControllerDelegate>

@end

@implementation DYBaseNVC
+ (void)initialize {
    [[UINavigationBar appearance] setTranslucent:NO];
    // 设置导航栏背景颜色
    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
    // 设置导航栏标题文字颜色
    // 创建字典保存文字大小和颜色
    NSMutableDictionary * color = [NSMutableDictionary dictionary];
    color[NSFontAttributeName] = kFont(17.0f);
    color[NSForegroundColorAttributeName] = [UIColor blackColor];
    [[UINavigationBar appearance] setTitleTextAttributes:color];
    
    // 拿到整个导航控制器的外观
    UIBarButtonItem * item = [UIBarButtonItem appearance];
    item.tintColor = [UIColor whiteColor];
    // 设置字典的字体大小
    NSMutableDictionary * atts = [NSMutableDictionary dictionary];
    
    atts[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    atts[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f];
    // 将字典给item
    [item setTitleTextAttributes:atts forState:UIControlStateNormal];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    DYBaseVC * baseVC = [DYBaseVC new];
    for (UIViewController *vc in self.viewControllers)
    {
        if ([vc isKindOfClass:[DYBaseVC class]])
        {
            baseVC = (DYBaseVC*)vc;
        }
    }
    
    BOOL isBaseVC = baseVC.tag == 1 ? YES:NO;
    
    if (!animated)
    {
        [super pushViewController:viewController animated:animated];
    }
    else if (self.mark == 1)
    {
        self.mark=0;
        [super pushViewController:viewController animated:animated];
    }
    else if(!isBaseVC)
    {
        [super pushViewController:viewController animated:animated];
    }
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
