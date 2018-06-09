//
//  NewInvestTableViewCell.h
//  NewDeayou
//
//  Created by apple on 15/11/17.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYInvestDetailVC.h"
#import "HKPieChartView.h"
#define kBorderWidth     0.5f
#define kBorderColor    [UIColor lightGrayColor].CGColor

#define kFontNumsBig  [UIFont systemFontOfSize:25.0f] //大字体
#define kFontNumsSmall  [UIFont systemFontOfSize:15.0f] //小字体

@interface NewInvestTableViewCell : UITableViewCell
-(void)setAttributeWithDictionary:(NSDictionary*)dic viewController:(DYInvestDetailVC*)vc isFlow:(BOOL)isFlow;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *rewardView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rewardViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;//年化收益
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;//持有期限
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//投资类型
@property (weak, nonatomic) IBOutlet UILabel *residueLabel;//可投金额
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;//还款方式
@property (weak, nonatomic) IBOutlet UILabel *refundWayLabel;//开始时间
@property (weak, nonatomic) IBOutlet UILabel *valueDateLabel;//起息时间
@property (weak, nonatomic) IBOutlet UILabel *projectStateLabel;//项目状态

@property (weak, nonatomic) IBOutlet UIButton *projectDetail;//项目详情
@property (weak, nonatomic) IBOutlet UIButton *safetyBtn;//安全保障
@property (weak, nonatomic) IBOutlet UIButton *planBtn;//还款计划

@property (weak, nonatomic) IBOutlet UIButton *recordBtn;//投资记录

@property(nonatomic,strong)NSDictionary * dicData;

@property (nonatomic,strong) DYInvestDetailVC * vcDelegate;
@property (weak, nonatomic) IBOutlet UILabel *firstPeople;//拔得头筹手机号

@property (weak, nonatomic) IBOutlet UILabel *limitMinMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;//融资金额
@property (weak, nonatomic) IBOutlet UIView *forwardView;//提前还款视图

@property (weak, nonatomic) IBOutlet UIButton *dancuanBtn;//弹窗按钮
@property (nonatomic, copy) NSString *fullstatus;//是否满标审核通过

//判断是否可以投资，判断是否是流转标
@property (nonatomic,assign)BOOL isRevert;
@property (nonatomic,assign)BOOL isFlow;
@property (nonatomic, copy) NSString *investType;
@property (nonatomic, copy) NSString *borrowType;
@property (nonatomic,strong)NSString *borrowId;
@property (weak, nonatomic) IBOutlet UIProgressView *InvestprogressView;


@property (nonatomic, strong) NSString *detailUrl;

@end
