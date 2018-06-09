//
//  DYInvestSubmitVC.h
//  NewDeayou
//
//  Created by wayne on 14/7/24.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFMineModel.h"
@interface DYInvestSubmitVC : DYBaseVC

@property(nonatomic,assign)BOOL isHaveInvestPassword;
@property(nonatomic,retain)NSDictionary * dicData;
@property(nonatomic,strong)NSString *borrowId;

@property(nonatomic,strong)NSString *balance;

@property(nonatomic)int type;//1：余额投资 2:零钱宝投资
@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (weak, nonatomic) IBOutlet UIButton *myCardBtn;
@property (weak, nonatomic) IBOutlet UILabel *myCardLabel;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIView *midView;

@property (nonatomic)float limit;//起投金额
@property (nonatomic) float parcent;
@property(nonatomic,copy) NSString *Borrow_Title;//标名
@property(nonatomic,copy) NSString *Borrow_ShenYu;//可投
@property(nonatomic,copy) NSString *Borrow_Total;//总融资
@property(nonatomic,copy)NSString *anual;//年化
@property(nonatomic,copy)NSString *day;//期限
@property (nonatomic, copy) NSString *isInvest;//是否投资
//银行卡信息
@property (nonatomic) BOOL isBindBank;//是否绑定银行卡
@property (nonatomic) int BankType;//银行类型
@property (nonatomic,strong)NSString *BankNo;//银行卡号
@property (nonatomic, strong) NSString *borrow_type;//标类型
@property (nonatomic, copy) NSString *cardName;
@property (weak, nonatomic) IBOutlet UITextField *tfInvestMoney;

@property (nonatomic, copy) NSString *borrowStyle;//判断是否活期宝
@property (weak, nonatomic) IBOutlet UIView *timelyGetMoney;//立返金额视图
@property (weak, nonatomic) IBOutlet UILabel *gotMoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (nonatomic,copy)NSString *word;
@property (weak, nonatomic) IBOutlet UILabel *DeadLineLabel;//持有期限
@property (weak, nonatomic) IBOutlet UILabel *nianHuaLabel;//年化

@property (weak, nonatomic) IBOutlet UILabel *LimstLabel;//起投金额

@property(nonatomic,strong)NSString *deadLine;
@property(nonatomic,strong)NSString *nianHua;
@property(nonatomic,strong)NSString *extraNianHua;
@property(nonatomic,strong)NSString *limst;

@property (nonatomic, copy) NSString *borrowType;//判断标类型

@property (nonatomic, copy) NSString *product;//tf:转让标
@property (weak, nonatomic) IBOutlet UIImageView *agereeMentImage;
@property (weak, nonatomic) IBOutlet UILabel *agreeMnetLabel;

@property (nonatomic, strong) FFMineModel *ffmodel;

@end
