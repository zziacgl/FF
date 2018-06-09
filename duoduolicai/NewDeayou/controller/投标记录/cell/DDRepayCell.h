//
//  DDRepayCell.h
//  NewDeayou
//
//  Created by Tony on 2016/10/27.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDRepayOtherModel.h"
#import "DDRepayModel.h"

@interface DDRepayCell : UITableViewCell
@property(nonatomic,strong)DDRepayOtherModel*otherModel;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property(nonatomic,strong)DDRepayModel*model;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end
