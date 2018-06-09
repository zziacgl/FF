//
//  DDSmallWalletHelperViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/19.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDSmallWalletHelperViewController.h"

@interface DDSmallWalletHelperViewController ()<UIWebViewDelegate>

@end
static int a = 0;
@implementation DDSmallWalletHelperViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.navigationController.navigationBarHidden = NO;
    a = 0;
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [[NSURL alloc]initWithString:self.urlStr];
    self.webview.delegate=self;
    [self.webview loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:0]];
    
    UIButton * btnLeftItem=[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeftItem.backgroundColor=[UIColor clearColor];
    btnLeftItem.frame=CGRectMake(0, 0, 50, 20);
    [btnLeftItem setTitle:@"返回" forState:UIControlStateNormal];
//    [btnLeftItem setBackgroundImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
//    [btnLeftItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLeftItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btnLeftItem addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeftItem];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    a++;
  
   
    return YES;
}
- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
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
