//
//  DDBackView.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/1.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDBackView.h"

@implementation DDBackView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.block) {
        self.block();
    }
    
}

@end
