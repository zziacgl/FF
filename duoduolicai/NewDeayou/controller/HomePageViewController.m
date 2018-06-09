//
//  HomePageViewController.m
//  NewDeayou
//
//  Created by apple on 15/11/20.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "HomePageViewController.h"
#import "CUSFlashLabel.h"
#import "DYNetWork.h"
#import "DYInvestDetailVC.h"
#import "DYLoginVC.h"
#import "DYADDetailContentVC.h"
#import "ZFProgressView.h"
#import "ActicityViewController.h"
#import "DYSafeViewController.h"
#import "ActivityDetailViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kScreen_Width   [UIScreen mainScreen].bounds.size.width
#define kScreen_Height  [UIScreen mainScreen].bounds.size.height

#define kADTimeInterval 3.0f  // 翻页间隔秒数

#define kFontNumsBig  [UIFont systemFontOfSize:16.0f] // 大字体
#define kFontNumsSmall  [UIFont systemFontOfSize:11.0f] // 小字体

typedef void(^FinishedAnimationBlock)(void); // 定义新的数据类型无返回值无参

@interface HomePageViewController ()
{
    UIButton * btnRefresh;//刷新按钮
    CGPoint pointMoreBoxCenter; // 记录更多按钮的frame(自定义box)
    NSMutableArray * aryOperation;// 请求的集合
    NSThread * threadADTimer;
    MKNetworkOperation* operation;
    BOOL isTest;
    BOOL isOpen;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewAD;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlAD;
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIImageView *safeImage;//安全保障

@property (weak, nonatomic) IBOutlet UIButton *messageBtn;//公司资讯
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;//活动图片
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic,retain) NSMutableArray *aryBoxs; // boxs
@property (nonatomic,retain) NSMutableArray * aryADImages; //轮播图片数组
@property (nonatomic,retain) NSMutableArray * aryUrls;//轮播图片urls
@property (weak, nonatomic) IBOutlet UIView *downView;

@property (nonatomic,assign) float newBidTotal; //新标金额
@property (nonatomic,assign) float newBidRate; //新标利率
@property (nonatomic,assign) float newBidDeadline; //新标期限
@property (nonatomic,assign) float bidProgress;
@property (strong, nonatomic) NSMutableDictionary * bidDic;                 //标的内容
@property (nonatomic)BOOL isInView;
@property (nonatomic,assign) InvestBidType bidType;

@property (nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic,retain)NSMutableArray *aryActvityImages;//活动中心
@property (nonatomic,retain)NSMutableArray *aryActivityUrls;//活动中心

@end

@implementation HomePageViewController
{
    CGPoint beginpoint;
    UIView *background;
    UIView *tanView;
    UIView *birthdayView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"多多理财";
        self.tabBarItem.title = @"首页";
               
        //        self.WalletView.frame = CGRectMake(0, CGRectGetMaxY(self.moneyLabel.frame), kScreen_Width, kScreen_Height-CGRectGetMaxY(self.moneyLabel.frame));
        //        self.WalletView.backgroundColor = [UIColor grayColor];
        
        if (IOS7)
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewDidAfterLoad];
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    int isResetPassword=[[ud objectForKey:@"isResetPassword"]intValue];
    if (isResetPassword==0) {
        [ud setObject:@"1" forKey:@"isResetPassword"];
    }

    
    isTest = NO;
    isOpen = YES;
    self.moneyLabel.textColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
    aryOperation = [NSMutableArray array];
    btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRefresh.frame = CGRectMake(0, 0, 19, 22);
    [btnRefresh setBackgroundImage:[UIImage imageNamed:@"refresh_highlight"] forState:UIControlStateNormal];
    [btnRefresh setBackgroundImage:[UIImage imageNamed:@"refresh_highlight"] forState:UIControlStateHighlighted];
    [btnRefresh addTarget:self action:@selector(refreshInformation) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRefresh];
    //请求数据 滑动图片
    [self performSelector:@selector(refreshInformation) withObject:nil afterDelay:1.0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.activityImage.userInteractionEnabled = YES;
    [self.activityImage addGestureRecognizer:tap];
    UITapGestureRecognizer *tapSafe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSafe:)];
    self.safeImage.userInteractionEnabled = YES;
    [self.safeImage addGestureRecognizer:tapSafe];

//    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moneyLabel.frame) + 50, kScreen_Width, kScreen_Height - CGRectGetMaxY(self.moneyLabel.frame) - 64)];
//    aView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:aView];
//    self.moneyLabel.frame = CGRectMake(self.moneyLabel.frame.origin.x, self.moneyLabel.frame.origin.y, self.moneyLabel.frame.size.width, 10);
//    NSLog(@"%f", self.moneyLabel.frame.size.height);
    UIButton *bnt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width- 60, 36)];
    bnt.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.downView.frame.size.height+ 45);
    [bnt setBackgroundColor:kCOLOR_R_G_B_A(253, 83, 83, 1)];
    [bnt setTitle:@"马上赚钱" forState:UIControlStateNormal];
    [bnt addTarget:self action:@selector(LingQianbao) forControlEvents:UIControlEventTouchDown];
    [bnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bnt.layer setMasksToBounds:YES];
    [bnt.layer setCornerRadius:5.0];
    
    [self.downView addSubview:bnt];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0 ,270,24)];
    //    label1.backgroundColor = [UIColor grayColor];
    label1.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, CGRectGetMinY(bnt.frame)-10);
    NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:@"年化收益8.0%，每周涨0.5%，最高10.88%"];
    [str4 addAttribute:NSForegroundColorAttributeName value:kCOLOR_R_G_B_A(253, 83, 83, 1) range:NSMakeRange(19,5)];
    label1.attributedText = str4;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font=[UIFont systemFontOfSize:13];
    [self.downView addSubview:label1];
    
    float annual=8.0;
    
//    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    float a=[[ud objectForKey:@"annual"] floatValue];
    if (a>annual) {
        annual=a;
    }
    if(annual>10.5){
        annual=11;
    }
//    float progress=annual;
//    float progresscent=0.58+(progress-8)/0.5*0.07;
//    ZFProgressView *progress2 = [[ZFProgressView alloc] initWithFrame:CGRectMake(kScreen_Width / 4, 30,kScreen_Width / 2.5 + 5 , kScreen_Width / 2.5 + 5) style:ZFProgressViewStyleRoundSegment number:1];
//    progress2.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, CGRectGetMinY(label1.frame)/2 +8 );
//    
//    progress2.progressLineWidth=8;
//    progress2.backgourndLineWidth=8;
//    progress2.progressLabel2.font = [UIFont systemFontOfSize:12];
//    progress2.aLabel.font = [UIFont systemFontOfSize:38];
//    //    progress2.backgroundColor = [UIColor orangeColor];
//    progress2.digitTintColor=kCOLOR_R_G_B_A(253, 83, 83, 1);
//    [self.downView addSubview:progress2];
//    [progress2 setProgressStrokeColor:kCOLOR_R_G_B_A(253, 83, 83, 1)];
//    [progress2 setProgress:progresscent Animated:YES];
    
//    NSUserDefaults *firstlogin = [NSUserDefaults standardUserDefaults];
//    
//    NSString *str = [NSString stringWithFormat:@"%@", [firstlogin objectForKey:@"firstLogin"]];
//    NSString *str1 = [NSString stringWithFormat:@"%@", [firstlogin objectForKey:@"firstName"]];
//    
//    if ([str isEqualToString:@"10"] && [str1 isEqualToString:[NSString stringWithFormat:@"%@",[DYUser DYUser].userName]]) {
//        
//        
//        background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+64)];
//        background.backgroundColor = [UIColor blackColor];
//        background.alpha = 1;
//        [self.tabBarController.view addSubview:background];
//        
//        
//        tanView = [[UIView alloc] initWithFrame:CGRectMake(30, 60, [UIScreen mainScreen].bounds.size.width - 60, [UIScreen mainScreen].bounds.size.height - 120)];
//        //        tanView.backgroundColor = [UIColor orangeColor];
//        [self.tabBarController.view addSubview:tanView];
//        
//        UIImageView *tanImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tanView.frame), CGRectGetHeight(tanView.frame))];
//        tanImage.image = [UIImage imageNamed:@"体验金弹窗"];
//        tanImage.userInteractionEnabled = YES;
//        [tanView addSubview:tanImage];
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClose)];
//        [tanImage addGestureRecognizer:tap];
//        
//        
//        
//        
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            tanView.alpha = 1.0;
//            background.alpha = 0.8;
//        } completion:^(BOOL finished) {
//            
//        }];
//        [firstlogin setObject:@"11" forKey:@"firstLogin"];
//    }
    
//    background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+64)];
//    background.backgroundColor = [UIColor blackColor];
//    background.alpha = 1;
//    [self.tabBarController.view addSubview:background];
//    
//    birthdayView = [[UIView alloc] initWithFrame:CGRectMake(30, 50, [UIScreen mainScreen].bounds.size.width - 60, [UIScreen mainScreen].bounds.size.height - 100)];
//    birthdayView.backgroundColor = [UIColor whiteColor];
//    [self.tabBarController.view addSubview:birthdayView];
//    
//    UIImageView *happyImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, CGRectGetWidth(birthdayView.frame) - 10, CGRectGetHeight(birthdayView.frame) - 20)];
//    happyImage.backgroundColor = [UIColor orangeColor];
//    happyImage.userInteractionEnabled = YES;
//    [birthdayView addSubview:happyImage];
//    
//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeBtn.frame = CGRectMake(CGRectGetMaxX(happyImage.frame) - 35, 5, 35, 35);
//    [closeBtn addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
//    closeBtn.backgroundColor = [UIColor greenColor];
//    [birthdayView addSubview:closeBtn];
//    
//    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    detailBtn.frame = CGRectMake(20, CGRectGetHeight(birthdayView.frame) - 80, CGRectGetWidth(birthdayView.frame) - 40, 40);
//    detailBtn.backgroundColor = [UIColor redColor];
//    [detailBtn.layer setMasksToBounds:YES];
//    [detailBtn.layer setCornerRadius:5.0];
//    [birthdayView addSubview:detailBtn];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        tanView.alpha = 1.0;
//        background.alpha = 0.7;
//    } completion:^(BOOL finished) {
//        
//    }];

    NSUserDefaults *tuisong = [NSUserDefaults standardUserDefaults];
    NSString *tui = [tuisong objectForKey:@"tuisong"];
    NSString *url = [tuisong objectForKey:@"url"];
    NSLog(@"%@", tui);
    if ([tui isEqualToString:@"huodong"]) {
        ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
        adVC.myUrls = url;
        [tuisong setObject:@"jieshu" forKey:@"tuisong"];
        [self.navigationController pushViewController:adVC animated:YES];
    }


}
- (void)handleClose {
    [UIView animateWithDuration:0.3 animations:^{
        [tanView removeFromSuperview];
        background.alpha = 0;
        
    }];
}

- (void)handleBack {
    [UIView animateWithDuration:0.3 animations:^{
        [birthdayView removeFromSuperview];
        background.alpha = 0;
        
    }];
}


-(void)LingQianbao{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"0" forKey:@"isDone"];
    [self.tabBarController setSelectedIndex:1];//0:首页，1：零钱包，2：投资，3：更多
    
}
//活动轻拍手势响应事件
- (void)handleTap:(UITapGestureRecognizer *)sender {
    
    ActicityViewController *activityVC = [[ActicityViewController alloc] initWithNibName:@"ActicityViewController" bundle:nil];
    activityVC.hidesBottomBarWhenPushed = YES;
    activityVC.imageArray = self.aryActvityImages;
    activityVC.urlArray = self.aryActivityUrls;
   
    [self.navigationController pushViewController:activityVC animated:YES];
}
- (IBAction)handleMessage:(UIButton *)sender {
    DYSafeViewController *safeVC = [[DYSafeViewController alloc] init];
    safeVC.hidesBottomBarWhenPushed = YES;
    safeVC.weburl=@"http://www.51duoduo.com/lqbbz/gszz.html";
    [self.navigationController pushViewController:safeVC animated:YES];
}
//安全保障轻拍手势
- (void)handleSafe:(UITapGestureRecognizer *)sender {
    DYSafeViewController *safeVC = [[DYSafeViewController alloc] init];
    safeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeVC animated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    [self queryNewBidInformation];
    [self queryADImages];
    [self queryActivity];
    [self GetLingQingBao];
    self.navigationController.navigationBarHidden=YES;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    int isLoadingMain=[[ud objectForKey:@"isLoadingMain"]intValue];
    if (isLoadingMain==1) {
        [ud setObject:@"0" forKey:@"isLoadingMain"];
        UIView *view=[self.view viewWithTag:40000];
        [view removeFromSuperview];
        
        int isResetPassword=[[ud objectForKey:@"isResetPassword"] intValue];
        //    [ud setObject:@"1" forKey:@"isResetPassword"];
        if (isResetPassword==0) {
            [ud setObject:@"1" forKey:@"isResetPassword"];
        }
        
        isTest = NO;
        isOpen = YES;
        
        aryOperation = [NSMutableArray array];
        
        //请求数据 滑动图片
        [self performSelector:@selector(refreshInformation) withObject:nil afterDelay:1.0];
        
        
        
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moneyLabel.frame) + 50, kScreen_Width, kScreen_Height - CGRectGetMaxY(self.moneyLabel.frame) - 64)];
        aView.backgroundColor = [UIColor whiteColor];
        aView.tag=40000;
        [self.view addSubview:aView];
        
        float annual=8.0;
        //    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        float a=[[ud objectForKey:@"annual"] floatValue];
        NSLog(@"%f",a);
        if (a>annual) {
            annual=a;
        }
        
        if(annual>10.5){
            annual=11;
        }
        //    NSLog(@"%f",annual);
        if ([UIScreen mainScreen].bounds.size.height == 736) {
            
            UIButton *bnt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width- 60, 44)];
            bnt.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, aView.frame.size.height-80);
            [bnt setBackgroundColor:kCOLOR_R_G_B_A(253, 83, 83, 1)];
            [bnt setTitle:@"马上赚钱" forState:UIControlStateNormal];
            [bnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bnt.layer setMasksToBounds:YES];
            [bnt.layer setCornerRadius:5.0];
            [bnt addTarget:self action:@selector(LingQianbao) forControlEvents:UIControlEventTouchDown];
            [aView addSubview:bnt];
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0 ,270,24)];
            //    label1.backgroundColor = [UIColor grayColor];
            label1.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, CGRectGetMinY(bnt.frame)-40);
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"年化收益8.0%，每周涨0.5%，最高10.88%"];
            [str addAttribute:NSForegroundColorAttributeName value:kCOLOR_R_G_B_A(253, 83, 83, 1) range:NSMakeRange(19,5)];
            label1.attributedText = str;
            label1.textAlignment = NSTextAlignmentCenter;
            label1.font=[UIFont systemFontOfSize:13];
            [aView addSubview:label1];
            
            float progress=annual;
            
            float progresscent=0.58+(progress-8)/0.5*0.07;
            
//            ZFProgressView *progress2 = [[ZFProgressView alloc] initWithFrame:CGRectMake(kScreen_Width / 4, 30,CGRectGetMinY(label1.frame) - 40 , CGRectGetMinY(label1.frame) - 40) style:ZFProgressViewStyleRoundSegment number:1];
//            progress2.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, CGRectGetMinY(label1.frame)/2+30);
//            
//            progress2.progressLineWidth=10;
//            progress2.backgourndLineWidth=10;
//            //    progress2.backgroundColor = [UIColor orangeColor];
//            progress2.digitTintColor=kCOLOR_R_G_B_A(253, 83, 83, 1);
//            [aView addSubview:progress2];
//            [progress2 setProgressStrokeColor:kCOLOR_R_G_B_A(253, 83, 83, 1)];
//            [progress2 setProgress:progresscent Animated:YES];
        } else if ([UIScreen mainScreen].bounds.size.height == 667) {
            
            UIButton *bnt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width- 60, 44)];
            bnt.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, aView.frame.size.height-80);
            [bnt setBackgroundColor:kCOLOR_R_G_B_A(253, 83, 83, 1)];
            [bnt setTitle:@"马上赚钱" forState:UIControlStateNormal];
            [bnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bnt.layer setMasksToBounds:YES];
            [bnt.layer setCornerRadius:5.0];
            [bnt addTarget:self action:@selector(LingQianbao) forControlEvents:UIControlEventTouchDown];
            [aView addSubview:bnt];
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0 ,270,24)];
            //    label1.backgroundColor = [UIColor grayColor];
            label1.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, CGRectGetMinY(bnt.frame)-40);
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"年化收益8.0%，每周涨0.5%，最高10.88%"];
            [str addAttribute:NSForegroundColorAttributeName value:kCOLOR_R_G_B_A(253, 83, 83, 1) range:NSMakeRange(19,5)];
            label1.attributedText = str;
            label1.textAlignment = NSTextAlignmentCenter;
            label1.font=[UIFont systemFontOfSize:13];
            [aView addSubview:label1];
            
            float progress=annual;
            NSLog(@"%f",progress);
            float progresscent=0.58+(progress-8)/0.5*0.07;
//            ZFProgressView *progress2 = [[ZFProgressView alloc] initWithFrame:CGRectMake(kScreen_Width / 4, 30,CGRectGetMinY(label1.frame) + 10 , CGRectGetMinY(label1.frame)+ 10) style:ZFProgressViewStyleRoundSegment number:1];
//            
//            progress2.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, CGRectGetMinY(label1.frame)/2+20);
//            
//            progress2.progressLineWidth=10;
//            progress2.backgourndLineWidth=10;
//            //    progress2.backgroundColor = [UIColor orangeColor];
//            progress2.digitTintColor=kCOLOR_R_G_B_A(253, 83, 83, 1);
//            [aView addSubview:progress2];
//            [progress2 setProgressStrokeColor:kCOLOR_R_G_B_A(253, 83, 83, 1)];
//            [progress2 setProgress:progresscent Animated:YES];
            
            
        } else if ([UIScreen mainScreen].bounds.size.height == 568) {
            
            UIButton *bnt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width- 60, 44)];
            bnt.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, aView.frame.size.height-60);
            [bnt setBackgroundColor:kCOLOR_R_G_B_A(253, 83, 83, 1)];
            [bnt setTitle:@"马上赚钱" forState:UIControlStateNormal];
            [bnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bnt.layer setMasksToBounds:YES];
            [bnt.layer setCornerRadius:5.0];
            [bnt addTarget:self action:@selector(LingQianbao) forControlEvents:UIControlEventTouchDown];
            [aView addSubview:bnt];
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0 ,270,24)];
            //    label1.backgroundColor = [UIColor grayColor];
            label1.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, CGRectGetMinY(bnt.frame)-15);
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"年化收益8.0%，每周涨0.5%，最高10.88%"];
            [str addAttribute:NSForegroundColorAttributeName value:kCOLOR_R_G_B_A(253, 83, 83, 1) range:NSMakeRange(19,5)];
            label1.attributedText = str;
            label1.textAlignment = NSTextAlignmentCenter;
            label1.font=[UIFont systemFontOfSize:13];
            [aView addSubview:label1];
            
            float progress=annual;
            float progresscent=0.58+(progress-8)/0.5*0.07;
            
            NSLog(@"%f",progresscent);
//            ZFProgressView *progress2 = [[ZFProgressView alloc] initWithFrame:CGRectMake(kScreen_Width / 4, 30,kScreen_Width / 2 , kScreen_Width / 2) style:ZFProgressViewStyleRoundSegment number:1];
//            progress2.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, CGRectGetMinY(label1.frame)/2 );
//            
//            progress2.progressLineWidth=10;
//            progress2.backgourndLineWidth=10;
//            //    progress2.backgroundColor = [UIColor orangeColor];
//            progress2.digitTintColor=kCOLOR_R_G_B_A(253, 83, 83, 1);
//            [aView addSubview:progress2];
//            [progress2 setProgressStrokeColor:kCOLOR_R_G_B_A(253, 83, 83, 1)];
//            [progress2 setProgress:progresscent Animated:YES];
            
        }
        
        
    }

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.opration)
    {
        [self.opration cancel];
        self.opration = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL)isAllOperationFinished
{
    BOOL isFinished=NO;
    for (MKNetworkOperation * operationother in aryOperation)
    {
        isFinished=operationother.isFinished ? YES:NO;
    }
    return isFinished;
}

#pragma mark- animations

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (![self isAllOperationFinished])
    {
        [btnRefresh.layer addAnimation:[self refreshAnimation] forKey:@"rotationAnimation"];
    }
}

- (CABasicAnimation* )refreshAnimation
{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.delegate=self;
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    return rotationAnimation;
}

-(void)refreshInformation
{
    if (btnRefresh.layer.animationKeys)
    {
        return;
    }
    [btnRefresh.layer addAnimation:[self refreshAnimation] forKey:@"rotationAnimation"];
    ;
    //    [self queryNewBidInformation];
    
    
    if (isTest)
    {
        //图片
        NSArray * ary=@[@"lunbo1",@"lunbo2",@"lunbo3",@"lunbo4"];
        _aryADImages=[NSMutableArray arrayWithArray:ary];
        //滑动图片点击URL
        NSArray * aryUrl=@[@"www.baidu.com",@"www.baidu.com",@"www.baidu.com",@"www.baidu.com"];
        _aryUrls=[NSMutableArray arrayWithArray:aryUrl];
        
        [self initADImageViews];
    }
    else
    {
        [self queryADImages];
    }
}

#pragma mark- netWork
-(void)queryADImages
{
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"mobile_get_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"scrollpic" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"all" forKey:@"limit" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"status" atIndex:0];
    [diyouDic insertObject:@"mobile_index" forKey:@"type_nid" atIndex:0];//mobile_top：活动中心 mobile_index:轮播图
    
    MKNetworkOperation* operationother= [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
                                         {
                                             if (isSuccess)
                                             {
                                                 NSArray * list=[object objectForKey:@"list"];
                                                 _aryADImages=[NSMutableArray array];
                                                 _aryUrls=[NSMutableArray array];
                                                 for (NSDictionary *dic in list)
                                                 {
                                                     [_aryADImages addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"full_pic_url"]]];
                                                     [_aryUrls addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]]];
                                                     
                                                     //                 NSLog(@"%@------%@",_aryADImages,_aryUrls);
                                                 }
                                                 [self initADImageViews];
                                             }
                                             else
                                             {
                                                 [MBProgressHUD errorHudWithView:self.view label:errorMessage hidesAfter:1];
                                             }
                                         } errorBlock:^(id error)
                                         {
                                             [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:1];
                                         }];
    
    [aryOperation addObject:operationother];
    
}
-(void)queryActivity
{
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"mobile_get_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"scrollpic" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"all" forKey:@"limit" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"status" atIndex:0];
    [diyouDic insertObject:@"mobile_top" forKey:@"type_nib" atIndex:0];
    [diyouDic insertObject:@"3" forKey:@"type_id" atIndex:0];
    
    MKNetworkOperation* operationother= [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
                                         {
                                             if (isSuccess)
                                             {
                                                 NSArray * list=[object objectForKey:@"list"];
                                                 _aryActvityImages=[NSMutableArray array];
                                                 _aryActivityUrls=[NSMutableArray array];
                                                 for (NSDictionary *dic in list)
                                                 {
                                                     [_aryActvityImages addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"full_pic_url"]]];
                                                     NSLog(@"%@", _aryActvityImages);
                                                     [_aryActivityUrls addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]]];
                                                     
                                                     //                 NSLog(@"%@------%@",_aryADImages,_aryUrls);
                                                 }
                                                 
                                             }
                                             else
                                             {
                                                 [MBProgressHUD errorHudWithView:self.view label:errorMessage hidesAfter:1];
                                             }
                                         } errorBlock:^(id error)
                                         {
                                             [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:1];
                                         }];
    
    [aryOperation addObject:operationother];
    
}

-(void)GetLingQingBao
{
    [MBProgressHUD hudWithView:self.view label:@"数据请求中"];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"lqb" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_lqb_info" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (success==YES) {
             //可用信用额度数据填充
             self.dataDic=object;
             NSLog(@"%@",[self.dataDic objectForKey:@"annual"]);
//             float annual=[[self.dataDic objectForKey:@"annual"] floatValue];
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
//             [ud setObject:[NSString stringWithFormat:@"%.2f",annual] forKey:@"annual"];
             [ud setObject:[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"gotexpgold"]] forKey:@"gotexpgold"];
         }
         else
         {
             [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
     }];
    
    
}


#pragma mark- ---scrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int offsetX=scrollView.contentOffset.x*2;
    
    int width=scrollView.frame.size.width*2;
    if (offsetX%width==0)
    {
        int numbers=offsetX/width;
        _pageControlAD.currentPage=numbers;
    }
    
}

#pragma mark- ---initADImageViews
//滑动图片 初始化
-(void)initADImageViews
{
    float imageViewHeight=_scrollViewAD.frame.size.height;
    float imageViewWidth=_scrollViewAD.frame.size.width;
    NSInteger imagesCount=_aryADImages.count;
    NSLog(@"%lu", (unsigned long)_aryADImages.count);
    
    for (UIView * view in _scrollViewAD.subviews)
    {
        if (view.tag==978)
        {
            [view removeFromSuperview];
        }
    }
    
    if (imagesCount<=0)
    {
        UIImageView * imageViewAD=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
        imageViewAD.image=[UIImage imageNamed:@"lunbo_default"];
        imageViewAD.userInteractionEnabled=YES;
        imageViewAD.tag=978;
        [_scrollViewAD addSubview:imageViewAD];
    }
    
    for (int i=0; i<imagesCount; i++)
    {
        
        UIImageView * imageViewAD=[[UIImageView alloc]initWithFrame:CGRectMake(i*imageViewWidth, 0, imageViewWidth, imageViewHeight)];
        imageViewAD.userInteractionEnabled=YES;
        imageViewAD.tag=978;
        [_scrollViewAD addSubview:imageViewAD];
        
        //设置图片
        // [imageViewAD setImageWithURL:[NSURL URLWithString:_aryADImages[i]] placeholderImage:[UIImage imageNamed:@"lunbo_default"]];
        
        if (isTest)
        {
            [imageViewAD setImage:[UIImage imageNamed:_aryADImages[i]]];
        }
        else
        {
            [imageViewAD setImageWithURL:[NSURL URLWithString:_aryADImages[i]] placeholderImage:[UIImage imageNamed:@"lunbo_default"]];
            //            [imageViewAD setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"lunbo_default"]];
        }
        
        //添加点击事件
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, 0,imageViewWidth, imageViewHeight);
        btn.backgroundColor=[UIColor clearColor];
        btn.tag=i;
        [btn addTarget:self action:@selector(tapADAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageViewAD addSubview:btn];
        
    }
    _scrollViewAD.pagingEnabled = YES;
    _scrollViewAD.showsHorizontalScrollIndicator = NO;
    _scrollViewAD.showsVerticalScrollIndicator=NO;
    _scrollViewAD.contentSize=CGSizeMake(imageViewWidth*imagesCount, imageViewHeight);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self initPageControl];
}

#pragma mark tapADAction
-(void)tapADAction:(UIButton*)button
{
    DYADDetailContentVC *vc=[[DYADDetailContentVC alloc]init];
    vc.webUrl=_aryUrls[button.tag];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark initPageControl
-(void)initPageControl
{
    _pageControlAD.numberOfPages=_aryADImages.count;
    
    [self initADtimer];
}

#pragma mark ADTimer
-(void)initADtimer
{
    [self performSelector:@selector(adTimerAction) withObject:nil afterDelay:kADTimeInterval];
}

//递归循环图片播放
-(void)adTimerAction
{
    
    NSInteger currentNumbers=_pageControlAD.currentPage+1;
    if (currentNumbers>=_aryADImages.count)
    {
        currentNumbers=0;
    }
    _scrollViewAD.contentOffset=CGPointMake(currentNumbers*_scrollViewAD.frame.size.width, 0);
    [self performSelector:@selector(adTimerAction) withObject:nil afterDelay:kADTimeInterval];
}

//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
