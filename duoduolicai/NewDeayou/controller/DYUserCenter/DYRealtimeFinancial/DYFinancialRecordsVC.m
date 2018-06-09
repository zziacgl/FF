//
//  DYFinancialRecordsVC.m
//  NewDeayou
//
//  Created by diyou on 14-7-21.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYFinancialRecordsVC.h"
#import "DYFinancialRecordsFootCell.h"
#import "DYFinancialRecordsHeadCell.h"
#import "PullingRefreshTableView.h"



#define cellHight 66;

#define KACCOUNTTYPE     @"account_type"//资金记录类型
#define KDOTIME1         @"dotime1"//起始日期
#define KDOTIME2         @"dotime2"//截止日期

@interface DYFinancialRecordsVC ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIActionSheetDelegate>
{
    
    UINib *nibHead;
    UINib *nibFoot;
    NSIndexPath *selecetIndexPath;
    int page;
    BOOL isViewDidLoad;
    
}

@property (strong, nonatomic) IBOutlet UIView *viewSelecter;
@property(strong,nonatomic)PullingRefreshTableView *tableView;
@property(strong,nonatomic)NSMutableArray *aryList;//数据
@property(strong,nonatomic)NSMutableArray *aryType;//资金类型
@property(nonatomic,retain)UIView * sortBackgroundView;
@property(strong,nonatomic)UIDatePicker*datepicker;//时间选择器
@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property(strong,nonatomic)NSMutableDictionary *dicSelectData;//筛选数据存储
@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@end

@implementation DYFinancialRecordsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewDidAfterLoad];
    self.title=@"资金记录";
    _tableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:kMainColor bottomBackgroundColor:nil];
    _tableView.pullingDelegate=self;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    isViewDidLoad=YES;
    
    //获取数据
    [self getdata];
    
    //筛选界面
//    [self makeSelecter];
    
    _dicSelectData=[[NSMutableDictionary alloc]init];
    [_dicSelectData setObject:@"" forKey:KACCOUNTTYPE];
    [_dicSelectData setObject:@"" forKey:KDOTIME1];
    [_dicSelectData setObject:@"" forKey:KDOTIME2];

    self.btnConfirm.layer.cornerRadius=3;
    
    self.viewBackground.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.viewBackground.layer.borderWidth = 0.5;
    self.viewBackground.layer.cornerRadius = 3;
    self.viewBackground.layer.masksToBounds = YES;
    
    CGSize btnImageSize = CGSizeMake(44, 44);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    //隐藏刷选条件 资金类型
//    self.MomeyTypeLabel.hidden=YES;
//    self.MomeyType.hidden=YES;
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
//获取资金记录类型
-(void)getdata
{
    [MBProgressHUD hudWithView:self.view label:@"数据请求..."];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"linkages" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"account_type" forKey:@"nid" atIndex:0];
    [diyouDic insertObject:@"20" forKey:@"epage" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (success==YES) {
            
            if ([[object objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                
                _aryType=[object objectForKey:@"list"];
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    CGRect bounds = self.view.bounds;
//    bounds.size.height=kScreenSize.height-20-44;
//    _tableView.frame = bounds;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isViewDidLoad)
    {
        //初始化tableView
        [_tableView launchRefreshing];
        isViewDidLoad=NO;
    }
    
}
#pragma mark ------tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!selecetIndexPath) {
        return 1;
    }
    else
    {
        if (selecetIndexPath.section==section) {
            return 2;
        }else
        {
            return 1;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return cellHight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0.5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _aryList.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * dic=[_aryList objectAtIndex:indexPath.section];
    
    if (indexPath.row==0) {
        NSString * mark=@"markHead";
        if (!nibHead) {
            nibHead=[UINib nibWithNibName:@"DYFinancialRecordsHeadCell" bundle:nil];
            [tableView registerNib:nibHead forCellReuseIdentifier:mark];
        }
        DYFinancialRecordsHeadCell * cell=[tableView dequeueReusableCellWithIdentifier:mark];
        //数据填充
        [self DYFinancialRecordsHeadCell:cell dic:dic];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        
        NSString * mark=@"markContent";
        if (!nibFoot) {
            nibFoot=[UINib nibWithNibName:@"DYFinancialRecordsFootCell" bundle:nil];
            [tableView registerNib:nibFoot forCellReuseIdentifier:mark];
        }
        DYFinancialRecordsFootCell * cell=[tableView dequeueReusableCellWithIdentifier:mark];
        //数据填充
        [self DYFinancialRecordsFootCell:cell dic:dic];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
     }
 }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=0) {
        
    }
    else
    {
        if ([indexPath isEqual:selecetIndexPath])
        {
            selecetIndexPath = nil;
            
        }else
        {
            selecetIndexPath=indexPath;
            
        }
        [_tableView reloadData];
    }
    
      
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
#pragma mark----PullingRefreshTableViewDelegate
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    
    [self refreshTableView:@0];
    
}
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    
    [self refreshTableView:@1];
    
}
-(void)refreshTableView:(id)object
{
    [self GetUserInfomation:[object intValue]];
}
//获取数据接口
-(void)GetUserInfomation:(BOOL)isRefreshing
{
    
    //————————————————————————我的主页->实时财务->资金记录——————————————————————————
    
    
    if (isRefreshing)
    {
        
        NSString * dotime1=[_dicSelectData objectForKey:KDOTIME1];
        NSString * dotime2=[_dicSelectData objectForKey:KDOTIME2];
        NSString * type=[_dicSelectData objectForKey:KACCOUNTTYPE];
        
        page=1;
        DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get_mobile_log_list" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:type forKey:@"account_type" atIndex:0];
        [diyouDic insertObject:dotime1 forKey:@"dotime1" atIndex:0];
        [diyouDic insertObject:dotime2 forKey:@"dotime2" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
                 
                 if ([[object objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                     
                     self.aryList=[object objectForKey:@"list"];
                 }
                  [_tableView reloadData];
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
        
    }else
    {
        NSString * dotime1=[_dicSelectData objectForKey:KDOTIME1];
        NSString * dotime2=[_dicSelectData objectForKey:KDOTIME2];
        NSString * type=[_dicSelectData objectForKey:KACCOUNTTYPE];
        page++;
        DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get_mobile_log_list" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic insertObject:type forKey:@"account_type" atIndex:0];
        [diyouDic insertObject:dotime1 forKey:@"dotime1" atIndex:0];
        [diyouDic insertObject:dotime2 forKey:@"dotime2" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.footerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
                if (success==YES) {
                 
                 if ([[object objectForKey:@"list"] isKindOfClass:[NSArray class]])
                 {
                       NSArray * ary=[object objectForKey:@"list"];
                       if (ary.count>0) {
                         
                         for (int i=0; i<ary.count;i++ )
                         {
                             [self.aryList addObject:ary[i]];
                         }
                     }
                     else
                     {
                         [MBProgressHUD errorHudWithView:self.view label:@"数据加载完了" hidesAfter:2];
                     }
                     }
                [_tableView reloadData];
             }
             else
             {
                 [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
             }
             
         } errorBlock:^(id error)
         {
             if (_tableView.footerView.isLoading)
             {
                [_tableView tableViewDidFinishedLoading];
             }
             [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
         }];
        
    }
}

#pragma mark------cell数据填充
-(void)DYFinancialRecordsHeadCell:(DYFinancialRecordsHeadCell*)cell dic:(NSDictionary*)dic
{
    UILabel * lab=(UILabel*)[cell viewWithTag:10000];
    lab.text=[DYUtils dataUnixTime:[dic objectForKey:@"addtime"]];
    lab=(UILabel*)[cell viewWithTag:10001];
    lab.text=[dic objectForKey:@"type"];
    lab=(UILabel*)[cell viewWithTag:10002];
    if([[dic objectForKey:@"action_name"] isEqualToString:@"支出"]==YES)
    {
        lab.text=[NSString stringWithFormat:@"-¥%@",[dic DYObjectForKey:@"money"]];
        [lab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        lab.textColor=kCOLOR_R_G_B_A(255, 128, 0, 1);
        
    }else if([[dic objectForKey:@"action_name"] isEqualToString:@"收入"]==YES)
    {
        
        lab.text=[NSString stringWithFormat:@"+¥%@",[dic DYObjectForKey:@"money"]];
        [lab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        lab.textColor=kCOLOR_R_G_B_A(58, 140, 9, 1);
    }    
    else if([[dic objectForKey:@"action_name"] isEqualToString:@"冻结"]==YES)
    {
        lab.text=[NSString stringWithFormat:@"冻结 ¥%@",[dic DYObjectForKey:@"money"]];
        [lab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        lab.textColor=[UIColor blackColor];
    }
    else if([[dic objectForKey:@"action_name"] isEqualToString:@"待收"]==YES)
    {
        lab.text=[NSString stringWithFormat:@"待收 ¥%@",[dic DYObjectForKey:@"money"]];
        [lab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        lab.textColor=[UIColor blackColor];
    }

    
    
    
    lab=(UILabel*)[cell viewWithTag:10003];
    lab.text=[NSString stringWithFormat:@"余额:%@元",[dic DYObjectForKey:@"balance"]];
    
}
-(void)DYFinancialRecordsFootCell:(DYFinancialRecordsFootCell*)cell dic:(NSDictionary*)dic
{
    
    UILabel * lab=(UILabel*)[cell viewWithTag:10000];
    
    lab.text=[NSString stringWithFormat:@"备注:%@",[dic objectForKey:@"remark"]];
    
    
    
}

#pragma mark------筛选界面
-(void)makeSelecter
{
    
    //选择界面
    CGSize btnImageSize=CGSizeMake(30, 30);
    UIButton * btnright=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnright setBackgroundImage:[UIImage imageNamed:@"chooser.png"] forState:UIControlStateNormal];
    btnright.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnright addTarget:self action:@selector(filtrateAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnright];
    // sortView
    _sortBackgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    _sortBackgroundView.backgroundColor=[UIColor clearColor];
    _sortBackgroundView.hidden=YES;
    _sortBackgroundView.layer.opacity=0;
    UIView * viewBG1=[[UIView alloc]initWithFrame:CGRectMake(0,20+44, kScreenSize.width,kScreenSize.height-20-44)];
    viewBG1.backgroundColor=kCOLOR_R_G_B_A(51, 51, 51, 0.7);
    UITapGestureRecognizer * tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHideSortView)];
    [viewBG1 addGestureRecognizer:tap1];
    [_sortBackgroundView addSubview:viewBG1];
    UIView * viewBG2=[[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenSize.width,20+44)];
    viewBG2.backgroundColor=[UIColor clearColor];
    UITapGestureRecognizer * tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHideSortView)];
    [viewBG2 addGestureRecognizer:tap2];
    [_sortBackgroundView addSubview:viewBG2];
    self.viewSelecter.frame=CGRectMake(60, 20+44, kScreenSize.width-60,kScreenSize.height-44-20);
    [_sortBackgroundView addSubview:self.viewSelecter];
    [[UIApplication sharedApplication].keyWindow addSubview:_sortBackgroundView];
    
}
-(void)filtrateAction
{
    //条件过滤
    
    BOOL hidden=_sortBackgroundView.hidden?NO:YES;
    [self animationSortViewHihhen:hidden];
    
}

-(void)tapHideSortView
{
    [self animationSortViewHihhen:YES];
    
}
-(void)animationSortViewHihhen:(BOOL)hidden
{
    float animationDuration = 0.3;
    if (hidden)
    {
        
        [UIView animateWithDuration:animationDuration animations:^
         {
             _sortBackgroundView.layer.opacity=0;
         } completion:^(BOOL finished)
         {
             _sortBackgroundView.hidden=YES;
         }];
    }
    else
    {
        _sortBackgroundView.hidden=NO;
        [UIView animateWithDuration:animationDuration animations:^
         {
             _sortBackgroundView.layer.opacity=1;
         } completion:^(BOOL finished)
         {
             
         }];
    }
}

#pragma mark -----筛选中的按钮方法
//选择资金类型
- (IBAction)selecterTypeAction:(id)sender {
    UIActionSheet * sheet=[[UIActionSheet alloc]initWithTitle:@"选择资金类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for (int i=0; i<_aryType.count; i++) {
        
        NSDictionary * dic=_aryType[i];
        if ([[dic objectForKey:@"name"]isKindOfClass:[NSString class]]) {
            [sheet addButtonWithTitle:[dic objectForKey:@"name"]];
        }
    }
    [sheet showInView:self.view];

    
}
//选择开始时间和结束时间
- (IBAction)selecterDataAction:(id)sender {
    
    
    UIButton * btn=sender;
    
    if (!_datepicker) {
        
        _datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(30, kScreenSize.height-200, kScreenSize.width-60, 200)];
        [_sortBackgroundView addSubview:_datepicker];
        
    }
//    NSLog(@"%@",[NSDate date]);
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    _datepicker.locale = locale;
    _datepicker.date=[NSDate date];
    _datepicker.hidden=NO;
    _datepicker.tag=btn.tag;
    [_datepicker addTarget:self action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
    _datepicker.datePickerMode=UIDatePickerModeDate;

    
    
}
//筛选确定
- (IBAction)cofirmAction:(id)sender {
    
    [self tapHideSortView];
    [self refreshTableView:@1];
}
//时间
-(void)datePickerAction:(UIDatePicker*)sender
{
    UIDatePicker*datepicker=sender;
    NSDateFormatter*format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"YYYY-MM-dd"];
    NSString * str=[format stringFromDate:sender.date];
    switch (datepicker.tag) {
        case 1000:
        {
            UILabel * lab=(UILabel*)[_viewSelecter viewWithTag:10002];
            lab.text=str;
            [_dicSelectData setObject:str forKey:KDOTIME1];
        }
            break;
        case 1001:
        {
            UILabel * lab=(UILabel*)[_viewSelecter viewWithTag:10003];
            lab.text=str;
            [_dicSelectData setObject:str forKey:KDOTIME2];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark-----sheetdelegat

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"取消"]==YES) {
        return;
    }
    else
    {
        NSDictionary * dic=_aryType[buttonIndex];
        UILabel *lab=(UILabel*)[_viewSelecter viewWithTag:10001];
        lab.text=[dic objectForKey:@"name"];
        [_dicSelectData setObject:[dic objectForKey:@"value"] forKey:KACCOUNTTYPE];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
