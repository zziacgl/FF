//
//  DYInvestDetailIntroduceVC.m
//  NewDeayou
//
//  Created by wayne on 14/8/15.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYInvestDetailIntroduceVC.h"

@interface DYInvestDetailIntroduceVC ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIView *myView;
@end

@implementation DYInvestDetailIntroduceVC
static bool canload;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"公告详情";
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    self.webView.delegate = self;
    self.webView.backgroundColor = kCOLOR_R_G_B_A(237, 238, 239, 1);
    [_webView loadHTMLString:self.tfText baseURL:nil];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    canload = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark- webViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [MBProgressHUD hudWithView:self.view label:@"正在加载，请稍后..."];
    
    [self performSelector:@selector(again) withObject:nil afterDelay:5.0];
    
    
}
- (void)again {
    if (canload) {
//        NSLog(@"%s,%d",__FUNCTION__,__LINE__);
        return;
    }else {
        [self.webView stopLoading];
//        NSLog(@"%s,%d",__FUNCTION__,__LINE__);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!_myView) {
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
            
        }
        _myView.alpha = 1;
        
    }
    
}

- (void)handleAgain {
   self.myView.alpha = 0;
    
    self.webView.delegate = self;
    [_webView loadHTMLString:self.tfText baseURL:nil];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
     canload = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}




@end
