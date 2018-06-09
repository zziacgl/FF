//
//  FFMemberViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/1/30.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "FFMemberViewController.h"
#import "DDRechargeViewController.h"
#import "FFshareView.h"
#import "DYAppDelegate.h"
#import "DDHomeMessageViewController.h"
#import "UIColor+FFCustomColor.h"
#import "PullingRefreshTableView.h"

@interface FFMemberViewController ()<UIWebViewDelegate>{
    UIView *shareBackView;

    
}
@property (nonatomic, strong) UIWebView *myWebView;
@property (nonatomic, strong) NSString *urltr;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareText;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *shareURL;
@property (nonatomic, strong) NSString *myShareImage;
@property (nonatomic, strong) FFshareView *shareView;
@property (nonatomic, strong)  UIView *topView ;
//@property (nonatomic, strong) PullingRefreshTableView *tableView;
@end
static bool canload;
static NSString *JSurl;

@implementation FFMemberViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(![DYUser loginIsLogin]){
        [DYUser  loginShowLoginView];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    CGRect frame = CGRectMake(0, 0, kMainScreenWidth,[UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height);
    UIImage *image = [DYUtils gradientImageWithBounds:frame andColors:@[kShallowColor,kDeepColor] andGradientType:1];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.barTintColor  = kBtnColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:17]}];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.barTintColor  = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:17]}];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员";
    //导航右边的按钮
    UIButton * btnRightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor = [UIColor clearColor];
    btnRightItem.frame = CGRectMake(0, 0, 80, 22);
    [btnRightItem setTitle:@"会员说明" forState:UIControlStateNormal];
    btnRightItem.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRightItem addTarget:self action:@selector(Vipinstructions) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0,0 , kMainScreenWidth, 300)];
    self.topView.backgroundColor = kBackColor;
    [self.view addSubview:self.topView];
    
    self.view.backgroundColor = kBackColor;
    float tabbarheight = self.tabBarController.tabBar.frame.size.height;
    
    
    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - tabbarheight - ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height))];
    self.myWebView.delegate = self;
    self.myWebView.opaque = NO;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [self handleAgain];
        
    }];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.textColor =  [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    self.myWebView.scrollView.mj_header = header;
    self.myWebView.backgroundColor = [UIColor clearColor];
//    self.myWebView.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.myWebView];
//    [self.myWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
 
    NSString *loginKey = [DYUser GetLoginKey];

    self.urltr = [NSString stringWithFormat:@"%@/action/site/view?v=activity/vip/index&login_key=%@",ffwebURL, loginKey];
    self.urltr = [self.urltr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:self.urltr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"mUserDefaultsCookie"]forHTTPHeaderField:@"Cookie"];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    //    NSLog(@"我的----%@", cookies);
    NSMutableDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies].mutableCopy;
    //    NSLog(@"%@", headers);
    [request setHTTPShouldHandleCookies:YES];
    [request setAllHTTPHeaderFields:headers];
    
    [self.myWebView loadRequest:request];
    
    
    
   
};

- (void)Vipinstructions {
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/vip/rule", ffwebURL];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"会员说明";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:adVC animated:YES];
    
}

//#pragma mark --- KVO
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        CGSize contentSize = [self.myWebView sizeThatFits:CGSizeZero];
//        self.myWebView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
//        [self.tableView reloadData];
//    }
//}




#pragma mark - 添加关闭按钮

- (void)addLeftButton
{
    self.navigationItem.leftBarButtonItem = self.backItem;
}

//点击返回的方法
- (void)backNative
{
    //判断是否有上一层H5页面
    if ([self.myWebView canGoBack]) {
        
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        
        //如果有则返回
        [self.myWebView goBack];
        
        
        
        
    } else {
        [self closeNative];
    }
}

//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.myWebView stopLoading];
}
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"whiteback"] forState:UIControlStateNormal];
        //左对齐
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, - 5, 0, 0);
        btn.frame = CGRectMake(0, 0, 40, 40);
        _backItem.customView = btn;
    }
    return _backItem;
}




#pragma mark- webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self performSelector:@selector(again) withObject:nil afterDelay:10.0];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.topView.layer addSublayer:[UIColor setGradualChangingColor:self.topView fromColor:@"fb9903" toColor:@"f76405"]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                   
                   dispatch_get_main_queue(), ^{
                       self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
                   });
    //判断是否有上一层H5页面
    if ([self.myWebView canGoBack]) {
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItem = self.backItem;
        
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    NSString *str = webView.request.URL.absoluteString;
    NSLog(@"结束%@",  webView.request.URL.absoluteString);
    if (str) {
        JSurl = str;
    }else {
        JSurl = nil;
    }
    canload = YES;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if([error code] == NSURLErrorCancelled)  {
        return;
    }
//    NSLog(@"error%@", error);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *str = request.URL.absoluteString;
    NSLog(@"str%@g", str);
    if ([str containsString:@"ios://jumpInvest"] || [str containsString:@"invest://gotoInvest"]) {
         [MobClick event:@"Member_shengji"];
        [self gotoInvest];
    }
    if ([str containsString:@"recharge://"]) {
        [self gotoRecharge];
    }
    if ([str containsString:@"action/site/view?v=activity/vip/invite_log"]) {
        [MobClick event:@"Member_yaoqingrenshu"];
    }
    if ([str containsString:@"action/site/view?v=activity/vip/draw_log"]) {
        [MobClick event:@"Member_lingqurenshu"];
    }
    if ([str containsString:@"ios://showShareView"]) {
        [self showShareView];
    }
    if ([str containsString:@"login://"]) {
        [self gotoLogin];
//         [DYUser  loginShowLoginView];
    }
    if ([str hasPrefix:@"ios://share"]) {
        [MobClick event:@"Member_yaoqinghaoyou"];
        //        NSArray *arry=[str componentsSeparatedByString:@"&"];
        
        NSLog(@"%@", [DYUtils stringConvertWithStr:str]);
        self.shareURL = [self URLDecodedString:[NSString stringWithFormat:@"%@",[[DYUtils stringConvertWithStr:str] objectForKey:@"url"] ]];

        NSString *strTitle = [[DYUtils stringConvertWithStr:str] objectForKey:@"title"];
        NSString *strText = [[DYUtils stringConvertWithStr:str] objectForKey:@"content"] ;
        self.myShareImage = [NSString stringWithFormat:@"%@",[[DYUtils stringConvertWithStr:str] objectForKey:@"icon"] ];
        self.shareText =  [self decodeFromPercentEscapeString:strText];
        self.shareTitle = [self decodeFromPercentEscapeString:strTitle];
        
        NSLog(@"测试3%@", self.shareURL);
        
        if (self.shareText.length > 0 && self.shareURL.length > 0&&self.shareTitle.length > 0&&self.myShareImage.length > 0) {
            [self handleCanShare];
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
- (void)gotoInvest {
    
    [self.tabBarController setSelectedIndex:1];//0:首页，1：理财，2：我的，3：更多
    if([self.view.superview isKindOfClass:[UIView class]]){
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }
}
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

//充值
- (void)gotoRecharge {
    [self getUserData];
    
}
- (void)getUserData {
    
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_users" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         
         if (success) {
             NSString *bankStatus = [NSString stringWithFormat:@"%@", [object objectForKey:@"bank_status"]];
             if ([bankStatus isEqualToString:@"0"]) {
                 ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
                 adVC.hidesBottomBarWhenPushed = YES;
                 NSString *loginKey = [DYUser GetLoginKey];
                 NSString *url = [NSString stringWithFormat:@"%@/action/recharge/mobilePay?money=100&login_key=%@",ffwebURL, loginKey];
                 adVC.myUrls = @{@"url":url};
                 adVC.titleM =@"充值";
                 [self.navigationController pushViewController:adVC animated:YES];
             }else {
                 DDRechargeViewController *rechargeVC=[[DDRechargeViewController alloc]initWithNibName:@"DDRechargeViewController" bundle:nil];
                 rechargeVC.hidesBottomBarWhenPushed=YES;
                 rechargeVC.isBindBank=bankStatus;
                 rechargeVC.Bankno = [NSString stringWithFormat:@"%@", [object objectForKey:@"bank"]];;
                 
                 rechargeVC.mybankNumber = [NSString stringWithFormat:@"%@", [object objectForKey:@"account_all"]];
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





- (void)again {
    
    
    if (canload) {
        return;
    }else {
        [self.myWebView stopLoading];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!_myView) {
            float tabbarheight = self.tabBarController.tabBar.frame.size.height;
            self.myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - tabbarheight -  ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height))];
            _myView.backgroundColor = kBackColor;
            
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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ffwebURL, self.urltr]];
    if (JSurl) {
        url = [NSURL URLWithString:JSurl];
    }
    
    self.myWebView.delegate=self;
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:0]];
    if (self.myWebView.scrollView.mj_header.isRefreshing)
    {
        [self.myWebView.scrollView.mj_header endRefreshing];
    }
    
}


- (void)showShareView {
    shareBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    shareBackView.backgroundColor = [UIColor blackColor];
    shareBackView.alpha = 0.3;
    [self.tabBarController.view addSubview:shareBackView];
    
    
    NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"FFshareView" owner:nil options:nil];
    self.shareView = [apparray firstObject];
    
    self.shareView.frame = CGRectMake(40, kMainScreenHeight / 2 - 200, kMainScreenWidth - 80, 400);
    //    self.shareView.backgroundColor = [UIColor whiteColor];
    
    [self.tabBarController.view addSubview:self.shareView];
    [self shakeToShow: self.shareView];
    
    
    [self.shareView.closeBtn addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView.weixinBtn addTarget:self action:@selector(handleWeixin) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView.friendBtn addTarget:self action:@selector(handleFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView.myQQBtn addTarget:self action:@selector(handleMyQQ) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView.kongjianBtn addTarget:self action:@selector(handleKongjian) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
- (void)handleClose {
    
    [self.shareView removeFromSuperview];
    [shareBackView removeFromSuperview];
    
}

- (void)handleWeixin {
    
    [self getShareData:0];
}
- (void)handleFriend {
    [self getShareData:1];
    
}
- (void)handleMyQQ {
    [self getShareData:2];
    
}
- (void)handleKongjian {
    [self getShareData:3];
    
}
- (void)getShareData:(int)sender {
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"share" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_share_info" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"recommend" forKey:@"name" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
             
             NSLog(@"sharedddd%@",object);
             self.shareURL = [object objectForKey:@"url"];
             self.shareText = [object objectForKey:@"content"];
             self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[object objectForKey:@"image"]]]];;
             self.shareTitle = [object objectForKey:@"title"];
             self.myShareImage = [NSString stringWithFormat:@"%@", [object objectForKey:@"image"]];
             [self handleClose];
             switch (sender) {
                     case 0:
                     [self share:UMSocialPlatformType_WechatSession];
                     break;
                     case 1:
                     [self share:UMSocialPlatformType_WechatTimeLine];
                     break;
                     case 2:
                     [self share:UMSocialPlatformType_QQ];
                     break;
                     case 3:
                     [self share:UMSocialPlatformType_Qzone];
                     break;
                 default:
                     break;
             }
             
             
             
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

- (void)share:(UMSocialPlatformType )shareType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //        UIImage *image = shareImage;
    NSString* thumbURL =  self.myShareImage;
    NSData *data=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:thumbURL]];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_shareTitle descr:_shareText thumImage:data];
    //设置网页地址
    shareObject.webpageUrl = _shareURL;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
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
    
    
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
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
//- (void)dealloc
//{
//    //移除
//    [self.myWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
//}

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
