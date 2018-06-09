//
//  DDMyCardVoucherViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/6/6.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMyCardVoucherViewController.h"
#import "PullingRefreshTableView.h"
#import "DDMyCardTableViewCell.h"
#import "DDRatesCardViewController.h"
#import "DDMoneyCardViewController.h"
#import "DYSafeViewController.h"
#import "DDCashWithdrawalViewController.h"

@interface DDMyCardVoucherViewController ()<UIScrollViewDelegate,DDRatesCardViewControllerDelegate, DDMoneyCardViewControllerDelegate,DDCashWithdrawalViewControllerDelegate>


@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *midBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *redView;


@property (nonatomic, strong) UIScrollView *cardScrollView;

@property (nonatomic, strong) DDRatesCardViewController *ratesTableView;
@property (nonatomic, strong) DDMoneyCardViewController *moneyTableView;
@property (nonatomic, strong) DDCashWithdrawalViewController *cashTableView;

@property (nonatomic, strong) NSDictionary *ratesDic;
@property (nonatomic, strong) NSDictionary *moneyDic;
@property (nonatomic, strong) NSDictionary *cashDic;



@end

@implementation DDMyCardVoucherViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([self.isDraw isEqualToString:@"1"]){
        [self.cardScrollView setContentOffset:CGPointMake(kMainScreenWidth*2, 0) animated:YES];
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.midBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:kBtnColor forState:UIControlStateNormal];
        self.redView.frame = CGRectMake(2*kMainScreenWidth / 3, 40, kMainScreenWidth / 3, 1);
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的卡券";
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = [topView layer];
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.3;
    [self.view addSubview:topView];
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, kMainScreenWidth / 3, 40);
    [self.leftBtn setTitle:@"我的返现券" forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:kBtnColor forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.leftBtn addTarget:self action:@selector(handleLeft:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.leftBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3, 5, 1, 30)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.5;
    [topView addSubview:lineView];
    
    self.midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.midBtn.frame = CGRectMake(kMainScreenWidth/3, 0, kMainScreenWidth / 3, 40);
    [self.midBtn setTitle:@"我的加息券" forState:UIControlStateNormal];
    [self.midBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.midBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.midBtn addTarget:self action:@selector(handleMidden:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.midBtn];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(2*kMainScreenWidth / 3, 5, 1, 30)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    lineView2.alpha = 0.5;
    [topView addSubview:lineView2];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(2*kMainScreenWidth/3, 0, kMainScreenWidth / 3, 40);
    [self.rightBtn setTitle:@"我的提现劵" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightBtn addTarget:self action:@selector(handleRight:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.rightBtn];
    
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth / 3, 1)];
    _redView.backgroundColor = kBtnColor;
    [self.view addSubview:self.redView];
    
    self.cardScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, kMainScreenWidth, kMainScreenHeight - 60 - 64)];
    
    _cardScrollView.backgroundColor = kCOLOR_R_G_B_A(236, 236, 236, 1);
    _cardScrollView.contentSize = CGSizeMake(3 * kMainScreenWidth, kMainScreenHeight - 60 - 64);
    _cardScrollView.showsVerticalScrollIndicator = YES;
    _cardScrollView.showsHorizontalScrollIndicator = YES;
    _cardScrollView.bounces = NO;
    _cardScrollView.pagingEnabled = YES;
    _cardScrollView.delegate = self;
    [self.view addSubview:self.cardScrollView];
    
    self.ratesTableView = [[DDRatesCardViewController alloc] init:self.isUse borrowtype:self.borrowType];
    _ratesTableView.view.frame = CGRectMake(kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight - 60 - 64);
    _ratesTableView.delegate = self;
    _ratesTableView.borrowNid = self.borrowNid;
    [self addChildViewController:self.ratesTableView];
    
    self.moneyTableView = [[DDMoneyCardViewController alloc] init:self.isUse borrowtype:self.borrowType];
    _moneyTableView.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 60 - 64);
    _moneyTableView.delegate = self;
    _moneyTableView.borrowNid = self.borrowNid;
    [self addChildViewController:self.moneyTableView];
    
    self.cashTableView = [[DDCashWithdrawalViewController alloc] init:self.isUse borrowtype:self.borrowType];
    _cashTableView.view.frame = CGRectMake(kMainScreenWidth*2, 0, kMainScreenWidth, kMainScreenHeight - 60 - 64);
    _cashTableView.delegate = self;
    _cashTableView.borrowNid = self.borrowNid;
    [self addChildViewController:self.cashTableView];
    
    [self.cardScrollView addSubview:self.ratesTableView.view];
    [self.cardScrollView addSubview:self.moneyTableView.view];
    [self.cardScrollView addSubview:self.cashTableView.view];
    
    
    UIButton *problemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    if (self.isUse) {
        problemBtn.frame = CGRectMake(0, 0, 60, 30);
        [problemBtn setTitle:@"不使用" forState:UIControlStateNormal];
        problemBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [problemBtn addTarget:self action:@selector(notUse) forControlEvents:UIControlEventTouchUpInside];
        //        self.ratesTableView.view.userInteractionEnabled = YES;
        //        self.moneyTableView.view.userInteractionEnabled = YES;
    }else {
        problemBtn.frame = CGRectMake(0, 0, 30, 30);
        [problemBtn setImage:[UIImage imageNamed:@"零钱宝_03"] forState:UIControlStateNormal];
        [problemBtn addTarget:self action:@selector(handleProblem) forControlEvents:UIControlEventTouchUpInside];
        //        self.ratesTableView.view.userInteractionEnabled = NO;
        //        self.moneyTableView.view.userInteractionEnabled = NO;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:problemBtn];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark  DDRatesCardViewControllerDelegate
- (void)cardMassage:(NSDictionary *)cardDic{
    self.ratesDic = [NSDictionary new];
    self.ratesDic = cardDic;
    
    if ([self.delegate respondsToSelector:@selector(myCard:)]) {
        [self.delegate myCard:cardDic];
    }
}
- (void)moneyMassage:(NSDictionary *)moneyDic {
    self.moneyDic = [NSDictionary new];
    self.moneyDic = moneyDic;
    if ([self.delegate respondsToSelector:@selector(myCard:)]) {
        [self.delegate myCard:moneyDic];
    }
    
}

-(void)cashMessage:(NSDictionary *)cashDic{
//    NSLog(@"%@",cashDic);
    self.cashDic = [NSDictionary new];
    self.cashDic = cashDic;
    if([self.delegate respondsToSelector:@selector(myCard:)])
    {
//        NSLog(@"%@",cashDic);
        [self.delegate myCard:cashDic];
    }
}

//我的卡券问题帮助
- (void)handleProblem {
//    DYSafeViewController *safeVC = [[DYSafeViewController alloc] init];
//    safeVC.hidesBottomBarWhenPushed = YES;
//    safeVC.weburl = @"https://www.51duoduo.com/ddjs/xjqjxqgz.html";
//    safeVC.title = @"卡券规则";
//    [self.navigationController pushViewController:safeVC animated:YES];
    
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":@"https://www.51duoduo.com/ddjs/xjqjxqgz.html"};
    adVC.titleM =@"卡券规则";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:adVC animated:YES];
}

//投资界面不使用卡券
- (void)notUse {
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(myCard:)]) {
        [self.delegate myCard:nil];
    }
}

- (void)handleLeft:(UIButton *)sender {
    
    [self.cardScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.midBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:kBtnColor forState:UIControlStateNormal];
    self.redView.frame = CGRectMake(0, 40, kMainScreenWidth / 3, 1);
}
- (void)handleMidden:(UIButton *)sender {
    
    
    [self.cardScrollView setContentOffset:CGPointMake(kMainScreenWidth, 0) animated:YES];
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:kBtnColor forState:UIControlStateNormal];
    self.redView.frame = CGRectMake(kMainScreenWidth / 3, 40, kMainScreenWidth / 3, 1);
}
- (void)handleRight:(UIButton *)sender {
    
    
    [self.cardScrollView setContentOffset:CGPointMake(kMainScreenWidth*2, 0) animated:YES];
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.midBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:kBtnColor forState:UIControlStateNormal];
    self.redView.frame = CGRectMake(2*kMainScreenWidth / 3, 40, kMainScreenWidth / 3, 1);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-－－－-scrollViewDelegate
//结束减速的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.redView.frame = CGRectMake((scrollView.contentOffset.x / kMainScreenWidth) * kMainScreenWidth / 3, 40, kMainScreenWidth / 3, 1);
    if ((scrollView.contentOffset.x / kMainScreenWidth) == 0) {
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.midBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:kBtnColor forState:UIControlStateNormal];
        
    }else if((scrollView.contentOffset.x / kMainScreenWidth) == 1){
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.midBtn setTitleColor:kBtnColor forState:UIControlStateNormal];
        
    }else {
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.midBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:kBtnColor forState:UIControlStateNormal];
        
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
