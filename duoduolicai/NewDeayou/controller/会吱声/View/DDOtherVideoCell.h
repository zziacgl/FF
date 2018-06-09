//
//  DDOtherVideoCell.h
//  NewDeayou
//
//  Created by Tony on 2016/11/1.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOtherVideoModel.h"

@interface DDOtherVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property(nonatomic,strong)DDOtherVideoModel*model;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
