//
//  AddRecordHederView.m
//  NewDeayou
//
//  Created by zhoubiwen on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "AddRecordHeaderView.h"

@interface AddRecordHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *nickNameBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *mobileBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *postageBackgroundView;


@end

@implementation AddRecordHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupBackgroundView:self.nickNameBackgroundView];
    [self setupBackgroundView:self.mobileBackgroundView];
    [self setupBackgroundView:self.postageBackgroundView];
}

- (void)setupBackgroundView:(UIView *)view {
    view.layer.cornerRadius = view.height / 2;
    view.clipsToBounds = YES;
    view.layer.borderWidth = 1;
    view.layer.borderColor = kMainColor.CGColor;
}


@end
