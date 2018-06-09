//
//  DDUITextField.m
//  NewDeayou
//
//  Created by 郭嘉 on 16/3/30.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDUITextField.h"
#define margin 20//缩进长度
@implementation DDUITextField
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)textRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+margin, bounds.origin.y, bounds.size.width-margin, bounds.size.height);
    return inset;
}
-(CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect inset =CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}
@end
