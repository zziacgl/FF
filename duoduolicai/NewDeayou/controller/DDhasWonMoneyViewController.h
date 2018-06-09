//
//  DDhasWonMoneyViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/18.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDhasWonMoneyViewController : DYBaseVC
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UILabel *havegetMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *moneyStr;
@property (nonatomic, copy) NSString *prodectStr;


@end
