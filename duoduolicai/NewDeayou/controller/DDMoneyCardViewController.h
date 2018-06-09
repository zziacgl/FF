//
//  DDMoneyCardViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/6/8.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDMoneyCardViewControllerDelegate <NSObject>

- (void)moneyMassage:(NSDictionary *)moneyDic;

@end


@interface DDMoneyCardViewController : DYBaseVC
- (instancetype)init:(NSString *)str borrowtype:(NSString *)type;
@property (nonatomic, strong) id <DDMoneyCardViewControllerDelegate>delegate;
@property (nonatomic, copy) NSString *borrowNid;

@end
