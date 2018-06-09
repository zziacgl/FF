//
//  DDRankListTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/10/31.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDRankListTableViewCell.h"

@implementation DDRankListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(DDRankListModel *)model {
    _model = model;
//    NSLog(@"_model%@", model);
    [self.avartView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.phoneLabel.text = model.user;
    self.duomiLabel.text = model.sum_duomi_num;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
