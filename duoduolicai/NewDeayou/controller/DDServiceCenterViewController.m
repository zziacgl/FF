//
//  DDServiceCenterViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/12/14.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDServiceCenterViewController.h"
#import "DYFrequentlyAskedQuestionsVC.h"
#import "DYFeedbackViewController.h"
//客服的电话
#define CUSTOMER_SERVICE_PHONE [NSURL URLWithString:kefu_phone]
#define kPhoneNumber         kefu_phone_title
#define kAlertPhoneTag       101
#define kAlertPhone2Tag       103

//客服的QQ
#define CUSTOMER_SERVICE_QQ [NSURL URLWithString:@"mqq://4000002883"]
//#define kQQNumber         @"2640816532"
#define kAlertQQTag       102
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface DDServiceCenterViewController ()<UIAlertViewDelegate,UIWebViewDelegate>
{
    UIView *backWiew;
    UIView *tanView;
    UIImageView *QRImage;//二维码
    
}
@property (weak, nonatomic) IBOutlet UIButton *kefuBtn;
@property (nonatomic, copy) NSString *qqNumber;
@end

@implementation DDServiceCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"服务中心";
    self.qqNumber = @"4000002883";
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    
    [self.kefuBtn addTarget:self action:@selector(PlayPhone:) forControlEvents:UIControlEventTouchDown];
    
}
- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
   

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)PlayPhone:(id)sender {
    if ( [[UIApplication sharedApplication]canOpenURL:CUSTOMER_SERVICE_PHONE])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否拨打客服热线" message:kPhoneNumber delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        alertView.tag = kAlertPhoneTag;
        [alertView show];
    }
    else
    {
        [LeafNotification showInController:self withText:@"设备不支持打电话"];
    }

}

- (IBAction)PlayQQ:(id)sender {
    if ( [[UIApplication sharedApplication]canOpenURL:CUSTOMER_SERVICE_QQ])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否联系客服QQ" message:@"请添加4000002883好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = kAlertQQTag;
        [alertView show];
    }
    else
    {
        [LeafNotification showInController:self withText:@"设备没安装QQ"];
    }
    
}

#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        if (alertView.tag == kAlertPhoneTag) {
            [[UIApplication sharedApplication]openURL:CUSTOMER_SERVICE_PHONE];
        }else if(alertView.tag == kAlertQQTag){
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.qqNumber];
            NSURL *url = [NSURL URLWithString:qqstr];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            webView.delegate = self;
            [webView loadRequest:request];
            [self.view addSubview:webView];
        }
    }
    
    
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
