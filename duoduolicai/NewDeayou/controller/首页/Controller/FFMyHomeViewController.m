//
//  FFMyHomeViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/4/19.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "FFMyHomeViewController.h"
#import "FFHomeBannerTableViewCell.h"
#import "FFHomeSecondTableViewCell.h"
#import "FFHomeThirdTableViewCell.h"
#import "FFHomeInvestTableViewCell.h"
#import "DDHomeMessageViewController.h"
#import "DDServiceCenterViewController.h"
#import "DDBarnerModel.h"
#import "DDNewuserModel.h"

#define kWidthsuspensionView   kMainScreenWidth / 5

#define kLeftSpace  (kMainScreenWidth / 2 - 95) / 2
#define kTopSpace  12.5
#define kImageWidth  25
#define kWidth_newMark 40  //新手标图标
@interface FFMyHomeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *HomeTableView;
@property (nonatomic, strong) NSMutableArray *barnerArray;
@property (nonatomic, strong) DDBarnerModel *banaerModel;
@property (nonatomic, strong) DDNewuserModel *newinvestModel;//新手标
@property (nonatomic, strong) DDNewuserModel *recommendedModel;//推荐标
@property (nonatomic, strong) UIButton *rightNavBtn;
@property (nonatomic, strong) UIButton *suspensionView;

@property (nonatomic, strong) UILabel *homeFootLabel;

@end
static NSString *banner = @"banner";
static NSString *second = @"second";
static NSString *third = @"third";
static NSString *invest = @"invest";
static float myheight;
@implementation FFMyHomeViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"丰丰金融";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self getInvestData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackColor;
    NSLog(@"高度%ff", self.view.frame.size.height);
    [self configuteTableView];
    [self MJ_refresh];
    [self queryADImages];
    [self getMYFootText];
    [self smallImage];
    // Do any additional setup after loading the view.
}

#pragma mark -- tableView
- (void)MJ_refresh{
    MJRefreshNormalHeader*mheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getInvestData)];
    mheader.stateLabel.font = [UIFont systemFontOfSize:12];
    mheader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    mheader.stateLabel.textColor = kBtnColor;
    mheader.lastUpdatedTimeLabel.textColor = kBtnColor;
    self.HomeTableView.mj_header = mheader;
    
}
- (void)configuteTableView {
    
    if ([UIScreen mainScreen].bounds.size.height == 812) {
        myheight = 85;
    }else {
        myheight = 50;
    }
    self.HomeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height) - myheight) style:UITableViewStylePlain];
    _HomeTableView.dataSource = self;
    _HomeTableView.delegate = self;
    _HomeTableView.backgroundColor = [UIColor clearColor];
    _HomeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _HomeTableView.showsVerticalScrollIndicator = NO;
    [self.HomeTableView registerNib:[UINib nibWithNibName:@"FFHomeBannerTableViewCell" bundle:nil] forCellReuseIdentifier:banner];
    [self.HomeTableView registerNib:[UINib nibWithNibName:@"FFHomeSecondTableViewCell" bundle:nil] forCellReuseIdentifier:second];
    [self.HomeTableView registerNib:[UINib nibWithNibName:@"FFHomeThirdTableViewCell" bundle:nil] forCellReuseIdentifier:third];
    [self.HomeTableView registerNib:[UINib nibWithNibName:@"FFHomeInvestTableViewCell" bundle:nil] forCellReuseIdentifier:invest];
    
    [self.view addSubview:self.HomeTableView];
    [self.HomeTableView addSubview:self.homeFootLabel];
    UIButton *liftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    liftNavBtn.frame = CGRectMake(0, 0, 30, 30);
    [liftNavBtn setImage:[UIImage imageNamed:@"service"] forState:UIControlStateNormal];
    [liftNavBtn addTarget:self action:@selector(handleLift) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:liftNavBtn];
    
    self.rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightNavBtn.frame = CGRectMake(0, 0, 30, 30);
    [self.rightNavBtn setImage:[UIImage imageNamed:@"Bell"] forState:UIControlStateNormal];
    [self.rightNavBtn addTarget:self action:@selector(handleRight) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavBtn];
    NSLog(@"tab高度%ff", self.HomeTableView.frame.size.height);
    
}
#pragma mark -- 导航item响应
-(void)handleLift {
    DDServiceCenterViewController *serviceCenterVC = [[DDServiceCenterViewController alloc]init];
    serviceCenterVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:serviceCenterVC animated:YES];
    
}

- (void)handleRight {
    DDHomeMessageViewController *messageVc = [[DDHomeMessageViewController alloc]init];
    messageVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVc animated:YES];
    
    
}
#pragma mark -- UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else {
        
        return 8;
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
            cell.bannerAry = self.barnerArray;
            
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
        if (indexPath.section == 2) {
            cell.newinvestModel = self.newinvestModel;
        }else if (indexPath.section == 3) {
            
            cell.recommendedModel = self.recommendedModel;
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        return cell;
    }
    
}
#pragma mark -- bannerData
-(void)queryADImages
{
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
    //    [diyouDic insertObject:udid forKey:@"udid" atIndex:0];
    //    [diyouDic insertObject:idfa forKey:@"idfa" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess == YES) {
            //            NSLog(@"queryADImages%@", object);
            self.barnerArray = [DDBarnerModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            
            //            NSLog(@"轮播%@", self.barnerArray);
            
            [self.HomeTableView reloadData];
            
        }else {
            [LeafNotification showInController:self withText:errorMessage];
        }
    } fail:^{
        [LeafNotification showInController:self withText:@"网络异常"];
    }];
    [self.HomeTableView.mj_header endRefreshing];
}
#pragma mark -- 标的数据
- (void)getInvestData {
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"index20180419" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"app" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    if([DYUser loginIsLogin]){
        [diyouDic insertObject:[NSString stringWithFormat:@"%@",[DYUser GetLoginKey]] forKey:@"login_key" atIndex:0];
    }
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        [self.HomeTableView.mj_header endRefreshing];
        if (isSuccess == YES) {
            myLog(@"新手标%@", object);
            NSString *messageStr = [object objectForKey:@"no_read_message"];
            if ([messageStr isEqualToString:@"0"]) {
                [self.rightNavBtn setImage:[UIImage imageNamed:@"Bell"] forState:UIControlStateNormal];
            }else {
                [self.rightNavBtn setImage:[UIImage imageNamed:@"Bellred"] forState:UIControlStateNormal];
                
            }
            
            self.newinvestModel = [DDNewuserModel mj_objectWithKeyValues:[object objectForKey:@"standard"]];
            self.recommendedModel = [DDNewuserModel mj_objectWithKeyValues:[object objectForKey:@"tj"]];
            [self.HomeTableView reloadData];
        }else {
            [LeafNotification showInController:self withText:errorMessage];
        }
        
        
    } fail:^{
        [self.HomeTableView.mj_header endRefreshing];
        
    }];
    
    
    
    
}
#pragma mark 浮动窗
- (void)smallImage {
    
    
    
    self.suspensionView = [UIButton buttonWithType:UIButtonTypeCustom];
    _suspensionView.frame = CGRectMake(kMainScreenWidth - kWidthsuspensionView - 10, [UIScreen mainScreen].bounds.size.width / 60 *26 + 100 , kWidthsuspensionView, kWidthsuspensionView);
    CALayer *layer = [_suspensionView layer];
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.3;
    _suspensionView.adjustsImageWhenHighlighted = NO;
    UIImage *image = [UIImage imageNamed:@"homenewuser"];
    
    
    
    [_suspensionView setImage:image forState:UIControlStateNormal];
//    [_suspensionView setContentMode:UIViewContentModeScaleToFill];
//    [_suspensionView setClipsToBounds:YES];
    
    [_suspensionView addTarget:self action:@selector(handleSuspen:) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlepan:)];
    [self.suspensionView addGestureRecognizer:pan];
    [self.view addSubview:self.suspensionView];
    
    
     [self shakeAnimationForView:self.suspensionView];
    
    
    
}
- (void)shakeAnimationForView:(UIView *) view

{
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
        // 获取当前View的位置
        CGPoint position = viewLayer.position;
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    // 设置自动反转
    [animation setAutoreverses:YES];
    
    // 设置时间
    [animation setDuration:1];
    // 设置次数
    [animation setRepeatCount:100];
    [viewLayer addAnimation:animation forKey:nil];
    
}
- (void)handleSuspen:(UIButton *)sender {
    [MobClick event:@"home_XSYD_fubiao"];
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/activity/mobile/course/course.html", ffwebURL];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"新手引导";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:adVC animated:YES];
    
    
}
//平移手势处理事件
- (void)handlepan:(UIPanGestureRecognizer *)gesture {
    //    NSLog(@"%f.f", gesture.view.frame.origin.y );
    //    NSLog(@"屏幕%f", kMainScreenHeight);
    CGPoint increment = [gesture translationInView:gesture.view];
    gesture.view.transform = CGAffineTransformTranslate(gesture.view.transform, increment.x, increment.y);
    
    [gesture setTranslation:CGPointZero inView:gesture.view];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.view.frame.origin.x < kMainScreenWidth / 2 - 30) {
            gesture.view.frame = CGRectMake(10, gesture.view.frame.origin.y, kWidthsuspensionView, kWidthsuspensionView);
            if (gesture.view.frame.origin.y < [UIScreen mainScreen].bounds.size.width / 60 *26) {
                
                gesture.view.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.width / 60 *26, kWidthsuspensionView, kWidthsuspensionView);
                
            }else if (gesture.view.frame.origin.y > kMainScreenHeight - 64 - myheight - kWidthsuspensionView){
                
                gesture.view.frame = CGRectMake(10, kMainScreenHeight - 64 - myheight - kWidthsuspensionView, kWidthsuspensionView, kWidthsuspensionView);
                
            }
        }else {
            gesture.view.frame = CGRectMake(kMainScreenWidth - kWidthsuspensionView - 10, gesture.view.frame.origin.y, kWidthsuspensionView, kWidthsuspensionView);
            if (gesture.view.frame.origin.y < [UIScreen mainScreen].bounds.size.width / 60 *26) {
                
                gesture.view.frame = CGRectMake(kMainScreenWidth - kMainScreenWidth / 5 - 10, [UIScreen mainScreen].bounds.size.width / 60 *26, kWidthsuspensionView, kWidthsuspensionView);
                ;
            }else if (gesture.view.frame.origin.y > kMainScreenHeight - 64 - myheight - kWidthsuspensionView){
                
                gesture.view.frame = CGRectMake(kMainScreenWidth - kWidthsuspensionView - 10, kMainScreenHeight - 64 - myheight  - kWidthsuspensionView, kWidthsuspensionView, kWidthsuspensionView);
                
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
                    
                    self.homeFootLabel.text = str;
                }
            }
            
        }else {
            [LeafNotification showInController:self withText:errorMessage];
            
        }
    } fail:^{
        [LeafNotification showInController:self withText:@"网络异常"];
    }];
}
- (UILabel *)homeFootLabel {
    if (!_homeFootLabel) {
        self.homeFootLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.width / 60 * 26 + 210 + 310 + 30 , kMainScreenWidth, 30)];
        
        _homeFootLabel.font = [UIFont systemFontOfSize:13];
        _homeFootLabel.textColor = [UIColor darkGrayColor];
        _homeFootLabel.textAlignment = NSTextAlignmentCenter;
       
        
        
    }
    return _homeFootLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
