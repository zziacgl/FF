//
//  PasswordManagementTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/3/22.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "PasswordManagementTableViewCell.h"
#import "DYUpdateLoginPwdViewController.h"
#import "SetPayPasswordViewController.h"
@implementation PasswordManagementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    
}

-(void)setFfModel:(FFMineModel *)ffModel {
    NSLog(@"支付密码%@", self.phone);
    if ([ffModel.pay_password_status isEqualToString:@"0"] ) {
        [self.payPasswordBtn setTitle:@"设置" forState:UIControlStateNormal];
        [self.payPasswordBtn addTarget:self action:@selector(handleSetPayPassWord) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [self.payPasswordBtn setTitle:@"修改" forState:UIControlStateNormal];
        [self.payPasswordBtn addTarget:self action:@selector(handleChangePayPassWord) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

#pragma mark -- 设置支付密码
- (void)handleSetPayPassWord {
    SetPayPasswordViewController *payVC = [[SetPayPasswordViewController alloc] initWithNibName:@"SetPayPasswordViewController" bundle:nil];
    payVC.phone = self.phone;
     payVC.title = @"设置支付密码";
    [self.viewController.navigationController pushViewController:payVC animated:YES];
    
}
#pragma mark -- 修改支付密码

- (void)handleChangePayPassWord {
    SetPayPasswordViewController *payVC = [[SetPayPasswordViewController alloc] initWithNibName:@"SetPayPasswordViewController" bundle:nil];
    payVC.phone = self.phone;
    payVC.title = @"修改支付密码";
    [self.viewController.navigationController pushViewController:payVC animated:YES];
    
    
}
- (IBAction)changeLoginPassword:(UIButton *)sender {
    DYUpdateLoginPwdViewController * updatePasswordVC=[[DYUpdateLoginPwdViewController alloc]initWithNibName:@"DYUpdateLoginPwdViewController" bundle:nil];
    updatePasswordVC.hidesBottomBarWhenPushed=YES;
    updatePasswordVC.phone=self.phone;
    NSLog(@"支付密码%@", self.phone);

    updatePasswordVC.isUpdate=@"1";
    [self.viewController.navigationController pushViewController:updatePasswordVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
