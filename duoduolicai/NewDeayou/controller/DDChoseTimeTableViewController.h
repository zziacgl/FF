//
//  DDChoseTimeTableViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/8/10.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//代理传值
@protocol DDChoseTimeTableViewControllerDelegate <NSObject>

- (void)choseTime:(NSString *)time;

@end


@interface DDChoseTimeTableViewController : UITableViewController
@property (nonatomic, strong) id<DDChoseTimeTableViewControllerDelegate>delegate;
@end
