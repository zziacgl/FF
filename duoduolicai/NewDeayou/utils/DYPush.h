//
//  DYPush.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/22.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"
#import "DYOrderedDictionary.h"

typedef void (^DYCompleteBlock)(id object,BOOL isSuccess,NSString * errorMessage); //网络请求完成block
typedef void (^DYErrorBlock)(id error);   //网络请求失败block

@interface DYPush : NSObject
//生成帝友字典
+(NSMutableDictionary*)DiYouDictionary;


//网络接口
+(MKNetworkOperation*)operationWithDictionary:(DYOrderedDictionary*)parmas completeBlock:(DYCompleteBlock)completeBlock errorBlock:(DYErrorBlock)errorBlock;
//中文
+(MKNetworkOperation*)ChineseOperationWithDictionary:(DYOrderedDictionary*)parmas completeBlock:(DYCompleteBlock)completeBlock errorBlock:(DYErrorBlock)errorBlock;
@end
