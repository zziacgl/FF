//
//  DDWalletTurnOutViewController.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/16.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDWalletTurnOutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *HeadView;//头部
@property (weak, nonatomic) IBOutlet UITextField *TextMoney;//转出金额
@property (nonatomic,strong)NSString *balance;//零钱包总资产
@property (weak, nonatomic) IBOutlet UILabel *Alert;
@property (nonatomic,strong)NSString *annual;//年化

@property (nonatomic)int isDone;
@end
