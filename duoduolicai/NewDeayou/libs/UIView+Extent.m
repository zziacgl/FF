//
//  UIView+Extent.m
//  NewDeayou
//
//  Created by Tony on 2016/10/27.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "UIView+Extent.h"

@implementation UIView (Extent)
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
