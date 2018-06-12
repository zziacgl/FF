//
//  ShellNoDataView.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/8.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "ShellNoDataView.h"
#define MainScreenRect [UIScreen mainScreen].bounds

@interface ShellNoDataView ()

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation ShellNoDataView
-(instancetype)initWithTitle:(NSString *)title image:(NSString *)imageName  {
    if(self = [super init]){
        self.frame =  MainScreenRect;
        self.backgroundColor = kBackColor;
        
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - 75, kMainScreenHeight / 2 - 120, 150, 130)];
        _backImage.image = [UIImage imageNamed:imageName];
        [self addSubview:self.backImage];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.backImage.frame) + 20, kMainScreenWidth - 20, 50)];
        _messageLabel.text = title;
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = [UIColor lightGrayColor];
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.messageLabel];
        
        
    }
    return self;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
