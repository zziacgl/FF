//
//  DDOtherVideoViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/10/28.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDOtherVideoModel;
@interface DDOtherVideoViewController : DYBaseVC
@property(nonatomic,copy)void(^returnBlock)(DDOtherVideoModel*model);
@end
