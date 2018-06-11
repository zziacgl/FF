//
//  ShellGoodsModel.m
//  NewDeayou
//
//  Created by zhoubiwen on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "ShellGoodsModel.h"
#import <objc/runtime.h>

@implementation ShellGoodsModel

- (NSDictionary *)convertDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    unsigned int count = 0;
    objc_property_t *propertyList =  class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if ([self valueForKey:propertyName]) {
            [dict setValue:[self valueForKey:propertyName] forKey:propertyName];
        }
    }
    free(propertyList);
    return dict;
}

@end
