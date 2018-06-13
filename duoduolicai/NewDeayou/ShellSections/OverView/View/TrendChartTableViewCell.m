//
//  TrendChartTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "TrendChartTableViewCell.h"
#import "DVLineChartView.h"
#import "UIView+Extension.h"
#import "UIColor+Hex.h"

@interface TrendChartTableViewCell () <DVLineChartViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) NSMutableArray *inMoenyAry;
@property (nonatomic, strong) NSMutableArray *countAry;
@property (nonatomic, strong) NSMutableArray *allinMoneyAry;
@property (nonatomic, copy) NSString * allMoneyStr;
@property (nonatomic, strong) NSMutableArray *myary;
@end
@implementation TrendChartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    [self.dataAry removeAllObjects];
    [self.dataAry addObjectsFromArray:[ShellModelTool getRecord:0]];
    
    if (self.dataAry.count > 0) {
        dispatch_queue_t queue =dispatch_queue_create("serial",DISPATCH_QUEUE_SERIAL);
        dispatch_sync(queue, ^{
            for (ShellRecordModel *model in self.dataAry[0]) {
                NSLog(@"%@", model.goods);
                for (ShellGoodsModel *goodsModel in model.goods) {
                    NSLog(@"dad%@", goodsModel.count);
                    [self.inMoenyAry addObject:goodsModel.buyingPrice];//进价
                    [self.countAry addObject:goodsModel.count];
                    
                }
            }
        });
        dispatch_sync(queue, ^{
            for (int i = 0; i < self.inMoenyAry.count; i++) {
                float a = [self.inMoenyAry[i] floatValue];//进价
                float b = [self.countAry[i] floatValue];//数量
                float c = a*b;
                [self.allinMoneyAry addObject:[NSString stringWithFormat:@"%.2f", c]];
                
            }
        
        });
        dispatch_sync(queue, ^{
            NSNumber *allsum = [self.allinMoneyAry valueForKeyPath:@"@sum.self"];
            float money = [allsum floatValue];
            self.allMoneyStr = [NSString stringWithFormat:@"%.2f", money];
            [self.myary insertObject:allsum atIndex:0];
            NSLog(@"我的%@", self.myary);
        });
        
        
    }
     [self setUpChartView];
    // Initialization code
}

    
- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        self.dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
- (NSMutableArray *)inMoenyAry {
    if (!_inMoenyAry) {
        self.inMoenyAry = [NSMutableArray array];
    }
    return _inMoenyAry;
}
- (NSMutableArray *)countAry {
    if (!_countAry) {
        self.countAry = [NSMutableArray array];
    }
    return _countAry;
}
- (NSMutableArray *)allinMoneyAry {
    if (!_allinMoneyAry) {
        self.allinMoneyAry = [NSMutableArray array];
    }
    return _allinMoneyAry;
}

- (NSMutableArray *)myary {
    if (!_myary) {
        self.myary = [NSMutableArray array];
    }
    return _myary;
}
- (void)setUpChartView {
    DVLineChartView *ccc = [[DVLineChartView alloc] init];
    [self.contentView addSubview:ccc];
    
    ccc.width = kMainScreenWidth;
    
    ccc.yAxisViewWidth = 52;
    
    ccc.numberOfYAxisElements = 5;
    
    ccc.delegate = self;
    ccc.pointUserInteractionEnabled = YES;
    
    ccc.yAxisMaxValue = 1000;
    
    ccc.pointGap = 50;
    
    ccc.showSeparate = YES;
    ccc.separateColor = [UIColor colorWithHexString:@"67707c"];
    
    ccc.textColor = [UIColor colorWithHexString:@"9aafc1"];
    ccc.backColor = [UIColor colorWithHexString:@"3e4a59"];
    ccc.axisColor = [UIColor colorWithHexString:@"67707c"];
    
    ccc.xAxisTitleArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30"];
    
    
    ccc.x = 0;
    ccc.y = 20;
    ccc.width = kMainScreenWidth;
    ccc.height = 300;
    
    
    
    DVPlot *plot = [[DVPlot alloc] init];
    plot.pointArray = @[@340,@550];
    
    
    
    
    plot.lineColor = [UIColor colorWithHexString:@"2f7184"];
    plot.pointColor = [UIColor colorWithHexString:@"14b9d6"];
    plot.chartViewFill = YES;
    plot.withPoint = YES;
    [ccc addPlot:plot];
    [ccc draw];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
