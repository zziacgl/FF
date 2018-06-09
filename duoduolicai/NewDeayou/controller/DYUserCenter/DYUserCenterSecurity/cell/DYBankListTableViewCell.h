//
//  DYBankListTableViewCell.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/9.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYBankListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgTop;
@property (weak, nonatomic) IBOutlet UILabel *BankName;
@property (weak, nonatomic) IBOutlet UILabel *BankID;
@property (weak, nonatomic) IBOutlet UILabel *limitD;//限额描述

@end
