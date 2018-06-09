//
//  SetPayPasswordViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/3/28.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPayPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *myPhoneTF;

@property (nonatomic, copy) NSString *phone;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@end
