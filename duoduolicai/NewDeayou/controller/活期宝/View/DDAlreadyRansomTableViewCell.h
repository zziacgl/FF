//
//  DDAlreadyRansomTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/11.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDAlreadyRansomModel.h"
@interface DDAlreadyRansomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ransomMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *getMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) DDAlreadyRansomModel *model;
@end
