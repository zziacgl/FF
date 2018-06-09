//
//  DDJiaBanFeiSeeingViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 16/3/3.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDJiaBanFeiSeeingViewController.h"

@interface DDJiaBanFeiSeeingViewController ()

@property(strong,nonatomic)UIWebView *webView;
@end

@implementation DDJiaBanFeiSeeingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"加班费查看详情";
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64)];
    _webView.backgroundColor=[UIColor whiteColor];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.51duoduo.com/mobile.php?overtime&q=pay&type=look&user_id=%d",[DYUser GetUserID]]];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:0];//创建NSURLRequest
    [_webView loadRequest:request];//加载
    [self.view addSubview:_webView];
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
