//
//  DDMyAccountViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/28.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMyAccountViewController.h"
#import "DDAccountTopTableViewCell.h"
#import "DDMailMessageViewController.h"
#import "DYMyAcountMainVC.h"
#import "DDRechargeViewController.h"
#import "DYMyInvestmentRecordViewController.h"
#import "DYFinancialRecordsVC.h"
#import "DDMyCardVoucherViewController.h"
#import "DDBondViewController.h"
#import "DDSmallWalletViewController.h"
#import "DDMyInvestViewController.h"
#import "DDhasWonMoneyViewController.h"
#import "UIImageView+WebCache.h"
//#import "DDVRPlayerViewController.h"
#import "DDCurrentViewController.h"
#import "DDAllMoneyViewController.h"
#import "DDDrawMoneyViewController.h"
//#import <CustomAlertView.h>
#import "DYAppDelegate.h"
#import "SCLoginVerifyView.h"
#import "SCSecureHelper.h"
#import "WaterView.h"
#import "FFMineModel.h"
#import "FFshareView.h"


#define kPRAnimationDuration .18f
#define kPROffsetY 60.f

@interface DDMyAccountViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UINib * nibHead;     // 复用cell的nib
    
    id userData; // 判断是否进行实名认证
    NSString *realname;
    NSString *card_id;
    UIView * nav;
    UIImageView* _iconImageView;
    
    int bank_status;
    int isGoTOSafeSet;
    UIView *shareBackView;
    
    
}
@property (nonatomic, strong)UITableView * tableView; // 第三方下拉刷新
@property (nonatomic, strong) UIButton *btnRightItem;
@property (nonatomic, strong) NSDictionary *AllData;
@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic, assign) int badge;
@property (nonatomic,strong)NSString *shareTitle;
@property (nonatomic,strong)NSString *shareText;
@property (nonatomic,strong)UIImage *shareImage;
@property (nonatomic,strong)NSString *shareURL;
@property (nonatomic, strong) NSString *myShareImage;
@property (nonatomic) BOOL isBindBank;//是否绑定银行卡
@property (nonatomic) int BankType;//银行类型
@property (nonatomic,strong)NSString *BankNo;//银行卡号
@property (nonatomic,strong) NSString *TopImage_String;
@property (nonatomic,strong) NSString *NiName_String;
@property (nonatomic,assign) float contentInsetBottom;
@property (nonatomic,assign) float offsetY;
@property (nonatomic,assign) float VY;
//@property(nonatomic)int n;
@property (nonatomic) float start;
@property (nonatomic) float end;
@property (nonatomic) float content;
@property (nonatomic,strong)UIImageView*bgView;

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *rechargeBtn;
@property (nonatomic, strong) UIButton *tixianBtn;
@property (nonatomic, strong) FFMineModel *model;
@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) FFshareView *shareView;

@end

@implementation DDMyAccountViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    if(![DYUser loginIsLogin]){
        [self firstpressed];
    }
    
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//}

- (void)firstpressed
{
    [DYUser  loginShowLoginView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [_tableView launchRefreshing];// 实现自身的刷新
    [self testFrefreshTableView];
    
}
- (void)MJ_headerView{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self testFrefreshTableView];
        
    }];
//    header.backgroundColor = kBackColor;
//    header.stateLabel.font = [UIFont systemFontOfSize:12];
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -1000, kMainScreenWidth, 1000)];
//    headerView.backgroundColor = kBackColor;
//    [header addSubview:headerView];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.textColor =  kBtnColor;
    header.lastUpdatedTimeLabel.textColor = kBtnColor;
    
    self.tableView.mj_header = header;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = kBackColor;
    [self getMYFootText];
//    self.navigationController.navigationBar.barTintColor  = kBackColor;

//    self.fd_prefersNavigationBarHidden = YES;

//    float topHeight;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
//        topHeight = -[UIApplication sharedApplication].statusBarFrame.size.height;
//    }else {
//        topHeight = 0;
//
//    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor]; // 背景颜色
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    _tableView.showsVerticalScrollIndicator = false;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    
    [self MJ_headerView];
    
    [self configNav];
    
    [self.view addSubview:_tableView];

    [_tableView reloadData];
    [self viewDidAfterLoad]; // 视图在加载完之后出现

    // Do any additional setup after loading the view from its nib.

}

#pragma mark -- 配置导航栏
- (void)configNav {
    UIView *leftItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 100, 40)];
    leftItemView.backgroundColor = [UIColor clearColor];
    [leftItemView addSubview:self.photoImage];
    [leftItemView addSubview:self.nameLabel];
    [leftItemView addSubview:self.phoneLabel];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftItemView];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"Settings"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(handleRight) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}
- (UIImageView *)photoImage {
    if (!_photoImage) {
        self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 35, 35)];
        _photoImage.layer.masksToBounds = YES;
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        NSData *tokenObject = [ud objectForKey:@"minedata"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:tokenObject];
        self.model = [FFMineModel mj_objectWithKeyValues:dic];
        [_photoImage sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"backphoto"]];
        _photoImage.layer.cornerRadius = 17.5;
    }
    return _photoImage;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoImage.frame) + 10, 5, 150, 15)];
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        NSData *tokenObject = [ud objectForKey:@"minedata"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:tokenObject];
        self.model = [FFMineModel mj_objectWithKeyValues:dic];
        if (self.model.niname > 0) {

            _nameLabel.text = self.model.niname ;
        }else {
            _nameLabel.text = @"未设置昵称";
        }

        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}
- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoImage.frame) + 10, CGRectGetMaxY(self.nameLabel.frame), 150, 15)];
        _phoneLabel.textColor = [UIColor darkGrayColor];
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        NSData *tokenObject = [ud objectForKey:@"minedata"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:tokenObject];
        self.model = [FFMineModel mj_objectWithKeyValues:dic];
        _phoneLabel.text = [self.model.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        
        _phoneLabel.font = [UIFont systemFontOfSize:13];
    }
    return _phoneLabel;
}
- (void)handleRight {
    DYMyAcountMainVC *VC = [[DYMyAcountMainVC alloc]initWithNibName:@"DYMyAcountMainVC" bundle:nil];
    VC.hidesBottomBarWhenPushed = YES;
    VC.model = self.model;
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark- tableViewDelegate
// 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1; // cell的个数
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 600;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * mark=@"markHead";
    if (!nibHead)
    {
        nibHead=[UINib nibWithNibName:@"DDAccountTopTableViewCell" bundle:nil];
        [tableView registerNib:nibHead forCellReuseIdentifier:mark];
        
    }
    DDAccountTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mark];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    [cell.shareBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSData *tokenObject = [ud objectForKey:@"minedata"];
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:tokenObject];
    self.model = [FFMineModel mj_objectWithKeyValues:dic];
    cell.model = self.model;
    

    
    return cell;
    
}






//债券转让
-(void)LingqianBao{
    
    DDBondViewController *bondVC = [[DDBondViewController alloc] init];
    bondVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bondVC animated:YES];
    
}



- (void)testFrefreshTableView {
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"app_center" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (_tableView.mj_header.isRefreshing)
        {
            [_tableView.mj_header endRefreshing];
        }
        
        if (isSuccess) {
            NSLog(@"我的%@", object);
            self.model = [FFMineModel mj_objectWithKeyValues:object];
            [self.photoImage sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"backphoto"]];
            self.phoneLabel.text = [self.model.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            if (self.model.niname.length > 0) {
                self.nameLabel.text = self.model.niname;
            }else {
                self.nameLabel.text = @"未设置昵称";
            }
            
            [self.tableView reloadData];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSData *tokenObject = [NSKeyedArchiver archivedDataWithRootObject:object];
            [ud setObject:tokenObject forKey:@"minedata"];
            [ud synchronize];
        }else {
             [LeafNotification showInController:self withText:errorMessage];
            
        }

        
    } fail:^{
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        NSData *tokenObject = [ud objectForKey:@"FBToken"];
        self.AllData = [NSKeyedUnarchiver unarchiveObjectWithData:tokenObject];
        
        [_tableView reloadData];
        [LeafNotification showInController:self withText:@"网络异常"];
        
        
        if (_tableView.mj_header.isRefreshing)
        {
            [_tableView.mj_header endRefreshing];
        }
        
    }];
    
    
}


#pragma mark -- 中银文字

- (void)getMYFootText {
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"word" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"app" forKey:@"module" atIndex:0];
    
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess) {
            NSLog(@"文字%@", object);
            NSDictionary *dic = object[@"data"];
            if (dic.count > 0) {
                float topHeight;
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
                    topHeight = -[UIApplication sharedApplication].statusBarFrame.size.height;
                }else {
                    topHeight = 0;
                    
                }
                UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kMainScreenWidth, 20)];
                NSString *str = [NSString stringWithFormat:@"%@", object[@"data"][@"ios_text"]];
                if (str.length > 0 && ![str isEqualToString:@"(null)"]) {
                    
                   footLabel.text = str;
                }
                footLabel.textColor = [UIColor darkGrayColor];
                footLabel.textAlignment = NSTextAlignmentCenter;
                footLabel.font = [UIFont systemFontOfSize:12];
//                [self.tableView addSubview:footLabel];
                self.tableView.tableFooterView = footLabel;
            }
            
        }else {
            [LeafNotification showInController:self withText:errorMessage];
            
        }
    } fail:^{
        [LeafNotification showInController:self withText:@"网络异常"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getShareData:(int)sender {
     [MobClick event:@"account_fenxiangfengfeng"];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"share" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_share_info" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"recommend" forKey:@"name" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
             
            NSLog(@"sharedddd%@",object);
             self.shareURL = [object objectForKey:@"url"];
             self.shareText = [object objectForKey:@"content"];
             self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[object objectForKey:@"image"]]]];;
             self.shareTitle = [object objectForKey:@"title"];
             self.myShareImage = [NSString stringWithFormat:@"%@", [object objectForKey:@"image"]];
              [self handleClose];
             switch (sender) {
                 case 0:
                     [self share:UMSocialPlatformType_WechatSession];
                     break;
                 case 1:
                     [self share:UMSocialPlatformType_WechatTimeLine];
                     break;
                 case 2:
                     [self share:UMSocialPlatformType_QQ];
                     break;
                 case 3:
                     [self share:UMSocialPlatformType_Qzone];
                     break;
                 default:
                     break;
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



- (void)showShareView {
    shareBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    shareBackView.backgroundColor = [UIColor blackColor];
    shareBackView.alpha = 0.3;
    [self.tabBarController.view addSubview:shareBackView];
    
    
    NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"FFshareView" owner:nil options:nil];
    self.shareView = [apparray firstObject];
    
    self.shareView.frame = CGRectMake(40, kMainScreenHeight / 2 - 200, kMainScreenWidth - 80, 400);
//    self.shareView.backgroundColor = [UIColor whiteColor];
    
    [self.tabBarController.view addSubview:self.shareView];
    [self shakeToShow: self.shareView];
    
    
    [self.shareView.closeBtn addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView.weixinBtn addTarget:self action:@selector(handleWeixin) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView.friendBtn addTarget:self action:@selector(handleFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView.myQQBtn addTarget:self action:@selector(handleMyQQ) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView.kongjianBtn addTarget:self action:@selector(handleKongjian) forControlEvents:UIControlEventTouchUpInside];
    
   
 
}
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
- (void)handleClose {
    
    [self.shareView removeFromSuperview];
    [shareBackView removeFromSuperview];
    
}

- (void)handleWeixin {
    
     [self getShareData:0];
}
- (void)handleFriend {
     [self getShareData:1];
    
}
- (void)handleMyQQ {
    [self getShareData:2];
    
}
- (void)handleKongjian {
     [self getShareData:3];
    
}

- (void)share:(UMSocialPlatformType )shareType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    //        UIImage *image = shareImage;
    NSString* thumbURL =  self.myShareImage;
//    NSData *data=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:thumbURL]];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_shareTitle descr:_shareText thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = _shareURL;

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
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


}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


@end
