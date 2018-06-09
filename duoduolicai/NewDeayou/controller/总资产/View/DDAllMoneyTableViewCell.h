//
//  DDAllMoneyTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/25.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCChart.h"
#import "DDAllMoneyModel.h"
@interface DDAllMoneyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *myPieView;
@property (nonatomic, strong) SCPieChart *chartView;
@property (nonatomic, strong) DDAllMoneyModel *model;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;//可用余额百分比
@property (weak, nonatomic) IBOutlet UILabel *frost_percentLabel;//冻结资金百分比
@property (weak, nonatomic) IBOutlet UILabel *await_capital_percentLabel;//待收本金百分比
@property (weak, nonatomic) IBOutlet UILabel *await_interest_percentLabel;//待收收益百分比
@property (weak, nonatomic) IBOutlet UILabel *canUseMoneyLabel;//可用余额
@property (weak, nonatomic) IBOutlet UILabel *frostLabel;//冻结金额
@property (weak, nonatomic) IBOutlet UILabel *awaitLabel;//待收本金
@property (weak, nonatomic) IBOutlet UILabel *await_interestLabel;//待收收益
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *frostBtn;
@property (weak, nonatomic) IBOutlet UIButton *capitalBtn;
@property (weak, nonatomic) IBOutlet UIButton *interestBtn;


@property (nonatomic, copy) NSString *interestMoney;
@property (nonatomic, copy) NSString *capitalMoney;
@property (nonatomic, copy) NSString *frozeMoney;
@end
