//
//  DDNickNameSetViewController.h
//  NewDeayou
//
//  Created by 郭嘉 on 16/2/24.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDNickNameSetViewController : DYBaseVC
@property (weak, nonatomic) IBOutlet UITextField *text;
@property (nonatomic,strong) NSString *niname;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@end
