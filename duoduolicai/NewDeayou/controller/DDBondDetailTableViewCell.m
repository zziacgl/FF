//
//  DDBondDetailTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/8/10.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDBondDetailTableViewCell.h"
@implementation DDBondDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isSureBtn.layer.cornerRadius = 5;
    self.isSureBtn.layer.masksToBounds = YES;
    
    // Initialization code
}
- (IBAction)readBtn:(UIButton *)sender {
    _isReadImage.highlighted = _isReadImage.isHighlighted ? NO : YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
