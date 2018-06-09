//
//  DDVRPlayerViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/10/26.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDVRPlayerViewController.h"
#import <UtoVRPlayer/UtoVRPlayer.h>
#import "DYAppDelegate.h"
#import "DDMassageViewController.h"
#import "DDRankListViewController.h"
#import "DDOtherVideoViewController.h"
#import "DDMessageModel.h"
#import "DDOtherVideoModel.h"
#import "DDBackView.h"
#import "AFNetworking.h"
#define viewHeight  40

@interface DDVRPlayerViewController ()<UVPlayerDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    DDBackView *backGroundView;
    UIView *tanView;
    UIButton *cancalBtn;
    UILabel *titleLabel;
}

@property (nonatomic, strong) NSString *onlineMP4;
@property (nonatomic, strong) UVPlayer *player;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) DDMassageViewController *massageView;
@property (nonatomic, strong) DDRankListViewController *rankListView;
@property (nonatomic, strong) UITextField *massageTF;
@property (nonatomic, strong) NSArray*dataArray;
@property (nonatomic, strong) UIImageView *selectimageview;
@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityMannger;
@end

static NSString *reward_type = @"lollipop";
static float moneyDuomi;
static float duomiNumber;
@implementation DDVRPlayerViewController
- (NSArray*)dataArray{
    if (_dataArray==nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    moneyDuomi = [[NSString stringWithFormat:@"%@", self.duomiStr] floatValue];
    //改变AppDelegate的appdelegete.allowRotation属性
    DYAppDelegate *appdelegete = (DYAppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegete.allowRotation = YES;

}

- (void)loadData{
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"video" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_video_one" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
    
    [diyouDic1 insertObject:self.videoID forKey:@"id" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess) {
            
            self.otherModel = [DDOtherVideoModel mj_objectWithKeyValues:object];
//            self.dataArray = [DDMessageModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
//            NSLog(@"%@",object);
            [self configPlayer];
            [self configTitleViewData];
            if (self.myScrollView) {
                
                [self.myScrollView removeFromSuperview];
            }
            self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 141, kMainScreenWidth, kMainScreenHeight / 3 * 2 - 141)];
            _myScrollView.backgroundColor = kCOLOR_R_G_B_A(239, 239, 244, 1);
            _myScrollView.contentSize = CGSizeMake(2 * kMainScreenWidth,kMainScreenHeight / 3 * 2 - 140);
            _myScrollView.showsVerticalScrollIndicator = YES;
            _myScrollView.showsHorizontalScrollIndicator = YES;
            _myScrollView.bounces = NO;
            _myScrollView.pagingEnabled = YES;
            _myScrollView.delegate = self;
            
            [self.customView addSubview:self.myScrollView];
             self.massageView = [[DDMassageViewController alloc] init];
            _massageView.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight / 3 * 2 - 141);
//            _massageView.dataArray = self.dataArray;
            _massageView.videoID = [NSString stringWithFormat:@"%@", [object objectForKey:@"id"]];
            [self addChildViewController:self.massageView];
            
            self.rankListView = [[DDRankListViewController alloc] init:self.videoID];
            _rankListView.view.frame = CGRectMake(kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight / 3 * 2 - 141);
            [self addChildViewController:self.rankListView];
            [self.myScrollView addSubview:self.massageView.view];
            [self.myScrollView addSubview:self.rankListView.view];
            
        }else{
            [LeafNotification showInController:self withText:errorMessage];
        }
        
    } fail:^{
        
    }];
    
    
}
- (void)netAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您正在使用非WiFi网络，是否继续播放" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.player prepareToRelease];
        [self.navigationController popViewControllerAnimated:YES];

        
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"会之声%@", self.videoUrl);
    self.reachabilityMannger =   [AFNetworkReachabilityManager sharedManager];
    [_reachabilityMannger startMonitoring];
     __weak typeof(self) wSelf = self;
    [_reachabilityMannger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *result = @"";
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                result = @"未知网络";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                result = @"无网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                result = @"WAN";
                [wSelf netAlert];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                result = @"WIFI";
//                [wSelf netAlert];
                
                break;
                
            default:
                break;
        }
//        NSLog(@"%@", result);
    }];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.player.viewStyle = UVPlayerViewStyleDefault;
    
    if (self.player.viewStyle == UVPlayerViewStyleDefault) {
        //默认界面。设置竖屏返回按钮动作
        [self.player setPortraitBackButtonTarget:self selector:@selector(back:)];
    }
    //把要播放的内容添加到播放器

    [self.view addSubview:self.player.playerView];
    
    //配置视图
    [self loadData];
     [self configTitleView];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}
- (void)configPlayer{
    UVPlayerItem *item = [[UVPlayerItem alloc] initWithPath:self.otherModel.video_url type:UVPlayerItemTypeOnline];

       [self.player appendItem:item];
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //调整frame。你可以使用任何其它布局方式保证播放视图是你期望的大小
    CGRect frame;
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        //        self.navigationController.navigationBarHidden = YES;
        frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        self.customView.alpha = 0;
    } else {
        //        self.navigationController.navigationBarHidden = NO;
        frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight / 3);
       
        self.customView.alpha = 1;
        
    }
    self.player.playerView.frame = frame;
    
}
#pragma mark- 配置视频下面视图

- (void)configTitleViewData{
     titleLabel.text = self.otherModel.video_title;
    
}
- (void)configTitleView {
    self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight / 3, kMainScreenWidth, kMainScreenHeight / 3 * 2)];
    [self.view addSubview:self.customView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, viewHeight)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.customView addSubview:titleView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kMainScreenWidth / 3 * 2, viewHeight)];
    titleLabel.text = self.videoTitle;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [HeXColor colorWithHexString:@"#333333"];
    [titleView addSubview:titleLabel];
    
    UIButton *otherVedio = [UIButton buttonWithType:UIButtonTypeCustom];
    otherVedio.frame = CGRectMake(kMainScreenWidth - 82, 0, 70, viewHeight);
    [otherVedio setTitle:@"查看往期" forState:UIControlStateNormal];
    otherVedio.titleLabel.font = [UIFont systemFontOfSize:14];
    [otherVedio setTitleColor:[HeXColor colorWithHexString:@"#fd5353"] forState:UIControlStateNormal];
    [otherVedio addTarget:self action:@selector(handleOtherVedio) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:otherVedio];
    
    UIView *rewardView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight, kMainScreenWidth, 60)];
    rewardView.backgroundColor = kCOLOR_R_G_B_A(239, 239, 245, 1);
    [self.customView addSubview:rewardView];
    
    UIButton *rewardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rewardBtn.frame = CGRectMake(kMainScreenWidth / 5, 10, kMainScreenWidth / 5 * 3, viewHeight);
    rewardBtn.backgroundColor = kMainColor2;
    [rewardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [rewardBtn setTitle:@"❤打赏鼓励下" forState:UIControlStateNormal];
    [rewardBtn setBackgroundImage:[UIImage imageNamed:@"video_btn"] forState:UIControlStateNormal];
    rewardBtn.layer.cornerRadius = 5.0f;
    rewardBtn.layer.masksToBounds = YES;
    [rewardBtn addTarget:self action:@selector(handleReward) forControlEvents:UIControlEventTouchDown];
    [rewardView addSubview:rewardBtn];
    
    UIView *minView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kMainScreenWidth, viewHeight)];
    [self.customView addSubview:minView];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, kMainScreenWidth / 2, viewHeight);
    [_leftBtn setTitle:@"留言板" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:kMainColor2 forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_leftBtn addTarget:self action:@selector(handleLeft:) forControlEvents:UIControlEventTouchUpInside];
    [minView addSubview:self.leftBtn];
    
    UIView *cutLineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2, 8, 1, 24)];
    cutLineView.backgroundColor = [UIColor lightGrayColor];
    cutLineView.alpha = 0.5;
    [minView addSubview:cutLineView];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(kMainScreenWidth / 2 + 1, 0, kMainScreenWidth / 2 - 1, viewHeight);
    [_rightBtn setTitle:@"排行榜" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightBtn addTarget:self action:@selector(handleRight:) forControlEvents:UIControlEventTouchUpInside];
    [minView addSubview:self.rightBtn];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight, kMainScreenWidth, 0.5)];
    backView.backgroundColor = [UIColor lightGrayColor];
    backView.alpha = 0.5;
    [minView addSubview:backView];
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 10, viewHeight - 1, kMainScreenWidth / 10 * 3, 1)];
    _lineView.backgroundColor = kMainColor2;
    [minView addSubview:self.lineView];
    
  
    
    
    
  
    
    

}
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int a = scrollView.contentOffset.x / kMainScreenWidth;
    if (a == 0) {
        self.lineView.frame = CGRectMake(kMainScreenWidth / 10, viewHeight - 1, kMainScreenWidth / 10 * 3, 1);
        [_leftBtn setTitleColor:kMainColor2 forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }else {
         self.lineView.frame = CGRectMake(kMainScreenWidth / 10 + kMainScreenWidth / 2, viewHeight - 1, kMainScreenWidth / 10 * 3, 1);
        [_leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:kMainColor2 forState:UIControlStateNormal];
    }
   
    
}
//往期视频
- (void)handleOtherVedio {
       DDOtherVideoViewController *otherVC = [[DDOtherVideoViewController alloc] initWithNibName:@"DDOtherVideoViewController" bundle:nil];
    otherVC.returnBlock = ^(DDOtherVideoModel*model){
        [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.lineView.frame = CGRectMake(kMainScreenWidth / 10, viewHeight - 1, kMainScreenWidth / 10 * 3, 1);
        [_leftBtn setTitleColor:kMainColor2 forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        self.videoID = model.videoID;
        [self loadData];
        
    };
    [self.navigationController pushViewController:otherVC animated:YES];
}
//打赏
- (void)handleReward {
    backGroundView = [[DDBackView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    backGroundView.backgroundColor = [UIColor blackColor];
    backGroundView.alpha = 0.7;
    [self.tabBarController.view addSubview:backGroundView];
    
    cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancalBtn.frame = CGRectMake(kMainScreenWidth - 55, (kMainScreenHeight - 64)/ 2 - 205, 25, 25);
    [cancalBtn setImage:[UIImage imageNamed:@"bounced_close"] forState:UIControlStateNormal];
    [cancalBtn addTarget:self action:@selector(handleCancal) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:cancalBtn];
    
    tanView = [[UIView alloc] initWithFrame:CGRectMake(20, (kMainScreenHeight - 64)/ 2 - 170, kMainScreenWidth - 40, 320)];
    tanView.backgroundColor = [UIColor whiteColor];
    tanView.layer.cornerRadius = 5;
    tanView.layer.masksToBounds = YES;
    [self.tabBarController.view addSubview:tanView];
    
    
    NSArray *imageAry = @[@"bounced_sugar",@"bounced_handclap",@"bounced_sbrick",@"bounced_flower",@"bounced_lluckstar",@"bounced_diamond"];
    NSArray *giftNameAry = @[@"棒棒糖",@"掌声",@"砖头",@"玫瑰花",@"幸运星",@"钻石"];
    NSArray *giftNumberAry = @[@"8多米",@"20多米",@"66多米",@"100多米",@"188多米",@"520多米"];
    
    for (int i = 0; i < 2; i++) {
        for (int j = 0 ; j < 3; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(((kMainScreenWidth - 40) / 3) * j , 100 * i , (kMainScreenWidth - 40) / 3, 100);
            //            btn.backgroundColor = [UIColor yellowColor];
            [btn addTarget:self action:@selector(handleChoseGift:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100 + j + (i + 1) * (i + 1);
            
            [tanView addSubview:btn];
            UIImageView *choseImage = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth - 40) / 3 - 20, 5, 15, 15)];
            choseImage.image = [UIImage imageNamed:@"bounced_pitch"];
            choseImage.alpha = 0;
            choseImage.tag = 200 + j + (i + 1) * (i + 1);
            if (choseImage.tag == 201) {
                choseImage.alpha = 1;
                self.selectimageview = choseImage;
            }
            
//            NSLog(@"%ld", (long)choseImage.tag);
            [btn addSubview:choseImage];
            UIImageView *giftImage = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth - 40) / 6 - 20 , 10, 40, 40)];
            //            giftImage.backgroundColor = [UIColor orangeColor];
            [btn addSubview:giftImage];
            giftImage.image = [UIImage imageNamed:imageAry[btn.tag - 101]];
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, (kMainScreenWidth - 40) / 3, 20)];
            nameLabel.text = giftNameAry[btn.tag - 101];
            nameLabel.textColor = [HeXColor colorWithHexString:@"#666666"];
            nameLabel.font = [UIFont systemFontOfSize:13];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:nameLabel];
            
            UILabel *giftNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, (kMainScreenWidth - 40) / 3, 20)];
            giftNumberLabel.text = giftNumberAry[btn.tag - 101];
            giftNumberLabel.textAlignment = NSTextAlignmentCenter;
            giftNumberLabel.textColor = [HeXColor colorWithHexString:@"#ff6c14"];
            giftNumberLabel.font = [UIFont systemFontOfSize:12];
            [btn addSubview:giftNumberLabel];
        }
        
    }
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kMainScreenWidth - 40, 0.5)];
    firstLineView.backgroundColor = [UIColor lightGrayColor];
    firstLineView.alpha = 0.5;
    [tanView addSubview:firstLineView];
    UIView *secondLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, kMainScreenWidth - 40, 0.5)];
    secondLineView.backgroundColor = [UIColor lightGrayColor];
    secondLineView.alpha = 0.5;
    [tanView addSubview:secondLineView];
    UIView *thirdLineView = [[UIView alloc] initWithFrame:CGRectMake((kMainScreenWidth - 40) / 3, 0, 0.5, 200)];
    thirdLineView.backgroundColor = [UIColor lightGrayColor];
    thirdLineView.alpha = 0.5;
    [tanView addSubview:thirdLineView];
    UIView *forthLineView = [[UIView alloc] initWithFrame:CGRectMake(((kMainScreenWidth - 40) / 3) * 2, 0, 0.5, 200)];
    forthLineView.backgroundColor = [UIColor lightGrayColor];
    forthLineView.alpha = 0.5;
    [tanView addSubview:forthLineView];
    
    self.massageTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 210, kMainScreenWidth - 60, 50)];
    _massageTF.placeholder = @"留个言呗~（限20个字符）";
    //    _massageTF.textColor = [UIColor lightGrayColor];
    _massageTF.layer.borderWidth = 0.5f;
    //    _massageTF.layer.cornerRadius = 5;
    _massageTF.font = [UIFont systemFontOfSize:13];
    _massageTF.delegate = self;
    _massageTF.layer.borderColor = kCOLOR_R_G_B_A(220, 220, 220, 1).CGColor;
    [tanView addSubview:self.massageTF];
    __weak typeof(self) wSelf = self;

    
    backGroundView.block = ^(){
        [ wSelf.massageTF resignFirstResponder];
        
    };
    
    
    UILabel *duomiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, kMainScreenWidth - 60 - 60, 20)];
    duomiLabel.text = self.duomiStr;
   
    NSString *str = [NSString stringWithFormat:@"%.2f", moneyDuomi];
    NSUInteger len1 = [str length];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余多米数：%@", str]];
    [str3 addAttribute:NSForegroundColorAttributeName value:[HeXColor colorWithHexString:@"#ff6c14"] range:NSMakeRange(6,len1)];
    duomiLabel.attributedText=str3;
    duomiLabel.font = [UIFont systemFontOfSize:12];
    [tanView addSubview:duomiLabel];
    
    UIButton *rewardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rewardBtn.frame = CGRectMake(kMainScreenWidth- 40 - 10 - 100, 275, 100, 30);
    rewardBtn.backgroundColor = kMainColor2;
    rewardBtn.layer.cornerRadius = 5;
    rewardBtn.layer.masksToBounds = YES;
    [rewardBtn setTitle:@"赏" forState:UIControlStateNormal];
    [rewardBtn addTarget:self action:@selector(handleSenderGift) forControlEvents:UIControlEventTouchUpInside];
    [rewardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tanView addSubview:rewardBtn];
}
#pragma mark - 礼物选择
- (void)handleChoseGift:(UIButton *)sender {
    
    self.selectimageview.alpha = 0;
    UIImageView *imageview =   [sender viewWithTag:sender.tag+100];
    imageview.alpha = 1;
    self.selectimageview = imageview;
    switch (sender.tag) {
        case 101:
            
            reward_type = @"lollipop";
            duomiNumber = 8;
            break;
        case 102:
            duomiNumber = 20;
            reward_type = @"applause";
            break;
        case 103:
            duomiNumber = 66;
            reward_type = @"brick";
            break;
        case 104:
           duomiNumber = 100;
            reward_type = @"flower";
            break;
        case 105:
           duomiNumber = 188;
            reward_type = @"lucky_star";
            break;
        case 106:
            duomiNumber = 520;
            reward_type = @"diamonds";
            break;
            
        default:
            break;
    }
    
}
//赏礼物
- (void)handleSenderGift {
    NSString *str = @"";
    NSString *str1 = @"";
    if (self.massageTF.text.length == 0) {
        if ([reward_type isEqualToString:@"lollipop"]) {
            str1 = @"棒棒糖";
        }else if ([reward_type isEqualToString:@"applause"]){
            str1 = @"掌声";
        }else if ([reward_type isEqualToString:@"brick"]){
            str1 = @"砖头";
        }else if ([reward_type isEqualToString:@"flower"]){
            str1 = @"鲜花";
        }else if ([reward_type isEqualToString:@"lucky_star"]){
            str1 = @"幸运星";
        }else if ([reward_type isEqualToString:@"diamonds"]){
            str1 = @"钻石";
        }
        str = [NSString stringWithFormat:@"送出一个%@,o(￣▽￣)ｄ", str1];
    }else {
        str = self.massageTF.text;
    }
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"video" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"reward" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d", [DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic1 insertObject:@"1" forKey:@"reward_num" atIndex:0];
    [diyouDic1 insertObject:self.videoID forKey:@"video_id" atIndex:0];
    [diyouDic1 insertObject:reward_type forKey:@"reward_type" atIndex:0];
    [diyouDic1 insertObject:str  forKey:@"message" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess) {
//            NSLog(@"isSuccess%@", object);
            [self handleCancal];
            [self loadData];
            moneyDuomi = moneyDuomi - duomiNumber;
            
            
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"多米余额不足" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self handleCancal];
                
            }]];
             [self presentViewController:alertController animated:YES completion:nil];
            
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"多米余额不足" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            alertView.tag = 888;
//            alertView.delegate = self;
//            [alertView show];
        }
        
    } fail:^{
        
    }];
    
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    float tanHeight = kMainScreenHeight - CGRectGetMaxY(tanView.frame);
    if (self.massageTF.editing) {
        [UIView animateWithDuration:0.1
                         animations:^()
         {
             tanView.transform = CGAffineTransformMakeTranslation(0, - (height - tanHeight));
             cancalBtn.transform = CGAffineTransformMakeTranslation(0, - (height - tanHeight));
         }];
    }
    
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    [UIView animateWithDuration:0.1
                     animations:^()
     {
         //         self.btnBuyInvestNow.transform = CGAffineTransformMakeTranslation(0, 0);//这里的坐标是与原始的比较；
         tanView.transform = CGAffineTransformMakeTranslation(0, 0);
         cancalBtn.transform = CGAffineTransformMakeTranslation(0, 0);
         
     }];
    
}

#pragma mark - UITextFieldDelegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [backGroundView endEditing:YES];
    
    [self.massageTF resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.massageTF resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField.text.length> 20) {
        return NO;
    }
    return YES;
}

- (void)handleCancal {
    [cancalBtn removeFromSuperview];
    backGroundView.alpha = 0;
    [backGroundView removeFromSuperview];
    [tanView removeFromSuperview];
}
- (void)handleLeft:(UIButton *)sender {
     [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.lineView.frame = CGRectMake(kMainScreenWidth / 10, viewHeight - 1, kMainScreenWidth / 10 * 3, 1);
    [_leftBtn setTitleColor:kMainColor2 forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

}
- (void)handleRight:(UIButton *)sender {
    [self.myScrollView setContentOffset:CGPointMake(kMainScreenWidth, 0) animated:YES];
    self.lineView.frame = CGRectMake(kMainScreenWidth / 10 + kMainScreenWidth / 2, viewHeight - 1, kMainScreenWidth / 10 * 3, 1);
    [_leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:kMainColor2 forState:UIControlStateNormal];
    
}

-(NSString*)onlineMP4 {
    if (_onlineMP4 == nil) {
        _onlineMP4 = self.videoUrl;
    }
    return _onlineMP4;
}
-(UVPlayer *)player {
    if (_player == nil) {
        _player = [[UVPlayer alloc] initWithConfiguration:nil];
        _player.delegate = self;
        
    }
    return _player;
}
-(void)back:(UIButton*)sender {
      [self.player prepareToRelease];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PanoPlayerDelegate
-(void)player:(UVPlayer *)player willBeginPlayItem:(UVPlayerItem *)item {
    if (player.viewStyle == UVPlayerViewStyleDefault) {
        //设置横屏显示的title为当前播放资源的路径。你可以设置为其它的任何内容
        [player setTitleText:self.videoTitle];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //退出时不要忘记调用prepareToRelease
    [self.reachabilityMannger stopMonitoring];
    DYAppDelegate *appdelegete = (DYAppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegete.allowRotation = NO;
}

- (BOOL)shouldAutorotate {
    return YES;
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
