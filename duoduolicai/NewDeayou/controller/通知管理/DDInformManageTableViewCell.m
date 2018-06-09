//
//  DDInformManageTableViewCell.m
//  NewDeayou
//
//  Created by 郭嘉 on 2017/11/30.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDInformManageTableViewCell.h"

@implementation DDInformManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)openOrclose:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end
