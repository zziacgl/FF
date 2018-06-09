//
//  DDMyHomeViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/21.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMyHomeViewController.h"
#import "DDMyHomeHeaderView.h"
#import "SDCycleScrollView.h"
#import <AdSupport/AdSupport.h>
#import "DDBarnerModel.h"
#import "DDNewuserModel.h"
#import "DYADDetailContentVC.h"
#import "ActivityDetailViewController.h"
#import "DDHomeMessageViewController.h"
#import "JPUSHService.h"
#import "SCLoginVerifyView.h"
#import "SCSecureHelper.h"
#import "DDNoticeViewController.h"
#import "FFHomeBannerTableViewCell.h"
#import "FFHomeSecondTableViewCell.h"
#import "FFHomeThirdTableViewCell.h"
#import "FFHomeInvestTableViewCell.h"

#define kWidthsuspensionView   kMainScreenWidth / 5

#define kLeftSpace  (kMainScreenWidth / 2 - 95) / 2
#define kTopSpace  12.5
#define kImageWidth  25
#define kWidth_newMark 40  //新手标图标


@interface DDMyHomeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    DDMyHomeHeaderView *header;
    DDNewuserModel* _newModel;
    UIView *backGroundView;
    UIImageView *newWelfareView;
    DDBarnerModel* _banaerModel;
    
    UIView *backView;
    UIView *gonggaoDanView;
    UIButton *rightBtn;
    
    NSDictionary *popData;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *barnerArray;
@property (nonatomic, strong) UIButton *suspensionView;
@property (nonatomic, strong) NSDictionary *firstUserDic;

//@property (nonatomic, strong) UILabel *footLabel;
@end
static NSString *banner = @"banner";
static NSString *second = @"second";
static NSString *third = @"third";
static NSString *invest = @"invest";

@implementation DDMyHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"多多理财";
        self.tabBarItem.title = @"首页";
//        self.fd_prefersNavigationBarHidden = YES;
    }
    return self;
}

- (void)MJ_refresh{
    MJRefreshNormalHeader*mheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getOperationData)];
    mheader.stateLabel.font = [UIFont systemFontOfSize:12];
    mheader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    mheader.stateLabel.textColor = kBtnColor;
    mheader.lastUpdatedTimeLabel.textColor = kBtnColor;
    self.tableView.mj_header = mheader;
   
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self getOperationData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getMYFootText];
    self.view.backgroundColor = kBackColor;

    if([DYUser loginIsLogin]){
//        [self customLogin];
        @try {
            [JPUSHService setTags:[NSSet setWithObjects:[NSString stringWithFormat:@"%d",[DYUser GetUserID]], nil] alias:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
                NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
            }];
        } @catch (NSException *exception) {
            
        }
    }
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"FFHomeBannerTableViewCell" bundle:nil] forCellReuseIdentifier:banner];
    [self.tableView registerNib:[UINib nibWithNibName:@"FFHomeSecondTableViewCell" bundle:nil] forCellReuseIdentifier:second];
    [self.tableView registerNib:[UINib nibWithNibName:@"FFHomeThirdTableViewCell" bundle:nil] forCellReuseIdentifier:third];
    [self.tableView registerNib:[UINib nibWithNibName:@"FFHomeInvestTableViewCell" bundle:nil] forCellReuseIdentifier:invest];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self queryADImages];
    
    [self MJ_refresh];
    
    [self smallImage];
    NSUserDefaults *tuisong = [NSUserDefaults standardUserDefaults];
    
    NSString *tui = [tuisong objectForKey:@"tuisongUrl"];
    
    if (tui.length > 0 ) {
        if ([DYUser loginIsLogin]) {
            DYADDetailContentVC *vc=[[DYADDetailContentVC alloc]init];
            vc.webUrl = tui;
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
            [tuisong setObject:@"" forKey:@"tuisongUrl"];
            
        }else {
            [DYUser  loginShowLoginView];
        }
    }
    
}
- (NSMutableArray *)barnerArray {
    if (!_barnerArray) {
        _barnerArray = [NSMutableArray array];
    }
    return _barnerArray;
}
#pragma mark -- tableviewDelegate
#pragma mark -- UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else {
        
        return 10;
    }
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kBackColor;
    return view;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [UIScreen mainScreen].bounds.size.width / 60 *26;
        }else {
            return 100;
        }
    }else if (indexPath.section == 1){
         return 110;
    }else {
        return 155;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FFHomeBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:banner forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellAccessoryNone;

            return cell;
        }else {
            FFHomeSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:second forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            
            return cell;
        }
    }else if (indexPath.section == 1){
        
        FFHomeThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:third forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        return cell;
    }else {
        
        FFHomeInvestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:invest forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        return cell;
    }
    
}

#pragma mark --运营
- (void)getOperationData {
    NSLog(@"%d",[DYUser GetUserID]);
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"index" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"app" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    if([DYUser loginIsLogin]){
        
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    }
    
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        [self.tableView.mj_header endRefreshing];
        if (isSuccess == YES) {
            myLog(@"新手标%@", object);
            NSArray*arr = [DDNewuserModel mj_objectArrayWithKeyValuesArray:object[@"borrow_info"][@"list"]];
            if (arr.count>0) {
                _newModel = arr[0];
                header.model = _newModel;
                
            }
            NSDictionary *dic = object;
            
            NSString *str = [NSString stringWithFormat:@"%@", [dic objectForKey:@"no_read_message"]];
            if ([str isEqualToString:@"1"]) {
                header.redView.alpha = 1;
            }else {
                header.redView.alpha = 0;
            }
            
            
        }else {
            [LeafNotification showInController:self withText:errorMessage];
        }
        
        
    } fail:^{
        
        
    }];
    
    
    
    
}


#pragma mark 风险评估

-(void)GetRiskAssessment{
    
    if ([DYUser loginIsLogin]) {
        DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"otherinterface" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"overtime" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic insertObject:@"risk_info" forKey:@"type" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
            if (isSuccess) {
                NSDictionary *data=[object objectForKey:@"data"];
                NSLog(@"xinshou%@", data);
                NSString *isRiskAssessment=[NSString stringWithFormat:@"%@",[data objectForKey:@"sql_result"]];
                NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                [ud setObject:isRiskAssessment forKey:@"isRiskAssessment"];
            }else {
                [LeafNotification showInController:self withText:errorMessage];
                
            }
        } fail:^{
            [LeafNotification showInController:self withText:@"网络异常"];
        }];
    }
}

#pragma mark - 活动专区接口

- (void)activityData : (NSString *)acID{
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"get_activity" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"activity" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"100" forKey:@"epage" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess == YES) {
            NSArray *arrayData = [object objectForKey:@"list"];
            [arrayData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                NSString *str = [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"]];
                //                NSLog(@"enumerateObjectsUsingBlock%@",obj);
                if ([str isEqualToString:acID]) {
                    //                    NSLog(@"unsigned%lu", (unsigned long)idx);
                    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
                    adVC.myUrls = arrayData[idx];
                    adVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:adVC animated:YES];
                }
            }];
            
        }else {
            [LeafNotification showInController:self withText:errorMessage];
        }
    } fail:^{
        [LeafNotification showInController:self withText:@"网络异常"];
        
    }];
}

#pragma mark- 轮播图
-(void)queryADImages
{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:idfa forKey:@"idfa"];
    
    NSString *udid=[[NSUUID UUID] UUIDString];;
    NSString *udids=[NSString stringWithFormat:@"%@",[ud objectForKey:@"udid"]];
    if (udids!=nil&&![udids isEqualToString:@""]&&![udids isEqualToString:@"(null)"]) {
        udid=udids;
    }else{
        [ud setObject:udid forKey:@"udid"];
    }
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"mobile_get_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"scrollpic" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"all" forKey:@"limit" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"status" atIndex:0];
    [diyouDic insertObject:@"mobile_index" forKey:@"type_nid" atIndex:0];//mobile_top：活动中心 mobile_index:轮播图
    if ([DYUser loginIsLogin]) {
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    }
    
    [diyouDic insertObject:udid forKey:@"udid" atIndex:0];
    [diyouDic insertObject:idfa forKey:@"idfa" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess == YES) {
            NSLog(@"queryADImages%@", object);
            self.barnerArray = [DDBarnerModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            
            NSLog(@"轮播%@", self.barnerArray);
            _banaerModel = self.barnerArray.firstObject;
            if (self.barnerArray.count>0) {
                header.allDataAry = self.barnerArray;
            }
            self.firstUserDic = [object objectForKey:@"novice_zone"];
            
          
            
            [self.tableView reloadData];
            
            
            
        }else {
            [LeafNotification showInController:self withText:errorMessage];
        }
    } fail:^{
        [LeafNotification showInController:self withText:@"网络异常"];
    }];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark 新手标

-(void)GetNewBorrow{
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"get_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"standard" forKey:@"borrow_type" atIndex:0];
    [diyouDic insertObject:@"invest" forKey:@"showstatus" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"limit" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        [self.tableView.mj_header endRefreshing];
        if (isSuccess) {
            //            NSLog(@"xinshou%@", object);
            NSArray*arr = [DDNewuserModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            if (arr.count>0) {
                _newModel = arr[0];
                header.model = _newModel;
                
            }
            
        }else {
            [LeafNotification showInController:self withText:errorMessage];
            
        }
    } fail:^{
        [self.tableView.mj_header endRefreshing];
        [LeafNotification showInController:self withText:@"网络异常"];
    }];
    
    
}
#pragma mark 浮动窗
- (void)smallImage {
    
    
    
    self.suspensionView = [UIButton buttonWithType:UIButtonTypeCustom];
    _suspensionView.frame = CGRectMake(10, CGRectGetHeight(self.view.frame) / 2 , kWidthsuspensionView, kWidthsuspensionView);
    CALayer *layer = [_suspensionView layer];
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.3;
    _suspensionView.adjustsImageWhenHighlighted = NO;
    UIImage *image=[UIImage imageNamed:@"homenewuser"];
    
    [_suspensionView setImage:image forState:UIControlStateNormal];
    [_suspensionView addTarget:self action:@selector(handleSuspen:) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlepan:)];
    [self.suspensionView addGestureRecognizer:pan];
    [self.view addSubview:self.suspensionView];
    
    
    
}
- (void)handleSuspen:(UIButton *)sender {
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/activity/mobile/course/course.html", ffwebURL];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"新手引导";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:adVC animated:YES];
   
   
}
//平移手势处理事件
- (void)handlepan:(UIPanGestureRecognizer *)gesture {
    
    CGPoint increment = [gesture translationInView:gesture.view];
    gesture.view.transform = CGAffineTransformTranslate(gesture.view.transform, increment.x, increment.y);
    
    [gesture setTranslation:CGPointZero inView:gesture.view];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.view.frame.origin.x < kMainScreenWidth / 2 - 30) {
            gesture.view.frame = CGRectMake(10, gesture.view.frame.origin.y, kWidthsuspensionView, kWidthsuspensionView);
            if (gesture.view.frame.origin.y < header.cycleView.frame.size.height) {
                
                gesture.view.frame = CGRectMake(10, header.cycleView.frame.size.height, kWidthsuspensionView, kWidthsuspensionView);
                
            }else if (gesture.view.frame.origin.y > kMainScreenHeight - 54 - kWidthsuspensionView){
                
                gesture.view.frame = CGRectMake(10, kMainScreenHeight - 54 - kWidthsuspensionView, kWidthsuspensionView, kWidthsuspensionView);
                
            }
        }else {
            gesture.view.frame = CGRectMake(kMainScreenWidth - kWidthsuspensionView - 10, gesture.view.frame.origin.y, kWidthsuspensionView, kWidthsuspensionView);
            if (gesture.view.frame.origin.y < header.cycleView.frame.size.height) {
                
                gesture.view.frame = CGRectMake(kMainScreenWidth - kMainScreenWidth / 5 - 10, header.cycleView.frame.size.height, kWidthsuspensionView, kWidthsuspensionView);
                ;
            }else if (gesture.view.frame.origin.y > kMainScreenHeight - 54 - kWidthsuspensionView){
                
                gesture.view.frame = CGRectMake(kMainScreenWidth - kWidthsuspensionView - 10, kMainScreenHeight - 54 - kWidthsuspensionView, kWidthsuspensionView, kWidthsuspensionView);
                
            }
        }
    }
    
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
                NSString *str = [NSString stringWithFormat:@"%@", object[@"data"][@"ios_text"]];
                if (str.length > 0 && ![str isEqualToString:@"(null)"]) {
                    
                    header.footLabel.text = str;
                }
            }
            
        }else {
            [LeafNotification showInController:self withText:errorMessage];
            
        }
    } fail:^{
        [LeafNotification showInController:self withText:@"网络异常"];
    }];
}

- (void) shakeToShow:(UIImageView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

#pragma mark -- 隐藏登录

- (void)customLogin{
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    
    NSLog(@"密码%@",[DYUser loginGetUserNameAndPassword]);
    
    [diyouDic insertObject:[DYUser loginGetUserNameAndPassword][1] forKey:@"password" atIndex:0];
    [diyouDic insertObject:[DYUtils stringToUnicode:[DYUser loginGetUserNameAndPassword][0]] forKey:@"loginname" atIndex:0];
    [diyouDic insertObject:@"login" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         if (_tableView.mj_header.isRefreshing)
         {
             [_tableView.mj_header endRefreshing];
         }
         if (isSuccess)
         {
             
             [DYUser userIDPersistence:object];
             [DYUser DYUser].userName=[DYUtils stringToUnicode:[DYUser loginGetUserNameAndPassword][0]];
             
         }
         else
         {
         }
         
     } errorBlock:^(id error)
     {
         if (_tableView.mj_header.isRefreshing)
         {
             [_tableView.mj_header endRefreshing];
         }
         
     }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
