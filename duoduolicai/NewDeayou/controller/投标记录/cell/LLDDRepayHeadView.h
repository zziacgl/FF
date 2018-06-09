//
//  LLDDRepayHeadView.h
//  NewDeayou
//
//  Created by Tony on 2016/10/27.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDRepayModel.h"

@interface LLDDRepayHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *presentMonth;
@property(nonatomic,strong)DDRepayModel*model;
@property (weak, nonatomic) IBOutlet UILabel *benKJ;//本月卡劵或额外
@property (weak, nonatomic) IBOutlet UILabel *yujiKJ;//预计卡劵或额外

@end
