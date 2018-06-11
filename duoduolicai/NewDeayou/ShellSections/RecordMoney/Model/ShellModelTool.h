//
//  ShellModelTool.h
//  NewDeayou
//
//  Created by zhoubiwen on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Sale, //出售记录
    Purchase, // 进货记录
} RecordType;

typedef enum : NSUInteger {
    GoodNotDispatched, // 未发货
    GoodHasDispatched, // 已发货
} SHippingStatus;

@class ShellRecordModel;

@interface ShellModelTool : NSObject

+ (NSArray *)getRecord:(RecordType)recordType;

+ (void)saveRecordModel:(ShellRecordModel *)recordModel;

+ (void)modifyRecordModel:(ShellRecordModel *)recordModel;

+ (void)deleteRecordModel:(ShellRecordModel *)recordModel;

@end
