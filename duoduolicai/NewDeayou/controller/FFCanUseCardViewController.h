//
//  FFCanUseCardViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/1/17.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFRedPacketmodel.h"
typedef void (^newBlock)(FFRedPacketmodel *);

@interface FFCanUseCardViewController : UIViewController
@property (nonatomic, copy) NSString *markID;
@property (nonatomic, strong) NSArray *dataAry;

@property (nonatomic, copy) newBlock block;
- (void)text:(newBlock)block;

@end
