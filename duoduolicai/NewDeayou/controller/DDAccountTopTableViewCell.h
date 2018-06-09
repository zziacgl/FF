//
//  DDAccountTopTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/5/24.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterView.h"
#import "FFMineModel.h"

@interface DDAccountTopTableViewCell : UITableViewCell
@property (nonatomic, strong) FFMineModel *model;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *bottomBgview;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIImageView *AvatarImage;//头像
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;


@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *AcountLabel;//账号
@property (weak, nonatomic) IBOutlet UIButton *WithdrawalBtn;//提现

@property (weak, nonatomic) IBOutlet UIButton *RechargeBtn2;//充值
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;//我的总资产


@property (weak, nonatomic) IBOutlet UILabel *residueMoney;//剩余金额

@property (weak, nonatomic) IBOutlet UILabel *cardCount;//红包个数


@property (weak, nonatomic) IBOutlet UIButton *haveGotMoneyBtn;//已获收益按钮

@property (weak, nonatomic) IBOutlet UIButton *waitGoMoneyBtn;//待收收益按钮

@property (weak, nonatomic) IBOutlet UILabel *ContentD;//已获得收益


@property (weak, nonatomic) IBOutlet UIButton *InvestRecordBtn;//我的投资按钮

@property (weak, nonatomic) IBOutlet UIButton *setUpBtn;//个人设置按钮
@property (weak, nonatomic) IBOutlet UIButton *totalMain;//总资产

@property (weak, nonatomic) IBOutlet UILabel *waitinvserstLabel;//待收收益

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UILabel *myInvestCountLabel;


@property (nonatomic)int iseyeOpen;



@end
