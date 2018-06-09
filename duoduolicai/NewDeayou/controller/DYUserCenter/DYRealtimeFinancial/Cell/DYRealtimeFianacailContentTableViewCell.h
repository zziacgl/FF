//
//  DYRealtimeFianacailContentTableViewCell.h
//  NewDeayou
//
//  Created by diyou on 14-7-10.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYRealtimeFianacailContentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnLook;
@property (strong, nonatomic) IBOutlet UIButton *button1;//账户余额
@property (weak, nonatomic) IBOutlet UIButton *button2;//持有资产

- (IBAction)getMoney:(UIButton *)sender;
- (IBAction)lastMoney:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *totalM;//累计收益
//@property (weak, nonatomic) IBOutlet UIButton *totalD;//总资产
@property (weak, nonatomic) IBOutlet UILabel *totalL; // 总资产
@property (weak, nonatomic) IBOutlet UIButton *ContentD;//持有资产
@property (weak, nonatomic) IBOutlet UIButton *Blance;//账户余额
@property (weak, nonatomic) IBOutlet UILabel *totalA;//总积分
@property (weak, nonatomic) IBOutlet UIButton *depositBtn; // 提现
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn; // 充值

@property (weak, nonatomic) IBOutlet UIButton *safeBut;
@property (weak, nonatomic) IBOutlet UILabel *MyAcountLabel;


@end
