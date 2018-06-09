//
//  NewInvestTableViewCell.m
//  NewDeayou
//
//  Created by apple on 15/11/17.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "NewInvestTableViewCell.h"

#import "DYInvestDetailIntroduceVC.h"
#import "DYSafeViewController.h"
#import "DYTransactionRecordsViewController_new.h"
#import "RepaymentPlanViewController.h"

@interface NewInvestTableViewCell (){
    UIImageView *ruleImageView;
    UIButton *closeBtn;
    UIView *blackView;
    UIView *tanView;
    
}
@property (strong, nonatomic) CAGradientLayer *gradientLayer;


@end
@implementation NewInvestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *image = [DYUtils gradientImageWithBounds:self.topImage.bounds andColors:@[kShallowColor,kDeepColor] andGradientType:1];
    self.topImage.image = image;
    
    
    CALayer *layer = [self.coverView layer];
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.3;
    self.rewardView.backgroundColor = kBackColor;
    self.InvestprogressView.progress = 0;
    
}

-(void)setAttributeWithDictionary:(NSDictionary*)dic viewController:(DYInvestDetailVC*)vc isFlow:(BOOL)isFlow{
    self.isFlow = isFlow;
    float a = [[dic DYObjectForKey:@"account"] floatValue];//总融资
    float b = [[dic DYObjectForKey:@"borrow_account_wait"] floatValue];
    
     [ self.InvestprogressView setProgress:(a - b) / a animated:YES];
    if (dic.allKeys.count < 1) {
        return;
    }
//    NSLog(@"详情%@", dic);
    
    _dicData = dic;
    self.vcDelegate = vc;
    self.typeLabel.text = [dic DYObjectForKey:@"name"];
    NSString *str = [NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"account"]];
    
    NSString *str1 = [NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"borrow_account_wait"]];
    self.surplusLabel.text = str;
    self.residueLabel.text = str1;
    NSString *borrowType = [dic objectForKey:@"is_standard"];
    if ([borrowType isEqualToString:@"1"]) {
        float waitMoney = [str1 floatValue];
        if (waitMoney > 10000) {
            str1 = @"10000.00";
        }
        self.surplusLabel.text = [NSString stringWithFormat:@"%@(最高可投2万元)", str];
        [MobClick event:@"product_XS"];

    }else {
        
    }
    self.limitMinMoneyLabel.text = [NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"tender_account_min"]];//起投金额
     NSString *borrowApr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"extra_borrow_apr"]];
    NSString *rate = [NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"borrow_apr"]];
    float borApr = [borrowApr floatValue];
//    NSLog(@"加息%@", borrowApr);
    NSUInteger len = [borrowApr length];
    NSUInteger len1 = [rate length];
    if (borApr > 0) {
        NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%+%@%%", rate,borrowApr]];
        [str4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(len + 2,len1+1)];
        self.incomeLabel.attributedText = str4;
    }else {
        self.incomeLabel.text = [NSString stringWithFormat:@"%@%%",[dic DYObjectForKey:@"borrow_apr"]];//年化收益
    
    }
//    NSLog(@"%@",[dic DYObjectForKey:@"borrow_period_name"]);
    self.deadlineLabel.text = [NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"borrow_period_name"]];//限期
//    self.detailUrl = [NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"borrow_contents_url"]];//项目详情
    
    if ([self.borrowType isEqualToString:@"fragment"]) {
        self.detailUrl=[NSString stringWithFormat:@"%@/?action&m=borrow&q=get_contents&borrow_nid=%@",ffwebURL,[dic DYObjectForKey:@"id"]];
    }else {
        self.detailUrl=[NSString stringWithFormat:@"%@/?action&m=borrow&q=get_contents&borrow_nid=%@",ffwebURL,[dic DYObjectForKey:@"borrow_nid"]];
    }
    
    
    NSLog(@"链接%@",self.detailUrl);
    
  
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    double starttime=[[dic DYObjectForKey:@"verify_time"]doubleValue];
    self.startTimeLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:starttime]]];//开始时间
    self.projectStateLabel.text = [NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"status_type_name"]];//状态名称
    self.refundWayLabel.text=[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"style_name"]];//还款方式
    
    
   self.fullstatus = [NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"borrow_full_status"]];
    
    
    
}
//项目详情
- (IBAction)projectDetail:(UIButton *)sender {

    [MobClick event:@"Novice1"];
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":self.detailUrl};
    adVC.titleM =@"项目详情";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.vcDelegate.navigationController pushViewController:adVC animated:YES];
}
//安全保障
- (IBAction)safeProtect:(UIButton *)sender {

    [MobClick event:@"Novice4"];
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/safe/index", ffwebURL];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"安全保障";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.vcDelegate.navigationController pushViewController:adVC animated:YES];
}
//风险提示
- (IBAction)safeShow:(id)sender {
    [MobClick event:@"Novice5"];

    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/safe/risk", ffwebURL];
    adVC.myUrls = @{@"url":url};    adVC.titleM =@"风险提示";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.vcDelegate.navigationController pushViewController:adVC animated:YES];
}
//还款计划
- (IBAction)repaymentPlan:(UIButton *)sender {
//    NSLog(@"还款计划");
    [MobClick event:@"Novice3"];
    if ([self.fullstatus isEqualToString:@"1"]) {
        RepaymentPlanViewController *repayVC = [[RepaymentPlanViewController alloc] initWithNibName:@"RepaymentPlanViewController" bundle:nil];
        repayVC.hidesBottomBarWhenPushed=YES;
        repayVC.borrowId=self.borrowId;
        repayVC.borrowType = self.borrowType;
        [self.vcDelegate.navigationController pushViewController:repayVC animated:YES];
    }else {
        [LeafNotification showInController:self.viewController withText:@"本条投资未进入还款期,无还款记录"];

    }
    
    
}
//投资记录
- (IBAction)record:(UIButton *)sender {
//    NSLog(@"投资记录");
    //投资人列表显示
    [MobClick event:@"Novice2"];
    DYTransactionRecordsViewController_new * vc=[[DYTransactionRecordsViewController_new alloc]initWithNibName:@"DYTransactionRecordsViewController_new" bundle:nil];
    vc.hidesBottomBarWhenPushed=YES;
    vc.borrowType = self.borrowType;
    vc.borrow_nid=self.borrowId;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)forwardRefund:(UIButton *)sender {
    

    
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":@"https://www.fengfengjinrong.com/ddjs/prepayment.html"};
    adVC.titleM =@"提前还款帮助";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.vcDelegate.navigationController pushViewController:adVC animated:YES];
    
}
- (IBAction)handleShowRule:(UIButton *)sender {
    blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+64)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.5;
    [self.viewController.tabBarController.view addSubview:blackView];
    
    tanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.viewController.tabBarController.view addSubview:tanView];
    [self shakeToShow:tanView];
    
    ruleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 40, (kMainScreenWidth - 40)/ 7 * 10)];
    ruleImageView.userInteractionEnabled = YES;
    ruleImageView.image = [UIImage imageNamed:@"bidrule"];
    ruleImageView.center = tanView.center;
    [tanView addSubview:ruleImageView];
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(CGRectGetWidth(ruleImageView.frame) - 25, 10, 15, 15);
    [closeBtn setImage:[UIImage imageNamed:@"矩形-86"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
    [ruleImageView addSubview:closeBtn];
    
}
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
- (void)handleClose {
    [blackView removeFromSuperview];
    [tanView removeFromSuperview];
    [ruleImageView removeFromSuperview];
    [closeBtn removeFromSuperview];
}

@end
