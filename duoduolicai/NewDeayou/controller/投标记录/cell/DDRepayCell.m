//
//  DDRepayCell.m
//  NewDeayou
//
//  Created by Tony on 2016/10/27.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDRepayCell.h"

@implementation DDRepayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setOtherModel:(DDRepayOtherModel *)otherModel{
//    _otherModel  = otherModel;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[otherModel.recover_time doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *timeString = [formatter stringFromDate:date];
    self.time.text = [NSString stringWithFormat:@"%@ 第%@期回款",timeString,otherModel.recover_period];
    
//       NSLog(@"还款%@", otherModel);
    if ([otherModel.recover_status isEqualToString:@"1"]) {
        self.icon.image = [UIImage imageNamed:@"huankuan_icon_sel"];
        self.line.backgroundColor = kCOLOR_R_G_B_A(83, 194, 154, 1);
        NSString * string = [NSString stringWithFormat:@"应收本金 %@ 元  应收利息 %@ 元",otherModel.recover_capital,otherModel.recover_interest];
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:string];
        NSRange range1 = NSMakeRange(5, otherModel.recover_capital.length);
        NSRange xiRange = [string rangeOfString:@"息"];
        NSRange range2 = NSMakeRange(xiRange.location+2, otherModel.recover_interest.length);
        NSDictionary *dic = @{
                              NSForegroundColorAttributeName:kCOLOR_R_G_B_A(241, 78, 86, 1)
                              };
        [aString setAttributes:dic range:range1];
        [aString setAttributes:dic range:range2];
        self.oneLabel.attributedText = aString;
        
        NSString * twoString = [NSString stringWithFormat:@"本息余额 %@ 元",otherModel.surplus_recover_account];
        NSMutableAttributedString *aTwoString = [[NSMutableAttributedString alloc]initWithString:twoString];
         NSRange twoRange = NSMakeRange(5, otherModel.surplus_recover_account.length);
        [aTwoString setAttributes:dic range:twoRange];
        self.twoLabel.attributedText = aTwoString;
        
    }else {
        self.icon.image = [UIImage imageNamed:@"huankuan_icon_nor"];
        self.line.backgroundColor = kCOLOR_R_G_B_A(221, 221, 221, 1);
        float moneyA = [otherModel.recover_capital floatValue];
        float moneyB = [otherModel.recover_interest floatValue];
        NSString * string = [NSString stringWithFormat:@"应收本金 %.2f 元  应收利息 %.2f 元",moneyA,moneyB];
         NSString * twoString = [NSString stringWithFormat:@"本息余额 %@ 元",otherModel.surplus_recover_account];
        self.oneLabel.text = string;
        self.twoLabel.text = twoString;
    }
    
}
- (void)setModel:(DDRepayModel *)model{
    _model = model;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.reverify_time doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *timeString = [formatter stringFromDate:date];
    self.time.text = timeString;
    self.oneLabel.text = @"开始计息";
    
    NSString * twoString =[NSString stringWithFormat:@"本息余额 %@ 元",model.account_total];
    NSMutableAttributedString *aTwoString = [[NSMutableAttributedString alloc]initWithString:twoString];
    NSRange twoRange = NSMakeRange(5, model.account_total.length);
    NSDictionary *dic = @{
                          NSForegroundColorAttributeName:kCOLOR_R_G_B_A(241, 78, 86, 1)
                          };
    
    [aTwoString setAttributes:dic range:twoRange];
    self.twoLabel.attributedText = aTwoString;
    
    
    
    
}

@end
