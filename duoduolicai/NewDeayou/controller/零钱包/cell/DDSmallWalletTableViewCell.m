//
//  DDSmallWalletTableViewCell.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/11.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDSmallWalletTableViewCell.h"
#import "LGGradientBackgroundView.h"
@implementation DDSmallWalletTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.detaiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.HeadView.frame) - 95, [UIScreen mainScreen].bounds.size.width, 30)];
    _detaiLabel.textAlignment = NSTextAlignmentCenter;
    _detaiLabel.textColor = [UIColor whiteColor];
    _detaiLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.detaiLabel];
    self.YesterdayEarnings.textColor=kCOLOR_R_G_B_A(255, 112, 112, 1);
    self.Line1.backgroundColor=kCOLOR_R_G_B_A(217, 217, 217, 1);
    self.Line2.backgroundColor=kCOLOR_R_G_B_A(217, 217, 217, 1);
    self.Line3.backgroundColor=kCOLOR_R_G_B_A(217, 217, 217, 1);
//    NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:@"年化收益8.0%，每周涨0.5%，最高10.88%"];
//    [str4 addAttribute:NSForegroundColorAttributeName value:kCOLOR_R_G_B_A(254, 207, 126, 1) range:NSMakeRange(19,5)];
//    self.detaiLabel.attributedText = str4;
    
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.HeadView.frame) - 55, kMainScreenWidth - 60 , 44)];
    rightLabel.backgroundColor = [UIColor clearColor];
    rightLabel.layer.cornerRadius = 5;
    rightLabel.layer.masksToBounds = YES;
    rightLabel.text = @"转  入";
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.font = [UIFont systemFontOfSize:25];
    [self addSubview:rightLabel];
    
    self.TranIn = [UIButton buttonWithType:UIButtonTypeCustom];
    _TranIn.frame = CGRectMake(30, CGRectGetMaxY(self.HeadView.frame) - 55, kMainScreenWidth - 60 , 44);
    _TranIn.layer.cornerRadius = 5;
    _TranIn.layer.masksToBounds = YES;
    [_TranIn setTitle:@"转  入" forState:UIControlStateNormal];
    [_TranIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _TranIn.backgroundColor = [UIColor whiteColor];
    _TranIn.alpha = 0.3;
    _TranIn.titleLabel.font = [UIFont systemFontOfSize:25];
    _TranIn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.TranIn];
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
