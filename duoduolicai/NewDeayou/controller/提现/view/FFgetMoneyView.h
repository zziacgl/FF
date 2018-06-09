//
//  FFgetMoneyView.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/1/5.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFMineModel.h"

@interface FFgetMoneyView : UIView


//@property (weak, nonatomic) IBOutlet UIView *cityView;
//@property (weak, nonatomic) IBOutlet UIView *BranchView;
@property (weak, nonatomic) IBOutlet UIView *MoneyView;


@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNumberLabel;
//@property (weak, nonatomic) IBOutlet UITextField *branchTF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *myMoenyLabel;
//@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic, strong) FFMineModel *model;
@end
