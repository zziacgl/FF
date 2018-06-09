//
//  AddRecordFirstTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/8.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "AddRecordFirstTableViewCell.h"

@implementation AddRecordFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat viewHeight = self.contentView.frame.size.height / 3 - 10;
    self.nicknameView.layer.cornerRadius = viewHeight / 2;
    self.nicknameView.layer.masksToBounds = YES;
    self.nicknameView.layer.borderWidth = 1;
    self.nicknameView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.phoneNumberView.layer.cornerRadius = viewHeight / 2;
    self.phoneNumberView.layer.masksToBounds = YES;
    self.phoneNumberView.layer.borderWidth = 1;
    self.phoneNumberView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.emailView.layer.cornerRadius = viewHeight / 2;
    self.emailView.layer.masksToBounds = YES;
    self.emailView.layer.borderWidth = 1;
    self.emailView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
