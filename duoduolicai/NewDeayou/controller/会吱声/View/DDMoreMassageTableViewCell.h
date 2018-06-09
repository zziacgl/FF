//
//  DDMoreMassageTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/3.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMoreMassageModel.h"
@interface DDMoreMassageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) DDMoreMassageModel *model;

-(void)cellAutoLayoutHeight:(NSString *)str;
@end
