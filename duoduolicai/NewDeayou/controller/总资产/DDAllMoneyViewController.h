//
//  DDAllMoneyViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/24.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAllMoneyViewController : DYBaseVC
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;
@property (nonatomic, copy) NSString *allMoney;
@end
