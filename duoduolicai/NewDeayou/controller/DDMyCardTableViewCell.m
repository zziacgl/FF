//
//  DDMyCardTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/6/6.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMyCardTableViewCell.h"

@implementation DDMyCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.backImage];
        [self.backImage addSubview:self.myCountLabel];
        [self.backImage addSubview:self.countLabel];
        [self.backImage addSubview:self.lineImage];
        [self.backImage addSubview:self.titleLabel];
        [self.backImage addSubview:self.firstLabel];
        [self.backImage addSubview:self.secondLabel];
        [self.backImage addSubview:self.thirdLabel];
        [self.backImage addSubview:self.useTypeLabel];
        [self.backImage addSubview:self.pastLabel];
        [self.backImage addSubview:self.useLabel];
        [self.backImage addSubview:self.coverView];
        [self.coverView addSubview:self.pastImage];
        
        
    }
    return self;
    
}
- (UIImageView *)backImage {
    if (!_backImage) {
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 20, 100)];
        _backImage.image = [UIImage imageNamed:@"我的现金券"];
        CALayer *layer = [_backImage layer];
        layer.shadowOffset = CGSizeMake(0, 3);
        layer.shadowRadius = 5.0;
        layer.shadowColor = [UIColor grayColor].CGColor;
        layer.shadowOpacity = 0.3;
        
        
    }
    return _backImage;
}

- (UILabel *)myCountLabel {
    if (!_myCountLabel) {
        self.myCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.backImage.frame) / 3, 60)];
        
        _myCountLabel.textColor = [UIColor orangeColor];
        _myCountLabel.textAlignment = NSTextAlignmentCenter;
        _myCountLabel.font = [UIFont systemFontOfSize:12];
    }
    return _myCountLabel;
}
-(UILabel *)countLabel{
    if(!_countLabel){
        self.countLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.backImage.frame) / 3, 30)];
        _countLabel.textColor=kCOLOR_R_G_B_A(253, 83, 83, 1);
        _countLabel.textAlignment=NSTextAlignmentCenter;
        _countLabel.font=[UIFont systemFontOfSize:12];
        _countLabel.text=@"提现劵";
        _countLabel.hidden=YES;
    }
    return _countLabel;
}

- (UIImageView *)lineImage {
    if (!_lineImage) {
        self.lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.myCountLabel.frame), 10, 1, CGRectGetHeight(self.backImage.frame) - 20)];
        _lineImage.image = [UIImage imageNamed:@"我的卡券_10"];
    }
    return _lineImage;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lineImage.frame) + 10, 8, CGRectGetWidth(self.backImage.frame) / 3 * 2, 28)];
        _titleLabel.text = @"新手专享";
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [UIColor grayColor];
    }
    return _titleLabel;
}

- (UILabel *)firstLabel {
    if (!_firstLabel) {
        self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lineImage.frame) + 10, CGRectGetMaxY(self.titleLabel.frame) + 5, CGRectGetWidth(self.backImage.frame) / 3 * 2, 18)];
        _firstLabel.text = @"限投资15天标（新手标）";
        _firstLabel.textColor = [UIColor grayColor];
        _firstLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _firstLabel;
}
- (UILabel *)secondLabel {
    if (!_secondLabel) {
        self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lineImage.frame) + 10, CGRectGetMaxY(self.firstLabel.frame), CGRectGetWidth(self.backImage.frame) / 3 * 2, 18)];
        _secondLabel.text = @"单笔投资金额不限制";
        _secondLabel.textColor = [UIColor grayColor];
        _secondLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _secondLabel;
}

- (UILabel *)thirdLabel {
    if (!_thirdLabel) {
        self.thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lineImage.frame) + 10, CGRectGetMaxY(self.secondLabel.frame), CGRectGetWidth(self.backImage.frame) / 3 * 2, 18)];
        _thirdLabel.text = @"有效期：2016.06.06-2016.06.25";
        _thirdLabel.textColor = [UIColor grayColor];
        _thirdLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _thirdLabel;
}

- (UIImageView *)pastImage {
    if (!_pastImage) {
        self.pastImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.backImage.frame) - 60, 10, 50, 50)];
//        _pastImage.image = [UIImage imageNamed:@"我的卡券_15"];
        _pastImage.alpha = 0;
    }
    return _pastImage;
}

- (UIView *)coverView {
    if (!_coverView) {
        self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.backImage.frame), 100)];
        _coverView.backgroundColor = [UIColor whiteColor];
        _coverView.alpha = 0;
        _coverView.userInteractionEnabled = NO;
    }
    return _coverView;
}

- (UILabel *)useTypeLabel {
    if (!_useTypeLabel) {
        
        self.useTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.backImage.frame) - 60, 5, 50, 20)];
        _useTypeLabel.text = @"未使用";
        _useTypeLabel.textAlignment = NSTextAlignmentCenter;
        _useTypeLabel.font = [UIFont systemFontOfSize:11];
        _useTypeLabel.layer.cornerRadius = 5;
        _useTypeLabel.layer.masksToBounds = YES;
        _useTypeLabel.textColor = [UIColor whiteColor];
        _useTypeLabel.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
//        _useTypeLabel.alpha = 0;
    }
    return _useTypeLabel;
}




- (UILabel *)pastLabel {
    if (!_pastLabel) {
        
        self.pastLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.backImage.frame) - 60, 5, 50, 20)];
        _pastLabel.text = @"已过期";
        _pastLabel.textAlignment = NSTextAlignmentCenter;
        _pastLabel.font = [UIFont systemFontOfSize:11];
        _pastLabel.layer.cornerRadius = 5;
        _pastLabel.layer.masksToBounds = YES;
        _pastLabel.textColor = [UIColor whiteColor];
//        _pastLabel.alpha = 0;
    }
    return _useTypeLabel;
}
- (UILabel *)useLabel {
    if (!_useLabel) {
        
        self.useLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.backImage.frame) - 120, 5, 110, 20)];
        _useLabel.text = @"已使用至优选计划2020";
        _useLabel.textAlignment = NSTextAlignmentCenter;
        _useLabel.font = [UIFont systemFontOfSize:10];
        _useLabel.layer.cornerRadius = 5;
        _useLabel.layer.masksToBounds = YES;
        _useLabel.textColor = [UIColor whiteColor];
        _useLabel.backgroundColor = kCOLOR_R_G_B_A(250, 116, 117, 1);
//        _useLabel.alpha = 0;
    }
    return _useLabel;
}

@end
