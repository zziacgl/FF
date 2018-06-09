//
//  DYBankInfoTableViewCell.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/8/28.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYBankInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *LogoImage;//银行logo
@property (weak, nonatomic) IBOutlet UILabel *BankName;//银行名称
@property (weak, nonatomic) IBOutlet UILabel *BankNo;//银行卡尾号
@property (weak, nonatomic) IBOutlet UILabel *BankType;//储蓄卡，信用卡

@property (weak, nonatomic) IBOutlet UIButton *TerminationBtn;//解绑按钮
@end
