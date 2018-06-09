//
//  DYAuthenticationTableViewCell.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/8/20.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYAuthenticationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *pwdSet;
@property (weak, nonatomic) IBOutlet UIButton *payPwdSet;

@property (weak, nonatomic) IBOutlet UISwitch *LockSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *TouchLockSwitch;

@end
