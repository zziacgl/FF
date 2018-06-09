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
//#import "DYRealtimeFianacailBottomTableViewCell.h"
#import "DYFinancialRecordsVC.h"
#import "DYWithdrawalViewController.h"
#import "DYBankCardVC.h"
#import "DYMyAcountMainVC.h"
#import "DYBankCardVC.h"
#import "DYMainTabBarController.h"
#import "DYAppDelegate.h"
#import "DYMyInvestmentRecordViewController.h"
#import "DYMyRecommendViewController.h"

@interface DYRealtimeFinancialViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    
    UINib * nibHead;     // 复用cell的nib
    UINib * nibContent;
    UINib * nibBottom;
    
    NSArray * aryCellData; // 标记cell的个数和高度
    BOOL isViewDidLoad; // 标记第一次刷新
    id objectData; // 判断是否绑定银行卡
    id userData; // 判断是否进行实名认证
    BOOL isbank;  // 判断是否绑定银行卡
    
    int  mark;
    
}
@property(nonatomic,retain)PullingRefreshTableView * tableView; // 第三方下拉刷新tableview

@end

@implementation DYRealtimeFinancialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.title = @"我的多多";
        self.title = @"账户";

    }
    return self;
}
- (void)loadView
{
    [super loadView];
    isbank = NO;
   
    //导航右边的按钮
//    UIButton * btnRightItem=[UIButton buttonWithType:UIButtonTypeCustom];
//    btnRightItem.backgroundColor=[UIColor clearColor];
//    btnRightItem.frame=CGRectMake(0, 0, 100.0f, 60.0f);
//    [btnRightItem setTitle:@"投标记录" forState:UIControlStateNormal];
//    [btnRightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
//    
//    [btnRightItem addTarget:self action:@selector(GetInvestRecord) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    
    //设置下拉刷新tableView
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:[UIColor blackColor] bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kCOLOR_R_G_B_A(241, 241 , 241, 1); // 背景颜色
    _tableView.headerOnly = YES;
    _tableView.pullingDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.headerView.backgroundColor=[UIColor clearColor]; // 头颜色
    _tableView.footerView.backgroundColor=[UIColor whiteColor]; // 脚颜色
    _tableView.hidden = YES;

    [self.view addSubview:_tableView];

    //设置cell的个数和高度
    aryCellData = @[@"130",@"495"];
    
    
//    //底部视图(充值和提现按钮)
//    UIView *viewFoot=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenSize.height - 49 - 20 - 44, kScreenSize.width, 49)];
//    viewFoot.backgroundColor = [UIColor whiteColor];
//    [viewFoot setAlpha:0.95];
//    [self.view addSubview:viewFoot];
    
//    //充值按钮
//    UIButton *btnRecharge=[UIButton buttonWithType:UIButtonTypeCustom];
//    btnRecharge.frame=CGRectMake(0, 0, kScreenSize.width/2, 49);
//    [btnRecharge setTitle:@"充值" forState:UIControlStateNormal];
//    [btnRecharge addTarget:self action:@selector(rechargeMoney) forControlEvents:UIControlEventTouchDown];
//    [btnRecharge setTitleColor:kCOLOR_R_G_B_A(13, 136, 207, 1) forState:UIControlStateNormal];
//    [viewFoot addSubview:btnRecharge];
    
//    //提现按钮
//    UIButton *btnWithdrawal=[UIButton buttonWithType:UIButtonTypeCustom];
//    btnWithdrawal.frame=CGRectMake(kScreenSize.width/2, 0, kScreenSize.width/2, 49);
//    [btnWithdrawal setTitle:@ "提现" forState:UIControlStateNormal];
//     [btnWithdrawal addTarget:self action:@selector(withdrawalMoney) forControlEvents:UIControlEventTouchDown];
//    [btnWithdrawal setTitleColor:kCOLOR_R_G_B_A(13, 136, 207, 1) forState:UIControlStateNormal];
//    [viewFoot addSubview:btnWithdrawal];
    
    [self getUsersBankOne]; // 解析过程
 
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect bounds = self.view.bounds;
    bounds.size.height = kScreenSize.height - 20 - 94;
    _tableView.frame = bounds;
    
    if(![DYUser loginIsLogin]){
        [self firstpressed];
    }
    

    
}
#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件

- (void)firstpressed
{
    [DYUser  loginShowLoginView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
    //初始化tableView
    [_tableView launchRefreshing];
     mark = 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self viewDidAfterLoad]; // 视图在加载完之后出现
    
    [self testFrefreshTableView]; // 实现自身的刷新
   
}

 // 充值
-(void)rechargeMoney
{
    if (mark!=1)
    {
        return;
    }
    mark = 0;
        self.view.userInteractionEnabled=NO;
//        DYRechargeVC *rechargeVC=[[DYRechargeVC alloc]initWithNibName:@"DYRechargeVC" bundle:nil];
//        rechargeVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:rechargeVC animated:YES];
    
    DYBankCardVC *rechargeVC=[[DYBankCardVC alloc]initWithNibName:@"DYBankCardVC" bundle:nil];
//    rechargeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rechargeVC animated:YES];
        self.view.userInteractionEnabled=YES;

}
//提现
- (void)withdrawalMoney
{
    
        self.view.userInteractionEnabled = NO;
        if (isbank==YES)
        {
            if (mark!=1)
            {
                return;
            }
            mark=0;
            DYWithdrawalViewController *withdrawalVC=[[DYWithdrawalViewController alloc]initWithNibName:@"DYWithdrawalViewController" bundle:nil];
            withdrawalVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:withdrawalVC animated:YES];
        }
        else//未绑定银行卡
        {
//            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"银行卡未绑定是否进行绑定？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"绑定银行卡" otherButtonTitles:nil, nil];
//            [sheet showInView:self.view];
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"无法提现" message:@"未绑定银行卡，绑卡需充值，充值之后自动绑卡。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertview show];
        }
        self.view.userInteractionEnabled=YES;
    
}
- (void)touch
{
    
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
        [cell.InvestRecord addTarget:self action:@selector(GetInvestRecord) forControlEvents:UIControlEventTouchDown];
        [self DYRealtimeFianacailHeadTableViewCell:cell dic:objectData];
        cell.backgroundColor = [UIColor colorWithRed:189 / 255.0 green:17 / 255.0 blue:48/ 255.0 alpha:1];
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
        
        [self DYRealtimeFianacailContentTableViewCell:cell dic:objectData];
                [cell.depositBtn addTarget:self action:@selector(withdrawalMoney) forControlEvents:UIControlEventTouchDown];
//                [cell.depositBtn setTitleColor:kCOLOR_R_G_B_A(13, 136, 207, 1) forState:UIControlStateNormal];
                [cell.rechargeBtn addTarget:self action:@selector(rechargeMoney) forControlEvents:UIControlEventTouchDown];
//                [cell.rechargeBtn setTitleColor:kCOLOR_R_G_B_A(13, 136, 207, 1) forState:UIControlStateNormal];
        [cell.safeBut addTarget:self action:@selector(gotoMyAcount) forControlEvents:UIControlEventTouchDown];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *str = [NSString stringWithFormat:@"%@",[user objectForKey:@"UserName"]];
//        [cell.MyAcountBtn setTitle:str forState:UIControlStateNormal];
        cell.MyAcountLabel.text = str;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        return cell;

    }
//        else{
//        NSString * markBottom = @"markBottom";
//        if (!nibBottom)
//        {
//            nibBottom = [UINib nibWithNibName:@"DYRealtimeFianacailBottomTableViewCell" bundle:nil];
//            [tableView registerNib:nibBottom forCellReuseIdentifier:markBottom];
//        }
//        DYRealtimeFianacailBottomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:markBottom];
//        [cell.depositBtn addTarget:self action:@selector(withdrawalMoney) forControlEvents:UIControlEventTouchDown];
//        [cell.depositBtn setTitleColor:kCOLOR_R_G_B_A(13, 136, 207, 1) forState:UIControlStateNormal];
//        [cell.rechargeBtn addTarget:self action:@selector(rechargeMoney) forControlEvents:UIControlEventTouchDown];
//        [cell.rechargeBtn setTitleColor:kCOLOR_R_G_B_A(13, 136, 207, 1) forState:UIControlStateNormal];
//        cell.selectionStyle = UITableViewCellAccessoryNone;
//
//        return cell;
//    }

}
//跳到我的投标记录
-(void)GetInvestRecord{
    DYMyInvestmentRecordViewController *VC = [[DYMyInvestmentRecordViewController alloc]initWithNibName:@"DYMyInvestmentRecordViewController" bundle:nil];
    VC.hidesBottomBarWhenPushed = YES; 
    [self.navigationController pushViewController:VC animated:YES];


}
-(void)gotoMyAcount{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:@"%@",[user objectForKey:@"UserName"]];

    DYMyAcountMainVC *VC = [[DYMyAcountMainVC alloc]initWithNibName:@"DYMyAcountMainVC" bundle:nil];
    VC.hidesBottomBarWhenPushed = YES;
    VC.phone=str;
    [self.navigationController pushViewController:VC animated:YES];

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
    [self getUsersBankOne]; // 解析过程
    [self performSelector:@selector(testFrefreshTableView) withObject:nil afterDelay:0];
}

-(void)testFrefreshTableView
{

    //————————————————————————我的主页->实时财务——————————————————————————

    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"mobile_get_account_result" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
        if (success==YES) {
             //可用信用额度数据填充
            if (_tableView.headerView.isLoading)
            {
                [_tableView tableViewDidFinishedLoading];
                 _tableView.hidden = NO;
            }
            objectData=object;
            [_tableView reloadData];
            
            [self getdata];
         }
         else
         {
             [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
         }
         
     } errorBlock:^(id error)
     {
         if (_tableView.headerView.isLoading)
         {
             [_tableView tableViewDidFinishedLoading];
         }
         [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
     }];

    
    if (_tableView.headerView.isLoading)
    {
        [_tableView tableViewDidFinishedLoading];
        _tableView.hidden = NO;
    }
}

//获取开户信息
-(void)getUsersBankOne
{
    [MBProgressHUD hudWithView:self.view label:@"数据请求中"]; // 风火轮菊花
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_users_bank_one" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    
    NSLog(@"%@",diyouDic);
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
  
             if ([[object objectForKey:@"account"] isKindOfClass:[NSString class]]) {
                 
                 if ([[object objectForKey:@"account"]length]>0&&[[object objectForKey:@"account"]isEqualToString:@""]==NO) {
                     isbank=YES;
                 }
                 
             }
             
         }
         else
         {
             [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
     }];
    
    
    
    
}


-(void)getdata
{
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"mobile_get_user_result" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
          if (success==YES) {
             
              
              userData = object;
//              NSLog(@"%@",userData);
              NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
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
              [_tableView reloadData];
              
         }
         else
         {
             [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
         }
         
     } errorBlock:^(id error)
     {
        [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
     }];

    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSString * titl=[actionSheet buttonTitleAtIndex:buttonIndex];
    if ([titl isEqualToString:@"绑定银行卡"]==YES) {
        
        int realnameStatus=[[userData objectForKey:@"realname_status"]intValue];
        if (realnameStatus==1) {
            DYBankCardVC * nameVC=[[DYBankCardVC alloc]initWithNibName:@"DYBankCardVC" bundle:nil];
            nameVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:nameVC animated:YES];
        }
        else
        {
            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"绑定银行卡要进行实名认证！您未进行实名认证是否进行实名认证？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"实名认证" otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
        }
    }
//    if ([titl isEqualToString:@"实名认证"]==YES) {
//        
//        DYNameSystemCertificationViewController*name=[[DYNameSystemCertificationViewController alloc]initWithNibName:@"DYNameSystemCertificationViewController" bundle:nil];
//        name.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:name animated:YES];
//        
//    }
    
    
}
#pragma mark - btnForItemAction
-(void)returnBarButtonItemActionMore
{
  
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)rightBarButtonItemActionMore
{

    if (mark!=1)
    {
        return;
    }
    mark=0;
    DYFinancialRecordsVC *transctionVC = [[DYFinancialRecordsVC alloc]initWithNibName:@"DYFinancialRecordsVC" bundle:nil];
    transctionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:transctionVC animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)ttttt
//{
//    DYMyRecommendViewController *re = [[DYMyRecommendViewController alloc] initWithNibName:@"DYMyRecommendViewController" bundle:nil];
//    re.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:re animated:YES];
//}
- (void)DYRealtimeFianacailContentTableViewCell:(DYRealtimeFianacailContentTableViewCell*)cell dic:(NSDictionary*)dic
{
//    NSLog(@"%@",dic);
    
    UILabel * lab=(UILabel*)[cell viewWithTag:1000]; //累计收益
    lab.text=[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"tender_wait_interest"]];
//    [cell.totald setTitle:[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"_total"]] forState:UIControlStateNormal];//总资产
    UILabel *totalL = (UILabel *)[cell viewWithTag:1001];
    totalL.text = [NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"_balance"]];// 可用余额
//    CGFloat account =[[dic DYObjectForKey:@"_balance"] floatValue]+[[dic DYObjectForKey:@"tender_wait_interest"] floatValue];
    CGFloat account =[[dic DYObjectForKey:@"recover_yes_profit"] floatValue];
    [cell.ContentD setTitle:[NSString stringWithFormat:@"%0.2f",account] forState:UIControlStateNormal];//持有资产
    [cell.Blance setTitle:[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"duomi_exchanged"]] forState:UIControlStateNormal];//推荐奖励
//    [cell.Blance addTarget:self action:@selector(ttttt) forControlEvents:UIControlEventTouchDown];
//    [cell.Blance addTarget:self action:@selector(touch) forControlEvents:UIControlEventTouchDown];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"_balance"]] forKey:@"balance"];
    
    lab=(UILabel*)[cell viewWithTag:1004];//总积分
//    NSLog(@"%@",[userData DYObjectForKey:@"credit_total"]);
    
    lab.text=[NSString stringWithFormat:@"%@",[userData DYObjectForKey:@"credit_total"]];
    [cell.btnLook addTarget:self action:@selector(rightBarButtonItemActionMore) forControlEvents:UIControlEventTouchDown];
//    [cell.button1 addTarget:self action:@selector(rightBarButtonItemActionMore) forControlEvents:UIControlEventTouchDown];//点击账号余额
    
    lab=(UILabel*)[cell viewWithTag:1010];//邀请码
    lab.text=[NSString stringWithFormat:@"%d",[DYUser GetUserID]];
}

-(void)DYRealtimeFianacailHeadTableViewCell:(DYRealtimeFianacailHeadTableViewCell*)cell dic:(NSDictionary*)dic
{
//    NSLog(@"%@",dic);
    
    UILabel * lab=(UILabel*)[cell viewWithTag:10000];
//    lab.text=[DYUtils withMoreTenThousand:[dic objectForKey:@"recover_yes_interest_time"]];
//    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd"];
//    NSString *  locationString=[dateformatter stringFromDate:senddate];
//    NSArray * arr=[locationString componentsSeparatedByString:@"-"];
    lab=(UILabel*)[cell viewWithTag:9999];
//    lab.text=[NSString stringWithFormat:@"%@月%@日收益(元)",arr[0],arr[1]];
    lab.text=[NSString stringWithFormat:@"总资产（元）"];
    cell.TotalM.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"_total"]];//总资产
}


@end
