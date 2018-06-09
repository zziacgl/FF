//
//  DDBondTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/8/9.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCircle.h"
#import "DDInTransferTableViewController.h"
#import "DDCanTranferTableViewController.h"
@interface DDBondTableViewCell : UITableViewCell
-(void)setAttributeWithDictionary:(NSDictionary*)dic viewController:(DDInTransferTableViewController*)vc;

@property (nonatomic, strong) DDInTransferTableViewController *VCdelegate;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *transferBtn;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIImageView *overImage;
@property (nonatomic, strong) DDCircle *pieChartView;

@end
