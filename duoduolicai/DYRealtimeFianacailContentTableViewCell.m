//
//  DYRealtimeFianacailContentTableViewCell.m
//  NewDeayou
//
//  Created by diyou on 14-7-10.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYRealtimeFianacailContentTableViewCell.h"
#import "LeafNotification.h"
#define kLeft   arc4random() % 15//左边距离

@implementation DYRealtimeFianacailContentTableViewCell


static int a = 0;
- (void)awakeFromNib
{
    
    CGRect frame = self.moneyImage.frame;
    CGPoint point = self.moneyImage.center;
    self.moneyImage.alpha = 0;
    self.arrry = [NSMutableArray arrayWithCapacity:1];
    self.myImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.myImage setImage:[UIImage imageNamed:@"可用余额"] forState:UIControlStateNormal];
    self.myImage.frame = frame;
    self.myImage.center = point;
    NSLog(@"aa%f", self.myImage.frame.origin.x);
    NSLog(@"bb%f", self.myImage.frame.origin.y);
    [self.RecordView addSubview:self.myImage];
    
//    CGRect baoFrame = self.baoImage.frame;
//    CGPoint baoPoint = self.baoImage.center;
//    self.lingqinImage = [[UIImageView alloc] initWithFrame:baoFrame];
//    self.lingqinImage.center = baoPoint;
//    self.lingqinImage.image = [UIImage imageNamed:@"零钱宝账户.png"];
//    [self addSubview:self.lingqinImage];
    
    self.myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.myBtn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchDown];
    self.myBtn.frame = frame;
    self.myBtn.center = point;
    self.myBtn.userInteractionEnabled = NO;
    [self.RecordView addSubview:self.myBtn];
    
    self.doudongImage = [[UIImageView alloc]init];
    _doudongImage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + 60, CGRectGetMinY(self.TiYanJianLabel.frame)+ 210, 45, 50);
//    _doudongImage.backgroundColor = [UIColor orangeColor];
    _doudongImage.image = [UIImage imageNamed:@"账户_04"];
    _doudongImage.userInteractionEnabled = YES;
    [self addSubview:self.doudongImage];
   
    _Imagepoint=self.doudongImage.center;
    if (!_timer3) {
        self.timer3 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doudong) userInfo:nil repeats:YES];
        
    }
}
- (void)doudong {
    CABasicAnimation *animation = (CABasicAnimation *)[self.doudongImage.layer animationForKey:@"rotation"];
    if (animation == nil) {
        [self shakeImage];
    }else {
        [self resume];
    }
}

- (void)shakeImage {
    //创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置属性，周期时长
    [animation setDuration:0.1];
    
    //抖动角度
    animation.fromValue = @(-M_1_PI);
    animation.toValue = @(M_1_PI);
    //重复次数，无限大
    //    animation.repeatCount = HUGE_VAL;
    animation.repeatCount = 2;
    //恢复原样
    animation.autoreverses = YES;
    //锚点设置为图片中心，绕中心抖动
    self.doudongImage.layer.anchorPoint = CGPointMake(0.5, 1);
    [self.doudongImage.layer setPosition:CGPointMake(_Imagepoint.x, _Imagepoint.y+25)];
    [self.doudongImage.layer addAnimation:animation forKey:@"rotation"];
}

- (void)resume {
    self.doudongImage.layer.speed = 1;
}
- (void)startTimer {
    self.myBtn.userInteractionEnabled = YES;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(handleDong) userInfo:nil repeats:YES];
    }
    
    
    float money = [self.totalL.text floatValue];
    
    if (money > 0) {

        [self.timer setFireDate:[NSDate distantPast]];
    } else {
        [self.timer setFireDate:[NSDate distantFuture]];
    }

}
-(void)closeTimer{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)handleDong {
    
    [self dongFall:self.myImage];
}
- (void)dongFall:(UIButton *)aImageView {
    [UIView animateWithDuration:1 animations:^{
//        CGPoint point = self.moneyImage.center;
//        self.myImage.center = point;
        self.myImage.frame = CGRectMake(self.moneyImage.frame.origin.x - 5, self.moneyImage.frame.origin.y - 5, 40, 40);
        
    } completion:^(BOOL finished) {
        [self secondFall:aImageView];
    }];
}
- (void)secondFall:(UIButton *)bImageView {
    [UIView animateWithDuration:1 animations:^{
//         CGPoint point = self.moneyImage.center;
        self.myImage.frame = CGRectMake(self.moneyImage.frame.origin.x , self.moneyImage.frame.origin.y, 30, 30);
//        self.myImage.center = point;
       
    } completion:^(BOOL finished) {
        
//        self.downImage  = [[UIImageView alloc] initWithFrame:CGRectMake(bImageView.frame.origin.x, bImageView.frame.origin.y + 10 , 18, 18)];
//        CGPoint bpoint = bImageView.center;
//        _downImage.center = bpoint;
//        _downImage.image = [UIImage imageNamed:@"可用余额"];
//        _downImage.alpha = 0.5;
//        [self addSubview:self.downImage];
//        [self thirdFall:self.downImage];
        
    }];
}
- (void)thirdFall:(UIImageView *)cImageView {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.baoImage.frame;
        //        CGPoint point = self.baoImage.center;
        self.downImage.frame = CGRectMake(frame.origin.x + 4, frame.origin.y - 4, 18, 18);
        //        self.downImage.center = point;
    } completion:^(BOOL finished) {
        [cImageView removeFromSuperview];
    }];
}
- (void)handleAction: (UIButton *)sender {
//    [self torformBalanceToLingqianbao];
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *str = [ud objectForKey:@"getmoney"];
//    NSLog(@"%@", str);
//    if ([str isEqualToString:@"8"]) {
//    
//        }
    
}
-(void)numberAnimation3:(UILabel *)label{
    if (!_timer_number3) {
        _timer_number3 = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                          target:self
                                                        selector:@selector(numberAnimation3)
                                                        userInfo:nil
                                                         repeats:YES];
        
    }
    label.tag=300;
}
-(void)numberAnimation3{
    UILabel *lb=[self viewWithTag:300];
    self.start3=self.start3-self.end3/16;
    if (self.start3<=0) {
        lb.text=@"0.00";
        [_timer_number3 invalidate];
        _timer_number3=nil;
        return;
    }
    lb.text=[NSString stringWithFormat:@"%.2f",self.start3];
}
-(void)numberAnimation2:(UILabel *)label{
    if (!_timer_number2) {
        _timer_number2 = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                          target:self
                                                        selector:@selector(numberAnimation2)
                                                        userInfo:nil
                                                         repeats:YES];
        
    }
}
-(void)numberAnimation2{
    self.start2+=self.content2/8;
    if (self.start2>self.end2) {
        self.LingQianBaoLabel.text=[NSString stringWithFormat:@"%.2f",self.end2];
        [_timer_number2 invalidate];
        _timer_number2=nil;
        return;
    }
    self.LingQianBaoLabel.text=[NSString stringWithFormat:@"%.2f",self.start2];
}

- (void)baodong {
    
    if (a < 9) {
        [self baoFirstfall:self.lingqinImage];
        a ++;
    }
}
- (void)baoFirstfall:(UIImageView *)bigImage {
    [UIImageView animateWithDuration:0.1 animations:^{
//        CGPoint center = bigImage.center;
        self.lingqinImage.frame = CGRectMake(self.baoImage.frame.origin.x- 2.5, self.baoImage.frame.origin.y- 2.5 , 35, 35);
//        self.lingqinImage.center = center;
    } completion:^(BOOL finished) {
        [self baoSecondfall:bigImage];
        
    }];
}
- (void)baoSecondfall:(UIImageView *)smallImage {
    [UIImageView animateWithDuration:0.1 animations:^{
//        CGPoint center = smallImage.center;
        self.lingqinImage.frame = CGRectMake(self.baoImage.frame.origin.x, self.baoImage.frame.origin.y, 30, 30);
//        self.lingqinImage.center = center;
    } completion:^(BOOL finished) {
      
        
    }];
}
//将余额转入零钱宝
-(void)torformBalanceToLingqianbao{
    NSString * amount=self.totalL.text;
   
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"lqb" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"info_lqb" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:amount forKey:@"amount" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"type" atIndex:0];//余额转入
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success==YES) {
             //可用信用额度数据填充
//             [self.tabBarController setSelectedIndex:1];//0:首页，1：零钱包，2：投资，3：更多
             
             float lingqianbao=[self.LingQianBaoLabel.text floatValue];
             float balance=[self.totalL.text floatValue];
             self.totalL.text=@"0";
             lingqianbao=lingqianbao+balance;
             self.LingQianBaoLabel.text=[NSString stringWithFormat:@"%.2f",lingqianbao];
             
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:@"2" forKey:@"key"];
             [ud setObject:@"0" forKey:@"balance"];
             [ud setObject:@"8" forKey:@"getmoney"];
             
             float money1 = [self.totalL.text floatValue];
             float money2 = [self.LingQianBaoLabel.text floatValue];
             float money = money1 + money2;
             if (money > 200000.00 ) {
                
                 [MBProgressHUD errorHudWithView:self label:@"无法转入，零钱宝总额最高20万" hidesAfter:2];
             } else {
                 
                 //暂停定时器
                 self.start3=[self.totalL.text floatValue];
                 self.end3=[self.totalL.text floatValue];
                 UILabel *m=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.totalL.frame.size.width, self.totalL.frame.size.height)];
                 m.backgroundColor=[UIColor whiteColor];
                 m.textColor=kMainColor2 ;
                 m.textAlignment=NSTextAlignmentLeft;
                 [self.totalL addSubview:m];
                 [self numberAnimation3:m];
                 self.start2=[self.LingQianBaoLabel.text floatValue];
                 self.end2=[self.LingQianBaoLabel.text floatValue]+[self.totalL.text floatValue];
                 self.content2=[self.totalL.text floatValue];
                 [self numberAnimation2:self.LingQianBaoLabel];
                 
                 [self.timer setFireDate:[NSDate distantFuture]];
                 
                 
                 
                 self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];
                 
                 
                 a = 0;
                 
             }

             
         }else{
             [MBProgressHUD errorHudWithView:self label:error hidesAfter:2];
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:@"9" forKey:@"getmoney"];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideAllHUDsForView:self animated:YES];
         [MBProgressHUD errorHudWithView:self label:@"网络异常" hidesAfter:2];
     }];

}
- (void)scrollTimer {
    [UIView animateWithDuration:1.5 animations:^{
        self.myImage.alpha = 1;
        
    } completion:^(BOOL finished) {
        self.myBtn.userInteractionEnabled = NO;
        [self.timer1 invalidate];
    }];
}
- (void)makeMoney {
//    [self baodong];
//    if ([self.arrry count] > 0) {
//        UIImageView *imageView = [_arrry objectAtIndex:0];
//        [self.arrry removeObjectAtIndex:0];
//        [self snowFall:imageView];
//    }
}
- (void)snowFall:(UIImageView *)aImageView {
    [UIView animateWithDuration:0.5 animations:^{
        aImageView.frame = CGRectMake(aImageView.frame.origin.x, self.baoImage.frame.origin.y, 15, 15);
    } completion:^(BOOL finished) {
//        //循环
//        aImageView.frame = CGRectMake(self.myImage.frame.origin.x, self.myImage.frame.origin.y, 10, 10);
//        [self.arrry addObject:aImageView];
        [aImageView removeFromSuperview];
    }];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
