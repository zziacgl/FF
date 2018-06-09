//
//  DDRatesCardViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/6/8.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DDRatesCardViewControllerDelegate <NSObject>
- (void)cardMassage:(NSDictionary *)cardDic;
@end

@interface DDRatesCardViewController : DYBaseVC
@property (nonatomic, strong) id<DDRatesCardViewControllerDelegate>delegate;
- (instancetype)init:(NSString *)str borrowtype:(NSString *)type;
@property (nonatomic, copy) NSString *borrowNid;

@end
