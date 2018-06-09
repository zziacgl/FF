//
//  DDAccountTopTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/5/24.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDAccountTopTableViewCell.h"
#import "DYSafeViewController.h"
#import "DDAllMoneyViewController.h"
#import "DYFinancialRecordsVC.h"
#import <QuartzCore/QuartzCore.h>
#import "DYMyAcountMainVC.h"
#import "DDMyInvestViewController.h"
#import "DDMyCardVoucherViewController.h"
#import "DDhasWonMoneyViewController.h"
#import "DDRechargeViewController.h"
#import "DDDrawMoneyViewController.h"
#import "FFRedPacketViewController.h"
#import "DDBondViewController.h"


static BOOL eye;

@implementation DDAccountTopTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.topView.backgroundColor=[UIColor clearColor];

    self.AvatarImage.layer.cornerRadius = 35;
    self.AvatarImage.layer.masksToBounds = YES;
    self.AvatarImage.layer.borderWidth = 1;
    self.AvatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, 30)];
    [path addLineToPoint:CGPointMake(kMainScreenWidth, 30)];
    [path addLineToPoint:CGPointMake(kMainScreenWidth, 0)];
    
    [path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:CGPointMake(kMainScreenWidth / 2, 30)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.frame = self.bottomBgview.bounds;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = [UIColor clearColor].CGColor;
    [self.bottomBgview.layer addSublayer:layer];
    
//    self.WithdrawalBtn.layer.borderWidth = 1;
//    self.WithdrawalBtn.layer.borderColor = kBtnColor.CGColor;
    
}


- (void)setModel:(FFMineModel *)model {
     _model = model;
    if (model) {
        
        
        [self.AvatarImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"backphoto"]];
        self.nickNameLabel.text =[NSString stringWithFormat:@"%@", model.niname];
        self.AcountLabel.text = [NSString stringWithFormat:@"%@" ,[ model.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
        self.cardCount.text = [NSString stringWithFormat:@"您有%@个红包可用", model.ticket_num];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *eyeType = [ud objectForKey:@"eyeType"];
        if ([eyeType isEqualToString:@"1"]) {
            [self.eyeBtn setImage:[UIImage imageNamed:@"eyes_1"] forState:UIControlStateNormal];
            self.totalMoney.text = @"****";
            self.ContentD.text =  @"****";
            self.residueMoney.text = @"****";
            self.waitinvserstLabel.text = @"****";
            eye = NO;
        }else {
            [self.eyeBtn setImage:[UIImage imageNamed:@"eyes_2"] forState:UIControlStateNormal];
            
           
            self.totalMoney.text = [NSString stringWithFormat:@"%@", model._total];
            self.ContentD.text = model.recover_yes_profit;
            self.residueMoney.text = [NSString stringWithFormat:@"%@", model._balance];
            self.waitinvserstLabel.text = [NSString stringWithFormat:@"%@", model.tender_wait_interest];
             eye = YES;
        }
        
    }
}

#pragma mark -- 充值

- (IBAction)handleRecharge:(UIButton *)sender {
    [MobClick event:@"account_chongzhi1"];
    if ([self.model.bank_status isEqualToString:@"0"]) {
        [MobClick event:@"Determine_Recharge"];
        ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
        adVC.hidesBottomBarWhenPushed = YES;
        NSString *loginKey = [DYUser GetLoginKey];
        NSString *url = [NSString stringWithFormat:@"%@/action/recharge/mobilePay?money=100&login_key=%@",ffwebURL ,loginKey];
        adVC.myUrls = @{@"url":url};
        adVC.titleM =@"充值";
        [self.viewController.navigationController pushViewController:adVC animated:YES];
    }else {
        DDRechargeViewController *rechargeVC=[[DDRechargeViewController alloc]initWithNibName:@"DDRechargeViewController" bundle:nil];
        rechargeVC.hidesBottomBarWhenPushed=YES;
        rechargeVC.isBindBank=self.model.bank_status;
        rechargeVC.Bankno=self.model.bank;
        
        rechargeVC.mybankNumber = self.model.account_all;
        [self.viewController.navigationController pushViewController:rechargeVC animated:YES];

    }
    
   
}

#pragma mark -- 提现

- (IBAction)handleDraw:(UIButton *)sender {
    [MobClick event:@"account_tixian1"];
    if ([self.model.bank_status isEqualToString:@"0"]) {
        ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
        adVC.hidesBottomBarWhenPushed = YES;
        NSString *loginKey = [DYUser GetLoginKey];
        NSString *url = [NSString stringWithFormat:@"%@/action/recharge/mobilePay?money=100&login_key=%@",ffwebURL, loginKey];
        adVC.myUrls = @{@"url":url};
        adVC.titleM =@"充值";
        [self.viewController.navigationController pushViewController:adVC animated:YES];
    }else {
        DDDrawMoneyViewController *drawMoneyVC = [[DDDrawMoneyViewController alloc] init];
        drawMoneyVC.hidesBottomBarWhenPushed = YES;
        drawMoneyVC.model = self.model;
//        drawMoneyVC.BankType = self.BankType;
//        drawMoneyVC.Bankno = self.model.bank;
//        drawMoneyVC.mybankNumber = self.model.account_all;
//        drawMoneyVC.myBranch = self.model.branch;
//        drawMoneyVC.myCity = self.model.city;
//        drawMoneyVC.balanceMoney = self.model._balance;//可用余额
        [self.viewController.navigationController pushViewController:drawMoneyVC animated:YES];
        
    }
}
#pragma mark -- 设置

- (IBAction)handleSetting:(UIButton *)sender {
    DYMyAcountMainVC *VC = [[DYMyAcountMainVC alloc]initWithNibName:@"DYMyAcountMainVC" bundle:nil];
    VC.hidesBottomBarWhenPushed = YES;
//    VC.phone=self.model.phone;
//    VC.card_id = _model.card_id;
//    VC.bank_status=[self.model.bank_status intValue];
    VC.model = self.model;
    [self.viewController.navigationController pushViewController:VC animated:YES];
    
}
#pragma mark -- 已获收益

- (IBAction)handleGotMoney:(UIButton *)sender {
    DDhasWonMoneyViewController *moneyVC = [[DDhasWonMoneyViewController alloc]initWithNibName:@"DDhasWonMoneyViewController" bundle:nil];
    moneyVC.hidesBottomBarWhenPushed = YES;
    moneyVC.typeStr = @"received";
    moneyVC.nameStr = @"已获总收益(元)";
    moneyVC.title = @"收益详情";
    moneyVC.moneyStr = self.model.recover_yes_profit;
    moneyVC.prodectStr = @"";
    [self.viewController.navigationController pushViewController:moneyVC animated:YES];
}
#pragma mark -- 待收收益
- (IBAction)handleWaitInvest:(UIButton *)sender {
    DDhasWonMoneyViewController *moneyVC = [[DDhasWonMoneyViewController alloc]initWithNibName:@"DDhasWonMoneyViewController" bundle:nil];
    moneyVC.hidesBottomBarWhenPushed = YES;
    moneyVC.typeStr = @"collecting";
    moneyVC.nameStr = @"待收收益总额(元)";
    moneyVC.title = @"待收收益";
    moneyVC.prodectStr = @"";
    moneyVC.moneyStr = self.model.tender_wait_interest;
    [self.viewController.navigationController pushViewController:moneyVC animated:YES];
}


- (IBAction)handleCalendar:(UIButton *)sender {

     [MobClick event:@"account_huikuanrili"];
    NSString *loginKey = [DYUser GetLoginKey];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/payment_calender/index&login_key=%@",ffwebURL, loginKey];
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"回款日历";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:adVC animated:YES];

}
#pragma mark -- 总资金
- (IBAction)gotoAllMoeny:(UIButton *)sender {
    DDAllMoneyViewController *allMoenyVC = [[DDAllMoneyViewController alloc] initWithNibName:@"DDAllMoneyViewController" bundle:nil];
    allMoenyVC.allMoney = self.totalMoney.text;
    allMoenyVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:allMoenyVC animated:YES];
}

//可用余额
- (IBAction)gotoResidue:(UIButton *)sender {
    DYFinancialRecordsVC *VC = [[DYFinancialRecordsVC alloc]initWithNibName:@"DYFinancialRecordsVC" bundle:nil];
    VC.money = self.residueMoney.text;// 可用余额
    VC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:VC animated:YES];
}

//助力红包
- (IBAction)handleRisk:(UIButton *)sender {
     [MobClick event:@"account_My_zhulihongbao"];
    NSString *loginKey = [DYUser GetLoginKey];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/packet/index&login_key=%@",ffwebURL,loginKey];
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"助力红包";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:adVC animated:YES];
    
}
- (IBAction)jisunqiBtn:(id)sender {
     NSString *url=[NSString stringWithFormat:@"%@/activity/mobile/calculator/calculator.html?login_key=%@",pcURL,[DYUser GetLoginKey]];
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.hidesBottomBarWhenPushed = YES;
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"理财计算器";
    [self.viewController.navigationController pushViewController:adVC animated:YES];

}
#pragma mark -- 我的投资0
- (IBAction)handleMyinvest:(UIButton *)sender {
     [MobClick event:@"account_Mytouzi"];
    DDMyInvestViewController *VC = [[DDMyInvestViewController alloc]initWithNibName:@"DDMyInvestViewController" bundle:nil];
    VC.hidesBottomBarWhenPushed = YES;
    
    [self.viewController.navigationController pushViewController:VC animated:YES];
}
#pragma mark -- 卡券
- (IBAction)handleCard:(UIButton *)sender {
     [MobClick event:@"account_Mykabao"];
//    DDMyCardVoucherViewController *cardVC = [[DDMyCardVoucherViewController alloc]initWithNibName:@"DDMyCardVoucherViewController" bundle:nil];
//    cardVC.hidesBottomBarWhenPushed = YES;
//    cardVC.borrowNid = @"";
//    [self.viewController.navigationController pushViewController:cardVC animated:YES];
    FFRedPacketViewController *cardVC = [[FFRedPacketViewController alloc] init];
    cardVC.hidesBottomBarWhenPushed = YES;
    cardVC.borrowNid = @"";
    [self.viewController.navigationController pushViewController:cardVC animated:YES];
    
}
#pragma mark -- 我的邀请
- (IBAction)myShare:(UIButton *)sender {
//    NSString *url=[NSString stringWithFormat:@"%@/mobile.php?action&module=activity&q=static&v=invitation&login_key=%@",pcURL,[DYUser GetLoginKey]];
//    ActivityDetailViewController *VC = [[ActivityDetailViewController alloc] init];
//    VC.hidesBottomBarWhenPushed = YES;
//    VC.myUrls = @{@"url" : url};
//    VC.title = @"邀请好友";
//    [self.viewController.navigationController pushViewController:VC animated:YES];
}
#pragma mark -- 债转
- (IBAction)handleTranfer:(UIButton *)sender {
     [MobClick event:@"account_zhaiquanzhuanrang"];
    DDBondViewController *bondVC = [[DDBondViewController alloc] init];
    bondVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:bondVC animated:YES];
}
- (IBAction)handleEyes:(UIButton *)sender {
    eye = !eye;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud synchronize];
    if (eye) {
        [ud setObject:@"0" forKey:@"eyeType"];
        [self.eyeBtn setImage:[UIImage imageNamed:@"eyes_2"] forState:UIControlStateNormal];
        self.totalMoney.text = [NSString stringWithFormat:@"%@", self.model._total];
        self.ContentD.text =  self.model.recover_yes_profit;
        self.residueMoney.text = [NSString stringWithFormat:@"%@",  self.model._balance];
        self.waitinvserstLabel.text = [NSString stringWithFormat:@"%@",  self.model.tender_wait_interest];
        
        
    }else {
        [ud setObject:@"1" forKey:@"eyeType"];
        [self.eyeBtn setImage:[UIImage imageNamed:@"eyes_1"] forState:UIControlStateNormal];
        
        self.totalMoney.text = @"****";
        self.ContentD.text =  @"****";
        self.residueMoney.text = @"****";
        self.waitinvserstLabel.text = @"****";
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
