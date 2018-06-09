//
//  DYMoreCell.m
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/13.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYMoreCell.h"

@interface DYMoreCell ()

@property (nonatomic,retain) UIImageView *topImageView;

@end

@implementation DYMoreCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 1)];
        topImageView.backgroundColor = kMoreSeparateColor;
        self.topImageView = topImageView;
        [self.contentView addSubview:topImageView];
        
        UIImageView *bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, kScreenSize.width, 1)];
        bottomImageView.backgroundColor = kMoreSeparateColor;
        [self.contentView addSubview:bottomImageView];
        
    }
    return self;
}

//第一行不隐藏，其余的都隐藏
-(void)hideTopImageView:(BOOL)hide
{
    self.topImageView.hidden = hide;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
