//
//  DYNetWork2.h
//  NewDeayou
//
//  Created by diyou on 14-7-31.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"

typedef void (^DYCompleteBlock2)(id object,NSString * error); //网络请求完成block
typedef void (^DYErrorBlock)(id error);   //网络请求失败block
 
@interface DYNetWork2 : NSObject

//额度申请记录
+(MKNetworkOperation*)DYBorrowLimitApplicationRecordUsedID:(int)userID page:(int)page completeBlock:(DYCompleteBlock2)completeBlock errorBlock:(DYErrorBlock)errorBlock;



//生成帝友字典
+(NSMutableDictionary*)DiYouDictionary;


//网络接口
+(MKNetworkOperation*)operationWithDictionary:(DYOrderedDictionary*)parmas completeBlock:(DYCompleteBlock)completeBlock errorBlock:(DYErrorBlock)errorBlock;


@end
