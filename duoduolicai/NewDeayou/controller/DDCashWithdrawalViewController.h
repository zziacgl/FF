//
//  DDCashWithdrawalViewController.h
//  NewDeayou
//
//  Created by 郭嘉 on 2017/12/1.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDCashWithdrawalViewControllerDelegate<NSObject>

-(void)cashMessage:(NSDictionary *)cashDic;

@end

@interface DDCashWithdrawalViewController : DYBaseVC
-(instancetype)init:(NSString *)str borrowtype:(NSString *)type;
@property (nonatomic,strong)id <DDCashWithdrawalViewControllerDelegate>delegate;
@property (nonatomic,copy)NSString *borrowNid;

@end
