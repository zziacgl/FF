//
//  ShellSearchTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/12.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShellSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *searchBackView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end
