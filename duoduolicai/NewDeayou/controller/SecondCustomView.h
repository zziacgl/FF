//
//  SecondCustomView.h
//  SnowDemo
//
//  Created by apple on 15/11/23.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SecondCustomViewDelegate <NSObject>
- (void)getAction:(int)row;
- (void)remove;
- (void)money:(float)how;


@end
@interface SecondCustomView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSString *str1;
@property (nonatomic, strong) NSString *str2;
@property (nonatomic, strong) NSString *str3;
@property (nonatomic, assign) NSInteger number;
@property id<SecondCustomViewDelegate>delegate;
@property (nonatomic, strong) UITableView *tableView;


@end
