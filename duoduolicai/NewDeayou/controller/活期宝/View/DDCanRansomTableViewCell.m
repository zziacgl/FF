//
//  DDCanRansomTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/11.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDCanRansomTableViewCell.h"
#import "DDRansomDetailViewController.h"
@implementation DDCanRansomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ransomBtn.layer.borderColor = kMainColor2.CGColor;
    // Initialization code
}

- (void)setCanRansomModel:(DDCanRansomModel *)canRansomModel {
    self.nameLabel.text = canRansomModel.name;
    self.moneyLabel.text = [NSString stringWithFormat:@"投资金额：%@元", canRansomModel.account];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[canRansomModel.borrow_start_time doubleValue]];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[canRansomModel.repay_last_time doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd";
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *startTime = [formatter stringFromDate:date];
    NSString *lastTime = [formatter stringFromDate:date1];
    self.timeLabel.text = [NSString stringWithFormat:@"投资时间：%@-%@",startTime,lastTime];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
