//
//  DDDrawMoneyViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 2017/2/10.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFMineModel.h"

@interface DDDrawMoneyViewController : DYBaseVC
@property (nonatomic) int BankType;//银行类型
@property (nonatomic, copy) NSString *Bankno;
@property (nonatomic, copy) NSString *balanceMoney;
@property (nonatomic, copy) NSString *mybankNumber;//银行卡号
@property (nonatomic, copy) NSString *myBranch;//支行
@property (nonatomic, copy) NSString *myCity;
@property (nonatomic, strong) FFMineModel *model;
@end
