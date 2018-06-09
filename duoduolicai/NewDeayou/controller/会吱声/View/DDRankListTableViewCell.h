//
//  DDRankListTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/10/31.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDRankListModel.h"
@interface DDRankListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *avartView;
@property (weak, nonatomic) IBOutlet UILabel *duomiLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (nonatomic, strong) DDRankListModel *model;
@end
