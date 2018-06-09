//
//  CustomViewCell.m
//  NewDeayou
//
//  Created by apple on 15/11/23.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "CustomViewCell.h"

@implementation CustomViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;

}
- (UILabel *)tittleLabel {
    if (!_tittleLabel) {
        self.tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.frame), 30)];
        self.tittleLabel.textColor = [UIColor orangeColor];
    }
    return _tittleLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.tittleLabel.frame), 20, 20)];
        self.detailLabel.textColor = [UIColor lightGrayColor];
        self.detailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _detailLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
