//
//  TrendPieChartTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "TrendPieChartTableViewCell.h"
#import "ShellRecordModel.h"
#import "ShellGoodsModel.h"
#define k_COLOR_STOCK @[[UIColor colorWithRed:22/255.0 green:56/255.0 blue:96/255.0 alpha:1],[UIColor colorWithRed:241/255.0 green:187/255.0 blue:62/255.0 alpha:1],[UIColor colorWithRed:163/255.0 green:200/255.0 blue:240/255.0 alpha:1]]

@implementation TrendPieChartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.dataAry removeAllObjects];
    [self.dataAry addObjectsFromArray:[ShellModelTool getRecord:0]];
    NSLog(@"收益%@", self.dataAry);
    [self setUpPieChartView];
   
    if (self.dataAry.count > 0) {
        dispatch_queue_t queue =dispatch_queue_create("serial",DISPATCH_QUEUE_SERIAL);
        dispatch_sync(queue, ^{
            for (ShellRecordModel *model in self.dataAry[0]) {
                NSLog(@"%@", model.goods);
                [self.postageAry addObject:model.postage];
                for (ShellGoodsModel *goodsModel in model.goods) {
                    NSLog(@"dad%@", goodsModel.count);
                    [self.inMoenyAry addObject:goodsModel.buyingPrice];//进价
                    [self.countAry addObject:goodsModel.count];
                    [self.sellAry addObject:goodsModel.sellingPrice];
                    
                }
            }
        });
        dispatch_sync(queue, ^{
            for (int i = 0; i < self.inMoenyAry.count; i++) {
                float a = [self.inMoenyAry[i] floatValue];//进价
                float b = [self.countAry[i] floatValue];//数量
                float d = [self.postageAry[i] floatValue];//邮费
                float f = [self.sellAry[i] floatValue];//售价
                float c = a*b;
                float e = b*d;
                float g = b*f;
                [self.allinMoneyAry addObject:[NSString stringWithFormat:@"%.2f", c]];
                [self.allPostageAry addObject:[NSString stringWithFormat:@"%.2f", e]];
                [self.allSellAry addObject:[NSString stringWithFormat:@"%.2f", g]];
            }
            
        });
        dispatch_sync(queue, ^{
            self.allsum = [self.allinMoneyAry valueForKeyPath:@"@sum.self"];
            
            float money = [self.allsum floatValue];
            self.allMoneyStr = [NSString stringWithFormat:@"%.2f", money];
            
            self.allPostageStr = [NSString stringWithFormat:@"%.2f", [[self.allPostageAry valueForKeyPath:@"@sum.self"] floatValue]];
            self.allSellStr = [NSString stringWithFormat:@"%.2f", [[self.allSellAry valueForKeyPath:@"@sum.self"] floatValue]];
        });
        
        
        NSLog(@"进价%@", self.allMoneyStr);
        NSLog(@"邮费%@", self.allPostageStr);
        NSLog(@"售价%@", self.allSellStr);
        
        
        float a = [self.allMoneyStr floatValue];
        float b= [self.allPostageStr floatValue];
        float c = [self.allSellStr floatValue];
        NSLog(@"%fnih%fnij%f", a, b, c);
        float d ;
        float e;
        float f;
        if (c > 0) {
            d = a / (a + b + c) * 100;
            e = b / (a + b + c) * 100;
            f = c / (a + b + c) * 100;
        }else {
            d = a / (a + b) * 100;
            e = b / (a + b) * 100;
            f = 0;
        }
        
        self.firstLabel.text = [NSString stringWithFormat:@"进价%.f%%",d];
        self.secondLabel.text = [NSString stringWithFormat:@"邮费%.f%%", e];
        self.thirdLabel.text = [NSString stringWithFormat:@"利润%.f%%", f];
        self.pie = [[WSPieChart alloc] initWithFrame:CGRectMake(0, 70, kMainScreenWidth / 3 * 2 , kMainScreenWidth / 3 * 2 )];
            CGFloat a1 = [self.allMoneyStr floatValue];
            CGFloat b1= [self.allPostageStr floatValue];
            CGFloat c1 = [self.allSellStr floatValue];
            NSNumber *a2 = [NSNumber numberWithFloat:a1];
            NSNumber *b2 = [NSNumber numberWithFloat:b1];
            NSNumber *c2 = [NSNumber numberWithFloat:c1];
        
        self.pie.valueArr = @[a2,b2,c2];
        
        self.pie.descArr = @[@"进价",@"邮费",@"利润"];
        self.pie.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.pie];
        self.pie.positionChangeLengthWhenClick = 20;
        //    pie.showDescripotion = YES;
        [self.pie showAnimation];
        
    }else {
        self.firstLabel.text = @"进价0%";
        self.secondLabel.text = @"邮费0%";
        self.thirdLabel.text = @"利润0%";
        self.pie = [[WSPieChart alloc] initWithFrame:CGRectMake(0, 70, kMainScreenWidth / 3 * 2 , kMainScreenWidth / 3 * 2 )];
       
        self.pie.valueArr = @[@10,@10,@10];
        self.pie.descArr = @[@"进价",@"邮费",@"利润"];
        self.pie.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.pie];
        self.pie.positionChangeLengthWhenClick = 20;
        [self.pie showAnimation];
        
    }
    
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
- (NSMutableArray *)postageAry {
    if (!_postageAry) {
        self.postageAry = [NSMutableArray array];
    }
    return _postageAry;
}
- (NSMutableArray *)allPostageAry {
    if (!_allPostageAry) {
        self.allPostageAry = [NSMutableArray array];
    }
    return _allPostageAry;
    
}
- (NSMutableArray *)sellAry {
    if (!_sellAry) {
        self.sellAry = [NSMutableArray array];
    }
    return _sellAry;
}

- (NSMutableArray *)allSellAry {
    if (!_allSellAry) {
        self.allSellAry = [NSMutableArray array];
    }
    return _allSellAry;
}
- (void)setUpPieChartView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, kMainScreenWidth, 20)];
    titleLabel.text = @"收益占比：";
    titleLabel.textColor = kCOLOR_R_G_B_A(224, 72, 22, 1);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    
    
    
    for (int i = 0; i < 3; i++) {
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 * 2, 70 + kMainScreenWidth / 15 * 2+ (kMainScreenWidth / 3 * 2 -20) / 6  * i, kMainScreenWidth / 3, (kMainScreenWidth / 3 * 2 -20) / 6 )];
        
        [self.contentView addSubview:colorView];
       
        if (i == 0) {
            UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(colorView.frame) / 2 - 8, 16, 16)];
            firstView.layer.cornerRadius = 8;
            firstView.layer.masksToBounds = YES;
            firstView.backgroundColor = kCOLOR_R_G_B_A(224, 72, 22, 1);
            [colorView addSubview:firstView];
            self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(colorView.frame) - 20, CGRectGetHeight(colorView.frame))];
            self.firstLabel.textColor = kCOLOR_R_G_B_A(224, 72, 22, 1);
            self.firstLabel.font = [UIFont systemFontOfSize:13];
           
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
            [colorView addSubview:self.thirdLabel];
        }
    }
    
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
