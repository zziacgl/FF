//
//  DYPlaceholderTextViewDelegate.h
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/13.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DYPlaceholderTextView;

@protocol DYPlaceholderTextViewDelegate <NSObject>

-(void)placeholderTextViewDidBeginEditing:(DYPlaceholderTextView *)placeholderTextView;
-(void)placeholderTextViewDidChange:(DYPlaceholderTextView *)placeholderTextView;
-(void)placeholderTextViewDidEndEditing:(DYPlaceholderTextView *)placeholderTextView;
@end
