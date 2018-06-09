//
//  DYMyInvestmentRecordViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/18.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYMyInvestmentRecordViewController.h"
#import "DYMyInvestmentRecordTableViewCell.h"
#import "PullingRefreshTableView.h"
#import "DYSafeViewController.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsPlatformManager.h"
#import "LeafNotification.h"
//#import "UMSocial.h"
#import "UMSocialScreenShoter.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialScreenShoter.h"

@interface DYMyInvestmentRecordViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UMSocialUIDelegate>{
    UINib *nibHead;
    UINib *nibcontent;
    int page;
    BOOL isViewDidLoad;
    MKNetworkOperation * opInvest;
    UIView * background;
    UIView *shareBackground;
    UIView *shareView;
    UIView *giftView;
    UIView *backView;
    UIView *rightBackView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;//
@property(nonatomic,strong)PullingRefreshTableView *tableView;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIButton *qqBtn;
@property (nonatomic, strong) UILabel *qqLabel;
@property (nonatomic, strong) UIButton *ZoneBnt;
@property (nonatomic, strong) UILabel *ZoneLabel;
@property (nonatomic, strong) UIButton *weixinBtn;
@property (nonatomic, strong) UILabel *weixinLabel;
@property (nonatomic, strong) UIButton *weixinFirendBtn;
@property (nonatomic, strong) UILabel *weixinFirendLabel;
@property (nonatomic,strong)NSString *shareTitle;
@property (nonatomic,strong)NSString *shareText;
@property (nonatomic,strong)UIImage *shareImage;
@property (nonatomic,strong)NSString *shareURL;

@property (nonatomic,strong)NSString *redPackage_URL;
@property (nonatomic,strong)NSString *nid;//投标成功之后返回的标识

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView * transverseLine;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIImageView *rightImage;

@property (nonatomic, strong) UIView *stateView;//回收状态下弹出View
@property (nonatomic, strong) UIView *hongbaoView;//红包状态弹出View
@property (nonatomic, copy) NSString *type;//判断红包状态字段
@property (nonatomic, copy) NSString *redpack;//判断回收状态字段
@property (nonatomic, strong) UIView *defaultView;
@end
static int left = 0;
static int right = 0;
@implementation DYMyInvestmentRecordViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"我的投资";
    }
    return self;
}
-(void)loadView{
    [super loadView];
    
    //    self.shareTitle = @"送你多多理财大礼包，抢10000元体验金赚收益";
    //    self.shareText = @"多多理财零钱宝，体验金赚收益，随时可提现，快来领取吧";
    //    self.shareImage = [UIImage imageNamed:@"200-200"];
    
    self.type = @"";
    self.redpack = @"";
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2, 5, 1, 30)];
    _verticalLine.backgroundColor = [UIColor lightGrayColor];
    _verticalLine.alpha = 0.6;
    [self.topView addSubview:self.verticalLine];
    
    self.transverseLine = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kMainScreenWidth, 1)];
    _transverseLine.backgroundColor = [UIColor lightGrayColor];
    _transverseLine.alpha = 0.6;
    [self.topView addSubview:self.transverseLine];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, kMainScreenWidth / 2, 39);
    [_leftBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(handleLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.leftBtn];
    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth / 3, 39)];
    _leftLabel.text = @"回收状态";
    _leftLabel.textAlignment = NSTextAlignmentRight;
    _leftLabel.font = [UIFont systemFontOfSize:15];
    [self.leftBtn addSubview:self.leftLabel];
    
    self.leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftLabel.frame) +2, 12, 15, 15)];
    _leftImage.image = [UIImage imageNamed:@"我的投资-2_03"];
    [self.leftBtn addSubview:self.leftImage];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(kMainScreenWidth / 2 + 1, 0, kMainScreenWidth / 2 - 1, 39);
    [_rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(handleRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.rightBtn];
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth / 3, 39)];
    _rightLabel.text = @"红包状态";
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.font = [UIFont systemFontOfSize:15];
    [self.rightBtn addSubview:self.rightLabel];
    
    self.rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftLabel.frame) +2, 12, 15, 15)];
    _rightImage.image = [UIImage imageNamed:@"我的投资-2_03"];
    [self.rightBtn addSubview:self.rightImage];
    
    
    //设置下拉刷新tableview
    _tableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-50) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:kMainColor bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullingDelegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    isViewDidLoad=YES;
    
    self.defaultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.defaultView.backgroundColor = kCOLOR_R_G_B_A(241, 241, 241, 1);
    [self.tableView addSubview:self.defaultView];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3, kMainScreenHeight / 2 - kMainScreenWidth / 2, kMainScreenWidth / 3, kMainScreenWidth / 4)];
    backImage.image = [UIImage imageNamed:@"我的卡券（无可用优惠券）_03"];
    [self.defaultView addSubview:backImage];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backImage.frame) + 20, kMainScreenWidth, 20)];
    titleLab.text = @"暂无数据";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    [self.defaultView addSubview:titleLab];
    self.defaultView.alpha = 0;
    
    
    
    self.stateView = [[UIView alloc] initWithFrame:CGRectMake(-kMainScreenWidth, 40, kMainScreenWidth, 40)];
    _stateView.backgroundColor = [UIColor whiteColor];
    _stateView.alpha = 0;
    [self.view addSubview:self.stateView];
    for (int i = 0; i < 4; i++) {
        NSArray *ary = @[@"全部",@"投资中",@"回收中",@"回收完"];
        UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        aBtn.frame = CGRectMake(kMainScreenWidth / 4 * i, 0, kMainScreenWidth / 4, 40);
        [aBtn setTitle:ary[i] forState:UIControlStateNormal];
        aBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == 0) {
            [aBtn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
        }
        aBtn.tag = 1000 + i;
        [aBtn addTarget:self action:@selector(handleState:) forControlEvents:UIControlEventTouchUpInside];
        [self.stateView addSubview:aBtn];
    }
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) + 40, kMainScreenWidth, kMainScreenHeight - 64 - 80)];
    backView.alpha = 0;
    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backView];
    
    
    self.hongbaoView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth, 40, kMainScreenWidth, 40)];
    _hongbaoView.backgroundColor = [UIColor whiteColor];
    _hongbaoView.alpha = 0;
    [self.view addSubview:self.hongbaoView];
    
    for (int i = 0; i < 3; i++) {
        NSArray *ary = @[@"全部",@"已分享",@"未分享"];
        UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        aBtn.frame = CGRectMake(kMainScreenWidth / 3 * i, 0, kMainScreenWidth / 3, 40);
        [aBtn setTitle:ary[i] forState:UIControlStateNormal];
        aBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == 0) {
            [aBtn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
        }
        aBtn.tag = 2000 + i;
        [aBtn addTarget:self action:@selector(handleHongbao:) forControlEvents:UIControlEventTouchUpInside];
        [self.hongbaoView addSubview:aBtn];
    }
    rightBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) + 40, kMainScreenWidth, kMainScreenHeight - 64 - 80)];
    rightBackView.alpha = 0;
    rightBackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightBackView];
    
    //弹窗阴影
    background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+64)];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0;
    //    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    //    [background addGestureRecognizer:tap];
    [self.tabBarController.view addSubview:background];
    
    shareBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+64)];
    shareBackground.backgroundColor = [UIColor blackColor];
    shareBackground.alpha = 0;
    [self.tabBarController.view addSubview:shareBackground];
    
    
    
}


- (void)handleLeft:(UIButton *)sender {
    
    if (left == 0) {
        
        if (right == 1) {
            self.stateView.alpha = 1;
            
            
            [UIView animateWithDuration:0.5 animations:^{
                self.hongbaoView.frame = CGRectMake(kMainScreenWidth, 40, kMainScreenWidth, 40);
                self.stateView.frame = CGRectMake(0, 40, kMainScreenWidth, 40);
                backView.alpha = 0.5;
                self.leftLabel.textColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
                self.rightLabel.textColor = [UIColor blackColor];
                self.leftImage.image = [UIImage imageNamed:@"我的投资-2_05"];
                self.rightImage.image = [UIImage imageNamed:@"我的投资-2_03"];
            } completion:^(BOOL finished) {
                self.hongbaoView.alpha = 0;
                left = 1;
                right = 0;
                
            }];
            
            
        }else {
            
            self.stateView.alpha = 1;
            
            [UIView animateWithDuration:0.5 animations:^{
                
                self.stateView.frame = CGRectMake(0, 40, kMainScreenWidth, 40);
                backView.alpha = 0.5;
                self.leftLabel.textColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
                
                self.leftImage.image = [UIImage imageNamed:@"我的投资-2_05"];
                
            } completion:^(BOOL finished) {
                
                left = 1;
                
            }];
            
        }
        
        
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.hongbaoView.frame = CGRectMake(kMainScreenWidth, 40, kMainScreenWidth, 40);
            self.stateView.frame = CGRectMake(-kMainScreenWidth, 40, kMainScreenWidth, 40);
            backView.alpha = 0;
            self.leftLabel.textColor = [UIColor blackColor];
            self.rightLabel.textColor = [UIColor blackColor];
            self.leftImage.image = [UIImage imageNamed:@"我的投资-2_03"];
            self.rightImage.image = [UIImage imageNamed:@"我的投资-2_03"];
        } completion:^(BOOL finished) {
            self.stateView.alpha = 0;
            self.hongbaoView.alpha = 0;
            
            left = 0;
            
        }];
        
    }
    
    
    
    
    
}
- (void)handleRight:(UIButton *)sender {
    
    if (right == 0) {
        
        if (left == 1) {
            self.hongbaoView.alpha = 1;
            [UIView animateWithDuration:0.5 animations:^{
                self.hongbaoView.frame = CGRectMake(0, 40, kMainScreenWidth, 40);
                self.stateView.frame = CGRectMake(-kMainScreenWidth, 40, kMainScreenWidth, 40);
                backView.alpha = 0.5;
                self.leftLabel.textColor = [UIColor blackColor];
                self.rightLabel.textColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
                self.leftImage.image = [UIImage imageNamed:@"我的投资-2_03"];
                self.rightImage.image = [UIImage imageNamed:@"我的投资-2_05"];
            } completion:^(BOOL finished) {
                self.stateView.alpha = 0;
                right = 1;
                left = 0;
                
            }];
            
        }else {
            
            self.hongbaoView.alpha = 1;
            [UIView animateWithDuration:0.5 animations:^{
                
                self.hongbaoView.frame = CGRectMake(0 , 40, kMainScreenWidth, 40);
                backView.alpha = 0.5;
                self.leftLabel.textColor = [UIColor blackColor];
                self.rightLabel.textColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
                self.rightImage.image = [UIImage imageNamed:@"我的投资-2_05"];
                self.leftImage.image = [UIImage imageNamed:@"我的投资-2_03"];
            } completion:^(BOOL finished) {
                right = 1;
            }];
            
        }
        
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.hongbaoView.frame = CGRectMake(kMainScreenWidth , 40, kMainScreenWidth, 40);
            backView.alpha = 0;
            self.leftLabel.textColor = [UIColor blackColor];
            self.rightLabel.textColor = [UIColor blackColor];
            self.rightImage.image = [UIImage imageNamed:@"我的投资-2_03"];
        } completion:^(BOOL finished) {
            self.hongbaoView.alpha = 0;
            right = 0;
            
        }];
        
        
    }
    
    
    
}
- (void)handleState:(UIButton *)sender {
    for (int i = 0; i < 4; i++) {
        UIButton *aBtn = [self.view viewWithTag:1000 + i];
        [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    UIButton *bBtn = [self.view viewWithTag:sender.tag];
    [bBtn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.stateView.frame = CGRectMake(-kMainScreenWidth , 40, kMainScreenWidth, 40);
        backView.alpha = 0;
        self.leftLabel.textColor = [UIColor blackColor];
        self.leftImage.image = [UIImage imageNamed:@"我的投资-2_03"];
    } completion:^(BOOL finished) {
        self.stateView.alpha = 0;
        left = 0;
        
        switch (sender.tag) {
            case 1000:
                self.type = @"";
                self.redpack = @"";
                [self.tableView launchRefreshing];
                break;
            case 1001:
                self.type = @"tender";
                self.redpack = @"";
                [self.tableView launchRefreshing];
                break;
            case 1002:
                self.type = @"recover";
                self.redpack = @"";
                [self.tableView launchRefreshing];
                break;
            case 1003:
                self.type = @"end";
                self.redpack = @"";
                [self.tableView launchRefreshing];
                break;
                
            default:
                break;
        }
        for (int i = 0; i < 3; i++) {
            UIButton *aBtn = [self.view viewWithTag:2000 + i];
            [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (i == 0) {
                [aBtn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
            }
        }
        
    }];
    
    
    
}

- (void)handleHongbao:(UIButton *)sender {
    for (int i = 0; i < 3; i++) {
        UIButton *aBtn = [self.view viewWithTag:2000 + i];
        [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    UIButton *bBtn = [self.view viewWithTag:sender.tag];
    [bBtn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.hongbaoView.frame = CGRectMake(kMainScreenWidth , 40, kMainScreenWidth, 40);
        backView.alpha = 0;
        self.rightLabel.textColor = [UIColor blackColor];
        self.rightImage.image = [UIImage imageNamed:@"我的投资-2_03"];
    } completion:^(BOOL finished) {
        self.hongbaoView.alpha = 0;
        right = 0;
        
        switch (sender.tag) {
            case 2000:
                self.redpack = @"";
                self.type = @"";
                [self.tableView launchRefreshing];
                break;
            case 2001:
                self.redpack = @"no";
                self.type = @"";
                [self.tableView launchRefreshing];
                break;
            case 2002:
                self.redpack = @"yes";
                self.type = @"";
                [self.tableView launchRefreshing];
                break;
                
            default:
                break;
        }
        
        for (int i = 0; i < 4; i++) {
            UIButton *aBtn = [self.view viewWithTag:1000 + i];
            [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (i == 0) {
                [aBtn setTitleColor:kCOLOR_R_G_B_A(253, 83, 83, 1) forState:UIControlStateNormal];
            }
        }
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (isViewDidLoad)
    {
        //初始化tableView
        [_tableView launchRefreshing];
        isViewDidLoad=NO;
    }
    
    //    [MobClick endLogPageView:@"我的投标记录"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self viewDidAfterLoad];//视图在加载完之后出现
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *markRuse=@"Recordinfo";
    if (!nibcontent) {
        nibcontent = [UINib nibWithNibName:@"DYMyInvestmentRecordTableViewCell" bundle:nil];
        [tableView registerNib:nibcontent forCellReuseIdentifier:markRuse];
    }
    DYMyInvestmentRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markRuse];
    cell.imageView.frame=CGRectMake(0, 0, 35, 35);
    cell.selectionStyle = UITableViewCellAccessoryNone;
    if (self.dataArray.count > 0) {
        
        NSDictionary *dic=[self.dataArray objectAtIndex:indexPath.row];
        
        
        cell.ProtocolBtn.tag = indexPath.row;
        [cell.ProtocolBtn addTarget:self action:@selector(handleProtocol:) forControlEvents:UIControlEventTouchDown];
        cell.Mark_titile.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"borrow_name"]];
        cell.Mark_InvestM.text=[NSString stringWithFormat:@"%@元",[dic objectForKey:@"account"]];
        float total=[[dic objectForKey:@"tender_award_fee"] floatValue]+[[dic objectForKey:@"recover_account_interest"] floatValue];
        cell.Mark_earningTotal.text=[NSString stringWithFormat:@"%.2f元",total];
        float since=[[dic objectForKey:@"tender_award_fee"] floatValue]+[[dic objectForKey:@"recover_account_interest_yes"] floatValue];
        cell.Mark_earningSince.text=[NSString stringWithFormat:@"%.2f元",since];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];//年应该用小写的yyyy不应该是大写的YYYY
        double begin=0;
        if ([dic objectForKey:@"borrow_start_time"]!=nil&&[dic objectForKey:@"borrow_start_time"]!=[NSNull null]) {
            begin=[[dic objectForKey:@"borrow_start_time"]doubleValue];
        }
        double start = 0;
        if ([dic objectForKey:@"repay_last_time"]!=nil&&[dic objectForKey:@"repay_last_time"]!=[NSNull null]) {
            start=[[dic objectForKey:@"repay_last_time"]doubleValue];
        }
        
        if(begin!=0&&start!=0){
            cell.Mark_Date.text=[NSString stringWithFormat:@"%@到%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:begin]],[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:start]]];
            
            
        }else{
            cell.Mark_Date.text=@"尚未开始计息";
        }
        cell.Mark_capital.text=[NSString stringWithFormat:@"%@元",[dic objectForKey:@"account"]];
        //回收中标红
        NSString *Mark_state=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status_type_name"]];
        
        
        cell.Mark_state.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status_type_name"]];
        if ([Mark_state isEqualToString:@"回收中"] || [Mark_state isEqualToString:@"还款中"]) {
            cell.Mark_state.textColor=[UIColor redColor];
        } else {
            cell.Mark_state.textColor = [UIColor blackColor];
        }
        int tender_id=[[dic objectForKey:@"id"] intValue];
        cell.ShareBnt.tag=tender_id;
        
        [cell.ShareBnt addTarget:self action:@selector(shareWith:) forControlEvents:UIControlEventTouchUpInside];
        
        int redpackage_status=[[dic objectForKey:@"redpackage_status"]intValue];
        NSString *borrowType = [NSString stringWithFormat:@"%@", [dic objectForKey:@"borrow_type"]];
        switch (redpackage_status) {
            case -2://-2表示投资记录时间太遥无法分享红包了
                [cell.ShareBnt setBackgroundImage:[UIImage imageNamed:@"账户-我的投资（灰色）_03"] forState:UIControlStateNormal];
                cell.ShareBnt.enabled=NO;
                break;
            case -1://-1表示红包已过期或者红包已经领完了
                [cell.ShareBnt setBackgroundImage:[UIImage imageNamed:@"账户-我的投资（灰色）_03"] forState:UIControlStateNormal];
                cell.ShareBnt.enabled=NO;
                break;
            case 1://1表示红包可以再次分享,未领完还可以再次分享
                [cell.ShareBnt setBackgroundImage:[UIImage imageNamed:@"我的投资.png"] forState:UIControlStateNormal];
                cell.ShareBnt.enabled=YES;
                break;
            case 0://0表示红包未生成可以生成并分享红包
                [cell.ShareBnt setBackgroundImage:[UIImage imageNamed:@"我的投资.png"] forState:UIControlStateNormal];
                cell.ShareBnt.enabled=YES;
                break;
        }
        
        if ([borrowType isEqualToString:@"transfer"]) {
            cell.ShareBnt.hidden = YES;
            cell.ShareBnt.enabled=NO;
        }
        
    }
    
    
    return cell;
    //    }
}


-(void)shareWith:(UIButton *)sender
{
    
    NSInteger tender_id=[sender tag];
    for (NSDictionary *dic in self.dataArray) {
        int i=[[dic objectForKey:@"id"]intValue];
        NSLog(@"%d",i);
        if (i==tender_id) {
            self.nid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nid"]];
            
            if (self.nid) {
                [self shareHongbao];
                NSLog(@"nnnnnn%@",self.nid);
            }
        }
    }
    
    
    //    NSInteger tender_id=[sender tag];
    //    int redpackage_status=-2;
    //    for (NSDictionary *dic in self.dataArray) {
    //        int i=[[dic objectForKey:@"id"]intValue];
    //        NSLog(@"%d",i);
    //        if (i==tender_id) {
    //            self.nid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nid"]];
    //            _redPackage_URL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"redpackage_url"]];
    //            redpackage_status=[[dic objectForKey:@"redpackage_status"]intValue];
    //            NSLog(@"44%@",dic);
    //        }
    //    }
    //
    //    if(redpackage_status!=0)
    //    {
    //        _shareURL=_redPackage_URL;
    //
    //        //设置微信AppId，设置分享url，默认使用友盟的网址
    //        [UMSocialWechatHandler setWXAppId:WXAppKey appSecret:WXAppSecret url:_shareURL];
    //        //设置分享到QQ空间的应用Id，和分享url 链接
    //        [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:_shareURL];
    //
    //        [self tanchuang];//投资成功弹出红包
    //    }else{
    //        [self setRedPackage];
    //    }
}

- (void)shareHongbao {
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"get_share_info" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"share" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:self.nid forKey:@"tender_nid" atIndex:0];
    [diyouDic insertObject:@"tender" forKey:@"name" atIndex:0];
    opInvest = [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (isSuccess)
                    {
                        
                        NSLog(@"%@",object);
                        //                        NSString *str = [object objectForKey:@"url"];
                        //                        self.shareURL = [str stringByReplacingCharactersInRange:NSMakeRange(0, 23) withString:@"http://120.24.220.186"];
                        self.shareURL = [object objectForKey:@"url"];
                        self.shareTitle = [object objectForKey:@"title"];
                        self.shareText = [object objectForKey:@"content"];
                        self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[object objectForKey:@"image"]]]];
                        //                        self.shareImage = [UIImage imageNamed:@"200-200"];
                        NSLog(@"rrrr%@",self.shareURL);
                        
                        //设置微信AppId，设置分享url，默认使用友盟的网址
                        [UMSocialWechatHandler setWXAppId:WXAppKey appSecret:WXAppSecret url:_shareURL];
                        //设置分享到QQ空间的应用Id，和分享url 链接
                        [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:_shareURL];
                        
                        [self tanchuang];//投资成功弹出红包
                        
                    }
                    else
                    {
                        
                        [LeafNotification showInController:self withText:errorMessage];
                    }
                } errorBlock:^(id error)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [LeafNotification showInController:self withText:@"网络异常"];                }];
    
    
}

- (void)handleProtocol:(UIButton *)sender {
    NSDictionary *dic=[self.dataArray objectAtIndex:sender.tag];
    NSString *url = [dic objectForKey:@"protocol"];
    NSLog(@"aaaaa%@", url);
    if (url) {
        DYSafeViewController *safeVC = [[DYSafeViewController alloc] initWithNibName:@"DYSafeViewController" bundle:nil];
        safeVC.weburl = url;
        safeVC.title = @"借款协议";
        [self.navigationController pushViewController:safeVC animated:YES];
    }
    
}
- (void)tanchuang {
    
    
    giftView = [[UIView alloc] initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height / 3, [UIScreen mainScreen].bounds.size.width - 80, [UIScreen mainScreen].bounds.size.height / 3)];
    giftView.alpha = 0;
    giftView.backgroundColor = [UIColor whiteColor];
    [giftView.layer setMasksToBounds:YES];
    [giftView.layer setCornerRadius:8.0];
    [self.tabBarController.view addSubview:giftView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(giftView.frame), CGRectGetHeight(giftView.frame))];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"分享红包_04"];
    [giftView addSubview:backImageView];
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(15, CGRectGetHeight(giftView.frame) - 50, (CGRectGetWidth(giftView.frame) - 40) / 2, 35);
    
    [_shareBtn addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtn setImage:[UIImage imageNamed:@"分享红包_03"] forState:UIControlStateNormal];
    [giftView addSubview:self.shareBtn];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake(CGRectGetMaxX(self.shareBtn.frame) + 10, CGRectGetHeight(giftView.frame) - 50, (CGRectGetWidth(giftView.frame) - 40) / 2, 35);
    [_closeBtn setImage:[UIImage imageNamed:@"分享红包_05"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(handleShare) forControlEvents:UIControlEventTouchUpInside];
    [giftView addSubview:self.closeBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        shareBackground.alpha = 0.5;
        giftView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    
}
- (void)handleClose {
    [UIView animateWithDuration:0.3 animations:^{
        [giftView removeFromSuperview];
        shareBackground.alpha = 0;
        
    }];
    
}
- (void)handleShare {
    NSLog(@"share");
    shareView = [[UIView alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height / 4, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height / 2.5)];
    shareView.alpha = 0;
    shareView.backgroundColor = [UIColor whiteColor];
    [shareView.layer setMasksToBounds:YES];
    [shareView.layer setCornerRadius:8.0];
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
    _weixinLabel.text = @"微信好友";
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
    cancelBtn.frame = CGRectMake(40, CGRectGetHeight(shareView.frame) - 60, CGRectGetWidth(shareView.frame) - 80, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor orangeColor];
    [cancelBtn.layer setCornerRadius:5];
    [cancelBtn.layer setMasksToBounds:YES];
    [cancelBtn addTarget:self action:@selector(handleCancel) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancelBtn];
    
    [UIView animateWithDuration:0.3 animations:^{
        [giftView removeFromSuperview];
        shareView.alpha = 1.0;
        shareBackground.alpha = 0.5;
        
    }];
    
}
- (void)handleCancel {
    [UIView animateWithDuration:0.3 animations:^{
        [shareView removeFromSuperview];
        shareBackground.alpha = 0;
        
    }];
}

- (void)handleWeixin {
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
    [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"wxsession"];
    
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    
    [self handleCancel];
}
- (void)handleQQ {
    
    [UMSocialData defaultData].extConfig.qqData.title=self.shareTitle;
    [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qq"];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    
    [self handleCancel];
}
- (void)handleWeixinFrirend {
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title=self.shareTitle;
    [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"wxtimeline"];
    
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    
    [self handleCancel];
}
- (void)handleZone {
    
    [UMSocialData defaultData].extConfig.qzoneData.title=self.shareTitle;
    [[UMSocialControllerService defaultControllerService] setShareText:_shareText shareImage:_shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qzone"];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    
    [self handleCancel];
}
-(void)setRedPackage{
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"new_tender_share" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"share" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:self.nid forKey:@"tender_nid" atIndex:0];
    
    opInvest = [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (isSuccess)
                    {
                        NSLog(@"%@",object);
                        NSDictionary *dic=object;
                        _redPackage_URL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"redpackage_url"]];
                        
                        _shareURL=_redPackage_URL;
                        
                        //设置微信AppId，设置分享url，默认使用友盟的网址
                        [UMSocialWechatHandler setWXAppId:WXAppKey appSecret:WXAppSecret url:_shareURL];
                        //设置分享到QQ空间的应用Id，和分享url 链接
                        [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:_shareURL];
                        
                        [self tanchuang];//投资成功弹出红包
                    }
                    else
                    {
                        
                        [LeafNotification showInController:self withText:errorMessage];
                    }
                } errorBlock:^(id error)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [LeafNotification showInController:self withText:@"网络异常"];
                }];
}

#pragma mark-－－－-scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.tableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
    
}
#pragma mark - pullingTableViewDelegate

-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    
    [self refreshTableView:NO pe:self.type ed:self.redpack];
    
}
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    
    [self refreshTableView:YES pe:self.type ed:self.redpack];
    
}
-(void)refreshTableView:(BOOL)object pe:(NSString *)type ed:(NSString *)red
{
    [self GetUserInfomation:object mytype:type myred:red];
}
//获取数据接口
-(void)GetUserInfomation:(BOOL)isRefreshing mytype:(NSString *)type myred:(NSString *)red
{
    
    //————————————————————————我的主页->实时财务->资金记录——————————————————————————
    
    
    if (isRefreshing)
    {
        
        NSLog(@"111111%@", type);
        NSLog(@"222222%@", red);
        
        page=1;
        DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
        [diyouDic1 insertObject:@"borrow" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"get_tender_list" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic1 insertObject:@"20" forKey:@"epage" atIndex:0];
        if (![type isEqualToString:@""]) {
            [diyouDic1 insertObject:type forKey:@"status_type" atIndex:0];
        }
        if (![red isEqualToString:@""]) {
            [diyouDic1 insertObject:red forKey:@"redpackage_status" atIndex:0];
        }
        [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
                 NSLog(@"dddddd%@",object);
                 self.dataArray = [NSMutableArray new];
                 self.dataArray=[object objectForKey:@"list"];
                 
                 if (self.dataArray.count == 0) {
                     self.defaultView.alpha = 1;
                 }else {
                     self.defaultView.alpha = 0;
                 }
                 
                 [self.tableView reloadData];
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }else
    {
        page++;
        DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
        [diyouDic1 insertObject:@"borrow" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"get_tender_list" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
        if (![type isEqualToString:@""]) {
            [diyouDic1 insertObject:type forKey:@"status_type" atIndex:0];
        }
        if (![red isEqualToString:@""]) {
            [diyouDic1 insertObject:red forKey:@"redpackage_status" atIndex:0];
        }
        
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic1 insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.footerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             
             if (success==YES) {
                 NSLog(@"ssssssss%@",object);
                 NSArray * ary=[object objectForKey:@"list"];
                 if (ary.count>0) {
                     
                     for (int i=0; i<ary.count;i++ )
                     {
                         [self.dataArray addObject:ary[i]];
                     }
                 }else
                 {
                     [LeafNotification showInController:self withText:@"数据加载完了"];
                 }
                 
                 
                 [self.tableView reloadData];
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }
}



@end
