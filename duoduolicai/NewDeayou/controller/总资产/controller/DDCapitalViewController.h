//
//  DDCapitalViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/12/8.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCapitalViewController : DYBaseVC
@property (nonatomic, copy) NSString *capitalMoney;
@property (weak, nonatomic) IBOutlet UILabel *capitalLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end
