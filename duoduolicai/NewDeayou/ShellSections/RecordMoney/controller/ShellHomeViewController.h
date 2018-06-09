//
//  ShellHomeViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/7.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUFoldingTableView.h"

@interface ShellHomeViewController : UIViewController<YUFoldingTableViewDelegate>
@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;

@end
