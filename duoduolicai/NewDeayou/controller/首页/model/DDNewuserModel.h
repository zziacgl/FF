//
//  DDNewuserModel.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/21.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDNewuserModel : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *borrow_period_name;
@property(nonatomic, copy) NSString *tender_account_min;
@property(nonatomic, copy) NSString *borrow_apr;
@property(nonatomic, copy) NSString *borrow_nid;
@property(nonatomic, copy) NSString *borrow_type;
@property(nonatomic, copy) NSString *borrow_status_nid;
@property(nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *extra_borrow_apr;
@property(nonatomic, copy) NSString *investID;
@property (nonatomic, copy) NSString *product;

@end
