//
//  FFHomeInvestTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/4/18.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDNewuserModel.h"
@interface FFHomeInvestTableViewCell : UITableViewCell
@property (nonatomic, strong) DDNewuserModel *newinvestModel;//新手标
@property (nonatomic, strong) DDNewuserModel *recommendedModel;//推荐标
@property (nonatomic, strong) DDNewuserModel *model;//推荐标
@property (weak, nonatomic) IBOutlet UILabel *investTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *startMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;



@end
