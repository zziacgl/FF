//
//  DYContentTableViewCell.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/10/7.
//  Copyright © 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Balance_DuoMi;//可兑换奖励
@property (weak, nonatomic) IBOutlet UILabel *Used_DuoMi;//已兑换奖励

@property (weak, nonatomic) IBOutlet UILabel *ATotal;//一级推荐人数
@property (weak, nonatomic) IBOutlet UILabel *BTotal;//二级推荐人数
@property (weak, nonatomic) IBOutlet UILabel *CTotal;//三级推荐人数

@property (weak, nonatomic) IBOutlet UIButton *RecommendFriendBtn;//推荐朋友
@property (weak, nonatomic) IBOutlet UIButton *HelperCenterBtn;//帮助中心
@property (weak, nonatomic) IBOutlet UIButton *MessageCenterBtn;//消息中心


@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;//兑换成账号余额

@property (weak, nonatomic) IBOutlet UIButton *AClassBtn;
@property (weak, nonatomic) IBOutlet UIButton *BClassBtn;
@property (weak, nonatomic) IBOutlet UIButton *CClassBtn;

@end
