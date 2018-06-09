//
//  DYBankInfoViewController.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/8/28.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYBankInfoViewController : DYBaseVC

@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *realname;
@property (nonatomic,strong)NSString *card_id;
@property (nonatomic,copy) NSString *gotexpgold;
@property (nonatomic) int isBindBank;//是否绑定银行卡
@end
