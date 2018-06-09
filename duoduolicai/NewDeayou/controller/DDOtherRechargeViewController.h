//
//  DDOtherRechargeViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/5/12.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLPaySdk.h"

#import "DYBankCardVC.h"
@interface DDOtherRechargeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inPutMoney;
@property (weak, nonatomic) IBOutlet UIButton *recharegeBtn;
@property (nonatomic) BOOL isBindBank;//是否绑定银行卡
@property (nonatomic) int BankType;//银行类型
@property (nonatomic,strong)NSString *BankNo;//银行卡号
@property (nonatomic,strong)NSString *gotexpgold;//送体验金
//连连支付
@property (nonatomic, retain) LLPaySdk *sdk;

@property (nonatomic, assign) LLVerifyPayState bLLPayState;

@property (nonatomic)int type;//1:连连 0:易宝

@end
