//
//  DYRealtimeFianacailHeadTableViewCell.h
//  NewDeayou
//
//  Created by diyou on 14-7-10.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYRealtimeFianacailHeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TotalM;//总资产
@property (weak, nonatomic) IBOutlet UIButton *WithdrawalBtn;//提现
//@property (weak, nonatomic) IBOutlet UIButton *RechargeBtn;//充值
@property (weak, nonatomic) IBOutlet UIButton *RechargeBtn2;

@property (weak, nonatomic) IBOutlet UIImageView *TiYanJinLogoImage;//送体验金图片
@property (nonatomic, strong) UIImageView *shareImage;
@property (nonatomic, strong)  NSTimer *timer;
@property (nonatomic)CGPoint mypoint;

@property (weak, nonatomic) IBOutlet UIButton *SafeSetBnt;//安全设置
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *AcountLabel;//账号
@property (weak, nonatomic) IBOutlet UIButton *TopImageBnt;//头像


@end
