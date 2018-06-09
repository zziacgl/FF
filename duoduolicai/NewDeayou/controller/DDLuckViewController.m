//
//  DDLuckViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/5/4.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDLuckViewController.h"
#import <AudioToolbox/AudioToolbox.h>//震动库
#import <AVFoundation/AVFoundation.h>
#import "UMSocialData.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsService.h"
#import "UMSocialScreenShoter.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialScreenShoter.h"
#import "DYSafeViewController.h"

@interface DDLuckViewController ()<UMSocialUIDelegate, UIAlertViewDelegate>
{
    UIView *background;
    UIView *tanView;
    UIView *shareBackground;
    UIView *shareView;
    UIView *giftView;
    
}
@property (nonatomic, strong) NSDictionary *myDic;
@property (nonatomic, strong) NSDictionary *rewardDic;
@property (nonatomic, strong) NSDictionary *shareDic;
@property (nonatomic,strong)NSString *shareTitle;
@property (nonatomic,strong)NSString *shareText;
@property (nonatomic,strong)UIImage *shareImage;
@property (nonatomic,strong)NSString *shareURL;

@property (nonatomic, strong) UIView *firstView;//摇一摇主视图
@property (nonatomic, strong) UIView *secondView;//分享视图
@property (nonatomic, strong) UIView *thirdView;//投资视图
@property (nonatomic, strong) UIView *forthView;//多米视图
@property (nonatomic, strong) UIView *fifthView;//分享注册视图

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UIImageView *lightImage;
@property (nonatomic, strong) UIImageView *hammerImage;//锤子图片
@property (nonatomic, strong) UIImageView *boxImage;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *friendLabel;
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic) CGPoint hammerCenter;
@property (nonatomic, strong) UIImageView *myShareImage;
@property (nonatomic, strong) UIImageView *piggyBankImage;//存钱罐
@property (nonatomic, strong) UIButton *qqBtn;
@property (nonatomic, strong) UILabel *qqLabel;
@property (nonatomic, strong) UIButton *ZoneBnt;
@property (nonatomic, strong) UILabel *ZoneLabel;
@property (nonatomic, strong) UIButton *weixinBtn;
@property (nonatomic, strong) UILabel *weixinLabel;
@property (nonatomic, strong) UIButton *weixinFirendBtn;
@property (nonatomic, strong) UILabel *weixinFirendLabel;

@property (nonatomic, strong) UIButton *shareFriend;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;//播放器
@end

@implementation DDLuckViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    [self getData];

    [UIApplication sharedApplication].statusBarHidden = NO;
    //监听程序进入前台或者后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
}

- (void)applicationDidEnterBackground {
    NSLog(@"=======applicationDidEnterBackground========");
}

- (void)applicationWillEnterForeground {
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self getData];
    NSLog(@"=======applicationWillEnterForeground========");

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"人品大作战";
    
    //支持摇动
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    
    //    _shareURL=[NSString stringWithFormat:@"http://www.51duoduo.com/mobile.php?about&about_type=reg_snow_redpackage&activity=luck&user_id=%d",[DYUser GetUserID]];
//    //    _shareURL=[NSString stringWithFormat:@"http://192.168.0.114:89/mobile.php?overtime&q=pay&type=share&user_id=%d",[DYUser GetUserID]];
//    //设置微信AppId，设置分享url，默认使用友盟的网址
//    [UMSocialWechatHandler setWXAppId:WXAppKey appSecret:WXAppSecret url:_shareURL];
//    //设置分享到QQ空间的应用Id，和分享url 链接
//    [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:_shareURL];
    
    
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    UIButton *helperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    helperBtn.frame = CGRectMake(0, 7, 30, 30);
    [helperBtn setImage:[UIImage imageNamed:@"零钱宝_03"] forState:UIControlStateNormal];
    [helperBtn addTarget:self action:@selector(handleHelper) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:helperBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(35, 7, 30, 30);
    [shareBtn setImage:[UIImage imageNamed:@"零钱宝_05"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(handleFriend) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shareBtn];
    
    
    
    //背景视图
    [self.view addSubview:self.backImage];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationItem.rightBarButtonItem.image=nil;
//    [self.btnRightItem removeFromSuperview];
    //    [MobClick endLogPageView:@"账户页面"];
    
    //取消第一响应者
    [self resignFirstResponder];
}
//帮助
- (void)handleHelper {
    DYSafeViewController *safeVC = [[DYSafeViewController alloc] init];
    safeVC.hidesBottomBarWhenPushed = YES;
    safeVC.weburl = @"http://www.51duoduo.com/ddjs/rpdzz/gzjs.html";
    safeVC.title = @"人品大作战规则";
    [self.navigationController pushViewController:safeVC animated:YES];
}

#pragma mark 请求数据
- (void)getData {
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"luck" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_info" forKey:@"q" atIndex:0];
//    [diyouDic insertObject:@"70" forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
     [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
             
             NSLog(@"aaaaaaa%@",object);
             
             self.myDic = object;
             NSLog(@"%@", self.myDic);
             NSString *changStr = [self.myDic objectForKey:@"day_times"];
             NSString *str = [self.myDic objectForKey:@"reg_can_draw"];//额外剩下的抽奖次数
             NSString *isshare = [self.myDic objectForKey:@"is_share"];//是否分享
             NSString *isduomi = [self.myDic objectForKey:@"is_click_choise"];
             
             int change = [changStr intValue];
             int other = [str intValue];
             
             if (change > 0 || other > 0) {
                 //原始主界面
                 
                 [self.firstView removeFromSuperview];
                 [self layOutView];
             }else {
                 int a = [isshare intValue];
                 if (a == 0) {
                     [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
                     
                     [self shareView];
                 }else if(a == 1) {
                     if ([isduomi isEqualToString:@"0"]) {//判断是否使用过多米
                         [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
                         [self duomiToChange];
                     }else {
                         [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
                         [self shanreRegister];
                     }
                     
                 }
                 
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
//分享获得免费机会
- (void)shanreData:(NSString *)come {
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"luck" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"share" forKey:@"q" atIndex:0];
//    [diyouDic insertObject:@"70" forKey:@"user_id" atIndex:0];
     [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
             
             self.shareDic = object;
             NSLog(@"gggggg%@", object);
             
             self.shareTitle = [object objectForKey:@"title"];
             self.shareText = [object objectForKey:@"content"];
             
             self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[object objectForKey:@"image"]]]];;
             _shareURL= [object objectForKey:@"url"];             //设置微信AppId，设置分享url，默认使用友盟的网址
             [UMSocialWechatHandler setWXAppId:WXAppKey appSecret:WXAppSecret url:_shareURL];
             //设置分享到QQ空间的应用Id，和分享url 链接
             [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:_shareURL];

             [UMSocialData defaultData].extConfig.qqData.title=self.shareTitle;
             [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
             UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:come];
             snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);

             
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

//抽奖数据(免费机会)
- (void)getLotteryData:(NSString *)str {
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"luck" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"draw" forKey:@"q" atIndex:0];
//    [diyouDic insertObject:@"70" forKey:@"user_id" atIndex:0];
     [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:str forKey:@"type" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
             self.rewardDic = object;
             NSLog(@"bbbbbbbbb%@", object);
             [self showTan:[self.rewardDic objectForKey:@"award"]];
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

//是否使用多米抽奖
- (void)makeDuoMi:(BOOL)sure {
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"luck" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"pay" forKey:@"q" atIndex:0];
//    [diyouDic insertObject:@"70" forKey:@"user_id" atIndex:0];
     [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    if (sure) {
        [diyouDic insertObject:@"1" forKey:@"status" atIndex:0];
    }else {
        [diyouDic insertObject:@"0" forKey:@"status" atIndex:0];
    }
    
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
             
             NSLog(@"gggggg%@", object);
             if (sure) {
                 [ self showTan:[object objectForKey:@"num"]];
             }else {
                 [self getData];
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
//加载播放器
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        AVAudioSession *session = [[AVAudioSession alloc] init];
        [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        NSString *urlStr=[[NSBundle mainBundle]pathForResource:@"jida" ofType:@"mp3"];
        NSURL *url=[NSURL fileURLWithPath:urlStr];
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops=0;//设置为0不循环
        //        _audioPlayer.delegate=self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

#pragma mark 主视图
- (void)layOutView {
    self.secondView.hidden = YES;
    self.thirdView.hidden = YES;
    self.forthView.hidden = YES;
    self.fifthView.hidden = YES;
    
    self.firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    [self.view addSubview:self.firstView];
    
    self.topImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 5, kMainScreenHeight / 13, kMainScreenWidth / 5 * 3, 60)];
    //        _topImage.backgroundColor = [UIColor grayColor];
    _topImage.image = [UIImage imageNamed:@"人品大作战_03(1)"];
    
    [self.firstView addSubview:self.topImage];
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kMainScreenWidth / 5 * 3 - 20, 20)];
    _topLabel.text = @"大奖就藏在宝箱里";
    _topLabel.textAlignment = NSTextAlignmentCenter;
    _topLabel.textColor = [UIColor whiteColor];
    [self.topImage addSubview:self.topLabel];
    
    self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10, CGRectGetMaxY(self.topLabel.frame), kMainScreenWidth / 5 * 3 - 20, 20)];
    _secondLabel.text = @"向下猛甩手机砸开";
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    _secondLabel.textColor = [UIColor whiteColor];
    [self.topImage addSubview:self.secondLabel];
    
    self.lightImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight / 2 - kMainScreenWidth / 5 *2.6 , kMainScreenWidth  , kMainScreenWidth)];
    //        _lightImage.backgroundColor = [UIColor orangeColor];
    _lightImage.image = [UIImage imageNamed:@"人品大作战_02"];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [_lightImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [self.firstView addSubview:self.lightImage];
    self.boxImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - kMainScreenWidth / 6, CGRectGetMidY(self.lightImage.frame) - kMainScreenWidth / 6, kMainScreenWidth / 3, kMainScreenWidth / 3)];
    
    //        _boxImage.backgroundColor = [UIColor redColor];
    _boxImage.image = [UIImage imageNamed:@"人品大作战_03_07"];
    [self.firstView addSubview:self.boxImage];
    
    self.hammerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2, CGRectGetMidY(self.lightImage.frame) - kMainScreenWidth / 6 * 2.5, kMainScreenWidth / 6 * 2, kMainScreenWidth / 6 * 2 )];
    //        _hammerImage.backgroundColor = [UIColor grayColor];
    _hammerImage.image = [UIImage imageNamed:@"人品大作战_03_03"];
    _hammerCenter = self.hammerImage.center;
    [self.firstView addSubview:self.hammerImage];
    
    self.friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, kMainScreenHeight - 64 - kMainScreenHeight / 6, kMainScreenWidth - 80, 40)];
    NSString *str = [self.myDic objectForKey:@"reg_all_draw"];//邀请注册的人数
    NSString *str1 = [self.myDic objectForKey:@"reg_can_draw"];//额外剩下的抽奖次数
    
    _friendLabel.text = [NSString stringWithFormat:@"邀请了%@个好友注册，获得额外%@次摇奖机会，剩余%@次", str, str,str1];
    
    _friendLabel.textColor = [UIColor whiteColor];
    _friendLabel.font = [UIFont systemFontOfSize:14];
    _friendLabel.numberOfLines = 0;
    _friendLabel.textAlignment = NSTextAlignmentCenter;
    [self.firstView addSubview:self.friendLabel];
    
    self.changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.friendLabel.frame) - 30, kMainScreenWidth, 20)];
    
    _changeLabel.textColor = [UIColor whiteColor];
    NSString *str11 = [self.myDic objectForKey:@"day_times"];
    NSString *str12 = [NSString stringWithFormat:@"今天还有%@次免费机会哦", str11];
    NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc]initWithString:str12];
    int number = [str11 intValue];
    if (number > 9) {
        [str4 addAttribute:NSForegroundColorAttributeName value:kCOLOR_R_G_B_A(255, 240, 77, 1) range:NSMakeRange(4,2)];
    }else {
        [str4 addAttribute:NSForegroundColorAttributeName value:kCOLOR_R_G_B_A(255, 240, 77, 1) range:NSMakeRange(4,1)];
    }
    
    _changeLabel.attributedText = str4;
    _changeLabel.font = [UIFont systemFontOfSize:16];
    _changeLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self.firstView addSubview:self.changeLabel];
}


- (UIImageView *)backImage {
    if (!_backImage) {
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64)];
        //        _backImage.backgroundColor = [UIColor blueColor];
        _backImage.image = [UIImage imageNamed:@"人品大作战"];
    }
    return _backImage;
}


- (void)shareButton {
    [self handleFriend];
    
    
}



////能够成为第一响应者
//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}



//任务开始
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"摇动开始");
    if([UIApplication sharedApplication].applicationSupportsShakeToEdit){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }else{
        [self motionCancelled:motion withEvent:event];
    }
    return;
    
}
//任务取消
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"摇动取消");
}
#pragma mark 任务结束
//任务结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"摇动结束");
//    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
    if([UIApplication sharedApplication].applicationSupportsShakeToEdit){
//        float allIncome = [[self.myDic objectForKey:@"sum_interest"] floatValue];//活动期间累计收益
        float count = [[self.myDic objectForKey:@"day_times"] floatValue];//剩余次数
        float otherCount = [[self.myDic objectForKey:@"reg_can_draw"] floatValue];//额外剩下的抽奖次数
        
        NSString *isture = [self.myDic objectForKey:@"is_can_draw"];
        
        if ([isture isEqualToString:@"1"]) {
            
            if (count > 0 || otherCount > 0) {//当有免费次数时
                
                if (count > 0) {
                    [self getLotteryData:@"day"];
                }else {
                    [self getLotteryData:@"reg"];//邀请注册获得奖励
                }
                
                
                
            }else {
                //如果没免费机会和额外机会显示分享界面
                [self shareView];
                
            }
            
            
            
            
        }else {
            //收益没有达到11.11时，提示投资
            [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
            [self getManyMoney];
            
        }

    
    }
    
    
    //    [self canBecomeFirstResponder];
    
}

- (void) showTan: (NSString *)duomi{
    if([UIApplication sharedApplication].applicationSupportsShakeToEdit){
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        [animation setDuration:0.2];
        animation.fromValue = @(-M_1_PI);
        animation.toValue = @(M_1_PI);
        animation.repeatCount = 1;
        animation.autoreverses = YES;
        
        self.hammerImage.layer.anchorPoint = CGPointMake(0.5, 1);
        [self.hammerImage.layer setPosition:CGPointMake(_hammerCenter.x, _hammerCenter.y + kMainScreenWidth / 12 * 2)];
        [self.hammerImage.layer addAnimation:animation forKey:@"rotation"];
        if (![self.audioPlayer isPlaying]) {
                        [self.audioPlayer play];
                    }
        

        dispatch_group_async(group, queue, ^{
            [NSThread sleepForTimeInterval:0.5];
            NSLog(@"222222");
            
        });
        
        dispatch_group_async(group, queue, ^{
            [NSThread sleepForTimeInterval:1.0];
            
            NSLog(@"33333");
        });
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
            
            background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            background.backgroundColor = [UIColor blackColor];
            background.alpha = 0.9;
            [self.tabBarController.view addSubview:background];
            
            tanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            //    tanView.backgroundColor = [UIColor whiteColor];
            [self shakeToShow:tanView];
            [self.tabBarController.view addSubview:tanView];
            
            UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, kMainScreenWidth, 40)];
            
            titlelab.textColor = kCOLOR_R_G_B_A(255, 240, 77, 1);
            titlelab.textAlignment = NSTextAlignmentCenter;
            titlelab.font = [UIFont systemFontOfSize:20];
            [tanView addSubview:titlelab];
            
            UILabel *rewardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 124, kMainScreenWidth, 40)];
            
            
//            rewardLabel.text = duomi;
            rewardLabel.textColor = [UIColor redColor];
            rewardLabel.textAlignment = NSTextAlignmentCenter;
            rewardLabel.font = [UIFont systemFontOfSize:20];
            [tanView addSubview:rewardLabel];
            
            if ([duomi isEqualToString:@"谢谢参与"]) {
                rewardLabel.text = @"很遗憾，再接再厉";
                rewardLabel.textColor = kCOLOR_R_G_B_A(255, 240, 77, 1);
            }else if ([duomi isEqualToString:@"再来一次"]){
                rewardLabel.text = @"恭喜获得一次免费机会";
                rewardLabel.textColor = kCOLOR_R_G_B_A(255, 240, 77, 1);
            }else {
                titlelab.text = @"恭喜获得";
                rewardLabel.text = [NSString stringWithFormat:@"%@多米", duomi];
            }

            UIImageView *tanLightImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rewardLabel.frame), kMainScreenWidth, kMainScreenWidth)];
            tanLightImage.image = [UIImage imageNamed:@"人品大作战_02"];
            //    tanLightImage.backgroundColor = [UIColor orangeColor];
            //    tanLightImage.center = tanView.center;
            CABasicAnimation* rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
            rotationAnimation.duration = 5;
            rotationAnimation.cumulative = YES;
            rotationAnimation.repeatCount = MAXFLOAT;
            
            [tanLightImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
            [tanView addSubview:tanLightImage];
            
            UIImageView *tanBoxImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3, CGRectGetMidY(tanLightImage.frame) - kMainScreenWidth / 6, kMainScreenWidth / 3, kMainScreenWidth / 3)];
            tanBoxImage.image = [UIImage imageNamed:@"人品大作战_03"];
            [tanView addSubview:tanBoxImage];
            
            UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            otherBtn.frame = CGRectMake((kMainScreenWidth - kMainScreenWidth / 8 * 6 ) / 3, kMainScreenHeight - 50 - kMainScreenWidth / 8, kMainScreenWidth / 8 * 3, kMainScreenWidth / 8);
            [otherBtn setImage:[UIImage imageNamed:@"人品大作战_05"] forState:UIControlStateNormal];
            [otherBtn addTarget:self action:@selector(handleOther) forControlEvents:UIControlEventTouchUpInside];
            [tanView addSubview:otherBtn];
            
            
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame = CGRectMake(CGRectGetMaxX(otherBtn.frame) + (kMainScreenWidth - kMainScreenWidth / 8 * 6 ) / 3, kMainScreenHeight - 50 - kMainScreenWidth / 8, kMainScreenWidth / 8 * 3, kMainScreenWidth / 8);
            [rightBtn setImage:[UIImage imageNamed:@"人品大作战_07"] forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(handleSure) forControlEvents:UIControlEventTouchUpInside];
            [tanView addSubview:rightBtn];
            
            
        });
    }
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
    
}
//再来一次
- (void)handleOther {
    [self getData];
    [tanView removeFromSuperview];
    [background removeFromSuperview];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    
}
//确定
- (void)handleSure {
    [self getData];
    [tanView removeFromSuperview];
    [background removeFromSuperview];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
}
#pragma mark 分享注册
//变成分享视图
- (void)shareView {
    
    [self.secondView removeFromSuperview];
    self.firstView.hidden = YES;
    self.thirdView.hidden = YES;
    self.forthView.hidden = YES;
    self.fifthView.hidden  = YES;
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    [self.view addSubview:self.secondView];
    
    
    
    self.myShareImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 5, -60, kMainScreenWidth / 5 * 3, 60)];
    _myShareImage.image = [UIImage imageNamed:@"人品大作战_03(1)"];
    [self.secondView addSubview:self.myShareImage];
    UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth / 5 * 3, 20)];
    upLabel.text = @"分享朋友圈";
    upLabel.textColor = [UIColor whiteColor];
    upLabel.textAlignment = NSTextAlignmentCenter;
    [self.myShareImage addSubview:upLabel];
    
    UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kMainScreenWidth / 5 * 3, 20)];
    downLabel.text = @"获取抽奖机会";
    downLabel.textAlignment = NSTextAlignmentCenter;
    downLabel.textColor = [UIColor whiteColor];
    [self.myShareImage addSubview:downLabel];
    
    self.lightImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight / 2 - kMainScreenWidth / 5 *2.6 , kMainScreenWidth  , kMainScreenWidth)];
    //        _lightImage.backgroundColor = [UIColor orangeColor];
    _lightImage.image = [UIImage imageNamed:@"人品大作战_02"];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [_lightImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    self.boxImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - kMainScreenWidth / 6, CGRectGetMidY(self.lightImage.frame) - kMainScreenWidth / 6, kMainScreenWidth / 3, kMainScreenWidth / 3)];
    
    //        _boxImage.backgroundColor = [UIColor redColor];
    _boxImage.image = [UIImage imageNamed:@"人品大作战_03_07"];
    
    self.hammerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2, CGRectGetMidY(self.lightImage.frame) - kMainScreenWidth / 6 * 2.5, kMainScreenWidth / 6 * 2, kMainScreenWidth / 6 * 2 )];
    //        _hammerImage.backgroundColor = [UIColor grayColor];
    _hammerImage.image = [UIImage imageNamed:@"人品大作战_03_03"];
    _hammerCenter = self.hammerImage.center;
    
    
    [self.secondView addSubview:self.lightImage];
    [self.secondView addSubview:self.boxImage];
    [self.secondView addSubview:self.hammerImage];
    
    self.shareFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareFriend.frame = CGRectMake((kMainScreenWidth - kMainScreenWidth / 8 * 5) / 2, kMainScreenHeight - 64 - kMainScreenHeight / 6, kMainScreenWidth / 8 * 5, kMainScreenWidth / 8);
    [_shareFriend setImage:[UIImage imageNamed:@"人品大作战_分享"] forState:UIControlStateNormal];
    [_shareFriend addTarget:self action:@selector(handleFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.secondView addSubview:self.shareFriend];
    
    //    CGPoint startPoint = CGPointMake(_myShareImage.center.x, -_myShareImage.frame.size.height);
    //    _myShareImage.layer.position=startPoint;
    [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:2.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.myShareImage.frame = CGRectMake(kMainScreenWidth / 5, kMainScreenHeight / 13, kMainScreenWidth / 5 * 3, 60);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}
//分享按钮响应事件
- (void)handleFriend {
    shareBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    shareBackground.backgroundColor = [UIColor blackColor];
    shareBackground.alpha = 0.7;
    [self.tabBarController.view addSubview:shareBackground];
    
    shareView = [[UIView alloc] initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height / 4, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height / 2.5)];
    //    shareView.alpha = 0;
    shareView.backgroundColor = [UIColor whiteColor];
    [shareView.layer setMasksToBounds:YES];
    [shareView.layer setCornerRadius:8.0];
    [self shakeToShow:shareView];
    [self.tabBarController.view addSubview:shareView];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, CGRectGetWidth(shareView.frame) / 2 - 50, 0.5)];
    leftImageView.image = [UIImage imageNamed:@""];
    leftImageView.backgroundColor = [UIColor grayColor];
    [shareView addSubview:leftImageView];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame), 30, 60, 20)];
    topLabel.text = @"分享到";
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont systemFontOfSize:12];
    topLabel.textColor = [UIColor lightGrayColor];
    [shareView addSubview:topLabel];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topLabel.frame), 40, CGRectGetWidth(shareView.frame) / 2 - 50, 0.5)];
    rightImageView.image = [UIImage imageNamed:@""];
    rightImageView.backgroundColor = [UIColor grayColor];
    [shareView addSubview:rightImageView];
    
    self.weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _weixinBtn.frame = CGRectMake(20, CGRectGetMaxY(topLabel.frame) + 30, (CGRectGetWidth(shareView.frame) - 100) / 4, (CGRectGetWidth(shareView.frame) - 100) / 4);
    //    _weixinBtn.backgroundColor = [UIColor orangeColor];
    [_weixinBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [_weixinBtn addTarget:self action:@selector(handleWeixin) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:self.weixinBtn];
    
    self.weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.weixinBtn.frame), (CGRectGetWidth(shareView.frame) - 100) / 4, 20)];
    _weixinLabel.textAlignment = NSTextAlignmentCenter;
    _weixinLabel.text = @"微信";
    _weixinLabel.font = [UIFont systemFontOfSize:12];
    _weixinLabel.textColor = [UIColor grayColor];
    [shareView addSubview:self.weixinLabel];
    
    self.qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _qqBtn.frame = CGRectMake(CGRectGetMaxX(self.weixinBtn.frame) + 20, CGRectGetMaxY(topLabel.frame) + 30, (CGRectGetWidth(shareView.frame) - 100) / 4, (CGRectGetWidth(shareView.frame) - 100) / 4);
    [_qqBtn addTarget:self action:@selector(handleQQ) forControlEvents:UIControlEventTouchUpInside];
    [_qqBtn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    //    _qqBtn.backgroundColor = [UIColor orangeColor];
    [shareView addSubview:self.qqBtn];
    
    self.qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.weixinBtn.frame) + 20, CGRectGetMaxY(self.qqBtn.frame), (CGRectGetWidth(shareView.frame) - 100) / 4, 20)];
    _qqLabel.text = @"腾讯QQ";
    _qqLabel.textColor = [UIColor grayColor];
    _qqLabel.textAlignment = NSTextAlignmentCenter;
    _qqLabel.font = [UIFont systemFontOfSize:12];
    [shareView addSubview:self.qqLabel];
    
    self.weixinFirendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _weixinFirendBtn.frame = CGRectMake(CGRectGetMaxX(self.qqBtn.frame) + 20, CGRectGetMaxY(topLabel.frame) + 30, (CGRectGetWidth(shareView.frame) - 100) / 4, (CGRectGetWidth(shareView.frame) - 100) / 4);
    [_weixinFirendBtn addTarget:self action:@selector(handleWeixinFrirend) forControlEvents:UIControlEventTouchUpInside];
    [_weixinFirendBtn setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
    //    _weixinFirendBtn.backgroundColor = [UIColor orangeColor];
    [shareView addSubview:self.weixinFirendBtn];
    
    self.weixinFirendLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.qqLabel.frame) + 20, CGRectGetMaxY(self.weixinFirendBtn.frame), (CGRectGetWidth(shareView.frame) - 100) / 4, 20)];
    _weixinFirendLabel.text = @"朋友圈";
    _weixinFirendLabel.textAlignment = NSTextAlignmentCenter;
    _weixinFirendLabel.font = [UIFont systemFontOfSize:12];
    _weixinFirendLabel.textColor = [UIColor lightGrayColor];
    [shareView addSubview:self.weixinFirendLabel];
    
    self.ZoneBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _ZoneBnt.frame = CGRectMake(CGRectGetMaxX(self.weixinFirendBtn.frame) + 20, CGRectGetMaxY(topLabel.frame) + 30, (CGRectGetWidth(shareView.frame) - 100) / 4, (CGRectGetWidth(shareView.frame) - 100) / 4);
    [_ZoneBnt addTarget:self action:@selector(handleZone) forControlEvents:UIControlEventTouchUpInside];
    //    _ZoneBnt.backgroundColor = [UIColor orangeColor];
    [_ZoneBnt setImage:[UIImage imageNamed:@"空间"] forState:UIControlStateNormal];
    [shareView addSubview:self.ZoneBnt];
    
    self.ZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.weixinFirendLabel.frame) + 20, CGRectGetMaxY(self.ZoneBnt.frame), (CGRectGetWidth(shareView.frame) - 100) / 4, 20)];
    _ZoneLabel.text = @"QQ空间";
    _ZoneLabel.textAlignment = NSTextAlignmentCenter;
    _ZoneLabel.font = [UIFont systemFontOfSize:12];
    _ZoneLabel.textColor = [UIColor grayColor];
    [shareView addSubview:self.ZoneLabel];
    
    
    [shareView addSubview:self.qqLabel];
    
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        cancelBtn.frame = CGRectMake(40, CGRectGetHeight(shareView.frame) - 40, CGRectGetWidth(shareView.frame) - 80, 30);
    }else {
        cancelBtn.frame = CGRectMake(40, CGRectGetHeight(shareView.frame) - 60, CGRectGetWidth(shareView.frame) - 80, 40);
    }
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = kCOLOR_R_G_B_A(78, 199, 210, 1);
    [cancelBtn.layer setCornerRadius:5];
    [cancelBtn.layer setMasksToBounds:YES];
    [cancelBtn addTarget:self action:@selector(handleCancel) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancelBtn];
    
}
- (void)handleWeixin {
    [self shanreData:@"wxsession"];
    [shareView removeFromSuperview];
    [shareBackground removeFromSuperview];

//    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
//    [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"wxsession"];
//    
//    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    
}
- (void)handleQQ {
    [self shanreData:@"qq"];
    
    [shareView removeFromSuperview];
    [shareBackground removeFromSuperview];
//
//    [UMSocialData defaultData].extConfig.qqData.title=self.shareTitle;
//    [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qq"];
//    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//    
    
    
}
- (void)handleWeixinFrirend {
    [self shanreData:@"wxtimeline"];
    [shareView removeFromSuperview];
    [shareBackground removeFromSuperview];

//    [UMSocialData defaultData].extConfig.wechatTimelineData.title=self.shareTitle;
//    [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"wxtimeline"];
//    
//    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    
}
- (void)handleZone {
    [self shanreData:@"qzone"];
    [shareView removeFromSuperview];
    [shareBackground removeFromSuperview];

//    [UMSocialData defaultData].extConfig.qzoneData.title=self.shareTitle;
//    [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qzone"];
//    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    
}

- (void)handleCancel {
    [UIView animateWithDuration:0.3 animations:^{
        [shareView removeFromSuperview];
        [shareBackground removeFromSuperview];
        
    }];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


//当累计收益没有达到11.11时的视图
- (void)getManyMoney{
    [self.thirdView removeFromSuperview];
    self.firstView.hidden = YES;
    self.secondView.hidden = YES;
    self.forthView.hidden = YES;
    self.fifthView.hidden = YES;
    self.thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    [self.view addSubview:self.thirdView];
    
    UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, kMainScreenWidth - 40, 40)];
    upLabel.text = [NSString stringWithFormat:@"%@", [self.myDic objectForKey:@"cannot_draw_reason"]];
    NSLog(@"%@", upLabel.text);
    upLabel.textColor = [UIColor whiteColor];
    upLabel.textAlignment = NSTextAlignmentCenter;
    upLabel.numberOfLines = 0;
    upLabel.font = [UIFont systemFontOfSize:16];
    [self.thirdView addSubview:upLabel];
    
//    UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, kMainScreenWidth, 20)];
//   
//    downLabel.text = [NSString stringWithFormat:@"当前待收益：%@元", [self.myDic objectForKey:@"sum_interest"]];
//    downLabel.textColor = [UIColor whiteColor];
//    downLabel.textAlignment = NSTextAlignmentCenter;
//    downLabel.font = [UIFont systemFontOfSize:16];
//    [self.thirdView addSubview:downLabel];
    
    UIImageView *pigImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 8, kMainScreenHeight / 2 - kMainScreenWidth / 6 * 3, kMainScreenWidth / 4 * 3, kMainScreenWidth / 4 * 3)];
    pigImage.image = [UIImage imageNamed:@"人品大作战_03_03(1)"];
    [self.thirdView addSubview:pigImage];
    
    UIButton *investBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    investBtn.frame = CGRectMake((kMainScreenWidth - kMainScreenWidth / 8 * 5) / 2, kMainScreenHeight - 64 - 120, kMainScreenWidth / 8 * 5, kMainScreenWidth / 8);
    [investBtn setImage:[UIImage imageNamed:@"人品大作战_03_07(1)"] forState:UIControlStateNormal];
    [investBtn addTarget:self action:@selector(handleInvest) forControlEvents:UIControlEventTouchUpInside];
    [self.thirdView addSubview:investBtn];
}
//立即投资按钮响应事件
- (void)handleInvest {
    [self.tabBarController setSelectedIndex:2];//0:首页，1：零钱包，2：投资，3：更多
    
}
//需要用多米购买机会的视图
- (void)duomiToChange {
    
    [self.forthView removeFromSuperview];
    self.firstView.hidden = YES;
    self.secondView.hidden = YES;
    self.thirdView.hidden = YES;
    self.fifthView.hidden = YES;
    self.forthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    [self.view addSubview:self.forthView];
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 5, -60, kMainScreenWidth / 5 * 3, 60)];
    topImageView.image = [UIImage imageNamed:@"人品大作战_03(1)"];
    [self.forthView addSubview:topImageView];
    UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth / 5 * 3, 20)];
    upLabel.text = @"只需50多米";
    upLabel.textColor = [UIColor whiteColor];
    upLabel.textAlignment = NSTextAlignmentCenter;
    [topImageView addSubview:upLabel];
    
    UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kMainScreenWidth / 5 * 3, 20)];
    downLabel.text = @"又可增加一次摇奖机会";
    downLabel.textAlignment = NSTextAlignmentCenter;
    downLabel.textColor = [UIColor whiteColor];
    [topImageView addSubview:downLabel];
    
    self.lightImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight / 2 - kMainScreenWidth / 5 *2.6 , kMainScreenWidth  , kMainScreenWidth)];
    //        _lightImage.backgroundColor = [UIColor orangeColor];
    _lightImage.image = [UIImage imageNamed:@"人品大作战_08"];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [_lightImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    self.boxImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - kMainScreenWidth / 6, CGRectGetMidY(self.lightImage.frame) - kMainScreenWidth / 6, kMainScreenWidth / 3, kMainScreenWidth / 3)];
    
    //        _boxImage.backgroundColor = [UIColor redColor];
    _boxImage.image = [UIImage imageNamed:@"人品大作战_03_07"];
    
    self.hammerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2, CGRectGetMidY(self.lightImage.frame) - kMainScreenWidth / 6 * 2.5, kMainScreenWidth / 6 * 2, kMainScreenWidth / 6 * 2 )];
    //        _hammerImage.backgroundColor = [UIColor grayColor];
    _hammerImage.image = [UIImage imageNamed:@"人品大作战_03_03"];
    _hammerCenter = self.hammerImage.center;
    
    
    [self.forthView addSubview:self.lightImage];
    [self.forthView addSubview:self.boxImage];
    [self.forthView addSubview:self.hammerImage];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake((kMainScreenWidth - kMainScreenWidth / 8 * 6 ) / 3, kMainScreenHeight - 64 - kMainScreenHeight / 6, kMainScreenWidth / 8 * 3, kMainScreenWidth / 8);
    [payBtn setImage:[UIImage imageNamed:@"人品大作战_ (1)"] forState:UIControlStateNormal];
    
    [payBtn addTarget:self action:@selector(handlePay) forControlEvents:UIControlEventTouchUpInside];
    [self.forthView addSubview:payBtn];
    
    UIButton *unWill = [UIButton buttonWithType:UIButtonTypeCustom];
    unWill.frame = CGRectMake(CGRectGetMaxX(payBtn.frame) + (kMainScreenWidth - kMainScreenWidth / 8 * 6 ) / 3, kMainScreenHeight - 64 - kMainScreenHeight / 6, kMainScreenWidth / 8 * 3, kMainScreenWidth / 8);
    [unWill setImage:[UIImage imageNamed:@"人品大作战_ (2)"] forState:UIControlStateNormal];
    [unWill addTarget:self action:@selector(handleUnwill) forControlEvents:UIControlEventTouchUpInside];
    [self.forthView addSubview:unWill];
    
    [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:2.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        topImageView.frame = CGRectMake(kMainScreenWidth / 5, kMainScreenHeight / 13, kMainScreenWidth / 5 * 3, 60);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}
//立即支付50多米
- (void)handlePay {
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"确定支付50多米？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alertView.delegate = self;
    [alertView show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
        [self makeDuoMi:YES];
    }
}
//不愿意支付
- (void)handleUnwill {
    [self makeDuoMi:NO];
}

#pragma mark 分享注册视图

- (void)shanreRegister {
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];

    [self.fifthView removeFromSuperview];
    self.firstView.hidden = YES;
    self.thirdView.hidden = YES;
    self.forthView.hidden = YES;
    self.secondView.hidden = YES;
    self.fifthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    [self.view addSubview:self.fifthView];
    
    
    
    self.myShareImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 10, -60, kMainScreenWidth / 5 * 4, 60)];
    _myShareImage.image = [UIImage imageNamed:@"人品大作战_03(1)"];
    [self.fifthView addSubview:self.myShareImage];
    UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth / 5 * 4, 20)];
    upLabel.text = @"邀请好友注册，可多得一次机会";
    upLabel.textColor = [UIColor whiteColor];
    upLabel.textAlignment = NSTextAlignmentCenter;
    [self.myShareImage addSubview:upLabel];
    
    UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kMainScreenWidth / 5 * 4, 20)];
    downLabel.text = @"可以累积不过期哦";
    downLabel.textAlignment = NSTextAlignmentCenter;
    downLabel.textColor = [UIColor whiteColor];
    [self.myShareImage addSubview:downLabel];
    
    self.lightImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight / 2 - kMainScreenWidth / 5 *2.6 , kMainScreenWidth  , kMainScreenWidth)];
    //        _lightImage.backgroundColor = [UIColor orangeColor];
    _lightImage.image = [UIImage imageNamed:@"人品大作战_08"];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [_lightImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    self.boxImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - kMainScreenWidth / 6, CGRectGetMidY(self.lightImage.frame) - kMainScreenWidth / 6, kMainScreenWidth / 3, kMainScreenWidth / 3)];
    
    //        _boxImage.backgroundColor = [UIColor redColor];
    _boxImage.image = [UIImage imageNamed:@"人品大作战_03_07"];
    
    self.hammerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2, CGRectGetMidY(self.lightImage.frame) - kMainScreenWidth / 6 * 2.5, kMainScreenWidth / 6 * 2, kMainScreenWidth / 6 * 2 )];
    //        _hammerImage.backgroundColor = [UIColor grayColor];
    _hammerImage.image = [UIImage imageNamed:@"人品大作战_03_03"];
    _hammerCenter = self.hammerImage.center;
    
    
    [self.fifthView addSubview:self.lightImage];
    [self.fifthView addSubview:self.boxImage];
    [self.fifthView addSubview:self.hammerImage];
    
    self.shareFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareFriend.frame = CGRectMake((kMainScreenWidth - kMainScreenWidth / 8 * 5) / 2, kMainScreenHeight - 64 - kMainScreenHeight / 6 - 15, kMainScreenWidth / 8 * 5, kMainScreenWidth / 8);
    [_shareFriend setImage:[UIImage imageNamed:@"人品大作战-按钮_07"] forState:UIControlStateNormal];
    [_shareFriend addTarget:self action:@selector(handleFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.fifthView addSubview:self.shareFriend];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shareFriend.frame) + 10, kMainScreenWidth, 30)];
    NSString *str = [self.myDic objectForKey:@"reg_all_draw"];
    NSString *str1 = [self.myDic objectForKey:@"reg_already_draw"];
    detailLabel.text = [NSString stringWithFormat:@"邀请了%@个好友注册,获得额外%@次机会", str, str1];
//    detailLabel.text = @"邀请了3个好友注册，获得额外三次机会";
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.font = [UIFont systemFontOfSize:15];
    [self.fifthView addSubview:detailLabel];
    
    //    CGPoint startPoint = CGPointMake(_myShareImage.center.x, -_myShareImage.frame.size.height);
    //    _myShareImage.layer.position=startPoint;
    [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:2.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.myShareImage.frame = CGRectMake(kMainScreenWidth / 10, kMainScreenHeight / 13, kMainScreenWidth / 5 * 4, 60);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
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
