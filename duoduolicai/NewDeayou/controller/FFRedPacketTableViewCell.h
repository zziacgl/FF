//
//  FFRedPacketTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/1/18.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFRedPacketmodel.h"
@interface FFRedPacketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *awardLabel;
@property (weak, nonatomic) IBOutlet UILabel *reComeLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImaeView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@property (nonatomic, strong) FFRedPacketmodel *model;

@end
