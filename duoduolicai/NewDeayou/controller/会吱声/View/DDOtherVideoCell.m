//
//  DDOtherVideoCell.m
//  NewDeayou
//
//  Created by Tony on 2016/11/1.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDOtherVideoCell.h"

@implementation DDOtherVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setModel:(DDOtherVideoModel *)model{
    _model = model;
    self.title.text = model.video_title;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.v_addtime doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *timeString = [formatter stringFromDate:date];
    self.time.text = timeString;
}


@end
