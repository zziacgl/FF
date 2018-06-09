//
//  DDBackView.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/1.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^myBlock)(void);
@interface DDBackView : UIView
@property(nonatomic,copy)myBlock block;
@end
