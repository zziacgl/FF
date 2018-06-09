//
//  DDBondViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/8/9.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDBondViewController.h"
#import "DDCanTranferTableViewController.h"
#import "DDInTransferTableViewController.h"
#import "DDCompleteTransferTableViewController.h"
#import "DDSmallWalletHelperViewController.h"

@interface DDBondViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;
@property (nonatomic, strong) UIButton *thirdBtn;
@property (nonatomic, strong) UIView *redView;

@property (nonatomic, strong) UIScrollView *bondScrollView;
@property (nonatomic, strong) DDCanTranferTableViewController *canTableView;
@property (nonatomic, strong) DDInTransferTableViewController *inTableView;
@property (nonatomic, strong) DDCompleteTransferTableViewController *completeTableView;
@end

@implementation DDBondViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"债权转让";
    self.view.backgroundColor = kCOLOR_R_G_B_A(236, 236, 236, 1);
    [self setNavigate];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = [topView layer];
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.3;
    [self.view addSubview:topView];
    
    
    self.firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _firstBtn.frame = CGRectMake(0, 0, kMainScreenWidth / 3, 40);
    [_firstBtn setTitle:@"可转让" forState:UIControlStateNormal];
    _firstBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_firstBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [_firstBtn addTarget:self action:@selector(handleFirst:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.firstBtn];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3, 5, 1, 30)];
    leftView.backgroundColor = [UIColor lightGrayColor];
    leftView.alpha = 0.5;
    [topView addSubview:leftView];
    
    self.secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _secondBtn.frame = CGRectMake(kMainScreenWidth / 3, 0, kMainScreenWidth / 3, 40);
    [_secondBtn setTitle:@"转让中" forState:UIControlStateNormal];
    _secondBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_secondBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_secondBtn addTarget:self action:@selector(handleSecond:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.secondBtn];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 * 2, 5, 1, 30)];
    rightView.backgroundColor = [UIColor lightGrayColor];
    rightView.alpha = 0.5;
    [topView addSubview:rightView];
    
    self.thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _thirdBtn.frame = CGRectMake(kMainScreenWidth / 3 * 2, 0, kMainScreenWidth / 3, 40);
    [_thirdBtn setTitle:@"已转完" forState:UIControlStateNormal];
    [_thirdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _thirdBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_thirdBtn addTarget:self action:@selector(handleThird:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.thirdBtn];
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth / 3, 1)];
    _redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
    
    self.bondScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, kMainScreenWidth, kMainScreenHeight - 50 - 64)];
    _bondScrollView.backgroundColor = kCOLOR_R_G_B_A(236, 236, 236, 1);
    _bondScrollView.contentSize = CGSizeMake(3 * kMainScreenWidth, kMainScreenHeight - 50 - 64);
    _bondScrollView.showsVerticalScrollIndicator = YES;
    _bondScrollView.showsHorizontalScrollIndicator = YES;
    _bondScrollView.bounces = NO;
    _bondScrollView.pagingEnabled = YES;
    _bondScrollView.delegate = self;
    [self.view addSubview:self.bondScrollView];
    
    self.canTableView = [[DDCanTranferTableViewController alloc] init];
    _canTableView.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 50 - 64);
    [self addChildViewController:self.canTableView];
    
    self.inTableView = [[DDInTransferTableViewController alloc] init];
    _inTableView.view.frame = CGRectMake(kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight - 50 - 64);
    [self addChildViewController:self.inTableView];
    
    self.completeTableView = [[DDCompleteTransferTableViewController alloc] init];
    _completeTableView.view.frame = CGRectMake(kMainScreenWidth * 2, 0, kMainScreenWidth, kMainScreenHeight - 50 - 64);
    [self addChildViewController:self.completeTableView];
    
    [self.bondScrollView addSubview:self.canTableView.view];
    [self.bondScrollView addSubview:self.inTableView.view];
    [self.bondScrollView addSubview:self.completeTableView.view];
    

    // Do any additional setup after loading the view.
}

- (void)setNavigate{
    UIButton * btnRightItem=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btnRightItem.backgroundColor=[UIColor clearColor];
    btnRightItem.frame=CGRectMake(0, 0, 30, 30);
    [btnRightItem setImage:[UIImage imageNamed:@"零钱宝_03"] forState:UIControlStateNormal];
    
    [btnRightItem addTarget:self action:@selector(getQusetion:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];

}
#pragma mark ----- btnaction
- (void)handleFirst:(UIButton *)sender {
    [self.bondScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.secondBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.thirdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:kMainColor forState:UIControlStateNormal];
    self.redView.frame = CGRectMake(0, 40, kMainScreenWidth / 3, 1);
}
- (void)handleSecond:(UIButton *)sender {
    [self.bondScrollView setContentOffset:CGPointMake(kMainScreenWidth, 0) animated:YES];
    [self.firstBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.thirdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:kMainColor forState:UIControlStateNormal];
    self.redView.frame = CGRectMake(kMainScreenWidth / 3, 40, kMainScreenWidth / 3, 1);
}

- (void)handleThird:(UIButton *)sender {
    [self.bondScrollView setContentOffset:CGPointMake(kMainScreenWidth * 2, 0) animated:YES];
    [self.firstBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.secondBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:kMainColor forState:UIControlStateNormal];
    self.redView.frame = CGRectMake(kMainScreenWidth / 3 * 2, 40, kMainScreenWidth / 3, 1);
}

- (void)getQusetion:(UIButton *)sender {
    DDSmallWalletHelperViewController *HelperCenter=[[DDSmallWalletHelperViewController alloc]initWithNibName:@"DDSmallWalletHelperViewController" bundle:nil];
    HelperCenter.hidesBottomBarWhenPushed=YES;
    HelperCenter.urlStr = @"https://www.51duoduo.com/ddjs/zqzr/zqzr.html";
    HelperCenter.title = @"债权转让问题";
    [self.navigationController pushViewController:HelperCenter animated:YES];

}

- (void)back {
     [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark-－－－-scrollViewDelegate
//结束减速的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
     self.redView.frame = CGRectMake((scrollView.contentOffset.x / kMainScreenWidth) * kMainScreenWidth / 3, 40, kMainScreenWidth / 3, 1);
    if ((scrollView.contentOffset.x / kMainScreenWidth) == 0) {
        [self.firstBtn setTitleColor:kMainColor forState:UIControlStateNormal];
        [self.secondBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.thirdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }else if ((scrollView.contentOffset.x / kMainScreenWidth) == 1) {
        [self.secondBtn setTitleColor:kMainColor forState:UIControlStateNormal];
        [self.firstBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.thirdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    }else {
        [self.thirdBtn setTitleColor:kMainColor forState:UIControlStateNormal];
        [self.secondBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.firstBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

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
