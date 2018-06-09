//
//  NoDataView.m
//  DuoDuoLiCai
//
//  Created by 陈高磊 on 2017/3/29.
//  Copyright © 2017年 陈高磊. All rights reserved.
//

#import "NoDataView.h"
#define MainScreenRect [UIScreen mainScreen].bounds

@interface NoDataView ()

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UILabel *messageLabel;

@end


@implementation NoDataView

-(instancetype)initWithTitle:(NSString *)title image:(NSString *)imageName  {
    if(self = [super init]){
        self.frame =  MainScreenRect;
        self.backgroundColor = kBackColor;
        
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - 60, kMainScreenHeight / 2 - 120, 125, 95)];
        _backImage.image = [UIImage imageNamed:imageName];
        [self addSubview:self.backImage];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.backImage.frame) + 20, kMainScreenWidth - 20, 40)];
        _messageLabel.text = title;
        _messageLabel.textColor = [UIColor lightGrayColor];
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.messageLabel];
        
        
    }
    return self;

}

@end
