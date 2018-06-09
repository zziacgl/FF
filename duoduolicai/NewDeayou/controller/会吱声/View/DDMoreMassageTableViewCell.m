//
//  DDMoreMassageTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/3.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMoreMassageTableViewCell.h"

@implementation DDMoreMassageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellAutoLayoutHeight:(NSString *)str {
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
    self.contentLabel.text = str;
}

- (void)setModel:(DDMoreMassageModel *)model {
    NSString *str2 = model.reply_user;
    NSString *str1 = model.user;
    
   
    
    NSUInteger len1 = [str1 length];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@回复%@",str1,str2]];
    [str3 addAttribute:NSForegroundColorAttributeName value:[HeXColor colorWithHexString:@"#666666"] range:NSMakeRange(len1,2)];
    self.titleLabel.attributedText=str3;
   
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.addtime doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm";
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *timeString = [formatter stringFromDate:date];
    self.timeLabel.text = timeString;
    
    self.contentLabel.text = model.message;
}

@end
