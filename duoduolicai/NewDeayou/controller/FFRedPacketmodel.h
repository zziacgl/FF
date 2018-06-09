//
//  FFRedPacketmodel.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/1/18.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFRedPacketmodel : NSObject
@property (nonatomic, copy) NSString *addtime;//开始时间
@property (nonatomic, copy) NSString *award;//金额
@property (nonatomic, copy) NSString *deadline;//结束时间
@property (nonatomic, copy) NSString *invest_account;//起投金额
@property (nonatomic, copy) NSString *lifetstatus;//是否可用
@property (nonatomic, copy) NSString *lifetstatus_name;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *period_name;//最低投资使用期限
@property (nonatomic, copy) NSString *recom;
@property (nonatomic, copy) NSString *recom_name;//来源
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *status_name;//状态
@property (nonatomic, copy) NSString *time_unit;//1天2月
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *type_name;
@property (nonatomic, copy) NSString *cardID;
@property (nonatomic, copy) NSString *award_money;


@end
