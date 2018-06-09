//
//  DDMoreMassageHeaderView.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/3.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMoreMassageHeaderView.h"

@implementation DDMoreMassageHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}
- (void)tapAction{
    if (self.block) {
        self.block();
    }
}
- (void)setModel:(DDMessageModel *)model {
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 设置图片大小
    attch.bounds = CGRectMake(0, 0, 22, 22);
    if ([model.reward_type isEqualToString:@"lollipop"]) {
        // 表情图片
        
        attch.image = [UIImage imageNamed:@"bounced_sugar"];
    }else if ([model.reward_type isEqualToString:@"applause"]){
        attch.image = [UIImage imageNamed:@"bounced_handclap"];
        
    }else if ([model.reward_type isEqualToString:@"brick"]){
        
        attch.image = [UIImage imageNamed:@"bounced_sbrick"];
        
    }else if ([model.reward_type isEqualToString:@"flower"]){
        attch.image = [UIImage imageNamed:@"bounced_flower"];
    }else if ([model.reward_type isEqualToString:@"lucky_star"]){
        attch.image = [UIImage imageNamed:@"bounced_luckstar"];
    }else if ([model.reward_type isEqualToString:@"diamonds"]){
        attch.image = [UIImage imageNamed:@"bounced_diamond"];
    }
    NSMutableAttributedString*aString =  [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ ",model.user]];
    NSAttributedString *iconString = [NSAttributedString attributedStringWithAttachment:attch];
    [aString appendAttributedString:iconString];
    
    
    self.nameLabel.attributedText = aString;

    
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
