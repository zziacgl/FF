//
//  DDDuoChoosePlanTableViewCell.m
//  NewDeayou
//
//  Created by 郭嘉 on 2017/9/30.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDDuoChoosePlanTableViewCell.h"
#import "DYSafeViewController.h"

@implementation DDDuoChoosePlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topView.backgroundColor = kNormalColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAttributeWithDictionary:(NSDictionary *)dic viewController:(DYInvestDetailVC *)vc{
    
    if (dic.allKeys.count<1) {
        return;
    }
    
    _dicData = dic;
    self.vcDelegate=vc;
    
    self.surplusLabel.text=[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"account"]];
    self.residueLabel.text=[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"borrow_account_wait"]];
    self.limitMinMoneyLabel.text = [NSString stringWithFormat:@"%@元", [dic DYObjectForKey:@"tender_account_min"]];//起投金额
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

    self.deadlineLabel.text = [NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"borrow_period_name"]];//限期
    self.detailUrl=[NSString stringWithFormat:@"http://www.51duoduo.com/?action&m=borrow&q=get_contents&borrow_nid=%@",[dic DYObjectForKey:@"borrow_nid"]];
    self.startTimeLabel.text=[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"style_name"]];//还款方式


}
- (IBAction)projectDetail:(id)sender {
//    DYSafeViewController *safeVC = [[DYSafeViewController alloc] initWithNibName:@"DYSafeViewController" bundle:nil];
//    safeVC.weburl = self.detailUrl;
//    safeVC.title = @"项目详情";
//    //    NSLog(@"%@", self.detailUrl);
//    [self.vcDelegate.navigationController pushViewController:safeVC animated:YES];
    
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":self.detailUrl};
    adVC.titleM =@"项目详情";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.vcDelegate.navigationController pushViewController:adVC animated:YES];

}
- (IBAction)safeProtect:(id)sender {
//    DYSafeViewController *safeVC = [[DYSafeViewController alloc] initWithNibName:@"DYSafeViewController" bundle:nil];
//    safeVC.weburl = @"https://www.51duoduo.com/lqbbz/baozhang.html";
//    safeVC.title = @"安全保障";
//    [self.vcDelegate.navigationController pushViewController:safeVC animated:YES];
    
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":@"https://www.51duoduo.com/lqbbz/baozhang.html"};
    adVC.titleM =@"安全保障";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.vcDelegate.navigationController pushViewController:adVC animated:YES];


}
- (IBAction)safeShow:(id)sender {
//    DYSafeViewController *safeVC = [[DYSafeViewController alloc] initWithNibName:@"DYSafeViewController" bundle:nil];
//    safeVC.weburl = @"https://www.51duoduo.com/ddjs/riskmsg.html";
//    safeVC.title = @"风险提示";
//    [self.vcDelegate.navigationController pushViewController:safeVC animated:YES];
    
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":@"https://www.51duoduo.com/ddjs/riskmsg.html"};
    adVC.titleM =@"风险提示";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.vcDelegate.navigationController pushViewController:adVC animated:YES];
}
@end
