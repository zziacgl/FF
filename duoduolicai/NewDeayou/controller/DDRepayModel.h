//
//  DDRepayModel.h
//  NewDeayou
//
//  Created by Tony on 2016/10/27.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDRepayModel : NSObject
//recover_account 本月应收
//recover_interest_total 预计总收益
//reverify_time 开始计息时间
//recover_time 回款时间
//recover_capital	应收本金
//recover_interest	应收利息
//surplus_recover_account	剩余本息
@property(nonatomic,copy)NSString*recover_account;
@property(nonatomic,copy)NSString*recover_interest_total;
@property(nonatomic,copy)NSString*reverify_time;




@end
