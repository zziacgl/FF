//
//  DDFrozenViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/25.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDFrozenViewController.h"
#import "DDInvestFrostViewController.h"
#import "DDDrawForstViewController.h"
#define kChoseView_Height    45

@interface DDFrozenViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *frozenMoneyLabel;
@property (nonatomic, strong) DDInvestFrostViewController *investView;
@property (nonatomic, strong) DDDrawForstViewController *drawView;

@property (nonatomic, strong) UIScrollView *customScrollView;
@property (nonatomic, strong) UIView *choseView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *redLineView;
@end

@implementation DDFrozenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处理中资金";
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    self.topView.backgroundColor = [UIColor whiteColor];
    [self configChoseView];
    self.frozenMoneyLabel.text = [NSString stringWithFormat:@"%@", self.moneyStr];
    // Do any additional setup after loading the view from its nib.
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)configChoseView {
    self.choseView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, kMainScreenWidth, kChoseView_Height)];
    _choseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.choseView];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, kMainScreenWidth / 2, kChoseView_Height);
    [_leftBtn setTitle:@"投标中" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(handleLeft:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.choseView addSubview:self.leftBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2, 10, 1, 25)];
    lineView.backgroundColor = [HeXColor colorWithHexString:@"#e4e4e4"];
    [self.choseView addSubview:lineView];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(kMainScreenWidth / 2 + 1, 0, kMainScreenWidth / 2 - 1, kChoseView_Height);
    [_rightBtn setTitle:@"提现中" forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightBtn addTarget:self action:@selector(handleRight:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setTitleColor:[HeXColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [self.choseView addSubview:self.rightBtn];
    
    self.customScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90 + kChoseView_Height, kMainScreenWidth, kMainScreenHeight - 90 - kChoseView_Height - 64)];
    _customScrollView.backgroundColor = kCOLOR_R_G_B_A(236, 236, 236, 1);
    _customScrollView.contentSize = CGSizeMake(2 * kMainScreenWidth, kMainScreenHeight - 90 - kChoseView_Height - 64);
    _customScrollView.showsVerticalScrollIndicator = YES;
    _customScrollView.showsHorizontalScrollIndicator = YES;
    _customScrollView.bounces = NO;
    _customScrollView.pagingEnabled = YES;
    _customScrollView.delegate = self;
    [self.view addSubview:self.customScrollView];
    
    self.investView = [[DDInvestFrostViewController alloc] init];
    _investView.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64 - 90 - kChoseView_Height);
//    [self addChildViewController:self.investView];
    
    self.drawView = [[DDDrawForstViewController alloc] init];
     _drawView.view.frame = CGRectMake(kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight - 64 - 90 - kChoseView_Height);
//    [self addChildViewController:self.drawView];
    
    [self.customScrollView addSubview:self.investView.view];
    [self.customScrollView addSubview:self.drawView.view];
    
    
}
- (void)handleLeft:(UIButton *)sender {
    [self.customScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.rightBtn setTitleColor:[HeXColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [sender setTitleColor:kBtnColor forState:UIControlStateNormal];
    
}

- (void)handleRight:(UIButton *)sender {
    
    [self.customScrollView setContentOffset:CGPointMake(kMainScreenWidth, 0) animated:YES];
    [self.leftBtn setTitleColor:[HeXColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [sender setTitleColor:kBtnColor forState:UIControlStateNormal];
   
}
#pragma mark-－－－-scrollViewDelegate
//结束减速的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    self.redView.frame = CGRectMake((scrollView.contentOffset.x / kMainScreenWidth) * kMainScreenWidth / 2, 40, kMainScreenWidth / 2, 1);
    if ((scrollView.contentOffset.x / kMainScreenWidth) == 0) {
        [self.rightBtn setTitleColor:[HeXColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:kBtnColor forState:UIControlStateNormal];
        
    }else {
        [self.leftBtn setTitleColor:[HeXColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:kBtnColor forState:UIControlStateNormal];
        
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
