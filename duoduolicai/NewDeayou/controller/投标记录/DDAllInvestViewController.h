//
//  DDAllInvestViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/19.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface DDAllInvestViewController : DYBaseVC
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSString *borrowType;//标类型
@end
