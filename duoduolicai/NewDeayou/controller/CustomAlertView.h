//
//  CustomAlertView.h
//  CustomAlertView
//
//  Created by huadao on 15/11/13.
//  Copyright © 2015年 KUKER. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAlertViewDelegate <NSObject>
- (void)gotoAction:(int)row;
- (void)makeDismiss;



@end
@interface CustomAlertView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSString *str1;
@property (nonatomic, strong) NSString *str2;
@property (nonatomic, strong) NSString *str3;
@property (nonatomic, assign) NSInteger number;
@property id<CustomAlertViewDelegate>delegate;
@property (nonatomic, strong) UITableView *tableView;


@end
