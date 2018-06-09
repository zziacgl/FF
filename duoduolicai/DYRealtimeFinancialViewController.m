//
//  DYRealtimeFinancialViewController.m
//  NewDeayou
//
//  Created by diyou on 14-7-10.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYRealtimeFinancialViewController.h"
#import "PullingRefreshTableView.h"
#import "DYRealtimeFianacailHeadTableViewCell.h"
#import "DYRealtimeFianacailContentTableViewCell.h"
#import "DYFinancialRecordsVC.h"
#import "DYWithdrawalViewController.h"
#import "DYBankCardVC.h"
#import "DYMyAcountMainVC.h"
#import "DYBankCardVC.h"
#import "DYMainTabBarController.h"
#import "DYAppDelegate.h"
#import "DYMyInvestmentRecordViewController.h"

#import "DDTeamViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SwayViewController.h"
#import "DDSmallWalletViewController.h"
#import "DDRechargeViewController.h"
#import "DDRechargeViewController_4s.h"
#import "DDLingQianBaoRecordViewController.h"
#import "DYShareViewController.h"

#import "DDNewRechargeViewController.h"

#import "DDMailMessageViewController.h"

#import "DYMessageCenterViewController.h"
#import "DDWorkViewController.h"
#import "DDLuckViewController.h"
#import "DDJiaBanFeiSeeingViewController.h"
#import "LeafNotification.h"
#import "JXTCacher.h"
#import "DDOtherRechargeViewController.h"

#define kCoinCountKey   100     //金币总数
@interface DYRealtimeFinancialViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIAlertViewDelegate, AVAudioPlayerDelegate>
{
    
    UINib * nibHead;     // 复用cell的nib
    UINib * nibContent;
    UINib * nibBottom;
    
    NSArray * aryCellData; // 标记cell的个数和高度
    BOOL isViewDidLoad; // 标记第一次刷新
    id objectData; // 判断是否绑定银行卡
    id userData; // 判断是否进行实名认证
    BOOL isbank;  // 判断是否绑定银行卡
    UIView *background;
    UIView *tanView;
    UIView *shareView;
    
    UIImageView     *_bagView;      //福袋图层
    NSMutableArray  *_coinTagsArr;  //存放生成的所有金币对应的tag值
    
    NSString *realname;
    NSString *card_id;
    
}
@property (nonatomic, strong)PullingRefreshTableView * tableView; // 第三方下拉刷新tableview
@property (nonatomic, strong) NSMutableArray *imagesArray; //存储图片的数组
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;//播放器
@property (nonatomic,strong)NSDictionary *LingQianBao_Info;

//银行卡信息
@property (nonatomic) BOOL isBindBank;//是否绑定银行卡
@property (nonatomic) int BankType;//银行类型
@property (nonatomic,strong)NSString *BankNo;//银行卡号
@property (nonatomic,strong)NSString *gotexpgold;//送体验金
@property(nonatomic)int n;

@property (nonatomic,strong) NSTimer *timer_number;
@property (nonatomic) float start;
@property (nonatomic) float end;
@property (nonatomic) float content;

@property (nonatomic,strong) NSString *badgeValue;

@property (nonatomic,strong) NSString *duomi;//可兑换多米数

@property (nonatomic,strong) NSString *TopImage_String;
@property (nonatomic,strong) NSString *NiName_String;

@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic, strong) UIButton *btnRightItem;

@property (nonatomic)int badge;

@property(nonatomic)BOOL isGetRecharge100;
@property(nonatomic)BOOL isGetRecharge1000;

@end

@implementation DYRealtimeFinancialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"账户";
        
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    isbank = NO;
    self.n=1;
    //设置下拉刷新tableView
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain topTextColor:[UIColor whiteColor] topBackgroundColor:nil bottomTextColor:[UIColor blackColor] bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor]; // 背景颜色
    _tableView.headerOnly = YES;
    _tableView.pullingDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.headerView.backgroundColor=kMainColor2; // 头颜色
    _tableView.footerView.backgroundColor=[UIColor clearColor]; // 脚颜色
//    _tableView.hidden = YES;
    
    [self.view addSubview:_tableView];
    
    //设置cell的个数和高度
    aryCellData = @[@"190",@"551"];
    //导航右边的按钮
    UIButton * btnRightItem=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor=[UIColor clearColor];
    btnRightItem.frame=CGRectMake(0, 0, 30.0f, 30.0f);
    if (self.badge>0) {
        [btnRightItem setBackgroundImage:[UIImage imageNamed:@"账户（消息1）_03@2x.png"] forState:UIControlStateNormal];
    }else{
        [btnRightItem setBackgroundImage:[UIImage imageNamed:@"账户_（消息）_03@2x.png"] forState:UIControlStateNormal];
    }
    
    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    [btnRightItem addTarget:self action:@selector(mailPage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    
    [_tableView reloadData];

    
}
-(void)mailPage{
    DDMailMessageViewController *mailVC=[[DDMailMessageViewController alloc]initWithNibName:@"DDMailMessageViewController" bundle:nil];
    mailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:mailVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //成为第一响应者.
    [self becomeFirstResponder];
    CGRect bounds = self.view.bounds;
    bounds.size.height = kScreenSize.height - 20 - 94;
    _tableView.frame = bounds;
    
    [objectData removeAllObjects];
    if(![DYUser loginIsLogin]){
        [self firstpressed];
    }
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    _data=[ud objectForKey:@"data"];
    
    if ([_data count]>0) {
        self.TopImage_String=[NSString stringWithFormat:@"%@",[_data objectForKey:@"avatar"]];
        self.NiName_String=[NSString stringWithFormat:@"%@",[_data objectForKey:@"niname"]];
        self.duomi=[NSString stringWithFormat:@"%@",[_data objectForKey:@"balance"]];
    }
    
    int badge=[[NSString stringWithFormat:@"%@",[_data objectForKey:@"badge"]] intValue];
    
    if (badge>0) {
        self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%@",[_data objectForKey:@"badge"]];
        //        [UIApplication sharedApplication].applicationIconBadgeNumber=badge;
    }
    [[JXTCacher cacher] objectForKey:@"账户" userId:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] achive:^(JXTCacher *cacher, id obj, CacheError error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (obj && error == 0) {  //local or cache have data
                
                NSLog(@"%@",obj);
                NSDictionary *dic=obj;
                NSLog(@"%@", dic);
                realname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"realname"]];
                card_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_id"]];
                NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                [ud setObject:dic forKey:@"data"];
                
                NSDictionary *BankInfoDic=dic;
                if ([[BankInfoDic objectForKey:@"account"] isKindOfClass:[NSString class]]) {
                    
                    if ([[BankInfoDic objectForKey:@"account"]length]>0&&[[BankInfoDic objectForKey:@"account"]isEqualToString:@""]==NO) {
                        isbank=YES;
                    }
                    
                }
                
                NSString *bankNo=[NSString stringWithFormat:@"%@",[BankInfoDic objectForKey:@"account_all"]];
                if (![bankNo isEqualToString:@""]&&bankNo.length>0) {
                    self.isBindBank=YES;
                    self.BankNo=bankNo;
                    self.BankType=[[BankInfoDic objectForKey:@"bank"]intValue];
                }else{
                    self.isBindBank=NO;
                }
                
                userData = dic;
                NSString *paypassword_status=[NSString stringWithFormat:@"%@",[userData objectForKey:@"paypassword_status"]];
                [ud setObject:paypassword_status forKey:@"paypassword_status"];
                NSString *phone_status=[NSString stringWithFormat:@"%@",[userData objectForKey:@"phone_status"]];
                [ud setObject:phone_status forKey:@"phone_status"];
                NSString *realname_status=[NSString stringWithFormat:@"%@",[userData objectForKey:@"realname_status"]];
                [ud setObject:realname_status forKey:@"realname_status"];
                if ([phone_status isEqualToString:@"1"]) {
                    NSString *phone=[NSString stringWithFormat:@"%@",[userData objectForKey:@"phone"]];
                    [ud setObject:phone forKey:@"phone"];
                }
                
                
                objectData=dic;
                
                self.LingQianBao_Info=dic;
                
                NSDictionary *DuoMiDic=dic;
                self.duomi=[NSString stringWithFormat:@"%@",[DuoMiDic objectForKey:@"balance"]];
                
                NSLog(@"%@",objectData);
                if (self.LingQianBao_Info!=nil&&objectData!=nil) {
                    _tableView.hidden = NO;
                    [_tableView reloadData];
                }
                
                //            [self getdata];
                
                self.TopImage_String=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
                self.NiName_String=[NSString stringWithFormat:@"%@",[dic objectForKey:@"niname"]];
                [ud setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"sex"]] forKey:@"sex"];//性别
                [ud setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"niname"]] forKey:@"niname"];//昵称
                [ud setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]] forKey:@"avatar"];//头像
                
                NSDate *today = [NSDate date];//当前时间
                NSLog(@"零钱宝%@",today);
                
                float annual=[[self.LingQianBao_Info objectForKey:@"annual"] floatValue];
                [ud setObject:[NSString stringWithFormat:@"%.2f",annual] forKey:@"annual"];
                [ud setObject:[NSString stringWithFormat:@"%@",[self.LingQianBao_Info objectForKey:@"gotexpgold"]] forKey:@"gotexpgold"];
                self.gotexpgold=[NSString stringWithFormat:@"%@",[self.LingQianBao_Info objectForKey:@"gotexpgold"]];
                NSLog(@"ffffffffff%@", self.gotexpgold);
                
                
                NSDictionary *MessageDic=dic;
                NSString *badge=[NSString stringWithFormat:@"%@",[MessageDic objectForKey:@"message_no"]];
                self.badge=[badge intValue];
                if ([badge intValue]>0) {
                    self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%@",[MessageDic objectForKey:@"badge"]];
                    //                 [UIApplication sharedApplication].applicationIconBadgeNumber=[badge intValue];
                }
            }
            else { // local and cache have no data
                
                NSDictionary *mudic = [self fixedData]; //generate data
                [cacher setObject:mudic // save data to local disk and cache
                           forKey:@"账户"
                           userId:[NSString stringWithFormat:@"%d",[DYUser GetUserID]]
                       useArchive:YES
                           setted:^(JXTCacher *cacher, CacheError error) {
                           }];
                objectData = mudic;
                [self.tableView reloadData];
            }
            
        });
    }];

   
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    [self testFrefreshTableView];
}
-(NSDictionary *)fixedData{
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_users" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success==YES) {
             
             NSDictionary *dic=object;
             objectData=dic;
         }
     } errorBlock:^(id error)
     {
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
    
    return objectData;
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    //    [_tableView launchRefreshing];
//    
//    [self testFrefreshTableView];
//    
//    
//}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.btnRightItem.imageView removeFromSuperview];
    [self.btnRightItem removeFromSuperview];
    //    [MobClick endLogPageView:@"账户页面"];
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件


- (void)firstpressed
{
    [DYUser  loginShowLoginView];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _coinTagsArr = [NSMutableArray new];
    [self viewDidAfterLoad]; // 视图在加载完之后出现
    
}

// 充值
-(void)rechargeMoney
{
    if (self.isBindBank) {
        DDRechargeViewController *rechargeVC=[[DDRechargeViewController alloc]initWithNibName:@"DDRechargeViewController" bundle:nil];
        rechargeVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:rechargeVC animated:YES];
        rechargeVC.isBindBank=self.isBindBank;
        rechargeVC.BankType=self.BankType;
        rechargeVC.Bankno=self.BankNo;
        rechargeVC.gotexpgold=self.gotexpgold;
        rechargeVC.type=1;
        self.view.userInteractionEnabled=YES;
    }else{
//        DDRechargeViewController_4s *rechargeVC=[[DDRechargeViewController_4s alloc]initWithNibName:@"DDRechargeViewController_4s" bundle:nil];
//        rechargeVC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:rechargeVC animated:YES];
//        rechargeVC.isBindBank=self.isBindBank;
//        rechargeVC.gotexpgold=self.gotexpgold;
//        rechargeVC.type=1;
//        self.view.userInteractionEnabled=YES;
//        NSLog(@"aaaaaa%@", self.gotexpgold);
        
        NSArray *array=[self.gotexpgold componentsSeparatedByString:@","];
        for (NSString *a in array) {
            if ([a isEqualToString:@"2"]) {
                self.isGetRecharge100=YES;
            }
            if ([a isEqualToString:@"3"]) {
                self.isGetRecharge1000=YES;
            }
        }
        if (self.isGetRecharge100&&self.isGetRecharge1000) {
           
            DDOtherRechargeViewController *otherVC = [[DDOtherRechargeViewController alloc] initWithNibName:@"DDOtherRechargeViewController" bundle:nil];
            otherVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:otherVC animated:YES];
            otherVC.isBindBank = self.isBindBank;
            otherVC.gotexpgold = self.gotexpgold;
            otherVC.type = 1;
        }else {
            DDRechargeViewController_4s *rechargeVC=[[DDRechargeViewController_4s alloc]initWithNibName:@"DDRechargeViewController_4s" bundle:nil];
            rechargeVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:rechargeVC animated:YES];
            rechargeVC.isBindBank=self.isBindBank;
            rechargeVC.gotexpgold=self.gotexpgold;
            rechargeVC.type=1;
            self.view.userInteractionEnabled=YES;

        
        }

        
    }
    
    
    
}
//提现
- (void)withdrawalMoney
{
    
    self.view.userInteractionEnabled = NO;
    if (isbank==YES)
    {
        //已经投过标了
        DYWithdrawalViewController *withdrawalVC=[[DYWithdrawalViewController alloc]initWithNibName:@"DYWithdrawalViewController" bundle:nil];
        withdrawalVC.hidesBottomBarWhenPushed=YES;
        withdrawalVC.isBindBank=self.isBindBank;
        withdrawalVC.BankType=self.BankType;
        withdrawalVC.Bankno=self.BankNo;
        [self.navigationController pushViewController:withdrawalVC animated:YES];
        
    }
    else//未绑定银行卡
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"无法提现" message:@"未绑定银行卡，绑卡需充值，充值之后自动绑卡。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertview show];
    }
    self.view.userInteractionEnabled=YES;
    
}
#pragma mark- tableViewDelegate
// 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryCellData.count; // cell的个数
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [aryCellData[indexPath.row] floatValue]; // cell的高度
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *lb=[self.view viewWithTag:300];
    [lb removeFromSuperview];
    if (indexPath.row==0) {
        //head
        NSString * markReuse = @"markHead";
        if (!nibHead)
        {
            nibHead = [UINib nibWithNibName:@"DYRealtimeFianacailHeadTableViewCell" bundle:nil];
            [tableView registerNib:nibHead forCellReuseIdentifier:markReuse];
        }
        DYRealtimeFianacailHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:markReuse];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        if ([objectData count]>0) {
            [self DYRealtimeFianacailHeadTableViewCell:cell dic:objectData];
        }else{
            if ([self.data count]>0) {
                [self DYRealtimeFianacailHeadTableViewCell:cell dic:self.data];
            }
        }
        
        return cell;
    }
    else {
        //content
        NSString * mark1 = @"markContent";
        if (!nibContent)
        {
            nibContent = [UINib nibWithNibName:@"DYRealtimeFianacailContentTableViewCell" bundle:nil];
            [tableView registerNib:nibContent forCellReuseIdentifier:mark1];
        }
        DYRealtimeFianacailContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mark1];
        
        if ([objectData count]>0) {
            [self DYRealtimeFianacailContentTableViewCell:cell dic:objectData];
        }else{
            if ([self.data count]>0) {
                [self DYRealtimeFianacailContentTableViewCell:cell dic:self.data];
            }
            
        }
        
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        return cell;
        
    }
}
-(void)SeeJiaBanFei{
    DDJiaBanFeiSeeingViewController *JiaBanFeiSeeingVC=[[DDJiaBanFeiSeeingViewController alloc]initWithNibName:@"DDJiaBanFeiSeeingViewController" bundle:nil];
    JiaBanFeiSeeingVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:JiaBanFeiSeeingVC animated:YES];
}
static int coinCount = 0;
- (void)getCoinAction {
    //初始化金币生成的数量
    coinCount = 0;
    for (int i = 0; i<kCoinCountKey; i++) {
        
        //延迟调用函数
        [self performSelector:@selector(initCoinViewWithInt:) withObject:[NSNumber numberWithInt:i] afterDelay:i * 0.01];
    }
    
}
-(void)GetDuoMiRecord{
    DYMessageCenterViewController *VC = [[DYMessageCenterViewController alloc]initWithNibName:@"DYMessageCenterViewController" bundle:nil];
    VC.hidesBottomBarWhenPushed = YES;
    VC.duomi=self.duomi;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)initCoinViewWithInt:(NSNumber *)i
{
    UIImageView *coin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_coin_%d",[i intValue] % 2 + 1]]];
    
    //初始化金币的最终位置
    coin.center = CGPointMake(CGRectGetMidX(tanView.frame) + arc4random()%40 * (arc4random() %3 - 1) - 20, CGRectGetMidY(tanView.frame) - 20);
    coin.tag = [i intValue] + 1;
    //每生产一个金币,就把该金币对应的tag加入到数组中,用于判断当金币结束动画时和福袋交换层次关系,并从视图上移除
    [_coinTagsArr addObject:[NSNumber numberWithInt:(int)coin.tag]];
    
    [tanView addSubview:coin];
    
    [self setAnimationWithLayer:coin];
}
- (void)setAnimationWithLayer:(UIView *)coin
{
    CGFloat duration = 1.6f;
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //绘制从底部到福袋口之间的抛物线
    CGFloat positionX   = coin.layer.position.x;    //终点x
    CGFloat positionY   = coin.layer.position.y;    //终点y
    CGMutablePathRef path = CGPathCreateMutable();
    int fromX       = arc4random() % 320;     //起始位置:x轴上随机生成一个位置
    int height      = [UIScreen mainScreen].bounds.size.height + coin.frame.size.height; //y轴以屏幕高度为准
    int fromY       = arc4random() % (int)positionY; //起始位置:生成位于福袋上方的随机一个y坐标
    
    CGFloat cpx = positionX + (fromX - positionX)/2;    //x控制点
    CGFloat cpy = fromY / 2 - positionY;                //y控制点,确保抛向的最大高度在屏幕内,并且在福袋上方(负数)
    
    //动画的起始位置
    CGPathMoveToPoint(path, NULL, fromX, height);
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, positionX, positionY);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setPath:path];
    CFRelease(path);
    path = nil;
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //图像由大到小的变化动画
    CGFloat from3DScale = 1 + arc4random() % 10 *0.1;
    CGFloat to3DScale = from3DScale * 0.5;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(from3DScale, from3DScale, from3DScale)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(to3DScale, to3DScale, to3DScale)]];
    scaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //动画组合
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = duration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.animations = @[scaleAnimation, animation];
    [coin.layer addAnimation:group forKey:@"position and transform"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        
        //动画完成后把金币和数组对应位置上的tag移除
        UIView *coinView = (UIView *)[tanView viewWithTag:[[_coinTagsArr firstObject] intValue]];
        NSLog(@"bbb%d", [[_coinTagsArr firstObject] intValue]);
        [coinView removeFromSuperview];
        
        
        [_coinTagsArr removeObjectAtIndex:0];
        
        //全部金币完成动画后执行的动作
        if (++coinCount == kCoinCountKey) {
            
            [self bagShakeAnimation];
            
        }
    }
}

//福袋晃动动画
- (void)bagShakeAnimation
{
    
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:- 0.2];
    shake.toValue   = [NSNumber numberWithFloat:+ 0.2];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = 4;
    
    [_bagView.layer addAnimation:shake forKey:@"bagShakeAnimation"];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self back];
    });
    
}
- (void)back {
    [UIView animateWithDuration:0.3 animations:^{
        [tanView removeFromSuperview];
        [background removeFromSuperview];
        UIButton *btn = [self.view viewWithTag:10086];
        btn.userInteractionEnabled = YES;
        
        [self testFrefreshTableView];
        
    }];
}

- (void)shareTap {
    background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+64)];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.6;
    [self.tabBarController.view addSubview:background];
    
    shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self shakeToShow:shareView];
    [self.tabBarController.view addSubview:shareView];
    
    UIImageView *myImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, self.view.center.y - CGRectGetHeight(shareView.frame)/ 4 - 60, CGRectGetWidth(shareView.frame) - 80, CGRectGetHeight(shareView.frame)/ 2)];
    myImage.image = [UIImage imageNamed:@"体验金弹窗_03(4)"];
    
    myImage.userInteractionEnabled = YES;
    //    myImage.backgroundColor = [UIColor yellowColor];
    [shareView addSubview:myImage];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(CGRectGetMaxX(myImage.frame) - 35, CGRectGetMinY(myImage.frame), 35, 35);
    [backBtn setImage:[UIImage imageNamed:@"体验金弹窗_03"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:backBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(40,CGRectGetMaxY(myImage.frame) + 20, CGRectGetWidth(shareView.frame) - 80, 50);
    shareBtn.backgroundColor = kCOLOR_R_G_B_A(255, 186, 0, 1);
    [shareBtn.layer setMasksToBounds:YES];
    [shareBtn.layer setCornerRadius:10];
    [shareBtn setTintColor:[UIColor whiteColor]];
    [shareBtn setTitle:@"分享立即得体验金" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [shareBtn addTarget:self action:@selector(handleShare) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:shareBtn];
    
}
- (void)handleBack {
    [shareView removeFromSuperview];
    [background removeFromSuperview];
}
- (void)handleShare {
    [UIView animateWithDuration:0.1 animations:^{
        [shareView removeFromSuperview];
        background.alpha = 0;
        DYShareViewController *shareVC = [[DYShareViewController alloc] init];
        shareVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:shareVC animated:YES];
    } completion:^(BOOL finished) {
    }];
    
}
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.8;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
//加班费
- (void)handleWork {
    DDLuckViewController *luckVC = [[DDLuckViewController alloc] initWithNibName:@"DDLuckViewController" bundle:nil];
    luckVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:luckVC animated:YES];
    
}
-(void)GetTiyanjinRecord{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    //1(注册送体验金)2(充值100送体验金1000)3(充值1000送体验金2000)4(分享成功送体验金2000)5(充值10000加1%年化)
    NSString *gotexpgold=[NSString stringWithFormat:@"%@",[ud objectForKey:@"gotexpgold"]];
    
    DDLingQianBaoRecordViewController *recordVC = [[DDLingQianBaoRecordViewController alloc]initWithNibName:@"DDLingQianBaoRecordViewController" bundle:nil];
    recordVC.hidesBottomBarWhenPushed = YES;
    recordVC.Amount=[NSString stringWithFormat:@"%.2f",[[self.LingQianBao_Info objectForKey:@"kexpgold"]floatValue]];
    recordVC.type=2;//体验金
    recordVC.isZhanghu=YES;
    recordVC.gotexpgold=[NSString stringWithFormat:@"%@",gotexpgold];
    [self.navigationController pushViewController:recordVC animated:YES];
}
-(void)LingqianBao{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"0" forKey:@"isDone"];
    [self.tabBarController setSelectedIndex:1];//0:首页，1：零钱包，2：投资，3：更多
}
-(void)Tuijian{
    
    DDTeamViewController *VC = [[DDTeamViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:VC animated:YES];
    
}
//跳到我的投标记录
-(void)GetInvestRecord{
    DYMyInvestmentRecordViewController *VC = [[DYMyInvestmentRecordViewController alloc]initWithNibName:@"DYMyInvestmentRecordViewController" bundle:nil];
    VC.hidesBottomBarWhenPushed = YES;
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    VC.profit = [NSString stringWithFormat:@"%@", [ud objectForKey:@"daishou"]];
    VC.Amount = [NSString stringWithFormat:@"%@", [ud objectForKey:@"yishou"]];
    [self.navigationController pushViewController:VC animated:YES];
    
    
}
//可用余额
-(void)GetRecord{
    DYFinancialRecordsVC *VC = [[DYFinancialRecordsVC alloc]initWithNibName:@"DYFinancialRecordsVC" bundle:nil];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    VC.money = [NSString stringWithFormat:@"%@", [ud objectForKey:@"nextstr"]];// 可用余额
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)gotoMyAcount{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:@"%@",[user objectForKey:@"UserName"]];
    
    DYMyAcountMainVC *VC = [[DYMyAcountMainVC alloc]initWithNibName:@"DYMyAcountMainVC" bundle:nil];
    VC.hidesBottomBarWhenPushed = YES;
    VC.phone=str;
    VC.isBank=isbank;
    VC.realname=realname;
    VC.card_id=card_id;
    VC.gotexpgold = self.gotexpgold;
    [self.navigationController pushViewController:VC animated:YES];
    
}
//摇一摇响应事件
-(void)everydaySway {
    SwayViewController *swayVC = [[SwayViewController alloc] initWithNibName:@"SwayViewController" bundle:nil];
    swayVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:swayVC animated:YES];
}
//零钱包
-(void)SmallWallet{
    //进入零钱包
    DDSmallWalletViewController *smallWalletVC = [[DDSmallWalletViewController alloc] initWithNibName:@"DDSmallWalletViewController" bundle:nil];
    smallWalletVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:smallWalletVC animated:YES];
}
#pragma mark- -scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark - pullingTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    //    [self getUsersBankOne]; // 解析过程
    [self performSelector:@selector(testFrefreshTableView) withObject:nil afterDelay:0];
}
//加载播放器
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        AVAudioSession *session = [[AVAudioSession alloc] init];
        [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        NSString *urlStr=[[NSBundle mainBundle]pathForResource:@"jinbi" ofType:@"mp3"];
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


-(void)testFrefreshTableView
{
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_users" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success==YES) {
             //            if (![self.audioPlayer isPlaying]) {
             //                [self.audioPlayer play];
             //            }
             
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
                 
             }
             NSDictionary *dic=object;
             NSLog(@"%@", dic);
             realname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"realname"]];
             card_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_id"]];
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:dic forKey:@"data"];
             
             NSDictionary *BankInfoDic=dic;
             if ([[BankInfoDic objectForKey:@"account"] isKindOfClass:[NSString class]]) {
                 
                 if ([[BankInfoDic objectForKey:@"account"]length]>0&&[[BankInfoDic objectForKey:@"account"]isEqualToString:@""]==NO) {
                     isbank=YES;
                 }
                 
             }
             
             NSString *bankNo=[NSString stringWithFormat:@"%@",[BankInfoDic objectForKey:@"account_all"]];
             if (![bankNo isEqualToString:@""]&&bankNo.length>0) {
                 self.isBindBank=YES;
                 self.BankNo=bankNo;
                 self.BankType=[[BankInfoDic objectForKey:@"bank"]intValue];
             }else{
                 self.isBindBank=NO;
             }
             
             userData = dic;
             NSString *paypassword_status=[NSString stringWithFormat:@"%@",[userData objectForKey:@"paypassword_status"]];
             [ud setObject:paypassword_status forKey:@"paypassword_status"];
             NSString *phone_status=[NSString stringWithFormat:@"%@",[userData objectForKey:@"phone_status"]];
             [ud setObject:phone_status forKey:@"phone_status"];
             NSString *realname_status=[NSString stringWithFormat:@"%@",[userData objectForKey:@"realname_status"]];
             [ud setObject:realname_status forKey:@"realname_status"];
             if ([phone_status isEqualToString:@"1"]) {
                 NSString *phone=[NSString stringWithFormat:@"%@",[userData objectForKey:@"phone"]];
                 [ud setObject:phone forKey:@"phone"];
             }
             
             
             objectData=dic;
             
             self.LingQianBao_Info=dic;
             
             NSDictionary *DuoMiDic=dic;
             self.duomi=[NSString stringWithFormat:@"%@",[DuoMiDic objectForKey:@"balance"]];
             
             NSLog(@"%@",objectData);
             if (self.LingQianBao_Info!=nil&&objectData!=nil) {
                 _tableView.hidden = NO;
                 [_tableView reloadData];
             }
             
             //            [self getdata];
             
             self.TopImage_String=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
             self.NiName_String=[NSString stringWithFormat:@"%@",[dic objectForKey:@"niname"]];
             [ud setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"sex"]] forKey:@"sex"];//性别
             [ud setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"niname"]] forKey:@"niname"];//昵称
             [ud setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]] forKey:@"avatar"];//头像
             
             NSDate *today = [NSDate date];//当前时间
             NSLog(@"零钱宝%@",today);
             
             float annual=[[self.LingQianBao_Info objectForKey:@"annual"] floatValue];
             [ud setObject:[NSString stringWithFormat:@"%.2f",annual] forKey:@"annual"];
             [ud setObject:[NSString stringWithFormat:@"%@",[self.LingQianBao_Info objectForKey:@"gotexpgold"]] forKey:@"gotexpgold"];
             self.gotexpgold=[NSString stringWithFormat:@"%@",[self.LingQianBao_Info objectForKey:@"gotexpgold"]];
             
             
             
             NSDictionary *MessageDic=dic;
             NSString *badge=[NSString stringWithFormat:@"%@",[MessageDic objectForKey:@"message_no"]];
             self.badge=[badge intValue];
             if ([badge intValue]>0) {
                 self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%@",[MessageDic objectForKey:@"badge"]];
                 //                 [UIApplication sharedApplication].applicationIconBadgeNumber=[badge intValue];
             }
             //导航右边的按钮
             UIButton * btnRightItem=[UIButton buttonWithType:UIButtonTypeCustom];
             btnRightItem.backgroundColor=[UIColor clearColor];
             btnRightItem.frame=CGRectMake(0, 0, 30.0f, 30.0f);
             if ([badge intValue]>0) {
                 [btnRightItem setBackgroundImage:[UIImage imageNamed:@"账户（消息1）_03@2x.png"] forState:UIControlStateNormal];
             }else{
                 [btnRightItem setBackgroundImage:[UIImage imageNamed:@"账户_（消息）_03@2x.png"] forState:UIControlStateNormal];
             }
             
             [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             [btnRightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
             
             [btnRightItem addTarget:self action:@selector(mailPage) forControlEvents:UIControlEventTouchUpInside];
             self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
             
             [_tableView reloadData];
             
             NSLog(@"%@",dic);
             [[JXTCacher cacher] clearObject:@"账户" userId:[NSString stringWithFormat:@"%d",[DYUser GetUserID]]];
             [[JXTCacher cacher] setObject:dic // save data to local disk and cache
                                    forKey:@"账户"
                                    userId:[NSString stringWithFormat:@"%d",[DYUser GetUserID]]
                                useArchive:YES
                                    setted:^(JXTCacher *cacher, CacheError error) {
                                    }];
         }
         else
         {
             [LeafNotification showInController:self withText:@"网络异常"];
         }
         
     } errorBlock:^(id error)
     {
         if (_tableView.headerView.isLoading)
         {
             [_tableView tableViewDidFinishedLoading];
         }
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
    
    
    if (_tableView.headerView.isLoading)
    {
        [_tableView tableViewDidFinishedLoading];
        _tableView.hidden = NO;
    }
}
#pragma mark - btnForItemAction

-(void)rightBarButtonItemActionMore
{
    DYFinancialRecordsVC *transctionVC = [[DYFinancialRecordsVC alloc]initWithNibName:@"DYFinancialRecordsVC" bundle:nil];
    transctionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:transctionVC animated:YES];
    
}
#pragma mark - 绑定数据

- (void)DYRealtimeFianacailContentTableViewCell:(DYRealtimeFianacailContentTableViewCell*)cell dic:(NSDictionary*)dic
{
    if (dic!=nil) {
        UILabel * lab=(UILabel*)[cell viewWithTag:1000];
        lab.text=[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"tender_wait_interest"]];//待收收益
        
        cell.totalMain.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"_total"]];//总资产
        
        int is_overtime=[[objectData objectForKey:@"is_overtime"] intValue];//is_overtime为1表示参加加班费，0为无加班费
        if (is_overtime==1) {
            cell.seeBnt.enabled=YES;
            cell.seeBnt.hidden=NO;
            cell.seeBnt2.enabled = YES;
            cell.seeBnt2.hidden = NO;
        }
        [cell.seeBnt2 addTarget:self action:@selector(SeeJiaBanFei) forControlEvents:UIControlEventTouchDown];
        [cell.seeBnt addTarget:self action:@selector(SeeJiaBanFei) forControlEvents:UIControlEventTouchDown];
        [cell.myBtn addTarget:self action:@selector(getMoney:) forControlEvents:UIControlEventTouchDown];
        cell.myBtn.tag = 10086;
        
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        [ud setObject:[dic DYObjectForKey:@"_balance"] forKey:@"nextstr"];
        [ud setObject:[dic DYObjectForKey:@"tender_wait_interest"] forKey:@"daishou"];
        NSString *money=[NSString stringWithFormat:@"%@",[ud objectForKey:@"BalanceEnd"]];
        int BalaneDone=[[NSString stringWithFormat:@"%@",[ud objectForKey:@"BalaneDone"]]intValue];
        self.start=[[dic DYObjectForKey:@"_balance"] floatValue]-[money floatValue];
        if (self.start<0) {
            self.start=0;
        }
        self.end=[[dic DYObjectForKey:@"_balance"] floatValue];
        self.content=[money floatValue];
        if (BalaneDone==1) {
            [self numberAnimation5:cell.totalL];
            [ud setObject:@"0" forKey:@"BalaneDone"];
        }else{
            cell.totalL.text = [NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"_balance"]];// 可用余额
        }
        
        float m=[cell.totalL.text floatValue];
        float l=[[dic DYObjectForKey:@"_balance"] floatValue];
        if (m!=l) {
            m=l;
            cell.totalL.text = [NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"_balance"]];// 可用余额
            
        }
        NSLog(@"%f",m);
        NSLog(@"%d",self.n);
        if (m>0) {
            
            if (self.n!=1) {
                NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                self.n=[[ud objectForKey:@"key"]intValue];
                NSLog(@"%d", self.n);
                
            }
            if (self.n==1) {
                self.n++;
            }
            NSLog(@"%d", self.n);
            if (self.n==2) {
                
                [cell startTimer];
                self.n=3;
                NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                [ud setObject:@"3" forKey:@"key"];
                NSLog(@"%d", [[ud objectForKey:@"key"]intValue]);
                
            }else{
                cell.totalL.text = [NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"_balance"]];// 可用余额
                
            }
        }else{
            [cell closeTimer];
            cell.totalL.text = [NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"_balance"]];// 可用余额
            
        }
        CGFloat account =[[dic DYObjectForKey:@"recover_yes_profit"] floatValue];
        [ud setObject:[dic DYObjectForKey:@"recover_yes_profit"] forKey:@"yishou"];
        
        [cell.ContentD setTitle:[NSString stringWithFormat:@"%0.2f",account] forState:UIControlStateNormal];//已获收益
        cell.MyAcountLabel.text=self.duomi;//推荐奖励
        [ud setObject:[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"_balance"]] forKey:@"balance"];
        [cell.InvestRecordBtn addTarget:self action:@selector(GetInvestRecord) forControlEvents:UIControlEventTouchDown];
        [cell.DuoMIBnt addTarget:self action:@selector(GetDuoMiRecord) forControlEvents:UIControlEventTouchDown];
        [cell.workBtn addTarget:self action:@selector(handleWork) forControlEvents:UIControlEventTouchUpInside];
        cell.tag = 888;
        NSLog(@"hhhhhhh%@",cell.LingQianBaoLabel.text);
        if ([self.LingQianBao_Info count]==0) {
            self.LingQianBao_Info=_data;
        }
        cell.LingQianBaoLabel.text =[NSString stringWithFormat:@"%.2f",[[self.LingQianBao_Info objectForKey:@"total"]floatValue]];//零钱包
        NSLog(@"%@",[self.LingQianBao_Info objectForKey:@"kexpgold"]);
        cell.myTiyanjin.text=[NSString stringWithFormat:@"%.2f",[[self.LingQianBao_Info objectForKey:@"kexpgold"]floatValue]];
        
        [cell.TuijianAward addTarget:self action:@selector(Tuijian) forControlEvents:UIControlEventTouchDown];
        
        [cell.RecordView addTarget:self action:@selector(GetRecord) forControlEvents:UIControlEventTouchDown];
        UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareTap)];
        [cell.doudongImage addGestureRecognizer:shareTap];
        //1(注册送体验金)2(充值100送体验金1000)3(充值1000送体验金2000)4(分享成功送体验金2000)5(充值10000加1%年化)
        NSString *gotexpgold=[NSString stringWithFormat:@"%@",[ud objectForKey:@"gotexpgold"]];
        NSArray *array=[gotexpgold componentsSeparatedByString:@","];
        NSLog(@"%@",array);
        
        BOOL isGet100=NO;
        BOOL isGet1000=NO;
        for (NSString *a in array) {
            if ([a isEqualToString:@"2"]) {
                isGet100=YES;
            }
            if ([a isEqualToString:@"3"]) {
                isGet1000=YES;
            }
            if ([a isEqualToString:@"4"]) {
                //分享送2000
                cell.doudongImage.alpha=0;
                [cell.timer3 invalidate];
            }
        }
        [cell.LingqianBaoBnt addTarget:self action:@selector(LingqianBao) forControlEvents:UIControlEventTouchDown];
        [cell.tiyanjinBnt addTarget:self action:@selector(GetTiyanjinRecord) forControlEvents:UIControlEventTouchDown];
    }
}
-(void)numberAnimation5:(UILabel *)label{
    _timer_number = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                     target:self
                                                   selector:@selector(numberAnimation5)
                                                   userInfo:nil
                                                    repeats:YES];
    label.tag=100;
}
-(void)numberAnimation5{
    UILabel *lb=[self.view viewWithTag:100];
    self.start+=self.content/8;
    if (self.start>self.end) {
        lb.text=[NSString stringWithFormat:@"%.2f",self.end];
        [_timer_number invalidate];
        _timer_number=nil;
        return;
    }
    lb.text=[NSString stringWithFormat:@"%.2f",self.start];
    NSLog(@"%f,%f,%f", self.start,self.content,self.end);
    
}

-(void)DYRealtimeFianacailHeadTableViewCell:(DYRealtimeFianacailHeadTableViewCell*)cell dic:(NSDictionary*)dic
{
    if (dic!=nil) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *phoneAll=[NSString stringWithFormat:@"%@",[user objectForKey:@"UserName"]];
        NSString *phone = [[NSString stringWithFormat:@"%@",[user objectForKey:@"UserName"]] substringToIndex:3];
        NSString *phone2 = [[NSString stringWithFormat:@"%@",[user objectForKey:@"UserName"]] substringFromIndex:phoneAll.length-4];
        NSString *pwdphone = [NSString stringWithFormat:@"%@****%@",phone,phone2];
        
        cell.AcountLabel.text=pwdphone;
        NSString *nickName=self.NiName_String;
        if (![nickName isEqualToString:@""]) {
            cell.nickNameLabel.text=nickName;
        }else{
            cell.nickNameLabel.text=@"未设置昵称";
        }
        NSString *fileURL=self.TopImage_String;
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
        [cell.TopImageBnt setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        
        [cell.SafeSetBnt addTarget:self action:@selector(gotoMyAcount) forControlEvents:UIControlEventTouchDown];
        [cell.RechargeBtn2 addTarget:self action:@selector(rechargeMoney) forControlEvents:UIControlEventTouchDown];
        [cell.WithdrawalBtn addTarget:self action:@selector(withdrawalMoney) forControlEvents:UIControlEventTouchDown];
        cell.userInteractionEnabled = YES;
        
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        //1(注册送体验金)2(充值100送体验金1000)3(充值1000送体验金2000)4(分享成功送体验金2000)5(充值10000加1%年化)
        NSString *gotexpgold=[NSString stringWithFormat:@"%@",[ud objectForKey:@"gotexpgold"]];
        NSArray *array=[gotexpgold componentsSeparatedByString:@","];
        NSLog(@"%@",array);
        
        BOOL isGet100=NO;
        BOOL isGet1000=NO;
        for (NSString *a in array) {
            if ([a isEqualToString:@"2"]) {
                isGet100=YES;
            }
            if ([a isEqualToString:@"3"]) {
                isGet1000=YES;
            }
            if ([a isEqualToString:@"4"]) {
                //分享送2000
                //                cell.shareImage.alpha=0;
                [cell.timer invalidate];
            }
        }
        
        if (isGet100&&isGet1000) {
            cell.TiYanJinLogoImage.hidden=YES;
        }
        
    }
    
}
- (void)getMoney:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    DYRealtimeFianacailContentTableViewCell * cell  = [self.view viewWithTag:888];
    
    NSString * amount=cell.totalL.text;
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"lqb" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"info_lqb" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:amount forKey:@"amount" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"type" atIndex:0];//余额转入
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success==YES) {
             //可用信用额度数据填充
             //             [self.tabBarController setSelectedIndex:1];//0:首页，1：零钱包，2：投资，3：更多
             
             float lingqianbao=[cell.LingQianBaoLabel.text floatValue];
             float balance=[amount floatValue];
             cell.totalL.text=@"0";
             lingqianbao=lingqianbao+balance;
             cell.LingQianBaoLabel.text=[NSString stringWithFormat:@"%.2f",lingqianbao];
             
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:@"2" forKey:@"key"];
             [ud setObject:@"0" forKey:@"balance"];
             //             [ud setObject:@"8" forKey:@"getmoney"];
             
             float money1 = [cell.totalL.text floatValue];
             float money2 = [cell.LingQianBaoLabel.text floatValue];
             float money = money1 + money2;
             if (money > 200000.00 ) {
                 [LeafNotification showInController:self withText:@"无法转入，零钱宝总额最高20万"];
                 
             } else {
                 
                 //                 //暂停定时器
                 //                 self.start3=[self.totalL.text floatValue];
                 //                 self.end3=[self.totalL.text floatValue];
                 //                 UILabel *m=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.totalL.frame.size.width, self.totalL.frame.size.height)];
                 //                 m.backgroundColor=[UIColor whiteColor];
                 //                 m.textColor=kMainColor2 ;
                 //                 m.textAlignment=NSTextAlignmentLeft;
                 //                 [self.totalL addSubview:m];
                 //                 [self numberAnimation3:m];
                 //                 self.start2=[self.LingQianBaoLabel.text floatValue];
                 //                 self.end2=[self.LingQianBaoLabel.text floatValue]+[self.totalL.text floatValue];
                 //                 self.content2=[self.totalL.text floatValue];
                 //                 [self numberAnimation2:self.LingQianBaoLabel];
                 //
                 [cell.timer setFireDate:[NSDate distantFuture]];
                 cell.myImage.alpha = 1;
                 cell.myBtn.userInteractionEnabled = NO;
                 
                 background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+64)];
                 background.backgroundColor = [UIColor blackColor];
                 background.alpha = 0.5;
                 [self.tabBarController.view addSubview:background];
                 
                 tanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                 //        tanView.backgroundColor = [UIColor orangeColor];
                 [self.tabBarController.view addSubview:tanView];
                 
                 _bagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_hongbao_bags"]];
                 _bagView.center = CGPointMake(CGRectGetMidX(self.view.frame) + 10, CGRectGetMidY(self.view.frame) - 20);
                 _bagView.userInteractionEnabled = YES;
                 [tanView addSubview:_bagView];
                 
                 
                 [UIView animateWithDuration:0.5 animations:^{
                     tanView.alpha = 1.0;
                     background.alpha = 0.7;
                 } completion:^(BOOL finished) {
                     
                     [self getCoinAction];
                     
                     
                 }];
                 
                 //
                 //
                 //
                 //                 self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];
                 //
                 //
                 //                 a = 0;
                 
             }
             
             
         }else{
             [LeafNotification showInController:self withText:error];
             UIButton *btn = [self.view viewWithTag:10086];
             btn.userInteractionEnabled = YES;

             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:@"9" forKey:@"getmoney"];
         }
         
     } errorBlock:^(id error)
     {
         UIButton *btn = [self.view viewWithTag:10086];
         btn.userInteractionEnabled = YES;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
    
    
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
