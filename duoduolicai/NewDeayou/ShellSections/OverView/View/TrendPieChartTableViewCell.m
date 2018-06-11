//
//  TrendPieChartTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "TrendPieChartTableViewCell.h"
#import "WSPieChart.h"

#define k_COLOR_STOCK @[[UIColor colorWithRed:22/255.0 green:56/255.0 blue:96/255.0 alpha:1],[UIColor colorWithRed:241/255.0 green:187/255.0 blue:62/255.0 alpha:1],[UIColor colorWithRed:163/255.0 green:200/255.0 blue:240/255.0 alpha:1]]

@implementation TrendPieChartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpPieChartView];
    // Initialization code
}

- (void)setUpPieChartView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, kMainScreenWidth, 20)];
    titleLabel.text = @"收益占比：";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    WSPieChart *pie = [[WSPieChart alloc] initWithFrame:CGRectMake(0, 70, kMainScreenWidth / 3 * 2 , kMainScreenWidth / 3 * 2 )];
    pie.valueArr = @[@50,@20,@33];
    pie.descArr = @[@"1月份",@"2月份",@"3月份"];
    pie.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:pie];
    pie.positionChangeLengthWhenClick = 20;
//    pie.showDescripotion = YES;
    [pie showAnimation];
    
    
    for (int i = 0; i < 3; i++) {
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 * 2, 70 + kMainScreenWidth / 15 * 2+ (kMainScreenWidth / 3 * 2 -20) / 6  * i, kMainScreenWidth / 3, (kMainScreenWidth / 3 * 2 -20) / 6 )];
        
        [self.contentView addSubview:colorView];
       
        if (i == 0) {
            UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(colorView.frame) / 2 - 8, 16, 16)];
            firstView.layer.cornerRadius = 8;
            firstView.layer.masksToBounds = YES;
            firstView.backgroundColor = [UIColor colorWithRed:22/255.0 green:56/255.0 blue:96/255.0 alpha:1];
            [colorView addSubview:firstView];
            self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(colorView.frame) - 20, CGRectGetHeight(colorView.frame))];
            self.firstLabel.textColor = k_COLOR_STOCK[i];
            self.firstLabel.font = [UIFont systemFontOfSize:13];
            self.firstLabel.text = @"进价";
            [colorView addSubview:self.firstLabel];
            
        }else if (i == 1){
            UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(colorView.frame) / 2 - 8, 16, 16)];
            secondView.layer.cornerRadius = 8;
            secondView.layer.masksToBounds = YES;
            secondView.backgroundColor = [UIColor colorWithRed:241/255.0 green:187/255.0 blue:62/255.0 alpha:1];
            [colorView addSubview:secondView];
            self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(colorView.frame) - 20, CGRectGetHeight(colorView.frame))];
            self.secondLabel.textColor = k_COLOR_STOCK[i];
            self.secondLabel.font = [UIFont systemFontOfSize:13];
            self.secondLabel.text = @"进价";
            [colorView addSubview:self.secondLabel];
            
        }else {
            UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(colorView.frame) / 2 - 8, 16, 16)];
            thirdView.layer.cornerRadius = 8;
            thirdView.layer.masksToBounds = YES;
            thirdView.backgroundColor = [UIColor colorWithRed:163/255.0 green:200/255.0 blue:240/255.0 alpha:1];
            [colorView addSubview:thirdView];
            self.thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(colorView.frame) - 20, CGRectGetHeight(colorView.frame))];
            self.thirdLabel.textColor = k_COLOR_STOCK[i];
            self.thirdLabel.font = [UIFont systemFontOfSize:13];
            self.thirdLabel.text = @"进价";
            [colorView addSubview:self.thirdLabel];
        }
    }
    
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
