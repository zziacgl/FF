//
//  UILabel+LabelHeightAndWidth.h
//  DuoDuoLiCai
//
//  Created by 陈高磊 on 2017/5/9.
//  Copyright © 2017年 陈高磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabelHeightAndWidth)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;
@end
