//
//  DDMidTableViewCell.h
//  NewDeayou
//
//  Created by 郭嘉 on 16/2/23.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFMineModel.h"
@interface DDMidTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *TopImageSetBnt;
@property (weak, nonatomic) IBOutlet UIButton *NickNameSetBnt;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@property (weak, nonatomic) IBOutlet UIButton *phoneAuthentication;
@property (weak, nonatomic) IBOutlet UIButton *nameAuthentication;
@property (weak, nonatomic) IBOutlet UIButton *securityManageBtn;

@property (weak, nonatomic) IBOutlet UIButton *bankLabel;
@property (weak, nonatomic) IBOutlet UIButton *bankbandBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankPhoneBtn;

@property (nonatomic, strong) FFMineModel *model;

@property (weak, nonatomic) IBOutlet UIButton *removeBank;


@end
