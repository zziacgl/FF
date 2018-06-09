//
//  DYBankCardVC.h
//  NewDeayou
//
//  Created by diyou on 14-8-9.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLPaySdk.h"

typedef enum LLVerifyPayState{
    kLLQuickPay = 0,//快捷支付
    kLLVerifyPay = 1,//认证支付
    kLLPreAuthorizePay = 2//预授权
}LLVerifyPayState;

@interface DYBankCardVC : UIViewController

@property (nonatomic, strong)NSDictionary *dic;

@property (nonatomic) int isFirstName;//是不是从实名认证入口过来的

-(void)setInfoWithDic:(NSDictionary *)dic;

//连连支付
@property (nonatomic, retain) LLPaySdk *sdk;

@property (nonatomic, assign) LLVerifyPayState bLLPayState;

@end
