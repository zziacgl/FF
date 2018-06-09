//
//  DDDuoChoosePlanTableViewCell.h
//  NewDeayou
//
//  Created by 郭嘉 on 2017/9/30.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYInvestDetailVC.h"

@interface DDDuoChoosePlanTableViewCell : UITableViewCell

-(void)setAttributeWithDictionary:(NSDictionary*)dic viewController:(DYInvestDetailVC*)vc;

@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;//年化收益
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;//持有期限
@property (weak, nonatomic) IBOutlet UILabel *residueLabel;//剩余金额
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;//还款方式
@property (weak, nonatomic) IBOutlet UILabel *valueDateLabel;//起息时间

@property (weak, nonatomic) IBOutlet UIButton *projectDetail;//项目详情
@property (weak, nonatomic) IBOutlet UIButton *safetyBtn;//安全保障

@property (weak, nonatomic) IBOutlet UILabel *limitMinMoneyLabel;//起投金额
@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;//融资金额
@property(nonatomic,strong)NSDictionary * dicData;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic,strong) DYInvestDetailVC * vcDelegate;
@property (nonatomic, strong) NSString *detailUrl;

@end
