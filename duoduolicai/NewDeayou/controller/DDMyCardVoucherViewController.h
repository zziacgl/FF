//
//  DDMyCardVoucherViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/6/6.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DDMyCardVoucherViewControllerDelegate <NSObject>

- (void)myCard: (NSDictionary *) myCardDic;

@end

@interface DDMyCardVoucherViewController : DYBaseVC
@property (nonatomic, copy) NSString *isUse;
//@property (nonatomic, copy) NSString *day;
@property (nonatomic,copy)NSString *isDraw;
@property (nonatomic, copy) NSString *borrowType;//新手标standard
@property (nonatomic, copy) NSString *borrowNid;//标id
@property (nonatomic, strong) id <DDMyCardVoucherViewControllerDelegate>delegate;

@end
