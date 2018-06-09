//
//  DDhasMoenyTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/18.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCapitalModel.h"
@interface DDhasMoenyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) DDCapitalModel *model;
@end
