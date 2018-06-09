//
//  DDInRecoverViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/19.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDInRecoverViewController.h"
#import "DYMyInvestmentRecordTableViewCell.h"
#import "DYSafeViewController.h"
#import "DYInvestDetailVC.h"
@interface DDInRecoverViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    UINib *nibcontent;
    BOOL isViewDidLoad;
    int page;
}

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation DDInRecoverViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (isViewDidLoad)
    {
        //初始化tableView
        [_tableView launchRefreshing];
        isViewDidLoad=NO;
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.borrowType = @"";
    _tableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kMainScreenHeight - 64 - 50) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:kMainColor bottomBackgroundColor:nil];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.pullingDelegate=self;
    _tableView.backgroundColor = kBackColor;
    _tableView.headerView.backgroundColor = kBackColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    isViewDidLoad=YES;

    // Do any additional setup after loading the view.
}
#pragma mark - tableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *markRuse=@"Recover";
    if (!nibcontent) {
        nibcontent = [UINib nibWithNibName:@"DYMyInvestmentRecordTableViewCell" bundle:nil];
        [tableView registerNib:nibcontent forCellReuseIdentifier:markRuse];
    }
    DYMyInvestmentRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markRuse];
    cell.backgroundColor = kBackColor;
    if (self.dataArray.count > 0) {
        NSDictionary *dic=[self.dataArray objectAtIndex:indexPath.row];
//        float extra = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"extra_borrow_apr"]] floatValue];//额外利息
//        float rates = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"rates_apr"]] floatValue];//加息券利息
//        float allApr = extra + rates;
        
        float allApr = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"extra_ticket_apr"]] floatValue];
        if (allApr > 0) {
            NSString *apr = [NSString stringWithFormat:@"%@%%", [dic objectForKey:@"borrow_apr"]];
            NSString *otherApr = [NSString stringWithFormat:@"%.2f%%", allApr];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%+%.2f%%", [dic objectForKey:@"borrow_apr"], allApr]];
            [str addAttribute:NSForegroundColorAttributeName value:kBtnColor range:NSMakeRange(apr.length, otherApr.length + 1)];
            cell.annualLabel.attributedText = str;
        }else {
            
            cell.annualLabel.text = [NSString stringWithFormat:@"%@%%", [dic objectForKey:@"borrow_apr"]];
        }
        cell.Mark_titile.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"borrow_name"]];
        cell.Mark_InvestM.text=[NSString stringWithFormat:@"%@元",[dic objectForKey:@"account"]];
        float total=[[dic objectForKey:@"recover_account_wait"] floatValue];
        cell.Mark_earningTotal.text=[NSString stringWithFormat:@"%.2f元",total];
        NSString *borrow_style =[NSString stringWithFormat:@"%@",[dic objectForKey:@"borrow_style"]];
        NSString *tender_status =[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
//        cell.isMonth = [borrow_style isEqualToString:@"month"]?YES:NO;
        if ([tender_status isEqualToString:@"1"]) {
            cell.xieyi.hidden = NO;
        }else {
            cell.xieyi.hidden = YES;
        }
        //        cell.isMonth = [borrow_style isEqualToString:@"month"]?YES:NO;
        if ([tender_status isEqualToString:@"1"]&&[borrow_style isEqualToString:@"month"]) {
            cell.isMonth = YES;
        }else{
            cell.isMonth = false;
        }

        cell.webURL = [NSString stringWithFormat:@"%@",[dic objectForKey:@"protocol"]];
         cell.borrowNid = [NSString stringWithFormat:@"%@", [dic objectForKey:@"borrow_nid"]];
        cell.TouID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        float since=[[dic objectForKey:@"tender_award_fee"] floatValue]+[[dic objectForKey:@"recover_account_interest_yes"] floatValue];
        cell.Mark_earningSince.text=[NSString stringWithFormat:@"%.2f元",since];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy/MM/dd"];//年应该用小写的yyyy不应该是大写的YYYY
        double begin=0;
        if ([dic objectForKey:@"borrow_start_time"]!=nil&&[dic objectForKey:@"borrow_start_time"]!=[NSNull null]) {
            begin=[[dic objectForKey:@"borrow_start_time"]doubleValue];
        }
        double start = 0;
        if ([dic objectForKey:@"repay_last_time"]!=nil&&[dic objectForKey:@"repay_last_time"]!=[NSNull null]) {
            start=[[dic objectForKey:@"repay_last_time"]doubleValue];
        }
        
        if(begin!=0&&start!=0){
            cell.Mark_Date.text=[NSString stringWithFormat:@"投资时间:%@到%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:begin]],[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:start]]];
            
            
        }else{
            cell.Mark_Date.text=@"尚未开始计息";
        }
        cell.Mark_capital.text=[NSString stringWithFormat:@"%@元",[dic objectForKey:@"account"]];
        
        NSString *Mark_state=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status_type_name"]];
        NSUInteger len = [Mark_state length];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"状态:%@", Mark_state]];
        [str addAttribute:NSForegroundColorAttributeName value:kBtnColor range:NSMakeRange(3, len)];
        cell.Mark_state.attributedText = str;
        NSString *transfer_status = [NSString stringWithFormat:@"%@", [dic objectForKey:@"transfer_status"]];

        if ([transfer_status isEqualToString:@"1"]||[transfer_status isEqualToString:@"2"]) {
            cell.xieyi.hidden = YES;
            cell.jihua.hidden = YES;
            cell.transferTypeImage.alpha = 1;
            
        }else {
            
            cell.transferTypeImage.alpha = 0;
        }

        
    }
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    DYSafeViewController *safeVC = [[DYSafeViewController alloc] initWithNibName:@"DYSafeViewController" bundle:nil];
//    safeVC.weburl =[NSString stringWithFormat:@"%@",[self.dataArray[indexPath.row]objectForKey:@"protocol"]] ;
//    safeVC.title = @"借款协议";
//    [self.navigationController pushViewController:safeVC animated:YES];
    
    NSDictionary *dic=[self.dataArray objectAtIndex:indexPath.row];
    NSLog(@"%@",[dic objectForKey:@"borrow_status_nid"]);
    DYInvestDetailVC * detailVC=[[DYInvestDetailVC alloc]initWithNibName:@"DYInvestDetailVC" bundle:nil];
    detailVC.hidesBottomBarWhenPushed=YES;
    detailVC.borrowType = [dic DYObjectForKey:@"borrow_type"];//标类型（判断银承通）
    detailVC.borrow_status_nid = [dic objectForKey:@"borrow_status_nid"];
    if ([[dic DYObjectForKey:@"product"] isEqualToString:@"ft"]) {
        detailVC.borrowId = [dic DYObjectForKey:@"fp_id"];
    }else {
        detailVC.borrowId = [dic DYObjectForKey:@"borrow_nid"];
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];

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
    
    [self getallData:[object intValue]];
}
- (void)getallData:(BOOL)isRefreshing {
    if (isRefreshing)
    {
        
        
        page=1;
        DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
        [diyouDic1 insertObject:@"tender" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"user_list" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic1 insertObject:self.borrowType forKey:@"product_nid" atIndex:0];

        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic1 insertObject:@"recover" forKey:@"status_type" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic1 insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
//                 NSLog(@"dddddd%@",object);
                 self.dataArray = [NSMutableArray new];
                 self.dataArray=[object objectForKey:@"list"];
                 
                 
                 [self.tableView reloadData];
             }
             else
             {
                 
                 if (_tableView.headerView.isLoading)
                 {
                     [_tableView tableViewDidFinishedLoading];
                 }
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
        [diyouDic1 insertObject:@"tender" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"user_list" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic1 insertObject:self.borrowType forKey:@"product_nid" atIndex:0];

        [diyouDic1 insertObject:@"recover" forKey:@"status_type" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic1 insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.footerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             
             if (success==YES) {
//                 NSLog(@"ssssssss%@",object);
                 NSArray * ary=[object objectForKey:@"list"];
                 if (ary.count>0) {
                     
                     for (int i=0; i<ary.count;i++ )
                     {
                         [self.dataArray addObject:ary[i]];
                     }
                 }else
                 {
                     [LeafNotification showInController:self withText:@"数据加载完了"];
                 }
                 
                 
                 [self.tableView reloadData];
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
