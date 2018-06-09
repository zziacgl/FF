//
//  versionModel.h
//  DuoDuoLiCai
//
//  Created by 陈高磊 on 2017/5/9.
//  Copyright © 2017年 陈高磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface versionModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *version_name;
@property (nonatomic, copy) NSString *force_check;
@property (nonatomic, copy) NSString *download;
@end
