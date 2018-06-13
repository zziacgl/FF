//
//  ShellOverViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/8.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "ShellOverViewCell.h"
#import "ShellRecordModel.h"
#import "ShellGoodsModel.h"
@implementation ShellOverViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.dataAry removeAllObjects];
    [self.dataAry addObjectsFromArray:[ShellModelTool getRecord:0]];
    if (self.dataAry.count > 0) {
        dispatch_queue_t queue =dispatch_queue_create("serial",DISPATCH_QUEUE_SERIAL);
        dispatch_sync(queue, ^{
            for (ShellRecordModel *model in self.dataAry[0]) {
                for (ShellGoodsModel *goodsModel in model.goods) {
                    
                    [self.sellAry addObject:goodsModel.sellingPrice];
                    [self.countAry addObject:goodsModel.count];
                    
                }
            }
        });
        dispatch_sync(queue, ^{
            for (int i = 0; i < self.sellAry.count; i++) {
                float a = [self.countAry[i] floatValue];//数量
                float b = [self.sellAry[i] floatValue];//售价
                float c = a*b;
                
                [self.allSellAry addObject:[NSString stringWithFormat:@"%.2f", c]];
            }
            
        });
        dispatch_sync(queue, ^{
            
            self.allSellStr = [NSString stringWithFormat:@"%.f", [[self.allSellAry valueForKeyPath:@"@sum.self"] floatValue]];
            NSLog(@"总价格%@", self.allSellStr);
            self.todayMoneyLabel.text = self.allSellStr;
            self.monthMoneyLabel.text = self.allSellStr;
            self.allMoneyLabel.text = self.allSellStr;
        });
    }
    
    // Initialization code
}
- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        self.dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
- (NSMutableArray *)sellAry{
    if (!_sellAry) {
        self.sellAry = [NSMutableArray array];
    }
    return _sellAry;
}
- (NSMutableArray *)countAry {
    if (!_countAry) {
        self.countAry = [NSMutableArray array];
    }
    return _countAry;
}
- (NSMutableArray *)allSellAry {
    if (!_allSellAry) {
        self.allSellAry = [NSMutableArray array];
    }
    return _allSellAry;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
