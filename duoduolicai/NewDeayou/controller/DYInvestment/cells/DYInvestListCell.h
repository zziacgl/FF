//
//  DYInvestListCell.h
//  NewDeayou
//
//  Created by wayne on 14-6-24.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPieChartView.h"
@interface DYInvestListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *myBackView;

-(void)setAttributeWithDictionary:(NSDictionary*)dictionary type:(int)tfty product:(NSString *)product;
//@property (weak, nonatomic) IBOutlet UIImageView *bidTypeIV;
@property (nonatomic , strong) UILabel *timeLabel;

@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *progressBackView;

@property (weak, nonatomic) IBOutlet UILabel *buyLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyLabelHeight;

//@property (weak, nonatomic) IBOutlet UILabel *investType;//标状态
//@property (weak, nonatomic) IBOutlet UILabel *countTimeLabel;//倒计时

//@property (weak, nonatomic) IBOutlet UIView *progressBackView;//进度条视图底部视图
@property (weak, nonatomic) IBOutlet UILabel *remainMoneyLabel;//剩余金额

@property (weak, nonatomic) IBOutlet UILabel *refundStyleLabel;//还款方式
//@property (nonatomic, strong) HKPieChartView *pieChartView;
@end
