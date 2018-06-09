//
//  DYRegistPolicyVC.m
//  NewDeayou
//
//  Created by wayne on 14/8/27.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYRegistPolicyVC.h"

@interface DYRegistPolicyVC ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DYRegistPolicyVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    [_webView loadHTMLString:_contents baseURL:nil];
}
- (void)back{
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
