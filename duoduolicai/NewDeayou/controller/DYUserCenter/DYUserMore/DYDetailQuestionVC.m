//
//  DYDetailQuestionVC.m
//  NewDeayou
//
//  Created by diyou on 14-8-6.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYDetailQuestionVC.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
@interface DYDetailQuestionVC ()<UIWebViewDelegate>
{
    WYWebProgressLayer *_progressLayer;

}
@property(strong,nonatomic)UIWebView *webView;

@end

@implementation DYDetailQuestionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"帮助";
    // Do any additional setup after loading the view.
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    self.view.backgroundColor=[UIColor whiteColor];
//    NSLog(@"%@",self.dicInfo);
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64)];
    _webView.delegate = self;
    _webView.backgroundColor=[UIColor whiteColor];
    _progressLayer = [WYWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];

    [self.view addSubview:_webView];
    [self getdata];
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    CGRect bounds = self.view.bounds;
    bounds.size.height=kScreenSize.height-64;
    _webView.frame = bounds;

    
    
}
-(void)getdata
{
    //————————————————————————个人中心->更多->常见问题接口->获取文章内容——————————————————————————
//    [MBProgressHUD hudWithView:self.view label:@"数据请求中"];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"articles" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_one" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
     [diyouDic insertObject:self.idStr forKey:@"id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

         if (success==YES) {
             //可用信用额度数据填充
             NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
             NSMutableString *path=[NSMutableString stringWithFormat:@"%@",[object objectForKey:@"contents"]];
//             NSLog(@"ddddd%@",baseURL);
             [_webView loadHTMLString:path baseURL:baseURL];
         }
         else
         {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"网络异常"];
     }];

    
    
    
    
    
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_progressLayer startLoad];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_progressLayer finishedLoad];

}
- (void)dealloc {
    
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
//    NSLog(@"i am dealloc");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
