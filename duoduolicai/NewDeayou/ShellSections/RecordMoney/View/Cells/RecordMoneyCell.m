//
//  RecordMoneyCell.m
//  NewDeayou
//
//  Created by zhoubiwen on 2018/6/12.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "RecordMoneyCell.h"

@implementation RecordMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cellBackgroundView.layer.cornerRadius = 5;
    self.cellBackgroundView.layer.masksToBounds = YES;
    self.cellBackgroundView.layer.borderWidth = 1;
    self.cellBackgroundView.layer.borderColor = kCOLOR_R_G_B_A(243, 181, 58, 1).CGColor;
}

-(void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"selected"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"select"];
                    }
                }
            }
        }
    }
    [super layoutSubviews];
}


//适配第一次图片为空的情况
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (!self.selected) {
                        img.image=[UIImage imageNamed:@"select"];
                    }
                }
            }
        }
    }
    
}

@end
