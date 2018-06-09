//
//  DDWorkViewController.m
//  NewDeayou
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDWorkViewController.h"

#import "UMSocialData.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsPlatformManager.h"

#import "UMSocialScreenShoter.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialScreenShoter.h"
#import "LeafNotification.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kLabel_Space  (kScreenWidth - 200) / 5
#define kShare_Space   (kScreenWidth - 160) / 5

@interface DDWorkViewController ()<UMSocialUIDelegate, UIScrollViewDelegate>

{
    UIView *background;
    UIView *tanView;
    UIView *shareBackground;
    UIView *shareView;
    UIView *giftView;
}
@property (nonatomic, strong) UIImageView *backImage;

@property (nonatomic,strong)NSString *shareTitle;
@property (nonatomic,strong)NSString *shareText;
@property (nonatomic,strong)UIImage *shareImage;
@property (nonatomic,strong)NSString *shareURL;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UILabel *aLeftLabel;
@property (nonatomic, strong) UILabel *bLeftLabel;
@property (nonatomic, strong) UILabel *cLeftLabel;
@property (nonatomic, strong) UILabel *aRightLabel;
@property (nonatomic, strong) UILabel *bRightLabel;
@property (nonatomic, strong) UILabel *cRightLabel;
@property (nonatomic, strong) UIButton *qqBtn;
@property (nonatomic, strong) UILabel *qqLabel;
@property (nonatomic, strong) UIButton *ZoneBnt;
@property (nonatomic, strong) UILabel *ZoneLabel;
@property (nonatomic, strong) UIButton *weixinBtn;
@property (nonatomic, strong) UILabel *weixinLabel;
@property (nonatomic, strong) UIButton *weixinFirendBtn;
@property (nonatomic, strong) UILabel *weixinFirendLabel;
@property (nonatomic, strong) NSDictionary *myDic;

@end

@implementation DDWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加班费";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.shareTitle = @"我刚才领了加班费，最低11.11元，最高不限！以后加班，天天领取加班费！";
    self.shareText = @"您的好友送了你一份加班费，以后加班的时候，它陪着你哦。";
    self.shareImage = [UIImage imageNamed:@"小图"];
         _shareURL=[NSString stringWithFormat:@"http://www.51duoduo.com/mobile.php?overtime&q=pay&type=share&user_id=%d",[DYUser GetUserID]];
//    _shareURL=[NSString stringWithFormat:@"http://192.168.0.114:89/mobile.php?overtime&q=pay&type=share&user_id=%d",[DYUser GetUserID]];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WXAppKey appSecret:WXAppSecret url:_shareURL];
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:_shareURL];
    //导航右边的按钮
    UIButton * btnRightItem=[UIButton buttonWithType:UIButtonTypeCustom];
    //    btnRightItem.backgroundColor=[UIColor clearColor];
    btnRightItem.frame=CGRectMake(0, 0, 30, 30);
    [btnRightItem setImage:[UIImage imageNamed:@"零钱宝_03@2x"] forState:UIControlStateNormal];
    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [btnRightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    [btnRightItem addTarget:self action:@selector(ruleBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    
    
    //读取数据
    [self getData];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [MobClick beginLogPageView:@"加班费规则详情"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [MobClick endLogPageView:@"加班费规则详情"];
}
- (void)ruleBtn {
    background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.7;
    [self.tabBarController.view addSubview:background];
    
    tanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //    tanView.backgroundColor = [UIColor whiteColor];
    [self shakeToShow:tanView];
    
    [self.tabBarController.view addSubview:tanView];
    
    UILabel *tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, 50)];
    tittleLabel.text = @"活动规则";
    tittleLabel.font = [UIFont systemFontOfSize:20];
    tittleLabel.textColor = [UIColor whiteColor];
    tittleLabel.textAlignment = NSTextAlignmentCenter;
    [tanView addSubview:tittleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(tittleLabel.frame) + 10, kScreenWidth - 40, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [tanView addSubview:lineView];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lineView.frame) + 20, kScreenWidth - 40, 40)];
    firstLabel.text = @"1. 新老用户均可参与，每个用户只有一次参与机会，需输入手机号码才能领取加班费；";
    
    firstLabel.textColor = [UIColor whiteColor];
    firstLabel.font = [UIFont systemFontOfSize:15];
    firstLabel.numberOfLines = 0;
    [tanView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstLabel.frame) + 10, kScreenWidth - 40, 40)];
    secondLabel.text= @"2. 领取时间在19:00-24:00之间，每多一个好友领取，领取时间提前5分钟，最多提前60分钟；";
    
    secondLabel.textColor = [UIColor whiteColor];
    secondLabel.font = [UIFont systemFontOfSize:15];
    secondLabel.numberOfLines = 0;
    [tanView addSubview:secondLabel];
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(secondLabel.frame) + 10, kScreenWidth - 40, 80)];
    thirdLabel.text = @"3. 参与活动后,当您的待收益≥9.86元，加班费将打入您的多多账户，最低11.11元；您也可以邀请您的好友一起领取，好友待收益≥9.86元，您和好友均可获得，分享越多领取越多；";
    thirdLabel.textColor = [UIColor whiteColor];
    
    thirdLabel.font = [UIFont systemFontOfSize:15];
    thirdLabel.numberOfLines = 0;
    [tanView addSubview:thirdLabel];
    
    UILabel *forthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(thirdLabel.frame) + 10, kScreenWidth - 40, 40)];
    forthLabel.text = @"4. 10万份加班费，领完为止，先到先得，活动结束之后就无法领取了哦~";
    
    forthLabel.textColor = [UIColor whiteColor];
    forthLabel.font = [UIFont systemFontOfSize:15];
    forthLabel.numberOfLines = 0;
    [tanView addSubview:forthLabel];
    
    UILabel *fifthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(forthLabel.frame) + 10, kScreenWidth - 40, 40)];
    fifthLabel.text = @"5. 投资项目包括新手标、车贷宝和银承通（不含零钱宝）。";
    
    fifthLabel.textColor = [UIColor whiteColor];
    fifthLabel.font = [UIFont systemFontOfSize:15];
    fifthLabel.numberOfLines = 0;
    [tanView addSubview:fifthLabel];
    
    UILabel *sixthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(fifthLabel.frame) + 10, kScreenWidth - 40, 40)];
    sixthLabel.text = @"6. 法律允许范围内，本活动最终解释权归多多理财；如有其他问题，请联系客服。";
    sixthLabel.textColor = [UIColor whiteColor];
    sixthLabel.font = [UIFont systemFontOfSize:15];
    sixthLabel.numberOfLines = 0;
    [tanView addSubview:sixthLabel];
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kScreenWidth / 2 - 50, CGRectGetMaxY(sixthLabel.frame) + 20, 100, 40);
    [closeBtn setTintColor:[UIColor whiteColor]];
    [closeBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    closeBtn.layer.masksToBounds = YES;
    closeBtn.layer.cornerRadius = 5;
    closeBtn.layer.borderWidth = 1;
    closeBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [closeBtn addTarget:self action:@selector(handleGuan) forControlEvents:UIControlEventTouchUpInside];
    [tanView addSubview:closeBtn];
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        tittleLabel.frame = CGRectMake(0, 60, kScreenWidth, 40);
        lineView.frame = CGRectMake(20, CGRectGetMaxY(tittleLabel.frame) + 10, kScreenWidth - 40, 1);
        firstLabel.frame = CGRectMake(20, CGRectGetMaxY(lineView.frame) + 10, kScreenWidth - 40, 40);
        secondLabel.frame = CGRectMake(20, CGRectGetMaxY(firstLabel.frame), kScreenWidth - 40, 40);
        thirdLabel.frame = CGRectMake(20, CGRectGetMaxY(secondLabel.frame) , kScreenWidth - 40, 80);
        forthLabel.frame = CGRectMake(20, CGRectGetMaxY(thirdLabel.frame), kScreenWidth - 40, 40);
        fifthLabel.frame = CGRectMake(20, CGRectGetMaxY(forthLabel.frame), kScreenWidth - 40, 40);
        sixthLabel.frame = CGRectMake(20, CGRectGetMaxY(fifthLabel.frame), kScreenWidth - 40, 40);
        closeBtn.frame = CGRectMake(kScreenWidth / 2 - 50, CGRectGetMaxY(sixthLabel.frame) + 10, 100, 30);
        firstLabel.font = [UIFont systemFontOfSize:13];
        secondLabel.font = [UIFont systemFontOfSize:13];
        thirdLabel.font = [UIFont systemFontOfSize:13];
        forthLabel.font = [UIFont systemFontOfSize:13];
        fifthLabel.font = [UIFont systemFontOfSize:13];
        sixthLabel.font = [UIFont systemFontOfSize:13];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    
}
- (void)handleGuan {
    [tanView removeFromSuperview];
    [background removeFromSuperview];
}


- (void)getData {
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"overtime" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"have" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    //    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    //    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
             
             NSLog(@"aaaaaaa%@",object);
             
             self.myDic = object;
             NSLog(@"%@", self.myDic);
             
             [self getView];
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

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.8;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)getView {
    self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _myScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight * 1.5);
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        _myScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight * 1.8);
    } else {
        _myScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight * 1.5);
    }
    _myScrollView.contentOffset = CGPointMake(0, 0);
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.showsVerticalScrollIndicator = NO;
    _myScrollView.delegate = self;
    _myScrollView.bounces = NO;
    _myScrollView.backgroundColor = kCOLOR_R_G_B_A(253, 240, 196, 1);
    [self.view addSubview:self.myScrollView];
    
    self.backImage = [[UIImageView alloc] init];
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        _backImage.frame = CGRectMake(0, 0, kScreenWidth, 220 );
    } else if ([UIScreen mainScreen].bounds.size.height == 568) {
        _backImage.frame = CGRectMake(0, 0, kScreenWidth, 220 );
    }else if ([UIScreen mainScreen].bounds.size.height == 667) {
        _backImage.frame = CGRectMake(0, 0, kScreenWidth, 260 );
    }else {
        _backImage.frame = CGRectMake(0, 0, kScreenWidth, 290 );
    }
    
    
    //    _backImage.backgroundColor = [UIColor orangeColor];
    _backImage.userInteractionEnabled = YES;
    _backImage.image = [UIImage imageNamed:@"加班费2(2)"];
    [self.myScrollView addSubview:self.backImage];
    
    UIImageView *whiteImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.backImage.frame) + 10, kScreenWidth - 40, 120)];
    whiteImage.image = [UIImage imageNamed:@"加班费2_03(1)"];
    whiteImage.userInteractionEnabled = YES;
    [self.myScrollView addSubview:whiteImage];
    
    NSString *str1 = [NSString stringWithFormat:@"%@",[self.myDic objectForKey:@"sum_number"]];
    NSLog(@"%@",str1);
    self.aLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(whiteImage.frame), 30)];
    _aLeftLabel.text = [NSString stringWithFormat:@"参加领取人数：%@人", str1];
    _aLeftLabel.textAlignment = NSTextAlignmentCenter;
    _aLeftLabel.font = [UIFont systemFontOfSize:15];
    [whiteImage addSubview:self.aLeftLabel];
    //    self.aRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.aLeftLabel.frame) + 10, 10, CGRectGetWidth(whiteImage.frame) / 2 - 10, 30)];
    //    _aRightLabel.text = @"9999人";
    //    [whiteImage addSubview:self.aRightLabel];
    
    NSString *str2 = [self.myDic objectForKey:@"amount"];
    self.bLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.aLeftLabel.frame), CGRectGetWidth(whiteImage.frame), 30)];
    _bLeftLabel.text = [NSString stringWithFormat:@"平均领取金额：%@元", str2];
    _bLeftLabel.textAlignment = NSTextAlignmentCenter;
    _bLeftLabel.font = [UIFont systemFontOfSize:15];
    //    _bLeftLabel.backgroundColor = [UIColor orangeColor];
    [whiteImage addSubview:self.bLeftLabel];
    //    self.bRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bLeftLabel.frame) + 10, CGRectGetMaxY(self.aRightLabel.frame), CGRectGetWidth(whiteImage.frame) / 2 - 10, 30)];
    //    _bRightLabel.text = @"9999元";
    //    [whiteImage addSubview:self.bRightLabel];
    NSString *str3 = [self.myDic objectForKey:@"exceed"];
    self.cLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bLeftLabel.frame), CGRectGetWidth(whiteImage.frame), 30)];
    _cLeftLabel.text = [NSString stringWithFormat:@"高于50元领取人数：%@人", str3];
    _cLeftLabel.font = [UIFont systemFontOfSize:15];
    _cLeftLabel.textAlignment = NSTextAlignmentCenter;
    [whiteImage addSubview:self.cLeftLabel];
    //    self.cRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cLeftLabel.frame) + 10, CGRectGetMaxY(self.bRightLabel.frame), CGRectGetWidth(whiteImage.frame) / 2 - 30, 30)];
    //    _cRightLabel.text = @"9999人";
    //    [whiteImage addSubview:self.cRightLabel];
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(30, CGRectGetMaxY(whiteImage.frame) + 30, kScreenWidth - 60, 40);
    shareBtn.layer.masksToBounds = YES;
    shareBtn.layer.cornerRadius = 8;
    shareBtn.backgroundColor = [UIColor orangeColor];
    [shareBtn addTarget:self action:@selector(handleToShare) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitle:@"分享领取" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.myScrollView addSubview:shareBtn];
    
    UIView *alineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(shareBtn.frame) + 35, kScreenWidth / 2 - 70, 1)];
    alineView.backgroundColor = [UIColor brownColor];
    [self.myScrollView addSubview:alineView];
    
    UILabel *tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(alineView.frame), CGRectGetMaxY(shareBtn.frame) + 20, 100, 30)];
    tittleLabel.text = @"活动规则";
    tittleLabel.textColor = [UIColor brownColor];
    tittleLabel.textAlignment = NSTextAlignmentCenter;
    [self.myScrollView addSubview:tittleLabel];
    
    UIView *blineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tittleLabel.frame), CGRectGetMaxY(shareBtn.frame) + 35, kScreenWidth / 2 - 70, 1)];
    blineView.backgroundColor = [UIColor brownColor];
    [self.myScrollView addSubview:blineView];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(tittleLabel.frame) + 20, kScreenWidth - 40, 40)];
    firstLabel.numberOfLines = 0;
    firstLabel.font = [UIFont systemFontOfSize:15];
    firstLabel.textColor = [UIColor brownColor];
    firstLabel.text = @"1.如何领取：在分享的链接中，输入手机号即可领取。";
    [self.myScrollView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstLabel.frame), kScreenWidth - 40, 40)];
    secondLabel.text = @"2.领取时间：在19:00-24:00之间，打开活动链接，点击领取按钮即可。";
    secondLabel.font = [UIFont systemFontOfSize:15];
    secondLabel.textColor = [UIColor brownColor];
    secondLabel.numberOfLines = 0;
    [self.myScrollView addSubview:secondLabel];
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(secondLabel.frame), kScreenWidth - 40, 40)];
    thirdLabel.text = @"3.领取金额：最低领取11.11元，最高不限哦。";
    thirdLabel.font = [UIFont systemFontOfSize:15];
    thirdLabel.numberOfLines = 0;
    thirdLabel.textColor = [UIColor brownColor];
    [self.myScrollView addSubview:thirdLabel];
    
    
    UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(thirdLabel.frame) + 20, kScreenWidth - 40, 80)];
    lastLabel.text = @"如何获得更多加班费：领取加班费后，分享活动链接，召唤其他小伙伴来领取！领取的人越多，您获得大额加班费的概率就越高哦。";
    lastLabel.font = [UIFont systemFontOfSize:15];
    lastLabel.numberOfLines = 0;
    lastLabel.textColor = [UIColor brownColor];
    [self.myScrollView addSubview:lastLabel];
    
    
    //    for (int i = 0; i < 4; i++) {
    //        UILabel *tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabel_Space + i * (50 + kLabel_Space) , kScreenHeight - 64 - 40, 50, 30)];
    ////        tittleLabel.backgroundColor = [UIColor whiteColor];
    //        NSArray *tittleArray = @[@"微信好友",@"朋友圈",@"腾讯QQ",@"QQ空间"];
    //        tittleLabel.text = tittleArray[i];
    //        tittleLabel.textColor = [UIColor blackColor];
    //        tittleLabel.textAlignment = NSTextAlignmentCenter;
    //        tittleLabel.font = [UIFont systemFontOfSize:12];
    //        [self.myScrollView addSubview:tittleLabel];
    //    }
    //    for (int i = 0; i < 4; i++) {
    //        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        shareBtn.frame = CGRectMake(kShare_Space + i * (40 + kShare_Space), kScreenHeight - 64 - 40 - 40, 40, 40);
    //        shareBtn.tag = 100 + i;
    ////        shareBtn.backgroundColor = [UIColor orangeColor];
    //        [shareBtn addTarget:self action:@selector(handleShare:) forControlEvents:UIControlEventTouchUpInside];
    //        NSArray *imageArray = @[@"微信@2x",@"朋友圈@2x",@"qq@2x",@"空间@2x"];
    //        [shareBtn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
    //        [self.myScrollView addSubview:shareBtn];
    //    }
    
}
//滚动视图代理方法
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
//{
////    scrollView.scrollEnabled = false;
//         NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
////    NSLog(@"%f", scrollView.contentOffset.y);
//
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //    if (scrollView.contentOffset.y < 0) {
    //        scrollView.scrollEnabled = NO;
    //    } else {
    //        scrollView.scrollEnabled = YES;
    //    }
    
}
- (void)handleToShare {
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
    cancelBtn.backgroundColor = [UIColor orangeColor];
    [cancelBtn.layer setCornerRadius:5];
    [cancelBtn.layer setMasksToBounds:YES];
    [cancelBtn addTarget:self action:@selector(handleCancel) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancelBtn];
    
}

- (void)handleShare:(UIButton *)sender {
    
    if (sender.tag == 100) {
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
        [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"wxsession"];
        
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }else if (sender.tag == 101) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.title=self.shareTitle;
        [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"wxtimeline"];
        
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    } else if (sender.tag == 102) {
        [UMSocialData defaultData].extConfig.qqData.title=self.shareTitle;
        [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qq"];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    } else {
        [UMSocialData defaultData].extConfig.qzoneData.title=self.shareTitle;
        [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qzone"];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    }
    
    
}
- (void)handleWeixin {
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
    [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"wxsession"];
    
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    
}
- (void)handleQQ {
    
    [UMSocialData defaultData].extConfig.qqData.title=self.shareTitle;
    [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qq"];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    
}
- (void)handleWeixinFrirend {
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title=self.shareTitle;
    [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"wxtimeline"];
    
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    
}
- (void)handleZone {
    
    [UMSocialData defaultData].extConfig.qzoneData.title=self.shareTitle;
    [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qzone"];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    
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
