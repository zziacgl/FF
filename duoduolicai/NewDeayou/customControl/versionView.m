//
//  versionView.m
//  DuoDuoLiCai
//
//  Created by 陈高磊 on 2017/5/9.
//  Copyright © 2017年 陈高磊. All rights reserved.
//

#import "versionView.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "UIColor+FFCustomColor.h"

@interface versionView()
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *cancleBtn;
//@property (nonatomic, strong) UIView *lineView;

@end


@implementation versionView


- (instancetype)initWithTitle:(NSString *)versionTitle message:(NSString *)message versionType:(BOOL)isMandatory{
  
    if (self = [super init]) {
        self.frame= [UIScreen mainScreen].bounds;
        
        
        self.alertView= [[UIView alloc]init];

        self.alertView.layer.position = self.center;
        self.alertView.userInteractionEnabled = YES;
        self.alertView.layer.cornerRadius = 15;
//        self.alertView.layer.masksToBounds = YES;
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.frame = CGRectMake(0, 0, kMainScreenWidth - 60, 180);
        
        self.topImageView = [[UIImageView alloc] init];
        self.topImageView.frame = CGRectMake(0, 0, kMainScreenWidth - 60, (kMainScreenWidth - 60) / 58 * 34);
        self.topImageView.image = [UIImage imageNamed:@"versionview"];
        [self.alertView addSubview:self.topImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, kMainScreenWidth - 60, 30)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = kMainColor;
        self.titleLabel.text = [NSString stringWithFormat:@"V%@", versionTitle];
        [self.alertView addSubview:self.titleLabel];
        
        
        UILabel *firstLabel =  [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame) + 20, kMainScreenWidth - 100, 100)];
        firstLabel.text = @"更新内容:";
        firstLabel.font = [UIFont systemFontOfSize:15];
        firstLabel.textAlignment = NSTextAlignmentLeft;
        [self.alertView addSubview:firstLabel];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstLabel.frame) , kMainScreenWidth - 100, 100)];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.font = [UIFont systemFontOfSize:14];
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        NSString *messageStr = [[NSString stringWithFormat:@"%@", message] stringByReplacingOccurrencesOfString:@"=" withString:@"\n"];
//        NSString *contentstr = [messageStr stringByReplacingOccurrencesOfString:@"\n" withString:@"="];
        self.messageLabel.textColor = [UIColor darkGrayColor];
        CGRect txRect = [messageStr boundingRectWithSize:CGSizeMake(kMainScreenWidth - 100, [UIScreen mainScreen].bounds.size.height*20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.messageLabel.font} context:nil];


        self.messageLabel.frame = CGRectMake(20, CGRectGetMaxY(firstLabel.frame) - 20 , kMainScreenWidth - 100, txRect.size.height);
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:messageStr];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:10];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [messageStr length])];
        [self.messageLabel setAttributedText:attributedString1];
        [self.messageLabel sizeToFit];
        [self.alertView addSubview:self.messageLabel];
        
        if (isMandatory) {
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.sureBtn.frame = CGRectMake(CGRectGetWidth(self.alertView.frame) / 8, CGRectGetMaxY(self.messageLabel.frame) + 40, CGRectGetWidth(self.alertView.frame) / 4 * 3, 40);
            [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.sureBtn.backgroundColor = kMainColor;
            self.sureBtn.tag = 203;
            self.sureBtn.layer.cornerRadius = 20;
            self.sureBtn.layer.masksToBounds = YES;
            [self.sureBtn.layer addSublayer:[UIColor setGradualChangingColor:self.sureBtn fromColor:@"fb9903" toColor:@"f76405"]];

            self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.sureBtn.frame), 40)];
            btnLabel.textAlignment = NSTextAlignmentCenter;
            btnLabel.text = @"立即升级";
            btnLabel.textColor = [UIColor whiteColor];
            btnLabel.font = [UIFont systemFontOfSize:15];
            [self.sureBtn addSubview:btnLabel];
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.sureBtn];
        }else {
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.sureBtn.frame = CGRectMake(CGRectGetWidth(self.alertView.frame) / 8, CGRectGetMaxY(self.messageLabel.frame) + 40, CGRectGetWidth(self.alertView.frame) / 4 * 3, 40);
            
            [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.sureBtn.backgroundColor = kMainColor;
            self.sureBtn.tag = 203;
            self.sureBtn.layer.cornerRadius = 20;
            self.sureBtn.layer.masksToBounds = YES;
            self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.sureBtn.layer addSublayer:[UIColor setGradualChangingColor:self.sureBtn fromColor:@"fb9903" toColor:@"f76405"]];
            UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.sureBtn.frame), 40)];
            btnLabel.textAlignment = NSTextAlignmentCenter;
            btnLabel.text = @"立即升级";
            btnLabel.textColor = [UIColor whiteColor];
            btnLabel.font = [UIFont systemFontOfSize:15];
            [self.sureBtn addSubview:btnLabel];
            
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.sureBtn];
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
           
            [self.cancleBtn setImage:[UIImage imageNamed:@"versioncancal"] forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.cancleBtn.tag = 202;
            self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];

            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
//            [self.alertView addSubview:self.cancleBtn];

            
        
        }
        //计算高度
        CGFloat alertHeight = CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, kMainScreenWidth - 60, alertHeight + 20);
        
        NSLog(@"高度%f", self.alertView.frame.origin.y);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
        [self addSubview:self.cancleBtn];
        
    }
    
    
    return self;
}




#pragma mark - 回调 -设置只有2 -- > 确定才回调
- (void)buttonEvent:(UIButton*)sender
{
    switch (sender.tag) {
        case 201:
            if (self.resultIndex) {
                self.resultIndex(sender.tag);
                [self removeFromSuperview];
            }
            break;
        case 202:
            [self removeFromSuperview];
            break;
        case 203:
            if (self.resultIndex) {
                self.resultIndex(sender.tag);
//                [self removeFromSuperview];
            }
            break;
            
        default:
            break;
    }
    
   
}



- (void)showAlertView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];

}
- (void)creatShowAnimation
{
    self.backgroundColor=  [UIColor colorWithRed:70.0 / 255.0 green:70.0 / 255.0 blue:70.0 / 255.0 alpha:0.5] ;
    
    self.alertView.layer.position = self.center;
    NSLog(@"高度%f", self.alertView.frame.origin.y);
     self.cancleBtn.frame = CGRectMake( kMainScreenWidth - 60, self.alertView.frame.origin.y - 50, 25, 50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
@end
