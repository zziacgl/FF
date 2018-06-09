//
//  DDCompleteTransferTableViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/8/9.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDCompleteTransferTableViewController.h"
#import "DDBondTableViewCell.h"
#import "PullingRefreshTableView.h"
#import "DDNoCardTableViewCell.h"
@interface DDCompleteTransferTableViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    int page;
    BOOL isViewDidLoad;
}
@property(nonatomic,strong)NSMutableArray *compDataArray;//
@property (nonatomic, strong) PullingRefreshTableView *completeTFTableView;
@end

@implementation DDCompleteTransferTableViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (isViewDidLoad)
    {
        //初始化tableView
        [self.completeTFTableView launchRefreshing];
        isViewDidLoad=NO;
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.completeTFTableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 50 - 64) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:kMainColor bottomBackgroundColor:nil];
    _completeTFTableView.delegate = self;
    _completeTFTableView.dataSource = self;
    _completeTFTableView.pullingDelegate = self;
    
    _completeTFTableView.backgroundColor = kCOLOR_R_G_B_A(236, 236, 236, 1);
    _completeTFTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.completeTFTableView];
    [_completeTFTableView registerClass:[DDNoCardTableViewCell class] forCellReuseIdentifier:@"no"];
    [_completeTFTableView registerClass:[DDBondTableViewCell class] forCellReuseIdentifier:@"complete"];
    isViewDidLoad = YES;
    
}
#pragma mark-－－－-scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.completeTFTableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.completeTFTableView tableViewDidEndDragging:scrollView];
    
}

#pragma mark - pullingTableViewDelegate

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
    
    [self getComRatesData:[object intValue]];
}
//获取数据接口
-(void)getComRatesData:(BOOL)isRefreshing{
    if (isRefreshing)
    {
        page=1;
        DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
        [diyouDic1 insertObject:@"transfer" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"get_list" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic1 insertObject:@"2" forKey:@"transfer_status" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic1 insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_completeTFTableView.headerView.isLoading)
             {
                 [_completeTFTableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
                 self.compDataArray = [NSMutableArray new];
                 self.compDataArray=[object objectForKey:@"list"];
                 
                 if (self.compDataArray.count==0) {
                     
                 }else{
                     
                     [self.completeTFTableView reloadData];
                 }
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }else
    {
        page++;
        DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
        [diyouDic1 insertObject:@"borrow" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"get_tender_list" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic1 insertObject:@"2" forKey:@"transfer_status" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic1 insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_completeTFTableView.footerView.isLoading)
             {
                 [_completeTFTableView tableViewDidFinishedLoading];
             }
             
             if (success==YES) {
                 NSArray * ary=[object objectForKey:@"list"];
                 if (ary.count>0) {
                     
                     for (int i=0; i<ary.count;i++ )
                     {
                         [self.compDataArray addObject:ary[i]];
                     }
                 }else
                 {
                     [LeafNotification showInController:self withText:@"数据加载完了"];
                 }
                 
                 
                 [self.completeTFTableView reloadData];
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }
    
    
}

#pragma mark - tableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.compDataArray.count > 0) {
        return self.compDataArray.count;
    }else {
        return 1;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.compDataArray.count > 0) {
        return 110;
    }else {
        return kMainScreenHeight - 64 - 60;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.compDataArray.count > 0) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld", (long)[indexPath row]];//以indexPath来唯一确定cell
        DDBondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
        if (cell == nil) {
            cell = [[DDBondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }

        cell.overImage.alpha = 0.7;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic=[self.compDataArray objectAtIndex:indexPath.row];
//        NSLog(@"timeLabel%@", dic);
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"borrow_name"]];
        cell.moneyLabel.text = [NSString stringWithFormat:@"投资金额：%@元", [dic objectForKey:@"account"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy/MM/dd"];//年应该用小写的yyyy不应该是大写的YYYY
        double begin=0;
        if ([dic objectForKey:@"borrow_success_time"]!=nil&&[dic objectForKey:@"borrow_success_time"]!=[NSNull null]) {
            begin=[[dic objectForKey:@"borrow_success_time"]doubleValue];
        }
        double start = 0;
        if ([dic objectForKey:@"repay_last_time"]!=nil&&[dic objectForKey:@"repay_last_time"]!=[NSNull null]) {
            start=[[dic objectForKey:@"repay_last_time"]doubleValue];
        }
        
        if(begin!=0&&start!=0){
            cell.timeLabel.text=[NSString stringWithFormat:@"投资时间：%@到%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:begin]],[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:start]]];
            
        }else{
            cell.timeLabel.text=@"尚未开始计息";
        }
        return cell;
        
        
    }else {
        DDNoCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"no" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kCOLOR_R_G_B_A(246, 246, 246, 1);
        cell.userInteractionEnabled = NO;
        cell.masageLabel.text = @"暂无数据";
        return cell;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
