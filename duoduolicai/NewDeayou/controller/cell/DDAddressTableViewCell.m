//
//  DDAddressTableViewCell.m
//  NewDeayou
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDAddressTableViewCell.h"
#define kMarginLeft_AvatarView 10 //头像左边距
#define kMarginTop_AvatarView 10 //头像上边距
#define kWidth_AvatarView 40  //头像宽度
#define kHeight_AvatarView 40 //头像高度

#define kMarginTop_Label 15 //标签上边距
#define kHeight_Label 30 //标签高度
#define kWidth_NameLabel 80 //姓名标签宽度
#define kWidth_PhoneLabel 150 //电话标签宽度

#define kInterSpacing 10 //左右间距

#define kWith_CallButton 60 // 按钮宽度
#define kHeight_CallButton 40 //按钮高度
@implementation DDAddressTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加子控件
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.CallButton];
    }
    return self;
}
//通过懒加载的方式创建子控件 -- 重写getter方法
- (UIImageView *)avatarView {
    CGRect frame = CGRectMake(kMarginLeft_AvatarView, kMarginTop_AvatarView, kWidth_AvatarView, kHeight_AvatarView);
    if (!_avatarView) {
        self.avatarView  = [[UIImageView alloc] initWithFrame:frame];
        _avatarView.image = [UIImage imageNamed:@"200-200"];
        _avatarView.layer.cornerRadius = 5;
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}
- (UILabel *)nameLabel {
    CGRect frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame) + kInterSpacing, kMarginTop_Label, kWidth_NameLabel, kHeight_Label);
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:frame];
        // _nameLabel.backgroundColor = [UIColor yellowColor];
        //_nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
- (UILabel *)phoneLabel {
    CGRect frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + kInterSpacing, kMarginTop_Label, kWidth_PhoneLabel, kHeight_Label);
    if (!_phoneLabel) {
        self.phoneLabel = [[UILabel alloc] initWithFrame:frame];
        //_phoneLabel.backgroundColor = [UIColor redColor];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneLabel;
}
- (UIButton *)CallButton {
    CGRect frame = CGRectMake(CGRectGetMaxX(self.phoneLabel.frame) + kInterSpacing, kMarginTop_AvatarView, kWith_CallButton, kHeight_CallButton);
    if (!_CallButton) {
        self.CallButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _CallButton.frame = frame;
        _CallButton.backgroundColor = [UIColor orangeColor];
        [_CallButton setTitle:@"邀请" forState:UIControlStateNormal];
    }
    return _CallButton;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
