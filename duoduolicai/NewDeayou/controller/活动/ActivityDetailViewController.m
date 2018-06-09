//
//  ActivityDetailViewController.m
//  NewDeayou
//
//  Created by apple on 15/11/19.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "DDPublicShare.h"
#import "DYInvestDetailVC.h"
#import "DDRechargeViewController.h"
#import "DYInvestDetailVC.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "DYAppDelegate.h"
#import "MBProgressHUD.h"
#import "DDServiceCenterViewController.h"
//#import <CustomAlertView.h>
@interface ActivityDetailViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
{
    
    UIView *shareBackground;
    WYWebProgressLayer *_progressLayer;
//    NSString *shareTitle;
    NSString *shareDec;
    NSString *shareImageUrl;
    NSString *shareWebpageUrl;
}

@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) NSDictionary *AllData;
@property (nonatomic, strong) DDPublicShare *shareView;
@property (nonatomic,copy)NSString *shareTitle;
@property (nonatomic,copy)NSString *shareText;
@property (nonatomic,strong)UIImage *shareImage;
@property (nonatomic,copy)NSString *shareURL;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic,strong)NSDictionary *NewBorrowDic;//新手标
@property (nonatomic) BOOL isBindBank;//是否绑定银行卡
@property (nonatomic, copy) NSString *myShareImage;
@property (nonatomic, copy) NSString *InvestID;
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@end

@implementation ActivityDetailViewController
static bool canload;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];

//    CGSize btnImageSize = CGSizeMake(22, 22);
//    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
//    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
//    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.title = @"活动详情";
    
    if (self.titleM.length>0) {
        self.title=self.titleM;
    }
    
    self.AllData = [NSDictionary new];
    self.navigationController.navigationBarHidden = NO;
    NSURL *url = [[NSURL alloc]initWithString:[self.myUrls objectForKey:@"url"]];
   
    self.activityWebView.delegate=self;
    [self.activityWebView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:0]];
    self.shareDic = [self.myUrls objectForKey:@"share"];
     NSLog(@"aaaaa%@",self.shareDic);
    _progressLayer = [WYWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];

    if (self.shareDic) {
        self.shareURL = [self.shareDic objectForKey:@"url"];
        self.shareText = [self.shareDic objectForKey:@"content"];
        
        self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.shareDic objectForKey:@"image"]]]];
        
        self.myShareImage = [NSString stringWithFormat:@"%@", [self.shareDic objectForKey:@"image"]];
        self.shareTitle = [self.shareDic objectForKey:@"title"];

        
        if(self.isdan!=1){
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightBtn.frame = CGRectMake(0, 0, 38, 38);
            [_rightBtn setImage:[UIImage imageNamed:@"sharebtn"] forState:UIControlStateNormal];
            [_rightBtn addTarget:self action:@selector(handleCanShare) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
        }
       
        
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
    if ([self.activityWebView canGoBack]) {
        
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        
        //如果有则返回
        [self.activityWebView goBack];
        
        
        
        
    } else {
        [self closeNative];
    }
}

//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.activityWebView stopLoading];
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

//- (void)back{
//    //判断是否有上一层H5页面
//    if ([self.activityWebView canGoBack]) {
//        //如果有则返回
//        [self.activityWebView goBack];
//        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//
//    }
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


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    canload = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSLog(@"开始%@",str);
//        if ([str containsString:@"newtouzi://"]) {
//
//            [self gotoNewTouzi];
//        }
        if ([str containsString:@"ios://jumpProjectDetails"]) {//标的详情
            self.InvestID = str;
            [self gotoNewInvest];
        }
        if ([str containsString:@"ios://jumpInvest"] || [str containsString:@"invest://gotoInvest"]) {
            [self gotoInvest];
        }
        
        if ([str hasPrefix:@"ios://share"]) {
            //        NSArray *arry=[str componentsSeparatedByString:@"&"];
            
            NSLog(@"你好%@", [DYUtils stringConvertWithStr:str]);
           self.shareURL = [self URLDecodedString:[NSString stringWithFormat:@"%@",[[DYUtils stringConvertWithStr:str] objectForKey:@"url"] ]];
            
            NSString *strTitle = [[DYUtils stringConvertWithStr:str] objectForKey:@"title"];
            NSString *strText = [[DYUtils stringConvertWithStr:str] objectForKey:@"content"] ;
            self.myShareImage = [NSString stringWithFormat:@"%@",[[DYUtils stringConvertWithStr:str] objectForKey:@"icon"] ];
            self.shareText =  [self decodeFromPercentEscapeString:strText];
            self.shareTitle = [self decodeFromPercentEscapeString:strTitle];
            NSLog(@"测试2%@", self.shareURL);
            
            if (self.shareText.length > 0 && self.shareURL.length > 0&&self.shareTitle.length > 0&&self.myShareImage.length > 0) {
                [self handleCanShare];
            }
            
        }
        
        if ([str containsString:@"recharge://"]) {
            [self gotoRecharge];
        }
        
        if ([str containsString:@"login://"]) {
            
            [self gotoLogin];
        }
        if ([str containsString:@"service://"]) {
            
            [self gotoService];
        }
        if ([str containsString:@"action/site/view?v=activity/packet/join"]) {
            
             [MobClick event:@"account_My_canyu"];
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

-(void)gotohome{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    int isFromMain=[[ud objectForKey:@"isFromMain"] intValue];
    if (isFromMain==1) {
        [ud setObject:@"0" forKey:@"isFromMain"];
        [self.navigationController popViewControllerAnimated:YES];

    }else
    {
        [self.tabBarController setSelectedIndex:0];//0:首页，1：理财，2：我的，3：更多

    }
    
}
#pragma mark -- 服务中心
- (void)gotoService{
    
    DDServiceCenterViewController *serviceCenterVC = [[DDServiceCenterViewController alloc]init];
    serviceCenterVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:serviceCenterVC animated:YES];
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




- (void)gotoInvest {
   
    [self.tabBarController setSelectedIndex:1];//0:首页，1：理财，2：我的，3：更多
    if([self.view.superview isKindOfClass:[UIView class]]){
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }
}
- (void)again {
    if (canload) {
//        NSLog(@"%s,%d",__FUNCTION__,__LINE__);
        return;
    }else {
        [self.activityWebView stopLoading];
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
    
    NSURL *url = [[NSURL alloc]initWithString:[self.myUrls objectForKey:@"url"]];
    self.activityWebView.delegate=self;
    [self.activityWebView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:0]];
    
}
#pragma mark -- 新手标
- (void)gotoNewInvest {
    
    NSArray *array = [self.InvestID componentsSeparatedByString:@"?"];
  
    NSString *str = array[1];
    NSArray *array1 = [str componentsSeparatedByString:@"&"];
    NSLog(@"新手标%@", array1);
    NSString *borrowType = [array1[0] componentsSeparatedByString:@"="][1];
    NSString *projetid = [array1[1] componentsSeparatedByString:@"="][1];
    DYInvestDetailVC * detailVC=[[DYInvestDetailVC alloc]initWithNibName:@"DYInvestDetailVC" bundle:nil];
    detailVC.hidesBottomBarWhenPushed=YES;
    detailVC.borrowId = projetid;
    detailVC.borrowType = borrowType;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

//登录
-(void)gotoLogin{
    
    DYAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
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
    [_progressLayer finishedLoad];

    canload = YES;
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
