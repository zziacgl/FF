//
//  ShellOverViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/8.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShellOverViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *todayMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *monthMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;

@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) NSMutableArray *sellAry;
@property (nonatomic, strong) NSMutableArray *countAry;
@property (nonatomic, strong) NSMutableArray *allSellAry;
@property (nonatomic, copy) NSString *allSellStr;

@end
