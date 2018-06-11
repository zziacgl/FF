//
//  ShellRecordModel.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/9.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "ShellRecordModel.h"
#import <objc/runtime.h>
#import "ShellGoodsModel.h"

@implementation ShellRecordModel

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"goods"]) {
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dict in arr) {
            ShellGoodsModel *model = [ShellGoodsModel new];
            [model setValuesForKeysWithDictionary:dict];
            [arr addObject:model];
        }
        self.goods = arr;
    }
}

- (NSDictionary *)convertDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    unsigned int count = 0;
    objc_property_t *propertyList =  class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if ([propertyName isEqualToString:@"goods"]) {
            NSMutableArray *arr = [NSMutableArray new];
            for (ShellGoodsModel *model in self.goods) {
                [arr addObject:[model convertDictionary]];
            }
            [dict setValue:arr forKey:propertyName];
        }else {
            if ([self valueForKey:propertyName]) {
                [dict setValue:[self valueForKey:propertyName] forKey:propertyName];
            }
        }
    }
    free(propertyList);
    return dict;
}


@end
