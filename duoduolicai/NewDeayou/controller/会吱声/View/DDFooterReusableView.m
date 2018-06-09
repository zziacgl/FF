//
//  DDFooterReusableView.m
//  NewDeayou
//
//  Created by Tony on 2016/10/31.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDFooterReusableView.h"
#import "DDMoreMassageViewController.h"
@implementation DDFooterReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.button = [[UIButton alloc]initWithFrame:self.bounds];
        [self.button setTitle:@"查看更多" forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.button setTitleColor:[HeXColor colorWithHexString:@"#999999"]  forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.button];
    }
    return self;
}


- (void)tapAction{
    if (self.block) {
        self.block();
    }
}
@end
