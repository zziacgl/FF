//
//  DDAllMoneyTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/25.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDAllMoneyTableViewCell.h"
#import "DYFinancialRecordsVC.h"
#import "DDFrozenViewController.h"
#import "DDhasWonMoneyViewController.h"
#import "DDCapitalViewController.h"
@implementation DDAllMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    
}
- (void)setModel:(DDAllMoneyModel *)model {
    _model = model;
    self.canUseMoneyLabel.text = [NSString stringWithFormat:@"%@元", model.balance];
    self.frostLabel.text = [NSString stringWithFormat:@"%@元",model.frost];
    self.awaitLabel.text = [NSString stringWithFormat:@"%@元",model.await_capital];
    self.await_interestLabel.text = [NSString stringWithFormat:@"%@元",model.await_interest];
    
    self.capitalMoney = model.await_capital;
    self.interestMoney = model.await_interest;
    self.frozeMoney = model.frost;
    if (_chartView) {
        [self.chartView removeFromSuperview];
        self.chartView = nil;
    }
    
    NSArray *items = @[[SCPieChartDataItem dataItemWithValue:[model.balance_percent floatValue] color:[HeXColor colorWithHexString:@"#E78C8F"] description:@""],
                       [SCPieChartDataItem dataItemWithValue:[model.frost_percent floatValue] color:[HeXColor colorWithHexString:@"#BD6065"] description:@""],
                       [SCPieChartDataItem dataItemWithValue:[model.await_capital_percent floatValue] color:[HeXColor colorWithHexString:@"#F6BF6E"] description:@""],
                       [SCPieChartDataItem dataItemWithValue:[model.await_interest_percent floatValue] color:[HeXColor colorWithHexString:@"#84B5B2"] description:@""]
                       ];
    
    self.chartView = [[SCPieChart alloc] initWithFrame:CGRectMake(10, 10, 140.0, 140.0) items:items];
    self.chartView.descriptionTextColor = [UIColor whiteColor];
    self.chartView.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:12.0];
    [self.chartView strokeChart];
    [self.myPieView addSubview:self.chartView];
}

- (IBAction)balanceDetial:(UIButton *)sender {
    DYFinancialRecordsVC *VC = [[DYFinancialRecordsVC alloc]initWithNibName:@"DYFinancialRecordsVC" bundle:nil];
    VC.money = self.model.balance;// 可用余额
    VC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:VC animated:YES];
}
- (IBAction)frostDetail:(UIButton *)sender {
    DDFrozenViewController *vc = [[DDFrozenViewController alloc] initWithNibName:@"DDFrozenViewController" bundle:nil];
    vc.moneyStr = self.frozeMoney;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}
//待收本金
- (IBAction)capitalDetail:(UIButton *)sender {
    DDCapitalViewController *capitalVC = [[DDCapitalViewController alloc] initWithNibName:@"DDCapitalViewController" bundle:nil];
    capitalVC.capitalMoney = self.capitalMoney;
    [self.viewController.navigationController pushViewController:capitalVC animated:YES];
    
}

- (IBAction)interestDetail:(UIButton *)sender {
    DDhasWonMoneyViewController *moneyVC = [[DDhasWonMoneyViewController alloc]initWithNibName:@"DDhasWonMoneyViewController" bundle:nil];
    moneyVC.hidesBottomBarWhenPushed = YES;
    moneyVC.typeStr = @"collecting";
    moneyVC.nameStr = @"待收收益总额(元)";
    moneyVC.title = @"待收收益";
    moneyVC.prodectStr = @"";
    moneyVC.moneyStr = self.interestMoney;
    [self.viewController.navigationController pushViewController:moneyVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
