//
//  DDNoCardTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/6/8.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDNoCardTableViewCell.h"

@implementation DDNoCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.myImage];
        [self.contentView addSubview:self.masageLabel];
    }
    return self;
}

- (UIImageView *)myImage {
    if (!_myImage) {
        self.myImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3, kMainScreenHeight / 2 - kMainScreenWidth / 2 , kMainScreenWidth / 3, kMainScreenWidth / 4)];
        _myImage.image = [UIImage imageNamed:@"我的卡券（无可用优惠券）_03"];
    }
    return _myImage;

}

- (UILabel *)masageLabel {
    if (!_masageLabel) {
        self.masageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myImage.frame) + 20, kMainScreenWidth, 40)];
        _masageLabel.text = @"暂无卡券~";
        _masageLabel.textColor = [UIColor lightGrayColor];
        _masageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _masageLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
