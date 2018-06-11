//
//  TopTitleCell.m
//  NewDeayou
//
//  Created by zhoubiwen on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "TopTitleCell.h"
#import "ShellGoodsModel.h"

@interface TopTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *buyPrice;
@property (weak, nonatomic) IBOutlet UILabel *sellPrice;

@end

@implementation TopTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setGoodsModel:(ShellGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    self.goodsName.text = goodsModel.goodsName;
    self.count.text = goodsModel.count;
    self.buyPrice.text = goodsModel.buyingPrice;
    self.sellPrice.text = goodsModel.sellingPrice;
}


@end
