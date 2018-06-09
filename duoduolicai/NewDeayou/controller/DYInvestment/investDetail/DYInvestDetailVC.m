//
//  DYInvestDetailVC.m
//  NewDeayou
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYInvestDetailVC.h"
#import "DYInvestSubmitVC.h"
#define kLoginUserName              @"mac"
#import "FFMineModel.h"
#import "DYLoginVC.h"
#import "DYUtils.h"

#import "PullingRefreshTableView.h"
#import "NewInvestTableViewCell.h"

#import "DDRechargeViewController.h"
#import "DDInsuranceViewController.h"
#import "UIColor+FFCustomColor.h"

#import "LeafNotification.h"
#import "DDAssignTableViewCell.h"
#import "SDCycleScrollView.h"
#import "DYSafeViewController.h"
#import "DDDuoChoosePlanTableViewCell.h"
//#import <CustomAlertView.h>

#define kScreen_Width   [UIScreen mainScreen].bounds.size.width
#define kScreen_Height   [UIScreen mainScreen].bounds.size.height

@interface DYInvestDetailVC ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,SDCycleScrollViewDelegate, UIAlertViewDelegate>

{
    UINib * nibCell;
    MKNetworkOperation * operation;
    
}

@property (strong, nonatomic) IBOutlet PullingRefreshTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *myFootView;
@property (strong, nonatomic) IBOutlet UIButton *btnInvestNow;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *firstDetailLabel;

@property (nonatomic, strong) UIButton *secondBtn;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *secondDetailLabel;

@property (nonatomic,retain) NSMutableDictionary * dicData;
@property (nonatomic,assign) BOOL isRevert;

//银行卡信息
@property (nonatomic) BOOL isBindBank;//是否绑定银行卡
@property (nonatomic) int BankType;//银行类型
@property (nonatomic,strong)NSString *BankNo;//银行卡号
@property (nonatomic, strong) NSDictionary *firstDataDic;
@property (nonatomic, strong) NSDictionary *secondDataDic;
@property (nonatomic, strong) NSDictionary *thirdDataDic;
@property (nonatomic, strong) SDCycleScrollView *customScrollView;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) FFMineModel *ffmodel;
@property (nonatomic)int isaddBiao;
@property (nonatomic)int isaddBalance;
@end

@implementation DYInvestDetailVC{
    NSString *balance;
    NSString *isInvest;
    
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        self.title=@"投资详情";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"标的id%@", self.borrowId);
    CALayer *layer = [self.btnInvestNow layer];
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.3;
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"whiteback"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    NSLog(@"搞定%f", ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height));
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kMainScreenHeight - ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height) - 60) style:UITableViewStylePlain topTextColor:[UIColor whiteColor] topBackgroundColor:nil bottomTextColor:[UIColor blackColor] bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor]; // 背景颜色
    _tableView.headerOnly = YES;
    _tableView.pullingDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.headerView.backgroundColor= [UIColor clearColor]; // 头颜色
    [_tableView.headerView.layer addSublayer:[UIColor setGradualChangingColor:_tableView.headerView fromColor:@"fb9903" toColor:@"f76405"]];
    
    
    
    _tableView.footerView.backgroundColor=[UIColor whiteColor]; // 脚颜色
    _tableView.hidden=YES;
    
    [self.view addSubview:_tableView];
    [self getuserMessage];
    
    if (![DYUser loginIsLogin]) {
        _btnInvestNow.userInteractionEnabled=YES;
        _btnInvestNow.backgroundColor=kBtnColor;
        [_btnInvestNow setTitle:@"请先登录" forState:UIControlStateNormal];
        [_btnInvestNow addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [_tableView launchRefreshing];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    CGRect frame = CGRectMake(0, 0, kMainScreenWidth,[UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height);
    
    UIImage *image = [DYUtils gradientImageWithBounds:frame andColors:@[kShallowColor,kDeepColor] andGradientType:1];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
    self.navigationController.navigationBar.barTintColor  = kBtnColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:17]}];
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.navigationController.navigationBar.bounds;
    //    [self.navigationController.navigationBar.layer addSublayer:self.gradientLayer];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 0);
    self.gradientLayer.colors = @[(__bridge id)kShallowColor.CGColor,
                                  (__bridge id)kDeepColor.CGColor];
    self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
    self.navigationController.toolbarHidden = YES;
    //    self.navigationController.navigationBarHidden=NO;
    
    _dicData = [NSMutableDictionary new];
    self.firstDataDic = [NSDictionary new];
    self.secondDataDic = [NSDictionary new];
    self.thirdDataDic = [NSDictionary new];
    [self queryInvestOrTransferDetailByBorrowId:self.borrowId];
    
    [self getdata];
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.barTintColor  = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:17]}];
    
    
    DDAssignTableViewCell *cell = [self.view viewWithTag:600];
    [cell.timer invalidate];
    cell.timer = nil;
    [operation cancel];
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)setBorrow_status_nid:(NSString *)borrow_status_nid{
//    _borrow_status_nid=borrow_status_nid;
//    
//}
-(void)setIsRevert:(BOOL)isRevert
{
    _isRevert=isRevert;
}
- (void)firstpressed
{
    [DYUser  loginShowLoginView];
}

#pragma mark- tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.borrowType isEqualToString:@"fragment"]) {
        return 600;//银城通
    }else if ([self.borrowType isEqualToString:@"transfer"]){
        return 620;//转让标
    }else{
        return 600;//普通标
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.borrowType isEqualToString:@"transfer"]){
        
        NSString * reuseMark2=@"ren3";
        if (!nibCell) {
            nibCell = [UINib nibWithNibName:@"DDAssignTableViewCell" bundle:nil];
            [tableView registerNib:nibCell forCellReuseIdentifier:reuseMark2];
        }
        DDAssignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseMark2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = 600;

        [cell setAttributeWithDictionary:_dicData viewController:self isFlow:self.isFlow];
        cell.borrowId=self.borrowId;
        
        return cell;
        
    }
    
    else {
        
        
        NSString * reuseMark3=@"ren";
        if (!nibCell) {
            nibCell = [UINib nibWithNibName:@"NewInvestTableViewCell" bundle:nil];
            [tableView registerNib:nibCell forCellReuseIdentifier:reuseMark3];
        }
        NewInvestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseMark3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = 500;
        self.customScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, cell.firstPeople.frame.size.width + 30, 50) delegate:self placeholderImage:nil];
        _customScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _customScrollView.onlyDisplayText = YES;
        _customScrollView.backgroundColor = kBackColor;
        _customScrollView.userInteractionEnabled = NO;
        NSMutableArray *titlesArray = [NSMutableArray new];
        
        if ([self.firstDataDic isEqual:@""]) {
            
        }else if (self.firstDataDic.count > 0) {
            
            NSString *tel = [[self.firstDataDic objectForKey:@"username"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            if (tel.length < 11) {
                tel = @"";
            }
            NSString *content = [NSString stringWithFormat:@"%@",[self.firstDataDic objectForKey:@"content"]];
            [titlesArray addObject:[NSString stringWithFormat:@"%@%@",tel,content]];
        }
        
        if ([self.secondDataDic isEqual:@""]) {
            
        }else if (self.secondDataDic.count > 0) {
            NSString *str = [NSString stringWithFormat:@"%@", [self.secondDataDic objectForKey:@"username"]];
            if (str.length < 11) {
                str = @"";
            }
            NSString *content = [NSString stringWithFormat:@"%@",[self.secondDataDic objectForKey:@"content"]];
            if (str.length >= 7 ) {
                NSString *tel = [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                [titlesArray addObject:[NSString stringWithFormat:@"%@%@",tel,content]];
            }
            
        }
        if ([self.thirdDataDic isEqual:@""]) {
            
        }else if (self.thirdDataDic.count > 0) {
            NSString *tel = [[self.thirdDataDic objectForKey:@"username"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            if (tel.length < 11) {
                tel = @"";
            }
            NSString *content = [NSString stringWithFormat:@"%@",[self.thirdDataDic objectForKey:@"content"]];
            [titlesArray addObject:[NSString stringWithFormat:@"%@%@",tel,content]];
        }
        _customScrollView.titlesGroup = [titlesArray copy];
        _customScrollView.titleLabelTextFont = [UIFont systemFontOfSize:12];
        [cell.firstPeople addSubview:self.customScrollView];
        
        [cell setAttributeWithDictionary:_dicData viewController:self isFlow:self.isFlow];
        cell.borrowId = self.borrowId;
        cell.borrowType = self.borrowType;
        return cell;
    }
    
}

#pragma mark- network

-(void)queryInvestOrTransferDetailByBorrowId:(NSString*)borrowId
{
        NSLog(@"标的id%@", self.borrowType);
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
   
    if ([self.borrowType isEqualToString:@"fragment"]){
         [diyouDic insertObject:@"pack_project_details" forKey:@"q" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%@",borrowId] forKey:@"id" atIndex:0];
    }else {
         [diyouDic insertObject:@"project_details" forKey:@"q" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%@",borrowId] forKey:@"borrow_nid" atIndex:0];
    }
    [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
//    [diyouDic insertObject:[NSString stringWithFormat:@"%@",borrowId] forKey:@"borrow_nid" atIndex:0];
    operation = [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
                 {
                     
                     if (isSuccess)
                     {
                         NSLog(@"isSuccess%@", object);
                         _dicData=[NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)object];
                         
                         self.title=[_dicData DYObjectForKey:@"name"];
                         
                         NSString * typeName=[_dicData DYObjectForKey:@"status_type_name"];
                         
                         self.firstDataDic = [object objectForKey:@"first"];
                         self.secondDataDic = [object objectForKey:@"max"];
                         self.thirdDataDic = [object objectForKey:@"last"];
                         
                         if ([typeName isEqualToString:@"马上认购"]||[typeName isEqualToString:@"马上投标"])
                         {
                             self.isRevert=NO;
                         }
                         else
                         {
                             self.isRevert=YES;
                         }
                         [_tableView reloadData];
                         self.borrow_status_nid = [NSString stringWithFormat:@"%@", object[@"borrow_status_nid"]];
                         if ([_borrow_status_nid isEqualToString:@"first"]) {
                             //初审中
                             
                         }else if([_borrow_status_nid isEqualToString:@"over"]){
                             //流标
                             
                         }else if([_borrow_status_nid isEqualToString:@"false"]){
                             //初审失败
                             
                         }else if([_borrow_status_nid isEqualToString:@"roam_now"]){
                             //马上认购
                             
                         }else if([_borrow_status_nid isEqualToString:@"roam_no"]){
                             //回购中
                             
                         }else if([_borrow_status_nid isEqualToString:@"roam_yes"]){
                             //回购完
                             
                         }else if([_borrow_status_nid isEqualToString:@"repay_advance"]){
                             //提前还款
                             
                         }else if([_borrow_status_nid isEqualToString:@"repay_yes"]){
                             //已还完
                             _btnInvestNow.backgroundColor=[UIColor lightGrayColor];
                             [_btnInvestNow setTitle:@"已还完" forState:UIControlStateNormal];
                             _btnInvestNow.userInteractionEnabled=NO;
                             
                         }else if([_borrow_status_nid isEqualToString:@"repay"]){
                             
                             //还款中
                             _btnInvestNow.backgroundColor=[UIColor lightGrayColor];
                             [_btnInvestNow setTitle:@"还款中" forState:UIControlStateNormal];
                             _btnInvestNow.userInteractionEnabled=NO;
                             
                             
                         }else if([_borrow_status_nid isEqualToString:@"full_false"]){
                             //复审失败
                             
                         }else if([_borrow_status_nid isEqualToString:@"cancel"]){
                             //用户撤标
                             
                         }else if([_borrow_status_nid isEqualToString:@"late"]){
                             //已过期
                             
                         }else if([_borrow_status_nid isEqualToString:@"full"]){
                             //满标待审
                             [_btnInvestNow setTitle:@"满标审核中" forState:UIControlStateNormal];
                             [_btnInvestNow setBackgroundColor:[UIColor lightGrayColor]];
                             _btnInvestNow.userInteractionEnabled=NO;
                         }else{
                             //投标
                             if (![DYUser loginIsLogin]) {
                                 _btnInvestNow.userInteractionEnabled=YES;
                                 _btnInvestNow.backgroundColor=kBtnColor;
                                 [_btnInvestNow setTitle:@"请先登录" forState:UIControlStateNormal];
                                 //                                 [_btnInvestNow addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
                             }else{
                                 _btnInvestNow.userInteractionEnabled=YES;
                                 _btnInvestNow.backgroundColor = kBtnColor;
                                 [_btnInvestNow setTitle:@"进入投标" forState:UIControlStateNormal];
                                 
                             }
                             
                         }
                         
                         self.isaddBiao=1;
                         
                         NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                         if ([self.borrowType isEqualToString:@"transfer"]) {
                             dic[@"产品类型"]=@"转让标";
                         }else{
                             dic[@"产品类型"]=@"普通标";
                             if (![_word isEqualToString:@"(null)"] && ![_word isEqualToString:@""] && _word) {
                                 dic[@"产品类型"]=self.word;
                             }
                         }
                         dic[@"产品名称"]=[_dicData DYObjectForKey:@"name"];
                         dic[@"收益率"]=[_dicData DYObjectForKey:@"borrow_apr"];
                         dic[@"期限"]=[_dicData DYObjectForKey:@"borrow_period_name"];
                         dic[@"标的金额"]=[_dicData DYObjectForKey:@"account"];
                         float residueM=[[_dicData DYObjectForKey:@"borrow_account_wait"] floatValue];
                         float totalM=[[_dicData DYObjectForKey:@"account"] floatValue];
                         float loading=1-residueM/totalM;
                         dic[@"投资进度"]=[NSString stringWithFormat:@"%f",loading];
                         dic[@"还款方式"]=[_dicData DYObjectForKey:@"style_name"];
                         if (self.isHome==1) {
                         }else{
                         }
                         
                     }
                     else
                     {
                         [_tableView reloadData];
                         [LeafNotification showInController:self withText:errorMessage];
                     }
                 } errorBlock:^(id error)
                 {
                     self.title=@"投资详情";
                     [_tableView reloadData];
                     
                 }];
}



//进入投标
- (IBAction)investRightNow:(UIButton *)sender
{
    if ([DYUser loginIsLogin]) {
        [MobClick event:@"product_enter"];
        [self GetRiskAssessment];
    }
}





//余额按钮
- (void)handleFirst {
    
    
    if (self.isaddBalance!=1) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"加载中，请稍候" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (self.isaddBiao!=1) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"加载中，请稍候" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    dic[@"产品名称"]=[_dicData DYObjectForKey:@"name"];
    dic[@"收益率"]=[_dicData DYObjectForKey:@"borrow_apr"];
    dic[@"期限"]=[_dicData DYObjectForKey:@"borrow_period_name"];
    dic[@"标的金额"]=[_dicData DYObjectForKey:@"account"];
    float residueM=[[_dicData DYObjectForKey:@"borrow_account_wait"] floatValue];
    float totalM=[[_dicData DYObjectForKey:@"account"] floatValue];
    float loading=1-residueM/totalM;
    dic[@"投资进度"]=[NSString stringWithFormat:@"%f",loading];
    dic[@"还款方式"]=[_dicData DYObjectForKey:@"style_name"];
    
    NSString *borrow_type=[NSString stringWithFormat:@"%@",[_dicData DYObjectForKey:@"borrow_type"]];
    int borrow_period=[[_dicData DYObjectForKey:@"borrow_period"]intValue];
    NSString *day=@"";
    if ([borrow_type isEqualToString:@"day"]||[borrow_type isEqualToString:@"standard"] || [borrow_type isEqualToString:@"transfer"]) {
        day=[NSString stringWithFormat:@"%d",borrow_period];
    }else{
        int d=borrow_period*30;
        day=[NSString stringWithFormat:@"%d",d];
    }
    BOOL isHaveInvestPassword=[[_dicData DYObjectForKey:@"borrow_password"]length] > 0 ? YES : NO;
    DYInvestSubmitVC * vc=[[DYInvestSubmitVC alloc]initWithNibName:@"DYInvestSubmitVC" bundle:nil];
    vc.hidesBottomBarWhenPushed=YES;
    vc.borrowId=self.borrowId;
    vc.dicData=_dicData;
    vc.ffmodel = self.ffmodel;
    vc.balance=balance;
    vc.isHaveInvestPassword=isHaveInvestPassword;
    vc.type=1;//余额
    vc.deadLine=[NSString stringWithFormat:@"%@",[_dicData DYObjectForKey:@"borrow_period_name"]];
    vc.extraNianHua=[NSString stringWithFormat:@"%@", [_dicData objectForKey:@"extra_borrow_apr"]];
    vc.nianHua=[NSString stringWithFormat:@"%@",[_dicData DYObjectForKey:@"borrow_apr"]];
    vc.limst=[NSString stringWithFormat:@"%@",[_dicData DYObjectForKey:@"tender_account_min"]];
    vc.Borrow_Title=[NSString stringWithFormat:@"%@",[self.dicData DYObjectForKey:@"name"]];
    vc.borrowType=self.borrowType;
    
    NSString *str1 = [NSString stringWithFormat:@"%@", [self.dicData DYObjectForKey:@"borrow_account_wait"]];
    
    NSString *borrowType = [self.dicData objectForKey:@"borrow_type"];
    if ([borrowType isEqualToString:@"standard"]) {
        float waitMoney = [str1 floatValue];
        if (waitMoney > 10000) {
            vc.Borrow_ShenYu=@"10000.00";
        }else {
            vc.Borrow_ShenYu=[NSString stringWithFormat:@"%@",[self.dicData DYObjectForKey:@"borrow_account_wait"]];
        }
    }else {
        vc.Borrow_ShenYu=[NSString stringWithFormat:@"%@",[self.dicData DYObjectForKey:@"borrow_account_wait"]];
    }
    
    
    vc.Borrow_Total=[NSString stringWithFormat:@"%.2f",[[self.dicData DYObjectForKey:@"account"]floatValue]];
    vc.anual=[NSString stringWithFormat:@"%@",[self.dicData DYObjectForKey:@"borrow_apr"]];
    vc.day=day;
    vc.parcent = [[self.dicData DYObjectForKey:@"borrow_account_scale"] floatValue];
    vc.borrow_type = borrow_type;
    
    vc.borrowStyle = [NSString stringWithFormat:@"%@", [self.dicData objectForKey:@"borrow_style"]];
    vc.isInvest = isInvest;//判断是否投资
    vc.isBindBank=self.isBindBank;
    vc.BankType=self.BankType;
    vc.BankNo=self.BankNo;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)getdata
{
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_users" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success==YES) {
             
             balance=[NSString stringWithFormat:@"%@",[object objectForKey:@"_balance"]];
             
             isInvest = [NSString stringWithFormat:@"%@", [object objectForKey:@"is_tender"]];
             
             self.isaddBalance=1;
         }
         
         
     } errorBlock:^(id error)
     {
         
     }];
    
    
    
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
    [self performSelector:@selector(testFrefreshTableView) withObject:nil afterDelay:0];
}

-(void)testFrefreshTableView
{
    
    [self queryInvestOrTransferDetailByBorrowId:self.borrowId];
    
    if (_tableView.headerView.isLoading)
    {
        [_tableView tableViewDidFinishedLoading];
        _tableView.hidden = NO;
    }
}
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
                NSLog(@"xinshou%@", object);
                NSString *isRiskAssessment=[NSString stringWithFormat:@"%@",object[@"data"][@"sql_result"]];
                if ([isRiskAssessment isEqualToString:@"1"]) {
                    [self handleFirst];
                }else {
                    
                    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未完成风险评测，为了帮助您更加了解个人风险承担能力，评测完成后方可进入投资。" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"前往评测",nil];
                    
                    alertView.delegate = self;
                    [alertView show];
                    
                }
                
            }else {
                [LeafNotification showInController:self withText:errorMessage];
                
            }
        } fail:^{
            [LeafNotification showInController:self withText:@"网络异常"];
        }];
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *loginKey = [DYUser GetLoginKey];
        NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/evaluating/begin&login_key=%@",ffwebURL,loginKey];
        ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
        adVC.myUrls = @{@"url":url};
        adVC.titleM =@"风险评测";
        adVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adVC animated:YES];
    }
    
}

#pragma mark -- 获取用户信息
- (void)getuserMessage {
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"app_center" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess) {
            NSLog(@"%@", object);
            self.ffmodel = [FFMineModel mj_objectWithKeyValues:object];

        }else {
            [LeafNotification showInController:self withText:errorMessage];
            
        }
        
        
    } fail:^{
      
        [LeafNotification showInController:self withText:@"网络异常"];
        
        
    }];
    
    
}

@end



