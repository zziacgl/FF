//
//  DDMyInvestViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/19.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMyInvestViewController.h"
#import "DDAllInvestViewController.h"
#import "DDInInvestViewController.h"
#import "DDInRecoverViewController.h"
#import "DDEndRecoverViewController.h"
@interface DDMyInvestViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;
@property (nonatomic, strong) UIButton *thirdBtn;
@property (nonatomic, strong) UIButton *forthBtn;
@property (nonatomic, strong) UIView *redView;


@property (nonatomic, strong) UIScrollView *investScrollView;
@property (nonatomic, strong) DDAllInvestViewController *firstTableView;
@property (nonatomic, strong) DDInInvestViewController *secondTableView;
@property (nonatomic, strong) DDInRecoverViewController *thirdTableView;
@property (nonatomic, strong) DDEndRecoverViewController *forthTableView;



@end

@implementation DDMyInvestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的投标";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = [topView layer];
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.3;
    [self.view addSubview:topView];
    
    NSArray *ary = @[@"全部",@"投资中",@"回收中",@"回收完"];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kMainScreenWidth / 4 * i, 0, kMainScreenWidth / 4, 40);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        btn.tag = 200 + i;
        [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
        }else {
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        [self.view addSubview:btn];
    }
    for (int i = 0 ; i < 3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 4 * (i + 1), 5, 1, 30)];
        lineView.backgroundColor = kCOLOR_R_G_B_A(230, 230, 230, 1);
        [self.view addSubview:lineView];
    }
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kMainScreenWidth / 4, 1)];
    _redView.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
    [self.view addSubview:self.redView];
    
    
    self.investScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, kMainScreenWidth, kMainScreenHeight - 40 - 64)];
    
    _investScrollView.backgroundColor = kCOLOR_R_G_B_A(236, 236, 236, 1);
    _investScrollView.contentSize = CGSizeMake(4 * kMainScreenWidth, kMainScreenHeight - 50 - 64);
    _investScrollView.showsVerticalScrollIndicator = YES;
    _investScrollView.showsHorizontalScrollIndicator = YES;
    _investScrollView.bounces = NO;
    _investScrollView.pagingEnabled = YES;
    _investScrollView.delegate = self;
    [self.view addSubview:self.investScrollView];

    self.firstTableView = [[DDAllInvestViewController alloc] init];
    _firstTableView.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 50 - 64);
    [self addChildViewController:self.firstTableView];
    
    self.secondTableView = [[DDInInvestViewController alloc] init];
    _secondTableView.view.frame = CGRectMake(kMainScreenWidth , 0, kMainScreenWidth, kMainScreenHeight - 50 - 64);
    [self addChildViewController:self.secondTableView];
    
    self.thirdTableView = [[DDInRecoverViewController alloc] init];
    _thirdTableView.view.frame = CGRectMake(kMainScreenWidth * 2, 0, kMainScreenWidth, kMainScreenHeight - 50 - 64);
    [self addChildViewController:self.thirdTableView];
    
    self.forthTableView = [[DDEndRecoverViewController alloc] init];
    _forthTableView.view.frame = CGRectMake(kMainScreenWidth * 3, 0, kMainScreenWidth, kMainScreenHeight - 50 - 64);
    [self addChildViewController:self.forthTableView];
    
    [self.investScrollView addSubview:self.firstTableView.view];
    [self.investScrollView addSubview:self.secondTableView.view];
    [self.investScrollView addSubview:self.thirdTableView.view];
    [self.investScrollView addSubview:self.forthTableView.view];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)handleBtn:(UIButton *)sender {
    NSInteger index = sender.tag - 200;
    [self.investScrollView setContentOffset:CGPointMake(kMainScreenWidth * index, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.redView.frame = CGRectMake(kMainScreenWidth / 4 * index, 39, kMainScreenWidth / 4, 1);
        for (int i = 0 ; i < 4; i ++) {
            UIButton * btn = [self.view viewWithTag:200 + i];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        [sender setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];

    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark-－－－-scrollViewDelegate
//结束减速的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.redView.frame = CGRectMake((scrollView.contentOffset.x / kMainScreenWidth) * kMainScreenWidth / 4, 39, kMainScreenWidth / 4, 1);
    } completion:^(BOOL finished) {
        
    }];
    int index = scrollView.contentOffset.x / kMainScreenWidth;
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [self.view viewWithTag:200+i];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    UIButton *btn = [self.view viewWithTag:200 + index];
    switch (index) {
        case 0:
            [btn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
            
            break;
        case 1:
            [btn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
            break;
        case 2:
            [btn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
            break;
        case 3:
            [btn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
            break;
        default:
            break;
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
