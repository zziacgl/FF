//
//  DDAllMoneyModel.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/25.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDAllMoneyModel : NSObject
@property (nonatomic, copy) NSString *await_capital;//待收本金
@property (nonatomic, copy) NSString *await_capital_percent;//待收本金百分比
@property (nonatomic, copy) NSString *await_interest;//待收利息
@property (nonatomic, copy) NSString *await_interest_percent;//待收利息百分比
@property (nonatomic, copy) NSString *balance_percent;
@property (nonatomic, copy) NSString *balance;//余额
@property (nonatomic, copy) NSString *frost;//冻结金额
@property (nonatomic, copy) NSString *frost_percent;//冻结金额百分比
@property (nonatomic, copy) NSString *total;//总额

@end
