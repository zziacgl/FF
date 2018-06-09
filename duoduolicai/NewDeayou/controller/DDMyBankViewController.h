//
//  DDMyBankViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/10/18.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMyBankViewController : DYBaseVC

@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *realname;
@property (nonatomic,strong)NSString *card_id;
@property (nonatomic,copy) NSString *gotexpgold;
@property (nonatomic) BOOL isBindBank;//是否绑定银行卡
@property (nonatomic, strong) NSDictionary *bankDic;

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImage;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankUserLabel;

@property (weak, nonatomic) IBOutlet UIButton *removeBankBtn;

@end
