//
//  DDmyCustonView.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/26.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WindowView      [[UIApplication sharedApplication] keyWindow]
@interface DDmyCustonView : UIView
@property (nonatomic, strong) UIView *backView;//蒙面背景
@property (nonatomic, strong) UILabel *tittleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong)UITableView *describeTableView;
@property (nonatomic, strong) UIButton *updateBtn;
@property (nonatomic, strong) UIButton *cancalBtn;
@property(nonatomic, strong)NSArray *DescribeArr;
@end
