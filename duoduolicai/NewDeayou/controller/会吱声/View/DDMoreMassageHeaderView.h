//
//  DDMoreMassageHeaderView.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/3.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMessageModel.h"
typedef void (^myBlock)(void);

@interface DDMoreMassageHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property(nonatomic,copy)myBlock block;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) DDMessageModel *model;

@end
