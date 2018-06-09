//
//  DDNewRechargeViewController.h
//  NewDeayou
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLPaySdk.h"

#import "DYBankCardVC.h"
@interface DDNewRechargeViewController : UIViewController

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIImageView *bankImage;//银行图标
@property (nonatomic, strong) UILabel *bankLabel;//银行卡
@property (nonatomic, strong) UILabel *bankNumber;//卡号

@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIImageView *shearImage;
@property (nonatomic, strong) UILabel *arriveLabel;
@property (nonatomic, strong) UIImageView *goldImage;
@property (nonatomic, strong) UILabel *goldLabel;
@property (nonatomic, strong) UILabel *restLabel;
@property (nonatomic, strong) UIButton *hundredBtn;//充值100元btn
@property (nonatomic, strong) UIButton *thousandBtn;//充值1000元Btn
@property (nonatomic, strong) UIImageView *rmbImage;
@property (nonatomic, strong) UITextField *moneyTF;//输入金额
@property (nonatomic, strong) UILabel *limitLabel;//银行限额
@property (nonatomic, strong) UIButton *nextBtn;//下一步
@property (nonatomic, strong) UILabel *safeLabel;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *hundredImage;//充值100对号图片
@property (nonatomic, strong) UIImageView *thousandImage;//充值1000对号图片
//银行卡信息
@property (nonatomic) BOOL isBindBank;//是否绑定银行卡
@property (nonatomic) int BankType;//银行类型
@property (nonatomic,strong)NSString *Bankno;//银行卡号
@property (nonatomic,strong)NSString *gotexpgold;//送体验金

@property (nonatomic)BOOL isLingqianBao;

//连连支付
@property (nonatomic, retain) LLPaySdk *sdk;

@property (nonatomic, assign) LLVerifyPayState bLLPayState;
@end
