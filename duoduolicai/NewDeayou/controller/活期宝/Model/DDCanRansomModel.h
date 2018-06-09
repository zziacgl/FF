//
//  DDCanRansomModel.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/28.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCanRansomModel : NSObject

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *borrow_start_time;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *recover_account_all;
@property (nonatomic, copy) NSString *repay_last_time;
@property (nonatomic, copy) NSString *sum_recover_interest;
@property (nonatomic, copy) NSString *url;
@end
