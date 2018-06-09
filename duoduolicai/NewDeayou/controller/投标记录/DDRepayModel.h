//
//  DDRepayModel.h
//  NewDeayou
//
//  Created by Tony on 2016/10/27.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDRepayModel : NSObject
//this_month_original_interest 本月应收原标本息
//this_month_extra_ticket_interest 本月应收卡券或额外利息
//interest_original_total 预计原标总收益
//extra_ticket_interest_total 预计卡券或额外总收益
//reverify_time 开始计息时间
//recover_time 回款时间
//recover_capital	应收本金
//recover_interest	应收利息
//surplus_recover_account	剩余本息
@property(nonatomic,copy)NSString *this_month_original_interest;
@property(nonatomic,copy)NSString *this_month_extra_ticket_interest;
@property(nonatomic,copy)NSString *interest_original_total;
@property(nonatomic,copy)NSString *extra_ticket_interest_total;
@property(nonatomic,copy)NSString*reverify_time;
@property(nonatomic,copy)NSString*account_total;
@property (nonatomic, copy) NSString *recover_advance_fine;


@end
