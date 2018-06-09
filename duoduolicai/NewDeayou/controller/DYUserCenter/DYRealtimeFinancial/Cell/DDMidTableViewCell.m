//
//  DDMidTableViewCell.m
//  NewDeayou
//
//  Created by 郭嘉 on 16/2/23.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMidTableViewCell.h"
#import "DDChangePhoneViewController.h"
#import "ActivityDetailViewController.h"
#import "DYUpdateLoginPwdViewController.h"
#import "DDSystemInfoViewController.h"
#import "PasswordManagementViewController.h"
@implementation DDMidTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = kBackColor;
    // Initialization code
}
- (void)setModel:(FFMineModel *)model {
    _model = model;
    if (model) {
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        if (model.niname.length > 0) {
             self.nickNameLabel.text = [NSString stringWithFormat:@"%@", model.niname];
        }else {
             self.nickNameLabel.text = @"未设置昵称";
            
        }
        if ([self.model.bank_status isEqualToString:@"0"]) {
            [self.removeBank setTitle:@"去绑定" forState:UIControlStateNormal];
            [self.removeBank addTarget:self action:@selector(handlebindBank) forControlEvents:UIControlEventTouchUpInside];

            
        }else {
            [self.removeBank setTitle:@"解绑" forState:UIControlStateNormal];
            [self.removeBank addTarget:self action:@selector(handleRemoveBind) forControlEvents:UIControlEventTouchUpInside];

            
        }
//        if ([model.bank_status isEqualToString:@"0"]) {
//            [self.bankbandBtn setTitle:@"去绑定" forState:UIControlStateNormal];
//            [self.bankbandBtn addTarget:self action:@selector(handlebindBank) forControlEvents:UIControlEventTouchUpInside];
//        }else {
//            [self.bankbandBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
//            [self.bankbandBtn setTintColor:[UIColor blueColor]];
//            NSString *number = [NSString stringWithFormat:@"%@", model.account_all];
//
//            NSString *numberStr = [number stringByReplacingCharactersInRange:NSMakeRange(0, number.length - 4) withString:@"****"];
//            [self.bankLabel setTitle:[NSString stringWithFormat:@"%@ %@", model.bank_name, numberStr] forState:UIControlStateNormal];
//            [self.bankbandBtn addTarget:self action:@selector(handleRemoveBind) forControlEvents:UIControlEventTouchUpInside];
//
//        }
        
        if (model.phone.length > 0) {
            [self.nameAuthentication setTintColor:[UIColor lightGrayColor]];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已认证/修改"]];
            [str addAttribute:NSForegroundColorAttributeName value:kBtnColor range:NSMakeRange(4,2)];
            [self.nameAuthentication setAttributedTitle:str forState:UIControlStateNormal];
            [self.nameAuthentication addTarget:self action:@selector(handleChangePhone) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if ([model.realname_status isEqualToString:@"1"]) {
            [self.phoneAuthentication setTitle:@"已认证" forState:UIControlStateNormal];
            self.phoneAuthentication.userInteractionEnabled = NO;
        }else {
              [self.phoneAuthentication setTitle:@"未认证" forState:UIControlStateNormal];
            self.phoneAuthentication.userInteractionEnabled = YES;
            [self.phoneAuthentication setTintColor:kBtnColor];
            [self.phoneAuthentication addTarget:self action:@selector(handlebindBank) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
}

#pragma mank -- 绑卡

- (void)handlebindBank {
    [MobClick event:@"click_shiming"];
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.hidesBottomBarWhenPushed = YES;
    NSString *loginKey = [DYUser GetLoginKey];
    NSString *url = [NSString stringWithFormat:@"%@/action/recharge/mobilePay?money=100&login_key=%@",ffwebURL, loginKey];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"充值";
    [self.viewController.navigationController pushViewController:adVC animated:YES];
    
}
- (void)handleRemoveBind {
    [MobClick event:@"jiebang"];
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.hidesBottomBarWhenPushed = YES;
    NSString *url = [NSString stringWithFormat:@"%@/activity/mobile/unbundling/unbundling.html",ffwebURL];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"解绑银行卡";
    [self.viewController.navigationController pushViewController:adVC animated:YES];
    
}
#pragma mark -- 修改手机号
- (void)handleChangePhone {
    DDChangePhoneViewController * changeVC=[[DDChangePhoneViewController alloc]initWithNibName:@"DDChangePhoneViewController" bundle:nil];
    changeVC.hidesBottomBarWhenPushed=YES;
    changeVC.phone= self.model.phone;
    
    [self.viewController.navigationController pushViewController:changeVC animated:YES];
    
}
- (IBAction)changepassWord:(UIButton *)sender {
    //修改登录密码
    DYUpdateLoginPwdViewController * updatePasswordVC=[[DYUpdateLoginPwdViewController alloc]initWithNibName:@"DYUpdateLoginPwdViewController" bundle:nil];
    updatePasswordVC.hidesBottomBarWhenPushed=YES;
    updatePasswordVC.phone=self.model.phone;
    updatePasswordVC.isUpdate=@"1";
    updatePasswordVC.paypasswordstatus = self.model.pay_password_status;
    [self.viewController.navigationController pushViewController:updatePasswordVC animated:YES];
}

- (IBAction)handleDetection:(UIButton *)sender {
    DDSystemInfoViewController *systeminfoVC = [[DDSystemInfoViewController alloc]init];
    systeminfoVC.hidesBottomBarWhenPushed=YES;
    [self.viewController.navigationController pushViewController:systeminfoVC animated:YES];
    
}
#pragma mark -- 密码管理
- (IBAction)handlePassWord:(UIButton *)sender {
    PasswordManagementViewController *passVC = [[PasswordManagementViewController alloc] init];
     passVC.phone=self.model.phone;
    passVC.ffmodel = self.model;
    NSLog(@"支付密码first%@", self.model.pay_password_status);

    passVC.paypasswordstatus = self.model.pay_password_status;
    [self.viewController.navigationController pushViewController:passVC animated:YES];
    
    
}

- (IBAction)handleAssessment:(UIButton *)sender {
    NSString *loginKey = [DYUser GetLoginKey];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/evaluating/begin&login_key=%@",ffwebURL,loginKey];
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"风险评测";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:adVC animated:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
