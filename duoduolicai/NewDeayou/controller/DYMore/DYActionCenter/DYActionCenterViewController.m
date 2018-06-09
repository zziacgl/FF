//
//  DYActionCenterViewController.m
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/13.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYActionCenterViewController.h"
#import "PullingRefreshTableView.h"
#import "DYActionCenterListCell.h"
#import "DYActionCenterDetailViewController.h"

@interface DYActionCenterViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    MKNetworkOperation * opList;
    int page;
}
@property (nonatomic,strong)  PullingRefreshTableView *tableView;
@property  (nonatomic,strong) NSMutableArray * huanArr;@end



@implementation DYActionCenterViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"活动中心";
        page = 1;
        self.huanArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tabelView
    [self viewDidAfterLoad];
    
    // 上拉，下拉，tableView
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64) pullingDelegate:self];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.tableView.footerView.backgroundColor = kCOLOR_R_G_B_A(241, 241, 241, 1);
    self.tableView.headerView.backgroundColor = kCOLOR_R_G_B_A(241, 241, 241, 1);
    self.tableView.pullingDelegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView launchRefreshing];

}

//
//-(void)statRequst{
//    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
//    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
//    [diyouDic insertObject:@"list" forKey:@"q" atIndex:0];
//    [diyouDic insertObject:[NSString stringWithFormat:
//                            @"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
//    [diyouDic insertObject:@"post" forKey:@"methond" atIndex:0];
//    [diyouDic insertObject:[NSString stringWithFormat:@"1"] forKey:@"page" atIndex:0];
//    [diyouDic insertObject:[NSString stringWithFormat:@"10"] forKey:@"epage" atIndex:0];
//    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage) {
//        if (isSuccess) {
//            NSLog(@"%@",object);
//            
//        }else{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [MBProgressHUD errorHudWithView:self.view label:errorMessage hidesAfter:1];
//        }
//    } errorBlock:^(id error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:1];
//    }];
//}

-(void)uplistArr:(NSArray*)arr
{
    [_huanArr addObjectsFromArray:arr];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- scrollViewDelegate
#pragma mark

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_tableView tableViewDidEndDragging:scrollView];
}

#pragma mark ------PullTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    
    if (opList)
    {
        [opList cancel];
    }
    [self queryDataIsRefreshing:YES];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    if (opList)
    {
        [opList cancel];
    }
    [self queryDataIsRefreshing:NO];
}

-(void)queryDataIsRefreshing:(BOOL)isRefreshing
{
    page=isRefreshing?1:page+1;
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:
                            @"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"10"] forKey:@"epage" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (_tableView.headerView.isLoading||_tableView.footerView.isLoading)
        {
            [_tableView tableViewDidFinishedLoading];
        }
        if (isSuccess) {

            if (isRefreshing)
            {
                [_huanArr removeAllObjects];
                NSArray * ary=[[object DYObjectForKey:@"user_id"] DYObjectForKey:@"list"];
                if (ary.count<1) {
                    [LeafNotification showInController:self withText:@"暂无数据"];
                }else
                {
                    [self uplistArr:ary];
                }
                
            }
            else
            {
                NSArray * ary=[[object DYObjectForKey:@"user_id"] DYObjectForKey:@"list"];
                if (ary.count<1) {
                    
                    [LeafNotification showInController:self withText:@"到底啦"];
                }
                else
                {
                    [self uplistArr:ary];
                }
            }
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [LeafNotification showInController:self withText:errorMessage];
        }
    } errorBlock:^(id error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       [LeafNotification showInController:self withText:@"网络异常"];
    }];
}


#pragma mark - tableView datasource
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.huanArr.count;
}

 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *inditifier = @"acttionCenterList";
    DYActionCenterListCell *acttionCenterListCell = [tableView dequeueReusableCellWithIdentifier:inditifier];
    if (acttionCenterListCell == nil) {
        acttionCenterListCell = [[DYActionCenterListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:inditifier];
    }
    [acttionCenterListCell.detailImageView setImageWithURL:[NSURL URLWithString:[self.huanArr[indexPath.row]objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"lunbo_default.png"]];
    acttionCenterListCell.detailLabel.text = [self.huanArr[indexPath.row]objectForKey:@"name"];
    return acttionCenterListCell;
}


#pragma mark - tableView delegate
#pragma mark

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenSize.width/2+40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DYActionCenterDetailViewController *actionCenterDetailVC = [[DYActionCenterDetailViewController alloc]init];
    actionCenterDetailVC.actionId = [self.huanArr[indexPath.row] objectForKey:@"id"];
    actionCenterDetailVC.title = [self.huanArr[indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:actionCenterDetailVC animated:YES];
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
