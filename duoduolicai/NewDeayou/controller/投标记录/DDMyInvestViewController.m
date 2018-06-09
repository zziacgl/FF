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
#import "WJPopoverViewController.h"
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
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) WJPopoverViewController *popView;

@end

@implementation DDMyInvestViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的投标";
    self.view.backgroundColor = kBackColor;
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];

    
    self.rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame=CGRectMake(0, 0, 20, 20);
    [self.rightButton setImage:[UIImage imageNamed:@"理财－筛选_03"] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(handleScreen:forEvent:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
//    CALayer *layer = [topView layer];
//    layer.shadowOffset = CGSizeMake(0, 3);
//    layer.shadowRadius = 5.0;
//    layer.shadowColor = [UIColor grayColor].CGColor;
//    layer.shadowOpacity = 0.3;
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
            [btn setTitleColor:kBtnColor forState:UIControlStateNormal];
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
    _redView.backgroundColor = kBtnColor;
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
- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
        [sender setTitleColor:kBtnColor forState:UIControlStateNormal];

    } completion:^(BOOL finished) {
        
    }];
}

- (void)handleScreen:(UIButton *)sender forEvent:(UIEvent *)event{
    [self creatPopViewWithEvent:event];
}
- (void)creatPopViewWithEvent:(UIEvent *)event{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.frame = CGRectMake(0, 0, 90, 160);
    vc.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPopViewFromSuperView)];
    [vc.view addGestureRecognizer:tap];
//    NSArray *ary = @[@"全部",@"车贷宝",@"诚商宝",@"日盈宝",@"转让标"];
    NSArray *ary = @[@"全部",@"车贷宝",@"诚商宝",@"转让标"];
    for (int i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i * 40, 90, 40);
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.tag = 500 + i;
        [btn addTarget:self action:@selector(handleChose:) forControlEvents:UIControlEventTouchUpInside];
        [vc.view addSubview:btn];
        
    }
    for (int i = 0; i < 4; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40*(i + 1) , 90, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.alpha = 0.5;
        [vc.view addSubview:lineView];
    }
    
    
    
    
    
    self.popView.borderWidth = 0;
    self.popView.offSet = -10;
    self.popView = [[WJPopoverViewController alloc] initWithViewController:vc];
    
    [self.popView showPopoverWithBarButtonItemTouch:event animation:YES];
    
}
#pragma mark --  筛选
- (void)handleChose:(UIButton *)sender {
    [self cancelPopViewFromSuperView];
    NSInteger index = sender.tag - 500;
    switch (index) {
        case 0://全部
            self.firstTableView.borrowType = @"";
            self.secondTableView.borrowType = @"";
            self.thirdTableView.borrowType = @"";
            self.forthTableView.borrowType = @"";
            [self.firstTableView.tableView launchRefreshing];
            [self.secondTableView.IntableView launchRefreshing];
            [self.thirdTableView.tableView launchRefreshing];
            [self.forthTableView.tableView launchRefreshing];
            break;
        case 1://车贷宝
            self.firstTableView.borrowType = @"cl";
            self.secondTableView.borrowType = @"cl";
            self.thirdTableView.borrowType = @"cl";
            self.forthTableView.borrowType = @"cl";
            [self.firstTableView.tableView launchRefreshing];
            [self.secondTableView.IntableView launchRefreshing];
            [self.thirdTableView.tableView launchRefreshing];
            [self.forthTableView.tableView launchRefreshing];
            break;
        case 2://诚商宝
            self.firstTableView.borrowType = @"csb";
            self.secondTableView.borrowType = @"csb";
            self.thirdTableView.borrowType = @"csb";
            self.forthTableView.borrowType = @"csb";
            [self.firstTableView.tableView launchRefreshing];
            [self.secondTableView.IntableView launchRefreshing];
            [self.thirdTableView.tableView launchRefreshing];
            [self.forthTableView.tableView launchRefreshing];
            break;
//        case 3://日盈宝
//            self.firstTableView.borrowType = @"cr";
//            self.secondTableView.borrowType = @"cr";
//            self.thirdTableView.borrowType = @"cr";
//            self.forthTableView.borrowType = @"cr";
//            [self.firstTableView.tableView launchRefreshing];
//            [self.secondTableView.IntableView launchRefreshing];
//            [self.thirdTableView.tableView launchRefreshing];
//            [self.forthTableView.tableView launchRefreshing];
//            break;
        case 3://转让标
            self.firstTableView.borrowType = @"tf";
            self.secondTableView.borrowType = @"tf";
            self.thirdTableView.borrowType = @"tf";
            self.forthTableView.borrowType = @"tf";
            [self.firstTableView.tableView launchRefreshing];
            [self.secondTableView.IntableView launchRefreshing];
            [self.thirdTableView.tableView launchRefreshing];
            [self.forthTableView.tableView launchRefreshing];
            break;
            
        default:
            break;
    }
    
}
- (void)cancelPopViewFromSuperView {
    [WJPopoverViewController dissPopoverViewWithAnimation:YES];
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
            [btn setTitleColor:kBtnColor forState:UIControlStateNormal];
            
            break;
        case 1:
            [btn setTitleColor:kBtnColor forState:UIControlStateNormal];
            break;
        case 2:
            [btn setTitleColor:kBtnColor forState:UIControlStateNormal];
            break;
        case 3:
            [btn setTitleColor:kBtnColor forState:UIControlStateNormal];
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
