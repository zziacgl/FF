//
//  DYPlaceholderTextView.h
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/13.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYPlaceholderTextViewDelegate.h"

@interface DYPlaceholderTextView : UITextView
@property (retain,nonatomic) UILabel *placeholderLabel;
@property (assign,nonatomic) id<DYPlaceholderTextViewDelegate>placeholderTextViewDelegate;
@property (copy,nonatomic) NSString *placeholder;
@end
