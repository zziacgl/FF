//
//  DDActivityAreaTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/22.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDActivityAreaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;//活动名称

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//活动状态
@property (weak, nonatomic) IBOutlet UIImageView *activityIamge;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//活动时间
@property (weak, nonatomic) IBOutlet UILabel *predictLabel;//预计时间
-(void)setAttributeWithDictionary:(NSDictionary*)dictionary;
@property (nonatomic, strong) NSTimer *timer;
@end
