//
//  DDWalletTurnInViewController.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/17.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDWalletTurnInViewController : DYBaseVC
@property (weak, nonatomic) IBOutlet UIView *HeadView;
@property (nonatomic)int type;
@property (weak, nonatomic) IBOutlet UILabel *Alert;
@property (nonatomic,strong)NSString *balance;
@property (nonatomic,strong)NSString *annual;

@property (nonatomic)int isDone;
@end
