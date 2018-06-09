//
//  CustomAlertView.m
//  CustomAlertView
//
//  Created by 丁宗凯 on 16/6/22.
//  Copyright © 2016年 dzk. All rights reserved.
//

#import "CustomAlertView.h"
#import "UIView+SDAutoLayout.h"

#define AlertViewJianGe 19.5
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width            // 屏幕宽
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height          // 屏幕高
#define SCREEN_PRESENT [[UIScreen mainScreen] bounds].size.width/375.0  // 屏幕宽高比例
#define DarkGrayColor [UIColor colorWithRGB:0x333333]     // 深灰色
#define WhiteColor  [UIColor whiteColor]                  // 白色
#define LightGrayColor [UIColor colorWithRGB:0x999999]    // 浅灰色

#define cornerRadiusView(View, Radius) \
\
[View.layer setCornerRadius:(Radius)];           \
[View.layer setMasksToBounds:YES]

#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ColorAlphe(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机色
#define RandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@implementation CustomAlertView

-(instancetype)initWithAlertViewHeight:(CGFloat)height
{
    self=[super init];
    if (self) {
        if (self.bGView==nil) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.5;
       
            [[UIApplication sharedApplication].keyWindow addSubview:view];
            self.bGView =view;
        }
        
        self.frame = CGRectMake(52*SCREEN_PRESENT,174*SCREEN_PRESENT,250,320);
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        //中间弹框的view
        UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(0,0,250,230)];
        popView.backgroundColor = [UIColor whiteColor];
        cornerRadiusView(popView, 5);
        [self addSubview:popView];
        
        UIImageView *meetImage =[[UIImageView alloc] init];
        meetImage.image = [UIImage imageNamed:@"image1"];
        [popView addSubview:meetImage];
        meetImage.sd_layout.leftSpaceToView(popView,20).topSpaceToView(popView,19).widthIs(100).heightIs(24);
        
        UIImageView *meetImage2 =[[UIImageView alloc] init];
        meetImage2.image = [UIImage imageNamed:@"image2"];
        [popView addSubview:meetImage2];
        meetImage2.sd_layout.rightSpaceToView(popView,20).topSpaceToView(popView,19).widthIs(100).heightIs(24);
        
        UILabel *lookLabel = [UILabel new];
        lookLabel.textColor = [UIColor lightGrayColor];
        lookLabel.text = @"多多理财已正式接入新网银行存管";
        lookLabel.font = [UIFont systemFontOfSize:10];
        [popView addSubview:lookLabel];
        lookLabel.textAlignment = NSTextAlignmentCenter;
        lookLabel.sd_layout.leftSpaceToView(popView,15).rightSpaceToView(popView,15).topSpaceToView(meetImage,2).heightIs(12);
        
        UILabel *addLabel = [UILabel new];
        addLabel.text = @"安全理财，坐享收益";
        addLabel.textColor = [UIColor redColor] ;
        addLabel.font = [UIFont systemFontOfSize:20];
        [popView addSubview:addLabel];
        addLabel.textAlignment = NSTextAlignmentCenter;
        addLabel.sd_layout.leftSpaceToView(popView,15).rightSpaceToView(popView,15).topSpaceToView(lookLabel,30).heightIs(14);
        
        UIButton *calendarBtn = [UIButton new];
        calendarBtn.tag =100;
        calendarBtn.backgroundColor = [UIColor redColor];
        [popView addSubview:calendarBtn];
        calendarBtn.sd_layout.topSpaceToView(addLabel,30).heightIs(40).widthIs(150);
        calendarBtn.sd_layout.centerXIs(self.frame.size.width/2);
        [calendarBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        [calendarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        calendarBtn.layer.cornerRadius= 5;
        [calendarBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *bottomLabel = [UILabel new];
        bottomLabel.text = @"您需要先开通银行存管的账户，才可进行投资。";
        bottomLabel.textColor = [UIColor lightGrayColor] ;
        bottomLabel.font = [UIFont systemFontOfSize:10];
        [popView addSubview:bottomLabel];
        bottomLabel.textAlignment = NSTextAlignmentLeft;
        bottomLabel.sd_layout.topSpaceToView(calendarBtn,25).leftSpaceToView(popView,15).heightIs(10).widthIs(self.frame.size.width-10);
        
        UILabel *bottomLabel2 = [UILabel new];
        bottomLabel2.text = @"充值，提现，转让。";
        bottomLabel2.textColor = [UIColor lightGrayColor] ;
        bottomLabel2.font = [UIFont systemFontOfSize:10];
        [popView addSubview:bottomLabel2];
        bottomLabel2.textAlignment = NSTextAlignmentLeft;
        bottomLabel2.sd_layout.topSpaceToView(bottomLabel,2).leftSpaceToView(popView,15).heightIs(10).widthIs(self.frame.size.width-10);
        
        UIButton *cancelBtn = [UIButton new];
        cancelBtn.tag =101;
        UIImage *image = [UIImage imageNamed:@"cancelBtn"];
        [cancelBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self addSubview:cancelBtn];
        cancelBtn.sd_layout.topSpaceToView(popView,20).heightIs(40).widthIs(40);
        cancelBtn.sd_layout.centerXIs(self.frame.size.width/2);
//        cancelBtn.layer.shadowOffset =  CGSizeMake(1, 1);
//        cancelBtn.layer.shadowOpacity = 0.8;
        cancelBtn.layer.shadowColor =  [UIColor blackColor].CGColor;
        cancelBtn.layer.cornerRadius= 20;
        [cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self show:YES];

    }
    return self;
}
-(void)buttonClick:(UIButton*)button
{
    [self hide:YES];
    if (self.ButtonClick) {
        self.ButtonClick(button);
    }
}
- (void)show:(BOOL)animated
{
    if (animated)
    {
        self.transform = CGAffineTransformScale(self.transform,0,0);
        __weak CustomAlertView *weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                weakSelf.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)hide:(BOOL)animated
{
    [self endEditing:YES];
    if (self.bGView != nil) {
        __weak CustomAlertView *weakSelf = self;
        
        [UIView animateWithDuration:animated ?0.3: 0 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1,1);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration: animated ?0.3: 0 animations:^{
                weakSelf.transform = CGAffineTransformScale(weakSelf.transform,0.2,0.2);
            } completion:^(BOOL finished) {
                [weakSelf.bGView removeFromSuperview];
                [weakSelf removeFromSuperview];
                weakSelf.bGView=nil;
            }];
        }];
    }
    
}

@end
