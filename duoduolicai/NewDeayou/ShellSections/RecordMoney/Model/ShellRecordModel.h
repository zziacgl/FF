//
//  ShellRecordModel.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/9.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShellModelTool.h"

@interface ShellRecordModel : NSObject

@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *postage; // 邮费
@property (nonatomic, strong) NSString *remark; // 备注
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSArray *goods;

@property (nonatomic, assign) RecordType recordType;
@property (nonatomic, assign) SHippingStatus shippingStatus;

- (NSDictionary *)convertDictionary;


@end
