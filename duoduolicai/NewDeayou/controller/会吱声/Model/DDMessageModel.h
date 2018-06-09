//
//  DDMessageModel.h
//  NewDeayou
//
//  Created by Tony on 2016/10/31.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//{"id":"1",
//    "root_id":"1",
//    "reward_type":"lollipop",
//    "reward_num":"66",
//    "message":"\u9001\u4f6066\u652f\u68d2\u68d2\u7cd6\uff0cO(\u2229_\u2229)O~",
//    "addtime":"1477644819",
//    "user":"\u5f11\u7fbd\u7edd",
//    "son_info":[{"id":"4",
//        "root_id":"1",
//        "reward_type":"",
//        "reward_num":"0",
//        "message":"\u54c8\u54c8\u54c8a",
//        "addtime":"1477645753",
//        "user":"\u5305\u5b50",
//        "reply_user":"\u5f11\u7fbd\u7edd"}
@interface DDMessageModel : NSObject
@property(nonatomic,copy)NSString * root_id;
@property(nonatomic,copy)NSString * messageID;
@property(nonatomic,copy)NSString * reward_num;
@property(nonatomic,copy)NSString * message;
@property(nonatomic,copy)NSString * addtime;
@property(nonatomic,copy)NSString * user;
@property(nonatomic,copy)NSString * reply_user;
@property(nonatomic,copy)NSString * avatar;
@property(nonatomic,copy)NSString * reward_type;

@property(nonatomic,strong)NSArray* son_info;





@end
