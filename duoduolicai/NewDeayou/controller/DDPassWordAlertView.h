//
//  DDPassWordAlertView.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/23.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DDPassWordAlertView : UIView<UITextFieldDelegate>


//物理屏幕宽度
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width

//物理屏幕高度
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height
@property(nonatomic,strong) UITextField *password;
@property(nonatomic,strong) UILabel *TxtMoney;
@property(nonatomic,strong) UITextField *text1;
@property(nonatomic,strong) UITextField *text2;
@property(nonatomic,strong) UITextField *text3;
@property(nonatomic,strong) UITextField *text4;
@property(nonatomic,strong) UITextField *text5;

@property (nonatomic, strong) UITextField *allTF;

@property(nonatomic,strong)UIButton *updatePasswordBnt;
@end
