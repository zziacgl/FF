//
//  DYLockTableViewCell.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/25.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYLockTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UISwitch *LockSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *TouchSwitch;

-(void)initView;
@end
