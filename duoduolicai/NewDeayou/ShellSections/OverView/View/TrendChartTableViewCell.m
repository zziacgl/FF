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

@end
@implementation TrendChartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpChartView];
    
    // Initialization code
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
    plot.pointArray = @[@100, @550, @700, @200, @370, @890, @760, @430, @210, @30, @300, @550, @700, @200, @370, @890, @760, @430, @210, @30, @300, @550, @700, @200, @370, @890, @760, @430, @210, @30];
    
    
    
    
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
