//
//  DDSmallWalletViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/11.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDSmallWalletViewController.h"
#import "PullingRefreshTableView.h"
#import "DDSmallWalletTableViewCell.h"
#import "DDWalletTurnInViewController.h"
#import "DDSmallWalletHelperViewController.h"
#import "DDRechargeViewController.h"
#import "PulsingHaloLayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "LeafNotification.h"
#import "DDTiYanBaoViewController.h"

//#import "JXTCacher.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kWidth_zhuzi  ([UIScreen mainScreen].bounds.size.width - 15 * 6 - 30 * 2) / 7
@interface DDSmallWalletViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate, UITabBarControllerDelegate>

{
    UINib *nibContent;
    UIView * background;
    NSArray *arr;
    NSString *aul;
}

@property (nonatomic, strong) PulsingHaloLayer *halo;
@property (nonatomic,strong) PullingRefreshTableView *tableView;
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,strong) NSDictionary *userinfo;

@property (nonatomic,strong)NSString *gotexpgold;//送体验金

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic) float start;
@property (nonatomic) float end;
@property (nonatomic) float content;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, copy) NSString *str;
@property (nonatomic, strong) UIScrollView *scrollView;//滚动文字
@property (nonatomic, strong) NSTimer *timer1;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (nonatomic) BOOL first;
@property (nonatomic) BOOL second;
@property (nonatomic) BOOL third;


@end
static int isProgress=1;
static int pointCount = 0;
static int isTure = 0;
@implementation DDSmallWalletViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"体验宝";
//        self.fd_prefersNavigationBarHidden = YES;
      
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(![DYUser loginIsLogin]){
        [self firstpressed];
    }
    
//    self.navigationController.navigationBarHidden=YES;
    
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    isProgress = 1;
}
-(void)loadView{
    [super loadView];
    
    
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.topView.backgroundColor = kCOLOR_R_G_B_A(251, 141, 149, 1);
    [self.view addSubview:_topView];
    
    UILabel *tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 35, 20, 70, 40)];
    tittleLabel.text = @"体验宝";
    tittleLabel.textColor = [UIColor whiteColor];
    tittleLabel.textAlignment = NSTextAlignmentCenter;
    tittleLabel.font = [UIFont systemFontOfSize:18];
    [self.topView addSubview:tittleLabel];
    
    
    //导航左边的按钮
    UIButton * btnLeftItem=[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeftItem.backgroundColor=[UIColor clearColor];
    btnLeftItem.frame=CGRectMake(20, 30, 13, 20);
    [btnLeftItem setBackgroundImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeftItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLeftItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    [btnLeftItem addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:btnLeftItem];
    
    //导航右边的按钮
    UIButton * btnRightItem=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor=[UIColor clearColor];
    btnRightItem.frame=CGRectMake(SCREEN_WIDTH - 45, 30, 25, 25);
    //    [btnRightItem setTitle:@"刷新" forState:UIControlStateNormal];
    [btnRightItem setBackgroundImage:[UIImage imageNamed:@"零钱宝_03@2x.png"] forState:UIControlStateNormal];
    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    [btnRightItem addTarget:self action:@selector(HelperCenter) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:btnRightItem];
    
    //设置下拉刷新tableview
    // 上拉，下拉，tableView
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 50) style:UITableViewStylePlain topTextColor:[UIColor whiteColor] topBackgroundColor:nil bottomTextColor:[UIColor blackColor] bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor]; // 背景颜色
    _tableView.headerOnly = YES;
    _tableView.pullingDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(251, 141, 149, 1); // 头颜色
    _tableView.footerView.backgroundColor=[UIColor whiteColor]; // 脚颜色
    
    _tableView.hidden=YES;
    
    [self.tableView launchRefreshing];
    
}
- (void)share {
    [self.navigationController popToRootViewControllerAnimated:YES];
        
    
}
//-(void)share{
//    DYShareViewController *shareVC = [[DYShareViewController alloc] init];
//    shareVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:shareVC animated:YES];
//}
-(void)HelperCenter{
    DDSmallWalletHelperViewController *HelperCenter=[[DDSmallWalletHelperViewController alloc]initWithNibName:@"DDSmallWalletHelperViewController" bundle:nil];
    HelperCenter.hidesBottomBarWhenPushed=YES;
    HelperCenter.urlStr = @"https://www.51duoduo.com/ddjs/tybbz/cjwt.html";
    HelperCenter.title = @"体验宝问题";
    [self.navigationController pushViewController:HelperCenter animated:YES];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.fd_prefersNavigationBarHidden = YES;

    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden=NO;
}

-(NSDictionary *)fixedData{
    
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
//             NSLog(@"aaaaaaa%@", object);
             self.dataDic=object;
             float annual=[[self.dataDic objectForKey:@"annual"] floatValue];
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:[NSString stringWithFormat:@"%.2f",annual] forKey:@"annual"];
             [ud setObject:[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"gotexpgold"]] forKey:@"gotexpgold"];
             self.gotexpgold=[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"gotexpgold"]];
             [_tableView reloadData];
             
         }
         else
         {
             [LeafNotification showInController:self withText:error];
             
         }
         
     } errorBlock:^(id error)
     {
         //         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
    [self.view addSubview:_tableView];
    
    return self.dataDic;
}

- (void)firstpressed
{
    [DYUser  loginShowLoginView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [_tableView launchRefreshing];// 实现自身的刷新
    
    [self testFrefreshTableView];
}


#pragma mark - tableView datasource
#pragma mark
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 610;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    static  NSString *markReuse = @"markContent";
    if (!nibContent) {
        nibContent = [UINib nibWithNibName:@"DDSmallWalletTableViewCell" bundle:nil];
        [tableView registerNib:nibContent forCellReuseIdentifier:markReuse];
    }
    DDSmallWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markReuse];
    cell.tag=200;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //去掉点击后的阴影
    
    NSUserDefaults *dataud = [NSUserDefaults standardUserDefaults];
    
    NSData *tokenObject = [dataud objectForKey:@"tiyanbaodata"];
    self.dataDic = [NSKeyedUnarchiver unarchiveObjectWithData:tokenObject];

    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    float progress=8;
    float a=[[ud objectForKey:@"annual"]floatValue];
//    NSLog(@"%f", a);
    if (a>progress) {
        progress=a;
    }
    if(progress>10.5){
        progress=11;
    }
    float progresscent=0.58+(progress-8)/0.5*0.07;
//    NSLog(@"%f", progresscent);
    NSString *isRefreshAcount=[NSString stringWithFormat:@"%@",[ud objectForKey:@"isRefreshLingQianBao"]];
    if ([isRefreshAcount isEqualToString:@"1"]) {
        isProgress=1;
        [ud setObject:@"0" forKey:@"isRefreshLingQianBao"];
    }
//    NSLog(@"qq%f", progresscent);
    if (isProgress == 1) {
        isProgress = 2;
        
        
        if (!_scrollView) {
            //设置文字滚动定时器
            self.timer1 = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(gundong) userInfo:nil repeats:YES];
            
            
            UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH / 2, 40)];
            leftLabel.text = @"年化收益";
            leftLabel.textColor = [UIColor whiteColor];
            leftLabel.textAlignment = NSTextAlignmentRight;
            leftLabel.font = [UIFont systemFontOfSize:20];
            leftLabel.tag=12345;
            [cell addSubview:leftLabel];
            
            NSString *str1 = @"";
            NSString *str2 = @"";
            NSString *str3 = @"";
            NSString *str4 = @"";
            NSString *str5 = @"";
            NSString *str6 = @"";
            NSString *str7 = @"";
            str1=@"6.0";
            str2=@"6.5";
            str3=@"7.0";
            str4=@"7.5";
            str5=@"8.0";
            str6=@"8.5";
            str7=@"8.88";
            arr=@[str1,str2,str3,str4,str5,str6,str7];
            
            self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel.frame), 0, 70, 40)];
            _scrollView.contentSize = CGSizeMake(70, 40 * arr.count);
            _scrollView.pagingEnabled = YES;
            _scrollView.userInteractionEnabled = NO;
            [cell addSubview:self.scrollView];
            for (int i = 0; i < 7; i++) {
                UIButton *zhuziBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                zhuziBtn.frame = CGRectMake(30 + (kWidth_zhuzi + 15) * i,160 - 20 * i , kWidth_zhuzi, 60 + 20 * i);
                zhuziBtn.backgroundColor = [UIColor whiteColor];
                zhuziBtn.tag = 101 +i;
                zhuziBtn.alpha = 0.2;
                zhuziBtn.userInteractionEnabled = NO;
                [zhuziBtn addTarget:self action:@selector(handleMusic:) forControlEvents:UIControlEventTouchDown];
                
                
                
                
                [cell addSubview:zhuziBtn];
            }
            
            for (int i = 0; i < arr.count; i++) {
                UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40 * i, 70, 40)];
                centerLabel.text = arr[i];
                centerLabel.font = [UIFont systemFontOfSize:25];
                centerLabel.textColor = [UIColor whiteColor];
                centerLabel.textAlignment = NSTextAlignmentCenter;
                [_scrollView addSubview:centerLabel];
                
            }
            
            
            
            UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_scrollView.frame), 0, 40, 40)];
            rightLabel.text = @"%";
            rightLabel.textColor = [UIColor whiteColor];
            rightLabel.textAlignment = NSTextAlignmentLeft;
            rightLabel.font = [UIFont systemFontOfSize:20];
            [cell addSubview:rightLabel];
            
            UIImageView *shouImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 80, 30, 30)];
            shouImage.image = [UIImage imageNamed:@"零钱宝(改)_06"];
            shouImage.userInteractionEnabled = YES;
            [cell addSubview:shouImage];
            UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(35, 75, 10, 10)];
            whiteView.backgroundColor = [UIColor whiteColor];
            [whiteView.layer setMasksToBounds:YES];
            [whiteView.layer setCornerRadius:5];
            whiteView.alpha = 0.5;
            [cell addSubview:whiteView];
            
            UIButton * dianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            dianBtn.frame = CGRectMake(20, 60, 40, 40);
            [dianBtn addTarget:self action:@selector(handledian:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:dianBtn];
            self.halo = [PulsingHaloLayer layer];
            self.halo.position = dianBtn.center;
            self.halo.radius = 40;
            self.halo.backgroundColor = [UIColor whiteColor].CGColor;
            [cell.layer insertSublayer:self.halo below:dianBtn.layer];
            
            UILabel *zhuanruLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 240, kMainScreenWidth - 60 , 44)];
            zhuanruLabel.backgroundColor = [UIColor clearColor];
            zhuanruLabel.layer.cornerRadius = 5;
            zhuanruLabel.layer.masksToBounds = YES;
            zhuanruLabel.text = @"转  入";
            zhuanruLabel.textColor = [UIColor whiteColor];
            zhuanruLabel.textAlignment = NSTextAlignmentCenter;
            zhuanruLabel.font = [UIFont systemFontOfSize:25];
            [cell addSubview:zhuanruLabel];
            
            UIButton *TranIn = [UIButton buttonWithType:UIButtonTypeCustom];
            TranIn.frame = CGRectMake(30, 240, kMainScreenWidth - 60 , 44);
            TranIn.layer.cornerRadius = 5;
            TranIn.layer.masksToBounds = YES;
            [TranIn setTitle:@"转  入" forState:UIControlStateNormal];
            [TranIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            TranIn.backgroundColor = [UIColor whiteColor];
            TranIn.alpha = 0.3;
            TranIn.titleLabel.font = [UIFont systemFontOfSize:25];
            TranIn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:TranIn];
            [TranIn addTarget:self action:@selector(GotoTurnIn) forControlEvents:UIControlEventTouchDown];
            
        }
        
        
    }
    if (self.dataDic) {
        
        
        
        cell.YesterdayEarnings.text=[NSString stringWithFormat:@"%.2f",[[self.dataDic objectForKey:@"yesincome"]floatValue]];
        
//        NSLog(@"%@,%@,%@",[ud objectForKey:@"LingqianBaoEnd"],[self.dataDic objectForKey:@"total"],[self.dataDic objectForKey:@"zexpgold"]);
        NSString *money=[NSString stringWithFormat:@"%@",[ud objectForKey:@"LingqianBaoEnd"]];
        int BalaneDone=[[NSString stringWithFormat:@"%@",[ud objectForKey:@"LingqianBaoDone"]]intValue];
        int type=[[NSString stringWithFormat:@"%@",[ud objectForKey:@"LingqianBaoType"]]intValue];
        if (type==1) {
            self.start=[[self.dataDic objectForKey:@"total"]floatValue]-[money floatValue];
            self.end=[[self.dataDic objectForKey:@"total"]floatValue];
            self.content=[money floatValue];
        }else{
            self.start=[[self.dataDic objectForKey:@"zexpgold"] floatValue]-[money floatValue];
            self.end=[[self.dataDic objectForKey:@"zexpgold"] floatValue];
            self.content=[money floatValue];
        }
        
        if (BalaneDone==1) {
            [self numberAnimation:cell.TotalLabel];
            [ud setObject:@"0" forKey:@"LingqianBaoDone"];
        }else{
            cell.TotalLabel.text=[NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"kexpgold"]];
        }
        
//        NSLog(@"%d",type);
        if (type==3) {
            self.start=[[self.dataDic objectForKey:@"zexpgold"] floatValue]-[money floatValue];
            self.end=[[self.dataDic objectForKey:@"zexpgold"] floatValue];
            self.content=[money floatValue];
        }
        if (BalaneDone==3) {
            
            [self numberAnimation:cell.TotalTiYanJInLabel];
            [ud setObject:@"0" forKey:@"LingqianBaoDone"];
        }else{
            cell.TotalTiYanJInLabel.text=[NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"zexpgold"]];
            
        }
        
        
        cell.Totalincome.text=[NSString stringWithFormat:@"%.2f",[[self.dataDic objectForKey:@"totalincome"]floatValue]];
        cell.ContinuousDays.text=[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"continuous_days"]];
        
        [cell.RecordBnt addTarget:self action:@selector(GetRecord) forControlEvents:UIControlEventTouchDown];
        [cell.TiYanJinRecordBnt addTarget:self action:@selector(GetTiyanjianRecord) forControlEvents:UIControlEventTouchDown];
    }
    
    return cell;
}
-(void)gundong{
    static int count = 0;
    [self.scrollView setContentOffset:CGPointMake(0, count * 40) animated:YES];
    count++;
    
    int i=count;
    if (count == arr.count) {
        [_timer1 invalidate];
        count = 0;
    }
    UIButton *zhuziBtn = [self.view viewWithTag:100+i];
    
    [UIView animateWithDuration:0.5 animations:^{
        zhuziBtn.alpha = 0.7;
        zhuziBtn.userInteractionEnabled = YES;
    } completion:^(BOOL finished) {
        
    }];
    
    
    DDSmallWalletTableViewCell *cell = [self.view viewWithTag:200];
    
    switch (i) {
        case 1:
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(251, 83, 83, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(250, 119, 84, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(251, 83, 83, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(251, 83, 83, 1); // 头颜色
            
            break;
        case 2:
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(237, 96, 58, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(238, 152, 89, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(237, 96, 58, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(237, 96, 58, 1);
            
            break;
        case 3:
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(242, 161, 24, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(254, 207, 127, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(242, 161, 24, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(242, 161, 24, 1);
            
            break;
        case 4:
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(99, 198, 105, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(157, 218, 116, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(99, 198, 105, 1);
            //            cell.HeadView.backgroundColor = kCOLOR_R_G_B_A(45, 179, 46, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(99, 198, 105, 1);
            
            break;
        case 5:
            //            self.str = [NSString stringWithFormat:@"/yin5.mp3"];
            //
            //            [self playSound: _str];
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(2, 189, 201, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(90, 219, 169, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(2, 189, 201, 1);
            //            cell.HeadView.backgroundColor = kCOLOR_R_G_B_A(237, 190, 19, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(2, 189, 201, 1);
            
            break;
        case 6:
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(15, 141, 245, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(59, 205, 247, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(15, 141, 245, 1);
            //            cell.HeadView.backgroundColor = kCOLOR_R_G_B_A(235, 115, 4, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(15, 141, 245, 1);
            
            break;
        case 7:
            //            self.str = [NSString stringWithFormat:@"/yin7.mp3"];
            //
            //            [self playSound: _str];
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(196, 6, 225, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(228, 96, 220, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(196, 6, 225, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(196, 6, 225, 1);
            
            break;
        default:
            break;
    }
    
    
    
}
- (void)handledian:(UIButton *)sender {
    pointCount = 0;
    isTure = 1;
    [MBProgressHUD errorHudWithView:self.view label:@"即将获得3个音节，按顺序弹奏吧，会有惊喜等你哦!" hidesAfter:2];
    sender.userInteractionEnabled = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2];
        int x = arc4random() % 7 + 1;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *str1 = [NSString stringWithFormat:@"%d", x];
        [ud setObject:str1 forKey:@"key1"];
        self.str = [NSString stringWithFormat:@"/yin%d.mp3", x];
        
        [self playSound: _str];
        
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2.5];
        int y = arc4random() % 7 + 1;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *str2 = [NSString stringWithFormat:@"%d", y];
        [ud setObject:str2 forKey:@"key2"];
        self.str = [NSString stringWithFormat:@"/yin%d.mp3", y];
        
        [self playSound: _str];
        
    });
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3];
        int z = arc4random() % 7 + 1;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *str3 = [NSString stringWithFormat:@"%d", z];
        [ud setObject:str3 forKey:@"key3"];
        self.str = [NSString stringWithFormat:@"/yin%d.mp3", z];
        
        [self playSound: _str];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
        
        
    });
    
    
}
- (void)handleMusic:(UIButton *)sender {
    pointCount++;
    static int right = 0;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str1 = [ud objectForKey:@"key1"];
    NSString *str2 = [ud objectForKey:@"key2"];
    NSString *str3 = [ud objectForKey:@"key3"];
//    NSLog(@"%@", str1);
//    NSLog(@"%@", str2);
//    NSLog(@"%@", str3);
    
    float key = sender.tag - 100;
    NSString *myKey = [NSString stringWithFormat:@"%.0f", key];
//    NSLog(@"%f", sender.frame.size.width);
    
    
//    NSLog(@"%d", pointCount);
    if (isTure == 1) {
        
        if (pointCount == 1) {
//            NSLog(@"aa%@", myKey);
//            NSLog(@"bb%@", str1);
            if ([myKey isEqualToString:str1]) {
                right++;
            }
//            NSLog(@"正确个数%d", right);
        } else if (pointCount == 2) {
//            NSLog(@"aa%@", myKey);
//            NSLog(@"bb%@", str2);
            if ([myKey isEqualToString:str2]) {
                right++;
            }
//            NSLog(@"正确个数%d", right);
        } else if (pointCount == 3) {
//            NSLog(@"aa%@", myKey);
//            NSLog(@"bb%@", str3);
            if ([myKey isEqualToString:str3]) {
                right++;
            }
            
            
            [MBProgressHUD hudWithView:self.view label:@"数据请求中"];
            DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
            [diyouDic insertObject:@"musicgame" forKey:@"module" atIndex:0];
            [diyouDic insertObject:@"handle_correct" forKey:@"q" atIndex:0];
            [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
            [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
            [diyouDic insertObject:[NSString stringWithFormat:@"%d",right] forKey:@"correct_num" atIndex:0];
            [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
                 if (success==YES) {
                     
                     NSDictionary *dic=object;
                     NSString *msg=[NSString stringWithFormat:@"%@",[dic objectForKey:@"message"]];
                     UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"结果" message:msg  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                     
                     [alertView show];
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
            
            
//            NSLog(@"正确个数%d", right);
            right = 0;
            isTure = 2;
        }
    }
    
    DDSmallWalletTableViewCell *cell = [self.view viewWithTag:200];
    switch (sender.tag) {
        case 101:
            self.str = [NSString stringWithFormat:@"/yin1.mp3"];
            
            [self playSound: _str];
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(251, 83, 83, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(250, 119, 84, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(251, 83, 83, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(251, 83, 83, 1); // 头颜色
            
            break;
        case 102:
            self.str = [NSString stringWithFormat:@"/yin2.mp3"];
            
            [self playSound: _str];
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(237, 96, 58, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(238, 152, 89, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(237, 96, 58, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(237, 96, 58, 1);
            
            break;
        case 103:
            self.str = [NSString stringWithFormat:@"/yin3.mp3"];
            
            [self playSound: _str];
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(242, 161, 24, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(254, 207, 127, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(242, 161, 24, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(242, 161, 24, 1);
            
            break;
        case 104:
            self.str = [NSString stringWithFormat:@"/yin4.mp3"];
            
            [self playSound: _str];
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(99, 198, 105, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(157, 218, 116, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(99, 198, 105, 1);
            //            cell.HeadView.backgroundColor = kCOLOR_R_G_B_A(45, 179, 46, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(99, 198, 105, 1);
            
            break;
        case 105:
            self.str = [NSString stringWithFormat:@"/yin5.mp3"];
            
            [self playSound: _str];
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(2, 189, 201, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(90, 219, 169, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(2, 189, 201, 1);
            //            cell.HeadView.backgroundColor = kCOLOR_R_G_B_A(237, 190, 19, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(2, 189, 201, 1);
            
            break;
        case 106:
            self.str = [NSString stringWithFormat:@"/yin6.mp3"];
            
            [self playSound: _str];
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(15, 141, 245, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(59, 205, 247, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(15, 141, 245, 1);
            //            cell.HeadView.backgroundColor = kCOLOR_R_G_B_A(235, 115, 4, 1);
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(15, 141, 245, 1);
            
            break;
        case 107:
            self.str = [NSString stringWithFormat:@"/yin7.mp3"];
            
            [self playSound: _str];
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = cell.HeadView.bounds;
            [cell.HeadView.layer addSublayer:self.gradientLayer];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.colors = @[(__bridge id)kCOLOR_R_G_B_A(196, 6, 225, 1).CGColor,
                                          (__bridge id)kCOLOR_R_G_B_A(228, 96, 220, 1).CGColor];
            self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
            
            
            self.topView.backgroundColor = kCOLOR_R_G_B_A(196, 6, 225, 1);
            
            _tableView.headerView.backgroundColor=kCOLOR_R_G_B_A(196, 6, 225, 1);
            
            break;
        default:
            break;
    }
}
-(void)playSound:(NSString*)soundKey{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath],soundKey];
    
    //NSLog(@"%@\n", path);
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    
    AudioServicesPlaySystemSound(soundID);
    
}

-(void)numberAnimation:(UILabel *)label{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(numberAnimation)
                                            userInfo:nil
                                             repeats:YES];
    label.tag=100;
}
-(void)numberAnimation{
    UILabel *lb=[self.view viewWithTag:100];
    self.start+=self.content/8;
    if (self.start>self.end) {
        lb.text=[NSString stringWithFormat:@"%.2f",self.end];
        lb.tag=0;
        [_timer invalidate];
        _timer=nil;
        return;
    }
    lb.text=[NSString stringWithFormat:@"%.2f",self.start];
}

-(void)GetRecord{
    
    DDTiYanBaoViewController *recordVC = [[DDTiYanBaoViewController alloc]initWithNibName:@"DDTiYanBaoViewController" bundle:nil];
    recordVC.hidesBottomBarWhenPushed = YES;
    recordVC.typeStr=[NSString stringWithFormat:@"%.2f",[[self.dataDic objectForKey:@"kexpgold"]floatValue]];
    recordVC.type=0;//体验金
    [self.navigationController pushViewController:recordVC animated:YES];
    
}
-(void)GetTiyanjianRecord{
    //进入体验金记录
    DDTiYanBaoViewController *recordVC = [[DDTiYanBaoViewController alloc]initWithNibName:@"DDTiYanBaoViewController" bundle:nil];
    recordVC.hidesBottomBarWhenPushed = YES;
    recordVC.typeStr=[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"zexpgold"]];
    recordVC.type=7;//体验金
    [self.navigationController pushViewController:recordVC animated:YES];
}
-(void)GotoTurnIn{
    
    
    float tiyanjin=[[self.dataDic objectForKey:@"kexpgold"]floatValue];//体验金
    DDWalletTurnInViewController *turnInVC = [[DDWalletTurnInViewController alloc] initWithNibName:@"DDWalletTurnInViewController" bundle:nil];
    turnInVC.hidesBottomBarWhenPushed=YES;
    turnInVC.type=3;
    turnInVC.balance=[NSString stringWithFormat:@"%.2f",tiyanjin];
    turnInVC.annual=[NSString stringWithFormat:@"%.2f",[[self.dataDic objectForKey:@"annual"]floatValue]];
    [self.navigationController pushViewController:turnInVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark- scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView tableViewDidScroll:scrollView];
    
    
    CGPoint contentOffsetPoint = _tableView.contentOffset;
    CGRect frame = _tableView.frame;
    if (contentOffsetPoint.y == _tableView.contentSize.height - frame.size.height || _tableView.contentSize.height < frame.size.height)
    {
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_tableView tableViewDidEndDragging:scrollView];
}

#pragma mark ------PullTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    //    [self queryDataIsRefresh:YES];
    [self performSelector:@selector(testFrefreshTableView) withObject:nil afterDelay:0];
}
-(void)testFrefreshTableView
{
    //————————————————————————我的主页->实时财务——————————————————————————
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
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
//             NSLog(@"%@",object);
             self.dataDic=object;
             float annual=[[self.dataDic objectForKey:@"annual"] floatValue];
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:[NSString stringWithFormat:@"%.2f",annual] forKey:@"annual"];
             [ud setObject:[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"gotexpgold"]] forKey:@"gotexpgold"];
             self.gotexpgold=[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"gotexpgold"]];
             NSData *tokenObject = [NSKeyedArchiver archivedDataWithRootObject:self.dataDic];
             [ud setObject:tokenObject forKey:@"tiyanbaodata"];
             [ud synchronize];

             [_tableView reloadData];
             
         }
         else
         {
             [LeafNotification showInController:self withText:error];
             
         }
         
     } errorBlock:^(id error)
     {
         if (_tableView.headerView.isLoading)
         {
             [_tableView tableViewDidFinishedLoading];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         //         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
    [self.view addSubview:_tableView];
    
    
    [_tableView reloadData];
    if (_tableView.headerView.isLoading)
    {
        [_tableView tableViewDidFinishedLoading];
        _tableView.hidden=NO;
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
