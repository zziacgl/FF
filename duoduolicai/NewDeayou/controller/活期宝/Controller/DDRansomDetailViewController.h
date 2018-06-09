//
//  DDRansomDetailViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/22.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCanRansomModel.h"
@interface DDRansomDetailViewController : DYBaseVC
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) DDCanRansomModel *model;
@property (weak, nonatomic) IBOutlet UILabel *investMoneyLabel;//投资金额
@property (weak, nonatomic) IBOutlet UILabel *oldInvestTimeLabel;//原投资时间
@property (weak, nonatomic) IBOutlet UILabel *recoverAccountAllLabel;//原回收本息
@property (weak, nonatomic) IBOutlet UILabel *handTimeLabel;//持有时间
@property (weak, nonatomic) IBOutlet UILabel *ransomMoney;//赎回金额
@property (weak, nonatomic) IBOutlet UILabel *getMoneyLabel;//已获收益

@end
