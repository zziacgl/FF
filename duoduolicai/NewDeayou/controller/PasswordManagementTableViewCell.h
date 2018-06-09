//
//  PasswordManagementTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/3/22.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFMineModel.h"

@interface PasswordManagementTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *paypasswordstatus;
@property (nonatomic, strong) FFMineModel *ffModel;
@property (weak, nonatomic) IBOutlet UIButton *payPasswordBtn;

@end
