//
//  DYWithdrawalRecordVC.m
//  NewDeayou
//
//  Created by diyou on 14-8-28.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYWithdrawalRecordVC.h"
#import "PullingRefreshTableView.h"
#import "DYRecordsCell.h"


#define CELLHIGHT 76

@interface DYWithdrawalRecordVC ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
     UINib * nibContent;
     int page;
}
@property(strong,nonatomic)PullingRefreshTableView *tableView;
@property(strong,nonatomic)NSMutableArray *aryData;
@end

@implementation DYWithdrawalRecordVC

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
    
    self.title=@"提现记录";
    
    self.aryData=[[NSMutableArray alloc]init];
    
    //设置下拉刷新tableView
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain topTextColor:[UIColor blackColor] topBackgroundColor:nil bottomTextColor:[UIColor blackColor] bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullingDelegate=self;
    _tableView.headerView.backgroundColor=[UIColor whiteColor];
    _tableView.footerView.backgroundColor=[UIColor whiteColor];
//    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
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
    [_tableView launchRefreshing];

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.aryData.count;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELLHIGHT;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSDictionary*dic=self.aryData[indexPath.row];
    NSString * mark=@"markContent";
    if (!nibContent)
    {
        nibContent=[UINib nibWithNibName:@"DYRecordsCell" bundle:nil];
        [tableView registerNib:nibContent forCellReuseIdentifier:mark];
    }
    DYRecordsCell * cell=[tableView dequeueReusableCellWithIdentifier:mark];
    [self fullDYRecordsCell:cell object:dic];
    return cell;

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
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    
    [self testFrefreshTableView:@"0"];
    
    
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    [self testFrefreshTableView:@"1"];
    
}

-(void)testFrefreshTableView:(id)object
{
    
    [self queryDataIsRefreshing:[object intValue]];
    
}
-(void)queryDataIsRefreshing:(BOOL)isRefreshing
{
    /*--------------------提现记录接口----------------------*/
    if(isRefreshing)
    {
        
      
        page=1;
        DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get_cash_list" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error){
            
            if (_tableView.headerView.isLoading)
            {
                [_tableView tableViewDidFinishedLoading];
            }
            if (success==YES) {
                NSMutableArray * ary=[object objectForKey:@"list"];
                if (ary.count==0) {
                    [MBProgressHUD errorHudWithView:self.view label:@"暂无数据" hidesAfter:2];
                }
                else
                {
                    self.aryData=ary;
                }
                 [_tableView reloadData];
            }
            else
            {
                [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
            }
            
        } errorBlock:^(id error){
            
            if (_tableView.headerView.isLoading)
            {
                [_tableView tableViewDidFinishedLoading];
            }
            
            [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
        }];
        
    }else
    {
        page++;
        DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get_cash_list" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.footerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
                 //可用信用额度数据填充
                 NSArray * ary=[object objectForKey:@"list"];
                 if (ary.count==0) {
                     [MBProgressHUD errorHudWithView:self.view label:@"数据加载完了！" hidesAfter:2];
                     
                 }else
                 {
                     for (int i=0; i<ary.count; i++) {
                         [self.aryData addObject:ary[i]];
                     }
                 }
                 [_tableView reloadData];
             }
             else
             {
                  [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
             }
             
         } errorBlock:^(id error){
             if (_tableView.footerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
         }];
        
    }
}
-(void)fullDYRecordsCell:(DYRecordsCell*)cell object:(NSDictionary*)dic
{
    
    //标题
    UILabel *lab=(UILabel*)[cell viewWithTag:10000];
    lab.text=@"提现";
    
    //时间
    lab=(UILabel*)[cell viewWithTag:10001];
    lab.text=[DYUtils dataUnixTimeYYYYMMDDHHmm:[dic DYObjectForKey:@"addtime"]];
    
    //金额
    lab=(UILabel*)[cell viewWithTag:10002];
    lab.text=[NSString stringWithFormat:@"¥%@",[dic DYObjectForKey:@"credited"]];
    lab.textColor=[UIColor lightGrayColor];
    
    //状态
    lab=(UILabel*)[cell viewWithTag:10003];
    if ([[dic DYObjectForKey:@"status"]intValue]==0) {
        lab.text=@"审核中";
    }
    else if([[dic DYObjectForKey:@"status"]intValue]==1)
    {
        lab.text=@"提现成功";
        lab=(UILabel*)[cell viewWithTag:10002];
        lab.textColor=kCOLOR_R_G_B_A(255, 128, 0, 1);
    }
    else if([[dic DYObjectForKey:@"status"]intValue]==2)
    {
        lab.text=@"提现失败";
    }
    else if([[dic DYObjectForKey:@"status"]intValue]==3)
    {
        lab.text=@"用户取消";
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
