//
//  DDPassWordAlertView.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/23.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDPassWordAlertView.h"


#define kScreen_Width   [UIScreen mainScreen].bounds.size.width
#define kScreen_Height   [UIScreen mainScreen].bounds.size.height
#define kLeft_Space      30
#define kTF_Width      (kScreen_Width - 2 * kLeft_Space) / 6

@interface DDPassWordAlertView ()
{
    
    
    
    NSMutableArray *_dataSource;
    
    
}
@end
@implementation DDPassWordAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, KScreenWidth-20, 40)];
    lable2.text = @"请输入支付密码";
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.font = [UIFont systemFontOfSize:18];
    [self addSubview:lable2];
    //请输入手机号码
    _TxtMoney = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, KScreenWidth-20, 40)];
    _TxtMoney.text = @"80";
    _TxtMoney.textAlignment = NSTextAlignmentCenter;
    _TxtMoney.font = [UIFont systemFontOfSize:30];
    [self addSubview:_TxtMoney];
    
    
    CGFloat width = (KScreenWidth-20)/6;
    
    //底部的textfield
    self.password = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_TxtMoney.frame)+10, KScreenWidth-20, width)];
    self.password.hidden = YES;
    self.password.keyboardType = UIKeyboardTypeNumberPad;
    [self.password addTarget:self action:@selector(txChange:) forControlEvents:UIControlEventEditingChanged];
     [self.password becomeFirstResponder];
    [self addSubview:self.password];
    
    
    //for循环创建4个按钮
    for (int i = 0; i < 6; i++) {
        
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10+i*width, CGRectGetMaxY(_TxtMoney.frame)+10, width, width)];
        button.tag=i+1;
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        button.layer.borderWidth = 0.5;
        
        [self addSubview:button];
        
        
        
    }
    
    self.updatePasswordBnt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    self.updatePasswordBnt.center=CGPointMake(KScreenWidth-50, CGRectGetMaxY(self.TxtMoney.frame)+width+30);
    [self.updatePasswordBnt setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.updatePasswordBnt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [self.updatePasswordBnt addTarget:self action:@selector(UpdatePayPassWord) forControlEvents:UIControlEventTouchDown];
//    [self.updatePasswordBnt setBackgroundColor:[UIColor redColor]];
    
    [self addSubview:self.updatePasswordBnt];

    
//    [self  addSubview:bgView];

    return self;
}

- (void)txChange:(UITextField*)tx
{
    
    NSString *text = tx.text;

    for (int i = 0; i < 6; i++) {
        
        int n=i+1;
        UIButton *btn = [self viewWithTag:n];
        
        
        NSString *str = @"";
        if (i < text.length) {
            
            
//            str = [text substringWithRange:NSMakeRange(i, 1)];
            
            str=@"*";
        }

        [btn setTitle:str forState:UIControlStateNormal];
    }
    
}//监听，输入文

@end
