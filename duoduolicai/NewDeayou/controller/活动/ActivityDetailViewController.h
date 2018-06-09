//
//  ActivityDetailViewController.h
//  NewDeayou
//
//  Created by apple on 15/11/19.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "DYBaseVC.h"


@interface ActivityDetailViewController : DYBaseVC
@property (weak, nonatomic) IBOutlet UIWebView *activityWebView;
@property (nonatomic, strong) NSDictionary *myUrls;
@property (nonatomic, strong, readonly) JSContext    *jsContext;
@property (nonatomic, strong) NSDictionary *shareDic;
@property (nonatomic,strong)NSString *titleM;

@property (nonatomic)int isdan;//1:是从活动弹窗那边过来的
@end
