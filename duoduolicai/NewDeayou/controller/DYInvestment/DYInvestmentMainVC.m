//
//  DYInvestmentMainVC.m
//  NewDeayou
//
//  Created by wayne on 14-6-18.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYInvestmentMainVC.h"
#import "DYSortButtonItem.h"
#import "UIButton+ImageTitleSpacing.h"
#import "DYInvestListCell.h"
#import "WJPopoverViewController.h"
#import "DYInvestDetailVC.h"
#import "LeafNotification.h"
#import "UIColor+FFCustomColor.h"
#define kSortViewOriginX  50
#define kScreen_Width    [UIScreen mainScreen].bounds.size.width //屏幕宽度
#define kScreen_Height   [UIScreen mainScreen].bounds.size.height//屏幕高度
#define kBtn_Width   (kScreen_Width - 60) / 5//按钮宽度

#define title1_myTransfer  @"original_fragment"
#define title2_myTransfer  @"tf"

@interface DYInvestmentMainVC ()< PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate, UIScrollViewDelegate,UIPopoverPresentationControllerDelegate,UIAlertViewDelegate>
{
    UINib * nibCellHead;
    UINib * nibCellForInvest;           //复用cell的nib(投资列表)
    UINib * nibCellForBondTransfer;     //复用cell的nib(债券转让)
    int page; //页号
    NSString* epage; //每页的数量
    BOOL isViewDidLoad;
    UIView *backView;
    BOOL _isMid;
    BOOL _isRight;
    
    UIView *backView2;
    UIView *gonggaoDanView;
    UIButton *myrightBtn;
    UIView *lineView;
    
    NSString *activityURL;//活动链接
    NSString *activityName;//活动标题

}

@property (nonatomic, strong) WJPopoverViewController *popView;
@property (nonatomic,retain)NSMutableArray * aryData;

@property (strong, nonatomic) IBOutlet UIView *tableHeadView;

@property (nonatomic,strong)PullingRefreshTableView *tableView;
@property (nonatomic,strong)NSDictionary *dicTime;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, copy) NSString *mySta;
@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, copy) NSString *myTransfer;
@property (nonatomic, strong) UISegmentedControl *segment ;

@property (nonatomic, strong) UIView *customScreenView;

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *midBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, weak)UIButton*button;
@property (nonatomic, strong) NSMutableArray *roanAry;
@property (nonatomic, strong) NSMutableArray *otherAry;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *segmentLeftLabel;
@property (nonatomic, strong) UILabel *segmentRightLabel;

@end
static int tftype = 0;//判断是否转让标


@implementation DYInvestmentMainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"产品";
        
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
    [MobClick beginLogPageView:@"product-Choice_PT"];
//    [self GetRiskAssessment];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"product-Choice_PT"];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (isViewDidLoad)
    {
        //初始化tableView
        [_tableView launchRefreshing];
        isViewDidLoad=NO;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    self.myPro = @"";
    self.mySta = @"";
    self.view.backgroundColor = kBackColor;
    self.myTransfer = title1_myTransfer;
    NSArray *titles = @[@"普通标",@"转让标",];
    self.segment = [[UISegmentedControl alloc] initWithItems:titles];
    
    _segment.frame = CGRectMake(kMainScreenWidth / 4, 10, kMainScreenWidth / 2, 30);
    _segment.tintColor = kBtnColor;
    _segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(handleSegment:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment;
    
    //导航右边的按钮
    UIButton * btnRightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor = [UIColor clearColor];
    btnRightItem.frame = CGRectMake(0, 0, 22, 22);
    [btnRightItem setBackgroundImage:[UIImage imageNamed:@"标规则"] forState:UIControlStateNormal];

    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRightItem addTarget:self action:@selector(rightBarButtonItemActionMore) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
    _topView.backgroundColor = kBackColor;
//    [self.view addSubview:self.topView];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, kMainScreenWidth / 3, 40);
    _leftBtn.backgroundColor = [UIColor whiteColor];
    [_leftBtn setTitle:@"默认" forState:UIControlStateNormal];

     [_leftBtn setTitleColor:kMainColor2 forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_leftBtn addTarget:self action:@selector(handleLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.leftBtn];
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 - 1, 10, 1, 20)];
    leftLineView.backgroundColor = [HeXColor colorWithHexString:@"#cccccc"];
    [self.topView addSubview:leftLineView];
    
    self.midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _midBtn.backgroundColor = [UIColor whiteColor];
    _midBtn.frame = CGRectMake(kMainScreenWidth / 3, 0, kMainScreenWidth / 3, 40);
    [_midBtn setTitle:@"期限" forState:UIControlStateNormal];
    [_midBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_midBtn setImage:[UIImage imageNamed:@"理财01"] forState:UIControlStateNormal];
    _midBtn.adjustsImageWhenHighlighted = NO;
    _isMid = YES;
    [self.midBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:2.0];
    _midBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UITapGestureRecognizer *midTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMid)];
    [_midBtn addGestureRecognizer:midTap];
    [self.topView addSubview:self.midBtn];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 * 2 - 1, 10, 1, 20)];
    rightLineView.backgroundColor = [HeXColor colorWithHexString:@"#cccccc"];
    [self.topView addSubview:rightLineView];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.backgroundColor = [UIColor whiteColor];
    _rightBtn.frame = CGRectMake(kMainScreenWidth / 3 * 2, 0, kMainScreenWidth / 3, 40);
    [_rightBtn setTitle:@"预期年化" forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"理财01"] forState:UIControlStateNormal];
    _rightBtn.adjustsImageWhenHighlighted = NO;
    [self.rightBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:2.0];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRight)];
    [_rightBtn addGestureRecognizer:rightTap];
    _isRight = YES;
    [self.topView addSubview:self.rightBtn];
    
    
    
    // 上拉，下拉，tableView
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 20, kScreenSize.width, kScreenSize.height- 84) style:UITableViewStylePlain topTextColor:kBtnColor topBackgroundColor:kBackColor bottomTextColor:[UIColor blackColor] bottomBackgroundColor:nil];
    _tableView.headerView.backgroundColor = kBackColor;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.pullingDelegate = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = kBackColor;
    
    isViewDidLoad=YES;
    
    self.noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.noDataView.backgroundColor = kBackColor;
    [self.tableView addSubview:self.noDataView];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3, kMainScreenHeight / 2 - kMainScreenWidth / 2, kMainScreenWidth / 3, kMainScreenWidth / 4)];
    backImage.image = [UIImage imageNamed:@"我的卡券（无可用优惠券）_03"];
    [self.noDataView addSubview:backImage];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backImage.frame) + 20, kMainScreenWidth, 20)];
    titleLab.text = @"客官~理财产品都被抢完啦";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    [self.noDataView addSubview:titleLab];
    self.noDataView.alpha = 0;
    

}
- (void)gonggaoDanView :(NSDictionary *)ConentND{
    
    backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    backView2.backgroundColor = [UIColor blackColor];
    backView2.alpha = 0.6;
    [[[UIApplication sharedApplication] keyWindow] addSubview:backView2];
    
    gonggaoDanView  = [[UIView alloc] initWithFrame:CGRectMake(30, kMainScreenHeight / 2 - (70 + 8 * 30 + 70) / 2 , kMainScreenWidth - 60, 0)];
    gonggaoDanView.backgroundColor = [UIColor whiteColor];
    gonggaoDanView.layer.cornerRadius = 10;
    gonggaoDanView.layer.masksToBounds = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:gonggaoDanView];
    
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:gonggaoDanView.frame];
    NSString *fileURL=[NSString stringWithFormat:@"%@",[ConentND objectForKey:@"pic_url"]];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    bgImageView.image=[UIImage imageWithData:data];
    [gonggaoDanView addSubview:bgImageView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(20, 3*80 + 20, (CGRectGetWidth(gonggaoDanView.frame) - 140), 40);
    //    leftBtn.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
    [leftBtn addTarget:self action:@selector(danchuangLeft) forControlEvents:UIControlEventTouchUpInside];
    [gonggaoDanView addSubview:leftBtn];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,0.5, 60)];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.alpha = 1;
    [[[UIApplication sharedApplication] keyWindow] addSubview:lineView];

    
    myrightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myrightBtn.frame = CGRectMake(kMainScreenWidth - 60-26,13,26,26);
    myrightBtn.layer.cornerRadius = 13;
    myrightBtn.layer.masksToBounds = YES;
    [myrightBtn setBackgroundImage:[UIImage imageNamed:@"homeClose"] forState:UIControlStateNormal];
    [myrightBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    myrightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [[[UIApplication sharedApplication] keyWindow] addSubview:myrightBtn];
    
    gonggaoDanView.frame = CGRectMake(30, kMainScreenHeight / 2 -(kMainScreenWidth - 60) / 660 *460/ 2+50,kMainScreenWidth-60, (kMainScreenWidth - 60) / 660 *460);
    bgImageView.frame=CGRectMake(0, 0, gonggaoDanView.frame.size.width, gonggaoDanView.frame.size.height);
    leftBtn.frame=CGRectMake(0, 0, gonggaoDanView.frame.size.width, gonggaoDanView.frame.size.height);
    myrightBtn.frame = CGRectMake(kMainScreenWidth -70, gonggaoDanView.frame.origin.y-100, 40, 40);
    lineView.frame=CGRectMake(myrightBtn.center.x, myrightBtn.center.y+20, 0.5,60);
    
    activityURL=[NSString stringWithFormat:@"%@",[ConentND objectForKey:@"contents"]];
    activityName=[NSString stringWithFormat:@"%@",[ConentND objectForKey:@"name"]];
    
    
}



- (void)danchuangLeft {
    [self danchuangRight];
    
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":activityURL};
    adVC.titleM=activityName;
    adVC.isdan=1;
    adVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:adVC animated:YES];

}
-(void)closeView{
    [self danchuangRight];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    int role =[[ud objectForKey:@"role"] intValue];
    if (role==0) {
        [ud setObject:@"1" forKey:@"role"];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有授权自动投标，如需投资多选必须去授权。" delegate:self cancelButtonTitle:@"去授权" otherButtonTitles:@"不了", nil];
        alert.tag=747;
        [alert show];
    }

}
- (void)danchuangRight {
    backView2.alpha = 0;
    [backView2 removeFromSuperview];
    [gonggaoDanView removeFromSuperview];
    [myrightBtn removeFromSuperview];
    [lineView removeFromSuperview];
    
   
}
-(void)viewDidDisappear:(BOOL)animated{
    [self danchuangRight];
    [super viewDidDisappear:animated];
}

-(void)rightBarButtonItemActionMore{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"规则公告" message:@"平台每日9点到22点整点发标且满标后随机发标；具体以平台实际发标时间为准。" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    
}

- (void)handleLeft {
    
    self.mySta = @"";
    _isMid = YES;
    _isRight = YES;
    [_midBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_midBtn setImage:[UIImage imageNamed:@"理财01"] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"理财01"] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:kMainColor2 forState:UIControlStateNormal];
    [self.tableView launchRefreshing];
}
- (void)handleMid {
     _isMid = !_isMid;
    [_leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"理财01"] forState:UIControlStateNormal];
    
    if (!_isMid) {
        
        [_midBtn setImage:[UIImage imageNamed:@"理财02"] forState:UIControlStateNormal];
        [_midBtn setTitleColor:kMainColor2 forState:UIControlStateNormal];
        self.mySta = @"period_up";
        [self.tableView launchRefreshing];
       
    }else {
        [_midBtn setImage:[UIImage imageNamed:@"理财03"] forState:UIControlStateNormal];
        [_midBtn setTitleColor:kMainColor2 forState:UIControlStateNormal];
        self.mySta = @"period_down";
        [self.tableView launchRefreshing];
    }
    
    
}
- (void)handleRight{
    _isRight = !_isRight;
    [_leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_midBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_midBtn setImage:[UIImage imageNamed:@"理财01"] forState:UIControlStateNormal];
    
    
    if (!_isRight) {
        [_rightBtn setTitleColor:kMainColor2 forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"理财02"] forState:UIControlStateNormal];
        self.mySta = @"apr_up";
        [self.tableView launchRefreshing];
    }else {
        [_rightBtn setTitleColor:kMainColor2 forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"理财03"] forState:UIControlStateNormal];
        self.mySta = @"apr_down";
        [self.tableView launchRefreshing];
    }
}

//分段控件响应事件
- (void)handleSegment:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
   
   if (index == 0){
        self.myTransfer = title1_myTransfer;
        self.mySta = @"";
        tftype = 0;
        [self.tableView launchRefreshing];
        
    }else if (index == 1){
        self.myTransfer = title2_myTransfer;
        self.mySta = @"";
        tftype = 1;
        [self.tableView launchRefreshing];
       
    }
    
}
#pragma mark-－－－-scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_tableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_tableView tableViewDidEndDragging:scrollView];
    
}

#pragma mark - pullingTableViewDelegate

-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    
    [self refreshTableView:NO prodect:self.myTransfer status:self.mySta];
    
}
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    
    [self refreshTableView:YES prodect:self.myTransfer status:self.mySta];
    
}
-(void)refreshTableView:(BOOL)object prodect:(NSString *)pro status:(NSString *)sta
{
    [self GetAdvanceNotice:object mypro:pro mysta:sta];
}

#pragma mark - tableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.roanAry.count;
    }else if(section==1){
        //还款中只显示20条
        if(self.otherAry.count>20){
            return 20;
        }else{
            return self.otherAry.count;
        }
    }else{
        return 0;
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = kBackColor;
    if (self.otherAry.count > 0) {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 20)];
        if (section==1) {
            lab.text = @"一以下为近期已满额项目一";
        }else{
            lab.text = @"仅显示近期20个还款项目";
        }
        
        lab.backgroundColor = kBackColor;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor lightGrayColor];
        [aView addSubview:lab];
    }
    return aView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else if(section==1){
        return 30;
    }else{
        return 30;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * mark=@"reusedInvest";
    if (!nibCellForInvest)
    {
        nibCellForInvest=[UINib nibWithNibName:@"DYInvestListCell" bundle:nil];
        [tableView registerNib:nibCellForInvest forCellReuseIdentifier:mark];
        
    }
    
    
    DYInvestListCell *cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (indexPath.section == 0) {
        if (self.roanAry.count > 0) {
            [cell setAttributeWithDictionary:self.roanAry[indexPath.row] type:tftype product:self.myTransfer];
        }
    }else {
        if (self.otherAry.count > 0) {
            [cell setAttributeWithDictionary:self.otherAry[indexPath.row] type:tftype product:self.myTransfer];
        }
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //去掉点击后的阴影
    return cell;
    
}

-(void)GetAdvanceNotice:(BOOL)isRefresh mypro:(NSString *)prodect mysta:(NSString *)status {
//      NSLog(@"排序%@ddd %@", prodect, status);
    if (isRefresh) {
      
        page = 1;
        DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"borrow_list" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"app" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
        if([DYUser loginIsLogin]){
            
            [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        }
        if (![prodect isEqualToString:@""]) {
            [diyouDic insertObject:prodect forKey:@"product_nid" atIndex:0];
        }
        if (![status isEqualToString:@""]) {
            [diyouDic insertObject:status forKey:@"order" atIndex:0];
        }
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
        
        
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
            
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
                 NSLog(@"打打%@", object);
                 NSDictionary *data=[object objectForKey:@"data"];
                 NSDictionary *borrowList=[data objectForKey:@"borrow_list"];
                 
                 self.roanAry = [NSMutableArray new];
                 self.otherAry = [NSMutableArray new];
                 self.aryData = [NSMutableArray new];
                 
                 self.aryData = [borrowList objectForKey:@"list"];
                 for (int i = 0 ; i < self.aryData.count; i++) {
                     NSDictionary *dic = self.aryData[i];
                     NSString *str = [NSString stringWithFormat:@"%@", [dic objectForKey:@"borrow_status_nid"]];
                     
                     if ([str isEqualToString:@"loan"] || [str isEqualToString:@"count_down"]) {
                         
                         [self.roanAry addObject:dic];
                     }
                     else {
                         [self.otherAry addObject:dic];
                     }
                 }
//                 NSLog(@"热手中%lu", (unsigned long)self.roanAry.count);
                 if (self.aryData.count == 0) {
                     self.noDataView.alpha = 1;
                 }else {
                     self.noDataView.alpha = 0;
                 }
                 
                 if ([prodect isEqualToString:title2_myTransfer]) {
                     tftype = 1;
                     _segment.selectedSegmentIndex = 1;

                 }else if ([prodect isEqualToString:title1_myTransfer]){
                     tftype = 0;
                     _segment.selectedSegmentIndex = 0;

                 }
                  [self.tableView reloadData];
                 
                 

             }
             else
             {
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         { if (_tableView.headerView.isLoading)
         {
             [_tableView tableViewDidFinishedLoading];
         }
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }else {
        page++;
        
        DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"get_list" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic insertObject:@"invest" forKey:@"showstatus" atIndex:0];
        if (![prodect isEqualToString:@""]) {
            [diyouDic insertObject:prodect forKey:@"product_nid" atIndex:0];
        }
        if (![status isEqualToString:@""]) {
            [diyouDic insertObject:status forKey:@"order" atIndex:0];
        }
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             
             if (_tableView.footerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
                 
                 
                 NSArray * ary=[object objectForKey:@"list"];
                 if (ary.count>0) {
                     
                     for (int i=0; i<ary.count;i++ )
                     {
                         NSDictionary *dic = ary[i];
                         NSString *str = [NSString stringWithFormat:@"%@", [dic objectForKey:@"borrow_status_nid"]];
                         if ([str isEqualToString:@"loan"] || [str isEqualToString:@"count_down"]) {
                             
                             [self.roanAry addObject:dic];
                            
                         }
                         else {
                             [self.otherAry addObject:dic];
                             
                         }
                         
                     }
                     
                     
                 }else
                 {
                     [LeafNotification showInController:self withText:@"数据加载完了"];
                 }
                 [self.tableView reloadData];
                 
                 
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
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str = @"";
    if (indexPath.section == 0) {
                    NSLog(@"南山南单%@", self.myTransfer);

        str = [self.roanAry[indexPath.row] DYObjectForKey:@"borrow_nid"];
        if (str) {
            DYInvestDetailVC * detailVC=[[DYInvestDetailVC alloc]initWithNibName:@"DYInvestDetailVC" bundle:nil];
            detailVC.hidesBottomBarWhenPushed=YES;
            detailVC.borrow_status_nid = [_roanAry[indexPath.row] objectForKey:@"borrow_status_nid"];
            NSString *borrow_type = [self.roanAry[indexPath.row] objectForKey:@"borrow_type"];
             detailVC.borrowType = borrow_type;
            detailVC.borrowId = [_roanAry[indexPath.row] DYObjectForKey:@"borrow_nid"];

            [self.navigationController pushViewController:detailVC animated:YES];
            
        }

    }else {
        str = [self.otherAry[indexPath.row] DYObjectForKey:@"borrow_nid"];
        if (str) {
            DYInvestDetailVC * detailVC=[[DYInvestDetailVC alloc]initWithNibName:@"DYInvestDetailVC" bundle:nil];
            detailVC.hidesBottomBarWhenPushed=YES;
            detailVC.borrow_status_nid = [_otherAry[indexPath.row] objectForKey:@"borrow_status_nid"];
            NSString *borrow_type = [self.otherAry[indexPath.row] objectForKey:@"borrow_type"];
             detailVC.borrowId = [_otherAry[indexPath.row] DYObjectForKey:@"borrow_nid"];
            detailVC.borrowType = borrow_type;

            [self.navigationController pushViewController:detailVC animated:YES];
            
        }

    }
}





@end
