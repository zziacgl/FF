//
//  ShellSearchTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/12.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "ShellSearchTableViewCell.h"

@implementation ShellSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.searchBackView.layer.cornerRadius = 5;
    self.searchBackView.layer.masksToBounds = YES;
    self.searchBackView.layer.borderWidth = 1;
    self.searchBackView.layer.borderColor = kCOLOR_R_G_B_A(243, 181, 58, 1).CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
