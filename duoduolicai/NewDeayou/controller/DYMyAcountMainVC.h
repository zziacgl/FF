//
//  DYMyAcountMainVC.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/8/20.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "FFMineModel.h"
#define kAcountBackgroundColor kCOLOR_R_G_B_A(246, 246, 246, 1)

@interface DYMyAcountMainVC : DYBaseVC
@property (nonatomic,strong)NSDictionary * dic;
@property(nonatomic,copy)NSString *payPwdStatus;//是否设置支付密码
@property (nonatomic,copy)NSString *phone;
@property (nonatomic)BOOL isBank;
@property (nonatomic,strong)NSString *realname;
@property (nonatomic,copy)NSString *card_id;
@property (nonatomic,copy) NSString *gotexpgold;

@property (nonatomic, copy) NSString *avatarUrl;//头像链接
@property (nonatomic, copy) NSString *genderStr;//性别
@property (nonatomic, copy) NSString *nickNameStr;//昵称

@property (nonatomic) int bank_status;
@property (nonatomic, strong) FFMineModel *model;

@end
