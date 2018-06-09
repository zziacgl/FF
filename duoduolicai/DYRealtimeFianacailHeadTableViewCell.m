//
//  DYRealtimeFianacailHeadTableViewCell.m
//  NewDeayou
//
//  Created by diyou on 14-7-10.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYRealtimeFianacailHeadTableViewCell.h"

@implementation DYRealtimeFianacailHeadTableViewCell
- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor=kCOLOR_R_G_B_A(253, 83, 83, 1);
    
    self.TotalM.text=@"";
    
    [self.WithdrawalBtn.layer setMasksToBounds:YES];
    [self.WithdrawalBtn.layer setCornerRadius:5.0];
    
    [self.RechargeBtn2.layer setMasksToBounds:YES];
    [self.RechargeBtn2.layer setCornerRadius:5.0];
    self.RechargeBtn2.backgroundColor = kCOLOR_R_G_B_A(253, 186, 45, 1);
    self.TopImageBnt.layer.cornerRadius = 44;
    self.TopImageBnt.layer.masksToBounds = YES;
    self.TopImageBnt.layer.borderWidth = 2;
    self.TopImageBnt.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.shareImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
//    _shareImage.image = [UIImage imageNamed:@"账户_05"];
//    _shareImage.userInteractionEnabled = YES;
//    [self addSubview:self.shareImage];
//    _mypoint=self.shareImage.center;
//   
//    
//    
////    [self big:self.shareImage];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getMoney) userInfo:nil repeats:YES];
    
}
- (void)getMoney {
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    // 动画选项设定
    animation.duration = 1; // 动画持续时间
    animation.repeatCount = HUGE_VAL; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    // 缩放倍数
        self.shareImage.layer.anchorPoint = CGPointMake(0, 1);
    [self.shareImage.layer setPosition:CGPointMake(_mypoint.x - 20, _mypoint.y + 20)];
    animation.fromValue = [NSValue valueWithCGRect:CGRectMake(10, 30, 40, 40)]; // 开始时
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(10, 20, 50, 50)]; // 结束时
    // 添加动画
    [self.shareImage.layer addAnimation:animation forKey:nil];
    
}

- (void)big:(UIImageView *)bigView {
    
   }

- (void)share:(UIImageView *)myImage {
   }
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
