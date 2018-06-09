//
//  DDCollectionReusableView.m
//  NewDeayou
//
//  Created by Tony on 2016/10/28.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDCollectionReusableView.h"
#import <UIView+SDAutoLayout.h>
@implementation DDCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.bgView = [[UIView alloc]init];
//        _bgView.layer.cornerRadius = 4;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_bgView addGestureRecognizer:tap];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        self.icon = [[UIImageView alloc]init];
        self.icon.layer.cornerRadius = 17.5;
        self.icon.clipsToBounds = YES;
        self.icon.contentMode = UIViewContentModeScaleAspectFill;
        self.icon.backgroundColor = [UIColor cyanColor];
        [_bgView addSubview:self.icon];
        self.nickName = [[UILabel alloc]init];
        self.nickName.font = [UIFont systemFontOfSize:16];
        self.nickName.textColor = [HeXColor colorWithHexString:@"#2cc9ff"];
        
        [_bgView addSubview:self.nickName];
        self.comment = [[UILabel alloc]init];
        _comment.numberOfLines = 0;
        _comment.font = [UIFont systemFontOfSize:14];
        _comment.textColor = [HeXColor colorWithHexString:@"#666666"];
        [_bgView addSubview:self.comment];
       
    }
     return self;
}
- (void)tapAction{
    if (self.block) {
        self.block();
    }
}

- (void)setModel:(DDMessageModel *)model{
    _model = model;
    self.comment.text = model.message;
    // 添加表情
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
    
    
    self.nickName.attributedText = aString;
    
    NSURL *url = [NSURL URLWithString:model.avatar];
    [self.icon sd_setImageWithURL:url];
    [self setNeedsLayout];
}
- (void)setModelText:(NSString *)modelText{
    _modelText = modelText;
    self.comment.text  = modelText;
    [self layoutIfNeeded];
}
- (void)layoutSubviews{
    [super layoutSubviews];
   
    
    self.bgView.frame = CGRectMake(17, 10, kMainScreenWidth-34, self.frame.size.height-10);
    
    self.icon.sd_layout.topSpaceToView(_bgView,10).leftSpaceToView(_bgView,8).widthIs(35).heightIs(35);
  
    self.nickName.sd_layout.leftSpaceToView(self.icon,10).topSpaceToView(_bgView,8).rightSpaceToView(_bgView,0).heightIs(21);
       self.comment.sd_layout.leftSpaceToView(self.icon,10).topSpaceToView(self.nickName,0).rightSpaceToView(_bgView,0).bottomSpaceToView(_bgView,7);
    
}
@end
