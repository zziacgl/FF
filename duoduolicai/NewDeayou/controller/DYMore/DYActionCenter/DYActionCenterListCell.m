//
//  DYActionCenterListCell.m
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/13.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYActionCenterListCell.h"

@implementation DYActionCenterListCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, kScreenSize.width, kScreenSize.width/2)];
        tempImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.detailImageView = tempImageView;
        [self.contentView addSubview:tempImageView];
        
        UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tempImageView.frame)+5, kScreenSize.width, 30)];
        tempLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel = tempLabel;
        [self.contentView addSubview:tempLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 1)];
        lineImageView.image = [UIImage imageNamed:@"fullline.png"];
//        lineImageView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:lineImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
