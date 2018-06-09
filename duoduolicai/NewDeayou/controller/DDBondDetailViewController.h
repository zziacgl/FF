//
//  DDBondDetailViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/8/10.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DDBondDetailViewControllerDelegate <NSObject>

- (void)refrech:(BOOL)isgo;

@end
@interface DDBondDetailViewController : DYBaseVC
@property (nonatomic, strong) NSDictionary *detailDic;
@property (nonatomic, strong) id <DDBondDetailViewControllerDelegate>delegate;

@end
