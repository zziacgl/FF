//
//  ShakeViewController.m
//  NewDeayou
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "ShakeViewController.h"
#import <AudioToolbox/AudioToolbox.h>//震动库
#import <AVFoundation/AVFoundation.h>
#import "JHTickerView.h"
#define kScreen_Width    [UIScreen mainScreen].bounds.size.width //屏幕宽度
#define kScreen_Height   [UIScreen mainScreen].bounds.size.height//屏幕高度
#define kBtn_Height      60 //btn高度
#define kSway_Width   kScreen_Width / 3    //摇一摇图片宽度
#define kSnowMarginLeft  arc4random() % (int)kScreen_Width //钱币下落距左边距的距离
#define kSnowWidth   arc4random() % 20 + 10//钱币的宽度

@interface ShakeViewController ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *avAudioPlayer;//播放器
}

@property (nonatomic, strong) UIImageView *pictureView;//摇一摇图片
@property (nonatomic, strong) NSMutableArray *imagesArray; //存储图片的数组
@property (nonatomic, strong) NSTimer *timer;//定时器


@end

@implementation ShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"摇摇涨涨";
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    NSString *string = [[NSBundle mainBundle] pathForResource:@"hh" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:string];
    avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //设置代理
    avAudioPlayer.delegate = self;
    //设置音乐播放次数
    //    avAudioPlayer.numberOfLoops = -1;
    //预播放
    [avAudioPlayer prepareToPlay];
    self.ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.pictureView.frame), kScreen_Width - 80, 40)];
    _ticker.backgroundColor = [UIColor grayColor];
    [_ticker setDirection:JHTickerDirectionRTL];
    [_ticker setTickerSpeed:90.0f];
    _ticker.backgroundColor = kCOLOR_R_G_B_A(241, 241, 241, 1);
    [self.view addSubview:_ticker];
    NSArray * array = [NSArray arrayWithObjects:
                       @"多多理财测试数据1",
                       @"多多理财测试数据2",
                       @"多多理财测试数据3",
                       @"多多理财测试数据4",
                       nil];
    
    [_ticker setTickerStrings:array];
    [_ticker start];

    
    // Do any additional setup after loading the view from its nib.
}
- (UIImageView *)pictureView {
    if (!_pictureView) {
        self.pictureView = [[UIImageView alloc] init];
        _pictureView.frame = CGRectMake(kScreen_Width / 4, kScreen_Width / 4, kScreen_Width / 2, kScreen_Width / 2);
        _pictureView.backgroundColor = [UIColor yellowColor];
    }
    return _pictureView;
}
//摇一摇方法
- (void)runAction {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

//能够成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //取消第一响应者
    [self resignFirstResponder];
}
//任务开始
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"摇动开始");
    [avAudioPlayer play];
}
//任务取消
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"摇动取消");
}
//任务结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"摇动结束");
    [avAudioPlayer play];
    [self money];
    if (motion == UIEventSubtypeMotionShake) {
    [self runAction];
    }
}
#pragma 钱币掉落动画
- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        self.imagesArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _imagesArray;
}
//钱币掉落
- (void)moneyFall:(UIImageView *)aImageView {
    [UIView animateWithDuration:1.5 animations:^{
        aImageView.frame = CGRectMake(aImageView.frame.origin.x, kScreen_Height , aImageView.frame.size.width, aImageView.frame.size.height);
    } completion:^(BOOL finished) {
        float x = kSnowWidth;
        aImageView.frame = CGRectMake(kSnowMarginLeft, -80, x + 40, x + 40);
        [_imagesArray addObject:aImageView];
    }];
}
//钱币动画
- (void)money {
    for (int i = 0; i < 50;  i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"金币_06"]];
        float x = kSnowWidth;
        imageView.frame = CGRectMake(kSnowMarginLeft, -80, x + 40, x + 40);
        [self.view addSubview:imageView];
        [self.imagesArray addObject:imageView];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(makeMoney) userInfo:nil repeats:YES];
}
//定时器触发事件
- (void)makeMoney {
    if ([self.imagesArray count] > 0) {
        UIImageView *imageView = [_imagesArray objectAtIndex:0];
        [self.imagesArray removeObjectAtIndex:0];
        [self moneyFall:imageView];
    }
}



//代理方法，播放完成调用的方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.timer invalidate];

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
