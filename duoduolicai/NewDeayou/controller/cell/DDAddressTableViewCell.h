//
//  DDAddressTableViewCell.h
//  NewDeayou
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAddressTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatarView; //头像
@property (nonatomic, strong) UILabel *nameLabel; //姓名
@property (nonatomic, strong) UILabel *phoneLabel; //联系方式
@property (nonatomic, strong) UIButton *CallButton; //拨打电话按钮

@end
