//
//  versionView.h
//  DuoDuoLiCai
//
//  Created by 陈高磊 on 2017/5/9.
//  Copyright © 2017年 陈高磊. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertResult)(NSInteger index);

@interface versionView : UIView
@property (nonatomic,copy) AlertResult resultIndex;
- (instancetype)initWithTitle:(NSString *)versionTitle message:(NSString *)message versionType:(BOOL)isMandatory;



- (void)showAlertView;
@end
