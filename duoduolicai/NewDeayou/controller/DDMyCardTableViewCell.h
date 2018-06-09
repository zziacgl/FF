//
//  DDMyCardTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/6/6.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMyCardTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UILabel *myCountLabel;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIImageView *lineImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UIImageView *pastImage;//判断是否过期或者已使用
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *useTypeLabel;
@property (nonatomic, strong) UILabel *useLabel;
@property (nonatomic, strong) UILabel *pastLabel;
@end
