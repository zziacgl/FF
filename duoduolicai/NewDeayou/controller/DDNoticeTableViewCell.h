//
//  DDNoticeTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/13.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDNoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
-(void)cellAutoLayoutHeight:(NSString *)str;
@end
