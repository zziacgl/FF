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
#import "DDFundRecordViewController.h"

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
    UIView *backView;
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
@property (nonatomic, strong) UIButton *aBtn;
@property (nonatomic, strong) UIImageView *aImage;

@property (nonatomic, strong) UILabel *tittleLabel;
@property (nonatomic, strong) UILabel *tittleDetail;

@end

@implementation DYFinancialRecordsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
- (void)viewDidLoad
{
   
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewDidAfterLoad];
    self.title=@"余额详情";
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90)];
    headView.backgroundColor = [UIColor whiteColor];
    
  
    
    
    self.tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, 20)];
    _tittleLabel.text = @"可用余额(元)";
    _tittleLabel.textAlignment = NSTextAlignmentCenter;
    _tittleLabel.textColor = [UIColor darkGrayColor];
    _tittleLabel.font = [UIFont systemFontOfSize:16];
    [headView addSubview:self.tittleLabel];
    
    self.tittleDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tittleLabel.frame) + 10, kMainScreenWidth, 40)];
    _tittleDetail.font = [UIFont systemFontOfSize:30];
    _tittleDetail.textAlignment = NSTextAlignmentCenter;
    _tittleDetail.textColor = [UIColor darkGrayColor];
    _tittleDetail.text = [NSString stringWithFormat:@"%@", self.money];
    
    [headView addSubview:self.tittleDetail];

    
    [self.view addSubview:headView];
    
    _tableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64 - 90) style:UITableViewStylePlain topTextColor:kBtnColor topBackgroundColor:nil bottomTextColor:kBtnColor bottomBackgroundColor:nil];
//    [_tableView setTableHeaderView:headView];
    _tableView.pullingDelegate=self;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    isViewDidLoad=YES;
//    UIButton * btnRightItem = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnRightItem.backgroundColor = [UIColor clearColor];
//    btnRightItem.frame = CGRectMake(0, 0, 80, 35);
//    [btnRightItem setTitle:@"资金记录" forState:UIControlStateNormal];
//    btnRightItem.titleLabel.font = [UIFont systemFontOfSize:16];
//    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnRightItem addTarget:self action:@selector(moneyRecord) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
//    
    //获取数据
    [self getdata];
    
     _dicSelectData=[[NSMutableDictionary alloc]init];
    [_dicSelectData setObject:@"" forKey:KACCOUNTTYPE];
    [_dicSelectData setObject:@"" forKey:KDOTIME1];
    [_dicSelectData setObject:@"" forKey:KDOTIME2];

    self.btnConfirm.layer.cornerRadius=3;
    
    self.viewBackground.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.viewBackground.layer.borderWidth = 0.5;
    self.viewBackground.layer.cornerRadius = 3;
    self.viewBackground.layer.masksToBounds = YES;
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
 
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
//资金记录
- (void)moneyRecord {
    DDFundRecordViewController *fundVC = [[DDFundRecordViewController alloc] init];
    [self.navigationController pushViewController:fundVC animated:YES];
}
-(void)getdata
{
//    [MBProgressHUD hudWithView:self.view label:@"数据请求..."];
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
            [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
//          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [LeafNotification showInController:self withText:@"网络异常"];
     }];

    
    
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
//    return 2;
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
   
        page=1;
        DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get_account_log_list" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
//        [diyouDic insertObject:type forKey:@"account_type" atIndex:0];
//        [diyouDic insertObject:dotime1 forKey:@"dotime1" atIndex:0];
//        [diyouDic insertObject:dotime2 forKey:@"dotime2" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             myLog(@"余额%@", object);
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
                [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }else
    {
//        NSString * dotime1=[_dicSelectData objectForKey:KDOTIME1];
//        NSString * dotime2=[_dicSelectData objectForKey:KDOTIME2];
//        NSString * type=[_dicSelectData objectForKey:KACCOUNTTYPE];
        page++;
        DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get_account_log_list" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:@"20" forKey:@"epage" atIndex:0];
//        [diyouDic insertObject:type forKey:@"account_type" atIndex:0];
//        [diyouDic insertObject:dotime1 forKey:@"dotime1" atIndex:0];
//        [diyouDic insertObject:dotime2 forKey:@"dotime2" atIndex:0];
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
                        [LeafNotification showInController:self withText:@"数据加载完了"];
                     }
                     }
                [_tableView reloadData];
             }
             else
             {
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             if (_tableView.footerView.isLoading)
             {
                [_tableView tableViewDidFinishedLoading];
             }
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }
}

#pragma mark------cell数据填充
-(void)DYFinancialRecordsHeadCell:(DYFinancialRecordsHeadCell*)cell dic:(NSDictionary*)dic
{
    UILabel * lab=(UILabel*)[cell viewWithTag:10000];
    lab.text=[DYUtils dataUnixTime:[dic objectForKey:@"addtime"]];
   
    lab=(UILabel*)[cell viewWithTag:10001];
    lab.text=[dic objectForKey:@"type_name"];
    lab=(UILabel*)[cell viewWithTag:10002];
    if([[dic objectForKey:@"operate_type_name"] isEqualToString:@"deduct"]==YES)
    {
        lab.text=[NSString stringWithFormat:@"-%@",[dic DYObjectForKey:@"money"]];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor=kCOLOR_R_G_B_A(58, 140, 9, 1);
        
    }else if([[dic objectForKey:@"operate_type_name"] isEqualToString:@"add"]==YES)
    {
        
        lab.text=[NSString stringWithFormat:@"+%@",[dic DYObjectForKey:@"money"]];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor=kBtnColor;
    }    
    else if([[dic objectForKey:@"operate_type_name"] isEqualToString:@"frost"]==YES)
    {
        lab.text=[NSString stringWithFormat:@"冻结 %@",[dic DYObjectForKey:@"money"]];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor=[UIColor darkGrayColor];
    }
    else if([[dic objectForKey:@"operate_type_name"] isEqualToString:@"await"]==YES)
    {
        lab.text=[NSString stringWithFormat:@"待收 %@",[dic DYObjectForKey:@"money"]];
        lab.font = [UIFont systemFontOfSize:16];
        
        lab.textColor=[UIColor darkGrayColor];
    }

    
    
    
    lab=(UILabel*)[cell viewWithTag:10003];
    lab.text=[NSString stringWithFormat:@"余额:%@元",[dic DYObjectForKey:@"balance"]];
    
}
-(void)DYFinancialRecordsFootCell:(DYFinancialRecordsFootCell*)cell dic:(NSDictionary*)dic
{
    
    UILabel * lab=(UILabel*)[cell viewWithTag:10000];
    
    lab.text=[NSString stringWithFormat:@"备注:%@",[dic objectForKey:@"remark"]];
    
    
    
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


//时间
-(void)datePickerAction:(UIDatePicker*)sender
{
    UIDatePicker*datepicker=sender;
    NSDateFormatter*format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString * str=[format stringFromDate:sender.date];
//    NSLog(@"%@", str);
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
