//
//  DDFundRecordTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/12/6.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCapitalRecordModel.h"
@interface DDFundRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (nonatomic, strong) DDCapitalRecordModel *model;
@end
