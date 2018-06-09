//
//  DDBarnerModel.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/21.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDBarnerModel : NSObject
@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, copy) NSString *full_pic_url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *banaerID;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, strong) NSDictionary *share;


@end
