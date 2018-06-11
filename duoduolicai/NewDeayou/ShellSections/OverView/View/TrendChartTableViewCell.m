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
    
    ccc.xAxisTitleArray = @[@"4.1", @"4.2", @"4.3", @"4.4", @"4.5", @"4.6", @"4.7", @"4.8", @"4.9", @"4.10", @"4.11", @"4.12", @"4.13", @"4.14", @"4.15", @"4.16", @"4.17", @"4.18", @"4.19", @"4.20", @"4.21", @"4.22", @"4.23", @"4.24", @"4.25", @"4.26", @"4.27", @"4.28", @"4.29", @"4.30"];
    
    
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
