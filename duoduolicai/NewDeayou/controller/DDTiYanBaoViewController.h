//
//  DDTiYanBaoViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/10/10.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDTiYanBaoViewController : DYBaseVC
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic, copy) NSString *typeStr;
@property(nonatomic)int type;
@end
