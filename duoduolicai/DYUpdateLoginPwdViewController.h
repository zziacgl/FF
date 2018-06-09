//
//  DYUpdateLoginPwdViewController.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/15.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYUpdateLoginPwdViewController : DYBaseVC

@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *isUpdate;

@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (nonatomic)int type;

@property (nonatomic)BOOL isBank;
@end
