//
//  DDMessageModel.m
//  NewDeayou
//
//  Created by Tony on 2016/10/31.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMessageModel.h"

@implementation DDMessageModel
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"messageID":@"id"};
}
+(NSDictionary*)mj_objectClassInArray{
    return @{@"son_info":[DDMessageModel class]};
}
@end
