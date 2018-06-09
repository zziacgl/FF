//
//  DDRansomDetailViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/22.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDRansomDetailViewController.h"
@interface DDRansomDetailViewController ()
@end

@implementation DDRansomDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确定退出信息";
    
    [self configView];
    
    
    
}
- (void)configView {
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY/MM/dd"];
    NSString *date2 = [dateformatter stringFromDate:senddate];
//    NSLog(@"获取当前时间   = %@",date2);
    
    self.nameLabel.text = self.model.name;
    self.investMoneyLabel.text = [NSString stringWithFormat:@"投资金额：%@元", self.model.account];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.model.borrow_start_time doubleValue]];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[self.model.repay_last_time doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd";
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *startTime = [formatter stringFromDate:date];
    NSString *lastTime = [formatter stringFromDate:date1];
    self.oldInvestTimeLabel.text = [NSString stringWithFormat:@"原投资时间：%@-%@",startTime,lastTime];
    self.recoverAccountAllLabel.text = [NSString stringWithFormat:@"原回收本息：%@元", self.model.recover_account_all];
//    self.ransomMoney.text = [NSString stringWithFormat:@"退出金额：%@", self.model.account];
    self.getMoneyLabel.text = [NSString stringWithFormat:@"已获收益：%@", self.model.sum_recover_interest];
    
    NSString *str = self.model.account;
    NSUInteger len = [str length];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"退出金额：%@元", str]];
    [str1 addAttribute:NSForegroundColorAttributeName value:kMainColor2 range:NSMakeRange(5,len + 1)];
    self.ransomMoney.attributedText=str1;
    
    NSString *sum_recover_interest = self.model.sum_recover_interest;
    NSUInteger sum_recover_interestLen = [sum_recover_interest length];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已获收益：%@元", sum_recover_interest]];
    [str3 addAttribute:NSForegroundColorAttributeName value:kMainColor2 range:NSMakeRange(5,sum_recover_interestLen + 1)];
    self.getMoneyLabel.attributedText=str3;
    
   
    NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"持有时间：%@-%@", startTime,date2]];
    [str4 addAttribute:NSForegroundColorAttributeName value:kMainColor2 range:NSMakeRange(5,date2.length + startTime.length + 1)];
    self.handTimeLabel.attributedText=str4;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)makeSure:(UIButton *)sender {
//    NSLog(@"sdadas%@", self.model.id);
    
    
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"borrow" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"apply_current" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d", [DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic1 insertObject:self.model.id forKey:@"id" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess) {
           
            [MBProgressHUD errorHudWithView:self.view label:@"退出成功" hidesAfter:1];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [LeafNotification showInController:self withText:errorMessage];
            
            
        }
        
        
        
    } fail:^{
        [LeafNotification showInController:self withText:@"网络异常"];
      
    }];

    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
