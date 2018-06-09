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
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    
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
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //去掉点击后的阴影
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
                    [LeafNotification showInController:self withText:@"暂无数据"];
                }
                else
                {
                    self.aryData=ary;
                }
                 [_tableView reloadData];
            }
            else
            {
                [LeafNotification showInController:self withText:error];
            }
            
        } errorBlock:^(id error){
            
            if (_tableView.headerView.isLoading)
            {
                [_tableView tableViewDidFinishedLoading];
            }
            
           [LeafNotification showInController:self withText:@"网络异常"];
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
                     [LeafNotification showInController:self withText:@"数据加载完了"];
                     
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
                  [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error){
             if (_tableView.footerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }
}
-(void)fullDYRecordsCell:(DYRecordsCell*)cell object:(NSDictionary*)dic
{
    
    //标题
    UILabel *lab=(UILabel*)[cell viewWithTag:10000];
    
    if ([[dic DYObjectForKey:@"status"]intValue]==0) {
        lab.text=@"提现中";
    }
    else if([[dic DYObjectForKey:@"status"]intValue]==1)
    {
        lab.text=@"提现成功";
    }
    else if([[dic DYObjectForKey:@"status"]intValue]==2)
    {
        lab.text=@"提现失败";
    }
    else if([[dic DYObjectForKey:@"status"]intValue]==3)
    {
        lab.text=@"用户取消";
    }

    //时间
    lab=(UILabel*)[cell viewWithTag:10001];
//    lab.text=[DYUtils dataUnixTimeYYYYMMDDHHmm:[dic DYObjectForKey:@"addtime"]];
    lab.text = [DYUtils dataUnixTime:[dic DYObjectForKey:@"addtime"]];
    
    //金额
    lab=(UILabel*)[cell viewWithTag:10002];
    lab.text=[NSString stringWithFormat:@"¥%@",[dic DYObjectForKey:@"credited"]];
    lab.textColor=[UIColor lightGrayColor];
    
    //状态
    lab=(UILabel*)[cell viewWithTag:10003];
    if ([[dic DYObjectForKey:@"status"]intValue]==0) {

        lab.text=@"";
    }
    else if([[dic DYObjectForKey:@"status"]intValue]==1)
    {
        lab.text=@"提现预计在T+1时间内到账，实际以银行到账时间为准。";
        lab=(UILabel*)[cell viewWithTag:10002];
        lab.textColor=kCOLOR_R_G_B_A(255, 128, 0, 1);
    }
    else if([[dic DYObjectForKey:@"status"]intValue]==2)
    {

        lab.text=@"";
    }
    else if([[dic DYObjectForKey:@"status"]intValue]==3)
    {

        lab.text=@"";
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
