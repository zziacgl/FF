//
//  WriteGoodsInfoView.m
//  NewDeayou
//
//  Created by zhoubiwen on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "WriteGoodsInfoView.h"

@interface WriteGoodsInfoView ()

@end

@implementation WriteGoodsInfoView


+ (void)showViewSureButtonAction:(void(^)(ShellGoodsModel *shellGoodsModel))sureButtonAction {
    WriteGoodsInfoView *view = [[NSBundle mainBundle] loadNibNamed:@"WriteGoodsInfoView" owner:nil options:nil].firstObject;
    view.frame = [UIScreen mainScreen].bounds;
    [view show];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    
}

- (void)show {
    self.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self hide];
}

- (IBAction)sureButtonPressed:(id)sender {
}

@end
