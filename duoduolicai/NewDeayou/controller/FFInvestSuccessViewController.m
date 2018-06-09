//
//  FFInvestSuccessViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/1/4.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "FFInvestSuccessViewController.h"

@interface FFInvestSuccessViewController ()

@end

@implementation FFInvestSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)goback {
     [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)gotoInvest:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)shareRedBox:(UIButton *)sender {
    NSString *loginKey = [DYUser GetLoginKey];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/packet/index&login_key=%@",ffwebURL,loginKey];
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"助力红包";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:adVC animated:YES];
    
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
