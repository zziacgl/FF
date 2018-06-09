//
//  DDKnowDuoduoViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/12/15.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDKnowDuoduoViewController.h"

@interface DDKnowDuoduoViewController ()<UIWebViewDelegate>

@end

@implementation DDKnowDuoduoViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"了解多多";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webview.delegate =self;
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [[NSURL alloc]initWithString:@"http://www.51duoduo.com/lqbbz/shoujiduan/demo.html"];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:0]];
}
#pragma mark- webViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [MBProgressHUD hudWithView:self.view label:@"正在加载，请稍后..."];
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    
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
