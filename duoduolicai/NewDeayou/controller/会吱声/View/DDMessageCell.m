//
//  DDMessageCell.m
//  NewDeayou
//
//  Created by Tony on 2016/10/28.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMessageCell.h"

@implementation DDMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(DDMessageModel *)model{
    _model = model;
    NSString *string = [NSString stringWithFormat:@"%@ 回复 %@",model.user,model.reply_user];
    NSMutableAttributedString * aString = [[NSMutableAttributedString alloc]initWithString:string];
    NSDictionary*dic = @{
                         NSForegroundColorAttributeName:[HeXColor colorWithHexString:@"#2cc9ff"]
                         };
    [aString setAttributes:dic range:NSMakeRange(0, model.user.length)];
    [aString setAttributes:dic range:NSMakeRange(string.length - model.reply_user.length, model.reply_user.length)];
    self.nickName.attributedText = aString;
    
    self.reply.text = model.message;
    
    
}
@end
