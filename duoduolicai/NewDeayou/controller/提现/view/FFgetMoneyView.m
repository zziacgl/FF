//
//  FFgetMoneyView.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/1/5.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "FFgetMoneyView.h"
@interface FFgetMoneyView ()<UITextFieldDelegate>

@property (nonatomic) BOOL isHaveDian;


@end
@implementation FFgetMoneyView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.bankNameLabel.layer.borderColor = LZColorFromHex(0xdadada).CGColor;
    self.bankNameLabel.layer.borderWidth = 0.5;
    self.bankNumberLabel.layer.borderColor = LZColorFromHex(0xdadada).CGColor;
    self.bankNumberLabel.layer.borderWidth = 0.5;
    
    self.MoneyView.layer.borderColor = LZColorFromHex(0xdadada).CGColor;
    self.MoneyView.layer.borderWidth = 0.5;
    
  
    self.moneyTF.delegate = self;
    CALayer *layer = [self.nextBtn layer];
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.3;
    self.nextBtn.backgroundColor = kBtnColor;
   
}



- (void)setModel:(FFMineModel *)model {
    if (model) {
        self.bankNameLabel.text = [NSString stringWithFormat:@"  %@", model.bank_name];
        self.bankNumberLabel.text = [NSString stringWithFormat:@"  %@", model.account_all];
        self.myMoenyLabel.text = [NSString stringWithFormat:@"可用余额：%@", model._balance];
    }
    
}
- (IBAction)handleNext:(UIButton *)sender {
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"apply_cash" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"cash" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    
    [diyouDic insertObject:self.moneyTF.text forKey:@"money" atIndex:0];
    
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess == YES) {
            [MobClick event:@"account_tixian2"];
            [MBProgressHUD checkHudWithView:self.viewController.view label:@"提现成功" hidesAfter:1];
            [self performSelector:@selector(GotoBack) withObject:nil afterDelay:1];
        }else {
            [MobClick event:@"account_tixian_fail"];
            [LeafNotification showInController:self.viewController withText:errorMessage];
        }
        
        
    } fail:^{
        [LeafNotification showInController:self.viewController withText:@"网络异常"];
        
    }];
    
}
- (void)GotoBack {
    
    [self.viewController.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- tf
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if (textField == self.moneyTF) {
        // 判断是否有小数点
        if ([textField.text containsString:@"."]) {
            self.isHaveDian = YES;
        }else{
            self.isHaveDian = NO;
        }
        
        if (string.length > 0) {
            
            //当前输入的字符
            unichar single = [string characterAtIndex:0];
            
            // 不能输入.0-9以外的字符
            if (!((single >= '0' && single <= '9') || single == '.'))
            {
                return NO;
            }
            
            // 只能有一个小数点
            if (self.isHaveDian && single == '.') {
                return NO;
            }
            
            // 如果第一位是.则前面加上0.
            if ((textField.text.length == 0) && (single == '.')) {
                textField.text = @"0";
            }
            
            // 如果第一位是0则后面必须输入点，否则不能输入。
            if ([textField.text hasPrefix:@"0"]) {
                if (textField.text.length > 1) {
                    NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                    if (![secondStr isEqualToString:@"."]) {
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
                        return NO;
                    }
                }
            }
            
            // 小数点后最多能输入两位
            if (self.isHaveDian) {
                NSRange ran = [textField.text rangeOfString:@"."];
                // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
                if (range.location > ran.location) {
                    if ([textField.text pathExtension].length > 1) {
                        return NO;
                    }
                }
            }
            
        }
        
        
        
        
    }
  
    
    return YES;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}



@end
