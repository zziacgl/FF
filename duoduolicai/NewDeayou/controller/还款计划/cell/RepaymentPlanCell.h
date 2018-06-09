//
//  RepaymentPlanCell.h
//  NewDeayou
//
//  Created by apple on 15/11/17.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepaymentPlanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *RepaymentAmount;//还款金额
@property (weak, nonatomic) IBOutlet UILabel *RepaymentTime;//还款时间
@property (weak, nonatomic) IBOutlet UILabel *repayType;

@end
