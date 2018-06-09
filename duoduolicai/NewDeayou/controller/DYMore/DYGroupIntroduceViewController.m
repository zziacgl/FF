//
//  DYGroupIntroduceViewController.m
//  NewDeayou
//
//  Created by apple on 15/10/21.
//  Copyright © 2015年 wayne. All rights reserved.
//

#import "DYGroupIntroduceViewController.h"

@interface DYGroupIntroduceViewController ()<UIWebViewDelegate>

@end

@implementation DYGroupIntroduceViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"团队介绍";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL *url = [[NSURL alloc]initWithString:@"http://www.51duoduo.com/ddjs/jieshaotuandui.html"];
    self.webview.delegate = self;
    [self.webview loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
