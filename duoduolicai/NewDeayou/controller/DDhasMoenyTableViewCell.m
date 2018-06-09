//
//  DDhasMoenyTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/18.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDhasMoenyTableViewCell.h"

@implementation DDhasMoenyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(DDCapitalModel *)model {
    self.nameLabel.text = model.name;
    self.moneyLabel.text = model.money;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.addtime doubleValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *startTime = [formatter stringFromDate:date];
   
    self.timeLabel.text = [NSString stringWithFormat:@"%@",startTime];


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
