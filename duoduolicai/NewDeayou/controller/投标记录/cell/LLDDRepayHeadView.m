//
//  LLDDRepayHeadView.m
//  NewDeayou
//
//  Created by Tony on 2016/10/27.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "LLDDRepayHeadView.h"

@implementation LLDDRepayHeadView

- (void)setModel:(DDRepayModel *)model{
    _model = model;
    if (model!=nil) {
    NSString * string = [NSString stringWithFormat:@"本月应收原标本：%@元",model.this_month_original_interest];
    self.presentMonth.attributedText  =  [self showINLabelWithString:string num:8];
        
    NSString * string1 = [NSString stringWithFormat:@"本月应收卡劵或额外利息：%@元",model.this_month_extra_ticket_interest];
    self.benKJ.attributedText  =  [self showINLabelWithString:string1 num:12];
        
    NSString * string2 = [NSString stringWithFormat:@"预计原标总收益：%@元",model.interest_original_total];
     self.total.attributedText =  [self showINLabelWithString:string2 num:8];
        
    NSString * string3 = [NSString stringWithFormat:@"预计卡劵或额外总收益：%@元",model.extra_ticket_interest_total];
    self.yujiKJ.attributedText  =  [self showINLabelWithString:string3 num:11];
    }
   
}
- (NSMutableAttributedString*)showINLabelWithString:(NSString*)string num:(int)num {
    NSMutableAttributedString*aString = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSRange yuanRange   =  [string rangeOfString:@"元"];
    NSRange range = NSMakeRange(num, yuanRange.location-num);
    NSDictionary *dic = @{
                          NSForegroundColorAttributeName:kCOLOR_R_G_B_A(241, 78, 86, 1)
                          };
     [aString setAttributes:dic range:range];
    return aString;
    
}
@end
