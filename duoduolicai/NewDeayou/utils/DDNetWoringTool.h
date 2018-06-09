//
//  DDNetWoringTool.h
//  NewDeayou
//
//  Created by Tony on 16/10/9.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYOrderedDictionary.h"
typedef void (^DDCompleteBlock)(id object,BOOL isSuccess,NSString * errorMessage); //网络请求完成block
@interface DDNetWoringTool : NSObject
//生成帝友字典
+(NSMutableDictionary*)DiYouDictionary;

+ (void)getJSONWithUrl:(NSString *)urlStr parameters:(DYOrderedDictionary *)parameters success:(DDCompleteBlock)success fail:(void (^)())fail;

+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(DYOrderedDictionary *)parameters success:(DDCompleteBlock)success fail:(void (^)())fail;


@end
