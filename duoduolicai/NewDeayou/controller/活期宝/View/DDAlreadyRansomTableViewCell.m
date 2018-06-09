//
//  DDAlreadyRansomTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/11.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDAlreadyRansomTableViewCell.h"

@implementation DDAlreadyRansomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(DDAlreadyRansomModel *)model {
    self.nameLabel.text = model.name;
    self.ransomMoneyLabel.text = [NSString stringWithFormat:@"退出金额：%@元", model.account];
    NSString *str = model.sum_recover_interest;
    NSUInteger len1 = [str length];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收益：%@元", str]];
    [str3 addAttribute:NSForegroundColorAttributeName value:kMainColor2 range:NSMakeRange(3,len1 + 1)];
    self.getMoneyLabel.attributedText=str3;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.borrow_start_time doubleValue]];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[model.current_time doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd";
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *startTime = [formatter stringFromDate:date];
    NSString *lastTime = [formatter stringFromDate:date1];
    self.timeLabel.text = [NSString stringWithFormat:@"持有时间：%@-%@",startTime,lastTime];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
