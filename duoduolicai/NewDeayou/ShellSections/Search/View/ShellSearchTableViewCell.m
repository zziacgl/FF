//
//  ShellSearchTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/12.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "ShellSearchTableViewCell.h"

@implementation ShellSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.searchBackView.layer.cornerRadius = 5;
    self.searchBackView.layer.masksToBounds = YES;
    self.searchBackView.layer.borderWidth = 1;
    self.searchBackView.layer.borderColor = kCOLOR_R_G_B_A(243, 181, 58, 1).CGColor;
    // Initialization code
}
- (void)setModel:(ShellRecordModel *)model {
    if (model) {
        self.nickLabel.text = [NSString stringWithFormat:@"昵称：%@", model.nickName];
        NSArray *ary = model.goods;
        NSLog(@"%@", ary);
        ShellGoodsModel *goodsmodel = ary[0];
        self.goodsLabel.text = [NSString stringWithFormat:@"商品:%@", goodsmodel.goodsName];
        self.noteLabel.text = [NSString stringWithFormat:@"备注：%@", model.remark];
        self.phoneLabel.text = [NSString stringWithFormat:@"手机号码:%@", model.mobile];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
