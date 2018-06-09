//
//  DDRechargeViewController.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/20.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DDRechargeViewController : DYBaseVC
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UITextField *TxtMoney2;
@property (weak, nonatomic) IBOutlet UIButton *RechargeBnt2;
@property (weak, nonatomic) IBOutlet UILabel *LimtLabel2;
@property (nonatomic, copy) NSString *mybankNumber;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;

//银行卡信息
@property (nonatomic) BOOL isBindBank;//是否绑定银行卡
@property (nonatomic) int BankType;//银行类型
@property (nonatomic,strong)NSString *Bankno;//银行卡号
@property (nonatomic,strong)NSString *gotexpgold;//送体验金

@property (nonatomic)BOOL isLingqianBao;


@property (nonatomic)BOOL isInvest;
@property (nonatomic,strong)NSDictionary *dicData;
@property (nonatomic,strong)NSString *balance;
//@property (weak, nonatomic) IBOutlet UILabel *PayWay;
//@property (nonatomic)int type;//1:连连 0:易宝
@end
