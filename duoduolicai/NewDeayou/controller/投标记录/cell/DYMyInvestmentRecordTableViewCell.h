//
//  DYMyInvestmentRecordTableViewCell.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/18.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYMyInvestmentRecordTableViewCell : UITableViewCell
@property(nonatomic,copy)NSString*TouID;

@property (weak, nonatomic) IBOutlet UILabel *Mark_titile;//标的标题
@property (weak, nonatomic) IBOutlet UILabel *Mark_InvestM;//已投资金额
@property (nonatomic,copy) NSString *webURL;
@property (weak, nonatomic) IBOutlet UIButton *jihua;
@property (weak, nonatomic) IBOutlet UILabel *Mark_earningTotal;//待收本息
@property (weak, nonatomic) IBOutlet UILabel *typenameLabel;

@property (weak, nonatomic) IBOutlet UILabel *Mark_earningSince;//已收收益
@property (weak, nonatomic) IBOutlet UILabel *Mark_capital;//待收本金
@property (weak, nonatomic) IBOutlet UIButton *xieyi;
@property (weak, nonatomic) IBOutlet UILabel *Mark_state;//状态
@property (weak, nonatomic) IBOutlet UILabel *Mark_Date;//投资时间
@property (weak, nonatomic) IBOutlet UILabel *annualLabel;//年化收益
@property (nonatomic,assign)BOOL isTender;

@property (nonatomic,assign)BOOL isMonth;
@property (weak, nonatomic) IBOutlet UILabel *nidLabel;
@property (weak, nonatomic) IBOutlet UILabel *tender_idLabel;
@property (weak, nonatomic) IBOutlet UIButton *ShareBnt;
@property (weak, nonatomic) IBOutlet UIButton *ProtocolBtn;//查看协议
@property (nonatomic, copy) NSString *borrowNid;

@property (weak, nonatomic) IBOutlet UIImageView *transferTypeImage;



@end
