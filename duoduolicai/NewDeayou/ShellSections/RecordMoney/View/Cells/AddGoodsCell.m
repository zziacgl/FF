//
//  FFTAddGoodsCell.m
//  NewDeayou
//
//  Created by zhoubiwen on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "AddGoodsCell.h"

@interface AddGoodsCell ()

@property (nonatomic, copy) void(^addGoodsAction)(void);
@end

@implementation AddGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)addGoodsButtonPressed:(id)sender {
    if (self.addGoodsAction) self.addGoodsAction();
}

- (void)addGoodsAction:(void(^)(void))action {
    self.addGoodsAction = action;
}

@end
