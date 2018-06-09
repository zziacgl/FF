//
//  DYActionCenterDetailViewController.m
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/13.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYActionCenterDetailViewController.h"

@interface DYActionCenterDetailViewController ()
@property (nonatomic,strong) UIWebView *webView;

@end


@implementation DYActionCenterDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"活动详情";
       
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
//    self.contentView.editable = NO;
    self.webView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    [self statRequst];
}

-(void)statRequst{
    [MBProgressHUD hudWithView:self.view label:@"加载中..."];
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:self.actionId forKey:@"id" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"content" forKey:@"q" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess) {
//            NSLog(@"%@",object);
//            self.contentView.text = [[object DYObjectForKey:@"content"]DYObjectForKey:@"content"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.webView loadHTMLString:[[object DYObjectForKey:@"content"]DYObjectForKey:@"content"] baseURL:nil];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [LeafNotification showInController:self withText:errorMessage];
        }
    } errorBlock:^(id error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"网络异常"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
