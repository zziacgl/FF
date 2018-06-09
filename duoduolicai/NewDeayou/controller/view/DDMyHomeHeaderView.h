//
//  DDMyHomeHeaderView.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/21.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "DDBarnerModel.h"
#import "DDNewuserModel.h"
@interface DDMyHomeHeaderView : UIView<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *OperationDayLabel;//运营时间
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;//累计交易额
@property (weak, nonatomic) IBOutlet UIView *redView;


@property (weak, nonatomic) IBOutlet UILabel *percentLabel;//年化
@property (weak, nonatomic) IBOutlet UIImageView *homeInvestImage;//新手、推荐小图标
@property (weak, nonatomic) IBOutlet UILabel *investNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *footLabel;


@property (nonatomic, strong) DDBarnerModel *barnerModel;
@property (weak, nonatomic) IBOutlet UIView *lineProgress;//进度条
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//投资期限
@property (weak, nonatomic) IBOutlet UILabel *startMoenyLabel;//起投金额

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleView;
@property (weak, nonatomic) IBOutlet UIImageView *cycleImage;

@property (weak, nonatomic) IBOutlet UIScrollView *barnerScrollView;
@property (weak, nonatomic) IBOutlet UIButton *safeBtn;
@property (weak, nonatomic) IBOutlet UIButton *activityBtn;
@property (weak, nonatomic) IBOutlet UIButton *firstUserBtn;//新手
@property (weak, nonatomic) IBOutlet UIView *noticeView;

@property (weak, nonatomic) IBOutlet UIView *customView;
@property (nonatomic, assign) SDCycleScrollView *homeBarner;
@property (nonatomic,strong)NSMutableArray*allDataAry;
@property (nonatomic,strong)NSMutableArray*aryADImages;
@property (nonatomic,strong)NSMutableArray*aryUrls;
@property (nonatomic,strong)DDNewuserModel*model;
@property (weak, nonatomic) IBOutlet UIButton *bugBtn;

@end
