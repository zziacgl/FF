//
//  DYSafeViewController.m
//  NewDeayou
//
//  Created by apple on 15/10/21.
//  Copyright © 2015年 wayne. All rights reserved.
//

#import "DYSafeViewController.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
@interface DYSafeViewController ()<UIWebViewDelegate>
{
     WYWebProgressLayer *_progressLayer;
}
@property (nonatomic, strong) UIView *myView;
@end
static bool canload;
@implementation DYSafeViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    canload = NO;
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webview.delegate = self;
    NSString *URL=self.weburl;
    NSURL *url = [[NSURL alloc]initWithString:URL];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:0]];
    _progressLayer = [WYWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
}
#pragma mark- webViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
//    [MBProgressHUD hudWithView:self.view label:@"正在加载，请稍后..."];
     [_progressLayer startLoad];
    
    
    [self performSelector:@selector(again) withObject:nil afterDelay:10.0];
    
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    //    NSLog(@"request = %@", request);
    NSString *systemVersion   =  [[UIDevice currentDevice] systemVersion];//系统版本
    float n = [systemVersion floatValue];
    if (n > 8) {
        
        NSString *str = request.URL.absoluteString;
             if ([str containsString:@"invest://"]) {
            [self gotoInvest];
        }
        
    }
    return YES;
}
- (void)gotoInvest {
    [self.tabBarController setSelectedIndex:1];//0:首页，1：理财，2：我的，3：更多
    if([self.view.superview isKindOfClass:[UIView class]]){
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }

}

//- (void)dealloc {
//    
//    [_progressLayer closeTimer];
//    [_progressLayer removeFromSuperlayer];
//    _progressLayer = nil;
//    NSLog(@"i am dealloc");
//}
- (void)again {
    if (canload) {
       
        return;
    }else {
        [self.webview stopLoading];
       
       
               
            self.myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
            _myView.backgroundColor = kCOLOR_R_G_B_A(241, 241, 241, 1);
            
            [self.view addSubview:self.myView];
            
            UIImageView *myImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3, kMainScreenHeight / 4 , kMainScreenWidth / 3 + 10, kMainScreenWidth / 3)];
            myImage.image = [UIImage imageNamed:@"重新下载页_03"];
            [self.myView addSubview:myImage];
            
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(myImage.frame) + 20, kMainScreenWidth, 30)];
            myLabel.text = @"网络出错啦，请点击按钮重新加载";
            myLabel.font = [UIFont systemFontOfSize:15];
            myLabel.textColor = [UIColor lightGrayColor];
            myLabel.textAlignment = NSTextAlignmentCenter;
            [self.myView addSubview:myLabel];
            
            UIButton *myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            myBtn.frame = CGRectMake(kMainScreenWidth / 4, CGRectGetMaxY(myLabel.frame) + 20, kMainScreenWidth / 2, 44);
            [myBtn setTitle:@"重新加载" forState:UIControlStateNormal];
            [myBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            myBtn.layer.cornerRadius = 5;
            myBtn.layer.masksToBounds = YES;
            myBtn.layer.borderWidth = 0.5;
            [myBtn addTarget:self action:@selector(handleAgain) forControlEvents:UIControlEventTouchUpInside];
            myBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [self.myView addSubview:myBtn];
            
        
        _myView.alpha = 1;
        
    }
    
}

- (void)handleAgain {
    [self.myView removeFromSuperview];
    
    self.webview.delegate = self;
    NSString *URL=self.weburl;
    NSURL *url = [[NSURL alloc]initWithString:URL];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:0]];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
         canload = YES;
    [_progressLayer finishedLoad];
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
