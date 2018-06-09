//
//  DYHeadTableViewCell.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/10/7.
//  Copyright © 2015年 wayne. All rights reserved.
//

#import "DYHeadTableViewCell.h"

@implementation DYHeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=kCOLOR_R_G_B_A(28, 137, 207, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
