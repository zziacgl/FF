//
//  AddRecordFooterView.m
//  NewDeayou
//
//  Created by zhoubiwen on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "AddRecordFooterView.h"

@interface AddRecordFooterView ()

@end

@implementation AddRecordFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderColor = kBackColor.CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.clipsToBounds = YES;
}


@end
