//
//  StatisticalViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "StatisticalViewController.h"
#import "WJPopoverViewController.h"

@interface StatisticalViewController ()
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) WJPopoverViewController *popView;
@end

@implementation StatisticalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户统计信息";
    self.view.backgroundColor = kBackColor;
    self.rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame=CGRectMake(0, 0, 20, 20);
//    self.rightButton.backgroundColor = [UIColor whiteColor];
    [self.rightButton setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(handleScreen:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    // Do any additional setup after loading the view.
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"shellBack"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 筛选
- (void)handleScreen:(UIButton *)sender forEvent:(UIEvent *)event{
    [self creatPopViewWithEvent:event];
}

- (void)creatPopViewWithEvent:(UIEvent *)event{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.frame = CGRectMake(0, 0, 90, 80);
    vc.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPopViewFromSuperView)];
    [vc.view addGestureRecognizer:tap];
    NSArray *ary = @[@"销量最高",@"利润最高"];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i * 40, 90, 40);
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.tag = 500 + i;
        [btn addTarget:self action:@selector(handleChose:) forControlEvents:UIControlEventTouchUpInside];
        [vc.view addSubview:btn];
    }
    for (int i = 0; i < 1; i++) {
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
        case 0:
            break;
        case 1:
            break;
            
        default:
            break;
    }
}

- (void)cancelPopViewFromSuperView {
    [WJPopoverViewController dissPopoverViewWithAnimation:YES];
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
