//
//  DYADDetailContentVC.m
//  NewDeayou
//
//  Created by wayne on 14/8/26.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYADDetailContentVC.h"
#import "DDPublicShare.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "DYInvestDetailVC.h"
#import "DDRechargeViewController.h"
//#import <CustomAlertView.h>
#import "FFMineModel.h"
#import "DYAppDelegate.h"
@interface DYADDetailContentVC ()<UIWebViewDelegate,UIAlertViewDelegate>
{
    
    UIView *shareBackground;
    WYWebProgressLayer *_progressLayer;

}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) NSDictionary *AllData;
@property (nonatomic, strong) DDPublicShare *shareView;
@property (nonatomic,copy)NSString *shareTitle;
@property (nonatomic,copy)NSString *shareText;
@property (nonatomic,strong)UIImage *shareImage;
@property (nonatomic,copy)NSString *shareURL;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy) NSString *myShareImage;
@property (nonatomic,strong)NSDictionary *NewBorrowDic;//新手标
@property (nonatomic, strong) FFMineModel *FFmodel;
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@end

@implementation DYADDetailContentVC

static bool canload;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.AllData = [NSDictionary new];
    canload = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftButton];
//     [MBProgressHUD hudWithView:self.view label:@"正在加载，请稍后..."];
//    NSLog(@"标题%@",self.model.name);
    self.title=self.model.name;
//    CGSize btnImageSize = CGSizeMake(22, 22);
//    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
//    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
//    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
//    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
//    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    NSLog(@"%@", self.shareDic);
    
    NSURLRequest * request=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.webUrl ] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:0];
    _webView.scalesPageToFit=YES;
    _webView.delegate=self;
    [_webView loadRequest:request];
    _progressLayer = [WYWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    //分享
    if (self.shareDic) {
//        NSLog(@"%@", self.shareDic);
        self.shareURL = [self.shareDic objectForKey:@"url"];
        self.shareText = [self.shareDic objectForKey:@"content"];
        self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.shareDic objectForKey:@"image"]]]];
        self.shareTitle = [self.shareDic objectForKey:@"title"];
        self.myShareImage = [NSString stringWithFormat:@"%@", [self.shareDic objectForKey:@"image"]];
         self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 38, 38);
        [_rightBtn setImage:[UIImage imageNamed:@"sharebtn"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(handleCanShare) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
        
    }
    
   
    
}
#pragma mark - 添加关闭按钮

- (void)addLeftButton
{
    self.navigationItem.leftBarButtonItem = self.backItem;
}
//点击返回的方法
- (void)backNative
{
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        
        //如果有则返回
        [self.webView goBack];
        
        
        
        
    } else {
        [self closeNative];
    }
}

//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.webView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 返回

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
        //左对齐
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, - 5, 0, 0);
        btn.frame = CGRectMake(0, 0, 40, 40);
        _backItem.customView = btn;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];

        [_closeItem setImage:[UIImage imageNamed:@"gaunbi"]];
        [_closeItem setImageInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
        
        
    }
    return _closeItem;
}
//- (void)back {
//    //判断是否有上一层H5页面
//    if ([self.webView canGoBack]) {
//        //如果有则返回
//        [self.webView goBack];
//
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//
//    }
//
//}
#pragma mark -- 分享
- (void)handleCanShare{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        //        UIImage *image = shareImage;
        NSString* thumbURL =  self.myShareImage;
//        NSData *data=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:thumbURL]];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareText thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = [self.shareURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
                
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            
        }];
        
        
    }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark- webViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSLog(@"request = %@", request);
    NSString *systemVersion   =  [[UIDevice currentDevice] systemVersion];//系统版本
    float n = [systemVersion floatValue];
    if (n > 8) {
    
        NSString *str = request.URL.absoluteString;
        NSLog(@"吧%@", str);
        if ([str containsString:@"activity://"]) {
           
            
        }
        
        if ([str containsString:@"newtouzi://"]) {
            
            [self gotoNewTouzi];
        }
        
        if ([str containsString:@"invest://"]) {
            [self gotoInvest];
        }
        if ([str containsString:@"share://"]) {
            
            [self handleCanShare];
        }
        
        if ([str containsString:@"login://"]) {

            [self gotoLogin];
        }
        if ([str containsString:@"recharge://"]) {
            
            [self gotoRecharge];
        }
        if ([str hasPrefix:@"ios://share"]) {
            //        NSArray *arry=[str componentsSeparatedByString:@"&"];
            
            NSLog(@"%@", [DYUtils stringConvertWithStr:str]);
            self.shareURL = [self URLDecodedString:[NSString stringWithFormat:@"%@",[[DYUtils stringConvertWithStr:str] objectForKey:@"url"] ]];

            NSString *strTitle = [[DYUtils stringConvertWithStr:str] objectForKey:@"title"];
            NSString *strText = [[DYUtils stringConvertWithStr:str] objectForKey:@"content"] ;
            self.myShareImage = [NSString stringWithFormat:@"%@",[[DYUtils stringConvertWithStr:str] objectForKey:@"icon"] ];
            self.shareText =  [self decodeFromPercentEscapeString:strText];
            self.shareTitle = [self decodeFromPercentEscapeString:strTitle];
            
            NSLog(@"测试1%@", self.shareURL);
            
            if (self.shareText.length > 0 && self.shareURL.length > 0&&self.shareTitle.length > 0&&self.myShareImage.length > 0) {
                [self handleCanShare];
            }
            
        }
        
    
    }
        return YES;
}
#pragma mark -- URL解码
-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}
- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
   
    [_progressLayer startLoad];

//    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    self.navigationController.navigationBarHidden=NO;
    
    [self performSelector:@selector(again) withObject:nil afterDelay:10.0];
    
}
//充值
- (void)gotoRecharge {
    if(![DYUser loginIsLogin]){
         [DYUser  loginShowLoginView];
        return;
    }
    [self getUserData];
    
}
- (void)getUserData {
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"app_center" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         
         if (success) {
             NSLog(@"MBProgressHUD%@", object);
             self.FFmodel = [FFMineModel mj_objectWithKeyValues:object];

             if ([self.FFmodel.bank_status isEqualToString:@"0"]) {
                 ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
                 adVC.hidesBottomBarWhenPushed = YES;
                 NSString *loginKey = [DYUser GetLoginKey];
                 NSString *url = [NSString stringWithFormat:@"https://www.fengfengjinrong.com/action/recharge/mobilePay?money=100&login_key=%@", loginKey];
                 adVC.myUrls = @{@"url":url};
                 adVC.titleM =@"充值";
                 [self.navigationController pushViewController:adVC animated:YES];
             }else {
                 DDRechargeViewController *rechargeVC=[[DDRechargeViewController alloc]initWithNibName:@"DDRechargeViewController" bundle:nil];
                 rechargeVC.hidesBottomBarWhenPushed=YES;
                 rechargeVC.isBindBank=self.FFmodel.bank_status;
                 rechargeVC.Bankno=self.FFmodel.bank;
                 
                 rechargeVC.mybankNumber = self.FFmodel.account_all;
                 [self.navigationController pushViewController:rechargeVC animated:YES];
                 
             }
             
             
             
         }else {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
    
}
#pragma mark - UIAlertViewDelegate
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==88) {
        //提现
        if(buttonIndex == 1){
            //去绑卡
            
            NSString *url=[NSString stringWithFormat:@"%@?service_name=personal_bind_bankcard_expand&login_key=%@",pcURL_XW,[DYUser GetLoginKey]];
//            NSLog(@"%@",url);
            ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
            adVC.hidesBottomBarWhenPushed = YES;
            adVC.myUrls = @{@"url":url};
            adVC.titleM =@"开通存管账户";
            [self.navigationController pushViewController:adVC animated:YES];
            
            
        }
    }
    
    
}


-(void)gotoNewTouzi

{
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"get_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"standard" forKey:@"borrow_type" atIndex:0];
    [diyouDic insertObject:@"invest" forKey:@"showstatus" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"limit" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         if (isSuccess)
         {
             NSArray *list=[object objectForKey:@"list"];
             self.NewBorrowDic=[list objectAtIndex:0];
             [self GetNewBorrow];
             
         }
         else
         {
             [LeafNotification showInController:self withText:errorMessage];
         }
         
     } errorBlock:^(id error)
     
     {
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
}
- (void)GetNewBorrow {
    //新手标详情页
    DYInvestDetailVC * detailVC=[[DYInvestDetailVC alloc]initWithNibName:@"DYInvestDetailVC" bundle:nil];
    detailVC.hidesBottomBarWhenPushed=YES;
    if (self.NewBorrowDic.count>0) {
        detailVC.borrowId=[self.NewBorrowDic DYObjectForKey:@"borrow_nid"];
    }
    
    
    NSString * bidType=@"";
    if (self.NewBorrowDic.count>0) {
        bidType=[self.NewBorrowDic DYObjectForKey:@"borrow_type"];
    }
    
    detailVC.isFlow=[bidType isEqualToString:@"roam"]?YES:NO;
    NSDictionary *dic=[NSDictionary new];
    if (self.NewBorrowDic.count>0) {
        dic=self.NewBorrowDic;
    }
    detailVC.borrow_status_nid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"borrow_status_nid"]];
    NSString *url=[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];//新标预告
    int borrowId=[url intValue];
    
    if (borrowId>0) {
        detailVC.borrowId=[NSString stringWithFormat:@"%@",url];
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)gotoInvest {
    [self.tabBarController setSelectedIndex:1];//0:首页，1：理财，2：我的，3：更多
}


- (void)again {
    if (canload) {
//         NSLog(@"%s,%d",__FUNCTION__,__LINE__);
        return;
    }else {
        [self.webView stopLoading];
//         NSLog(@"%s,%d",__FUNCTION__,__LINE__);
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
//    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    self.myView.alpha = 0;
    NSURLRequest * request=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.webUrl ] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:0];
    _webView.scalesPageToFit=YES;
    _webView.delegate=self;
    [_webView loadRequest:request];
}
//登录
-(void)gotoLogin{
    
    DYAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
    
    DYLoginVC * loginVC=[[DYLoginVC alloc]initWithNibName:@"DYLoginVC" bundle:nil];
    UINavigationController * loginNVC=[[UINavigationController alloc]initWithRootViewController:loginVC];
    
    if ([UIApplication sharedApplication].delegate.window.rootViewController)
    {
        [[UIApplication sharedApplication].delegate.window addSubview:loginNVC.view];
        [appDelegate.window sendSubviewToBack:loginNVC.view];
        
        UIView * fromView=appDelegate.window.rootViewController.presentedViewController?appDelegate.window.rootViewController.presentedViewController.view:appDelegate.window.rootViewController.view;
        [UIView transitionFromView:fromView toView:loginNVC.view duration:1 options:UIViewAnimationOptionTransitionCurlDown completion:^(BOOL finished)
         {
             appDelegate.window.rootViewController=loginNVC;
             appDelegate.mainTabBarVC=nil;
         }];
    }
    else
    {
        appDelegate.window.rootViewController=loginNVC;
        appDelegate.mainTabBarVC=nil;
    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    canload = YES;
    [_progressLayer finishedLoad];

//    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
   [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
//登录




@end
