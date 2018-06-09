//
//  DDBarnerModel.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/21.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDBarnerModel.h"

@implementation DDBarnerModel
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"banaerID":@"id",@"typeName":@"typename"};
}

@end
