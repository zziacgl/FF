//
//  DDBondDetailTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/8/10.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDBondDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *choseTime;

@property (weak, nonatomic) IBOutlet UITextField *transferPriceTF;//转让价格输入框
@property (weak, nonatomic) IBOutlet UILabel *moneyInterVal;//转让价格设置区间
@property (weak, nonatomic) IBOutlet UILabel *principalLabel;//到账金额

@property (weak, nonatomic) IBOutlet UILabel *allMoenyLabel;//转让手续费

@property (weak, nonatomic) IBOutlet UILabel *FEELabel;//原利率


@property (weak, nonatomic) IBOutlet UILabel *conversionRateLab;//折合利率
@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@property (weak, nonatomic) IBOutlet UIImageView *isReadImage;

@property (weak, nonatomic) IBOutlet UIButton *isSureBtn;

@property (weak, nonatomic) IBOutlet UIButton *dealBtn;


@end
