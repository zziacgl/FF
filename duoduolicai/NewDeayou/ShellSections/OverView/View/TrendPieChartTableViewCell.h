//
//  TrendPieChartTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSPieChart.h"

@interface TrendPieChartTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) NSMutableArray *inMoenyAry;
@property (nonatomic, strong) NSMutableArray *countAry;
@property (nonatomic, strong) NSMutableArray *allinMoneyAry;
@property (nonatomic) NSNumber *allsum;
@property (nonatomic, strong) NSMutableArray *postageAry;
@property (nonatomic, strong) NSMutableArray *allPostageAry;
@property (nonatomic, copy) NSString *allMoneyStr;
@property (nonatomic, copy) NSString *allPostageStr;
@property (nonatomic, strong) NSMutableArray *sellAry;
@property (nonatomic, strong) NSMutableArray *allSellAry;
@property (nonatomic, copy) NSString *allSellStr;
@property (nonatomic, strong) WSPieChart *pie;
@end
