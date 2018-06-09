//
//  DYMoreFootView.m
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/13.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYMoreFootView.h"

@implementation DYMoreFootView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button setTitleColor:[HeXColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageWithColor:kMainColor] forState:UIControlStateNormal];
//        button.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:83 / 255.0 blue:83 / 255.0 alpha:1];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        button.center = self.center;
        self.exitButton = button;
        [self addSubview:button];
    }
    return self;
}
@end
