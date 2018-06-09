//
//  DDAssignTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/8/12.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPieChartView.h"

#import "DYInvestDetailVC.h"

@interface DDAssignTableViewCell : UITableViewCell
{
     NSTimeInterval timeUserValue;
}
-(void)setAttributeWithDictionary:(NSDictionary*)dic viewController:(DYInvestDetailVC*)vc isFlow:(BOOL)isFlow;
@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;//剩余金额
@property (weak, nonatomic) IBOutlet UILabel *limitMinMoneyLabel;//起投金额

@property (weak, nonatomic) IBOutlet UIView *redView;//红色视图
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;//年化收益
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;//持有时间
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//标类型
@property (weak, nonatomic) IBOutlet UILabel *residueLabel;//融资/可投
@property (weak, nonatomic) IBOutlet UILabel *oldaprLabel;//原始年化
@property (weak, nonatomic) IBOutlet UIImageView *topImage;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;//持有时间
@property (weak, nonatomic) IBOutlet UILabel *refundWayLabel;//还款方式
@property (weak, nonatomic) IBOutlet UILabel *valueDateLabel;//距离流标时间
@property (weak, nonatomic) IBOutlet UILabel *projectStateLabel;//项目状态
@property (weak, nonatomic) IBOutlet UIButton *projectDetail;//项目详情

@property (weak, nonatomic) IBOutlet UIButton *safetyBtn;//安全保障
@property (weak, nonatomic) IBOutlet UIButton *planBtn;//还款计划
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;//投资记录
@property (weak, nonatomic) IBOutlet UIButton *massageBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (nonatomic, copy) NSString *fullstatus;//是否满标审核通过

@property(nonatomic,strong)NSDictionary * dicData;
@property (nonatomic,strong) DYInvestDetailVC * vcDelegate;
//判断是否可以投资，判断是否是流转标
@property (nonatomic,assign)BOOL isRevert;
@property (nonatomic,assign)BOOL isFlow;

@property (nonatomic, strong)NSString *borrowId;
@property (nonatomic, strong) NSString *detailUrl;
@property (nonatomic, strong) NSTimer *timer;
@end
