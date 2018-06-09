//
//  DDBondTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/8/9.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDBondTableViewCell.h"


#define kSpace    10
#define kTitleLabelHeight  30
#define k_Height   25
#define kHeight_Btn   30
#define kWidth_Btn    70
#define kProgress     60
@implementation DDBondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kCOLOR_R_G_B_A(236, 236, 236, 1);
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.moneyLabel];
        [self.backView addSubview:self.timeLabel];
        [self.backView addSubview:self.transferBtn];
        [self.backView addSubview:self.progressView];
        [self.backView addSubview:self.overImage];
        
    }
    return self;
    
}

- (UIView *)backView {
    if (!_backView) {
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kMainScreenWidth , 100)];
        _backView.backgroundColor = kCOLOR_R_G_B_A(249, 250, 251, 1);
        CALayer *layer = [_backView layer];
        layer.shadowOffset = CGSizeMake(0, 3);
        layer.shadowRadius = 5.0;
        layer.shadowColor = [UIColor grayColor].CGColor;
        layer.shadowOpacity = 0.3;
        
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpace, kSpace, kMainScreenWidth - kSpace, kTitleLabelHeight)];
        _titleLabel.text = @"车贷宝999";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = kCOLOR_R_G_B_A(51, 51, 51, 1);
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpace, CGRectGetMaxY(self.titleLabel.frame), kMainScreenWidth - kSpace, k_Height)];
        _moneyLabel.textColor = kCOLOR_R_G_B_A(51, 51, 51, 1);
        _moneyLabel.text = @"投资金额：88888.00元";
        _moneyLabel.font = [UIFont systemFontOfSize:12];
    }
    return _moneyLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpace, CGRectGetMaxY(self.moneyLabel.frame), kMainScreenWidth - kSpace, k_Height + 10)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = kCOLOR_R_G_B_A(51, 51, 51, 1);
        _timeLabel.text = @"投资时间:2016-04-12到2016-05-12";
        _timeLabel.numberOfLines = 0;
        
    }
    return _timeLabel;
}

- (UIButton *)transferBtn {
    if (!_transferBtn) {
        self.transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _transferBtn.frame = CGRectMake(kMainScreenWidth - kSpace - kWidth_Btn, CGRectGetHeight(self.frame) / 2  , kWidth_Btn, kHeight_Btn);
        [_transferBtn setTitle:@"转让" forState:UIControlStateNormal];
        _transferBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_transferBtn setTitleColor:kMainColor forState:UIControlStateNormal];
        
        _transferBtn.layer.masksToBounds = YES;
        _transferBtn.layer.cornerRadius = 5.0;
        _transferBtn.layer.borderWidth = 1;
        _transferBtn.layer.borderColor = kMainColor.CGColor;
        _transferBtn.alpha = 0;
        
    }
    return _transferBtn;
}

- (UIView *)progressView {
    if (!_progressView) {
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth - kProgress - kSpace, CGRectGetHeight(self.frame) / 2 , kProgress, kProgress)];
        _progressView.alpha = 0;
        //        _progressView.backgroundColor = [UIColor lightGrayColor];
        self.pieChartView = [[DDCircle alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self.progressView addSubview:self.pieChartView];
        
        
    }
    return _progressView;
}

- (UIImageView *)overImage {
    if (!_overImage) {
        self.overImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - kProgress - kSpace, CGRectGetHeight(self.frame) / 2, kProgress, kProgress)];
        _overImage.alpha = 0;
        _overImage.layer.masksToBounds = YES;
        _overImage.layer.cornerRadius = kProgress / 2;
        _overImage.layer.borderWidth = 1;
        _overImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        UILabel *overLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kProgress, kProgress)];
        overLabel.text = @"抢光";
        overLabel.textAlignment = NSTextAlignmentCenter;
        overLabel.textColor = [UIColor lightGrayColor];
        overLabel.font = [UIFont systemFontOfSize:15];
        [self.overImage addSubview:overLabel];
        
       
    }
    return _overImage;
}
-(void)setAttributeWithDictionary:(NSDictionary*)dic viewController:(DDInTransferTableViewController*)vc{
    float prent = [[dic objectForKey:@"transfer_borrow_account_scale"] floatValue];
    [_pieChartView updatePercent:prent animation:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
