//
//  DDCurrentViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/11.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDCurrentViewController.h"
#import "DDCanRansomViewController.h"
#import "DDAlreadyRansomComViewController.h"
#import "DDhasWonMoneyViewController.h"
@interface DDCurrentViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIScrollView *currentScrollView;
@property (nonatomic, strong) DDCanRansomViewController *canRansomView;
@property (nonatomic, strong) DDAlreadyRansomComViewController *alreadyRansomView;
@end

@implementation DDCurrentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"日盈宝%@", self.current_yes_profit);
    
    self.title = @"日盈宝";
    self.view.backgroundColor = kBackColor;
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 30);
    [rightBtn setTitle:@"收益详情" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(handleGetMoneyDetail) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = [topView layer];
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.3;
    [self.view addSubview:topView];
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, kMainScreenWidth / 2, 40);
    [self.leftBtn setTitle:@"可退出" forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.leftBtn addTarget:self action:@selector(handleLeft:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.leftBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2, 5, 1, 30)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.5;
    [topView addSubview:lineView];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(kMainScreenWidth/2, 0, kMainScreenWidth / 2, 40);
    [self.rightBtn setTitle:@"已退出" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightBtn addTarget:self action:@selector(handleRight:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.rightBtn];
    
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth / 2, 1)];
    _redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];

    self.currentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, kMainScreenWidth, kMainScreenHeight - 50 - 64)];
    
    _currentScrollView.backgroundColor = kCOLOR_R_G_B_A(236, 236, 236, 1);
    _currentScrollView.contentSize = CGSizeMake(2 * kMainScreenWidth, kMainScreenHeight - 50 - 64);
    _currentScrollView.showsVerticalScrollIndicator = YES;
    _currentScrollView.showsHorizontalScrollIndicator = YES;
    _currentScrollView.bounces = NO;
    _currentScrollView.pagingEnabled = YES;
    _currentScrollView.delegate = self;
    [self.view addSubview:self.currentScrollView];
    
    self.canRansomView = [[DDCanRansomViewController alloc] init];
    _canRansomView.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 50 - 64);
    [self addChildViewController:self.canRansomView];
    
    self.alreadyRansomView = [[DDAlreadyRansomComViewController alloc] init];
    _alreadyRansomView.view.frame = CGRectMake(kMainScreenWidth , 0, kMainScreenWidth, kMainScreenHeight - 60 - 64);
    [self addChildViewController:self.alreadyRansomView];
    [self.currentScrollView addSubview:self.canRansomView.view];
    [self.currentScrollView addSubview:self.alreadyRansomView.view];

    
    // Do any additional setup after loading the view.
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)handleGetMoneyDetail {
    DDhasWonMoneyViewController *moneyVC = [[DDhasWonMoneyViewController alloc]initWithNibName:@"DDhasWonMoneyViewController" bundle:nil];
    moneyVC.hidesBottomBarWhenPushed = YES;
    moneyVC.title = @"收益详情";
    moneyVC.typeStr = @"received";
    moneyVC.nameStr = @"活期收益(元)";
    moneyVC.prodectStr = @"cr";
    moneyVC.moneyStr = self.current_yes_profit;
    [self.navigationController pushViewController:moneyVC animated:YES];

}
- (void)handleLeft:(UIButton *)sender {
    
    [self.currentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
    self.redView.frame = CGRectMake(0, 40, kMainScreenWidth / 2, 1);
}
- (void)handleRight:(UIButton *)sender {
    
    
    [self.currentScrollView setContentOffset:CGPointMake(kMainScreenWidth, 0) animated:YES];
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
    self.redView.frame = CGRectMake(kMainScreenWidth / 2, 40, kMainScreenWidth / 2, 1);
}
#pragma mark-－－－-scrollViewDelegate
//结束减速的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.redView.frame = CGRectMake((scrollView.contentOffset.x / kMainScreenWidth) * kMainScreenWidth / 2, 40, kMainScreenWidth / 2, 1);
    if ((scrollView.contentOffset.x / kMainScreenWidth) == 0) {
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
        
    }else {
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
        
    }
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
