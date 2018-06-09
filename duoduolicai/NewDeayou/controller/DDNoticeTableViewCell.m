//
//  DDNoticeTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/13.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDNoticeTableViewCell.h"

@implementation DDNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)cellAutoLayoutHeight:(NSString *)str {
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
    self.contentLabel.text = str;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
