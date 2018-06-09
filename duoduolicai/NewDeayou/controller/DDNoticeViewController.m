//
//  DDNoticeViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/13.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDNoticeViewController.h"
#import "DDNoticeTableViewCell.h"
#import "PullingRefreshTableView.h"
#import "DYInvestDetailIntroduceVC.h"
@interface DDNoticeViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    UINib *nibContent;
    int page;
    BOOL isViewDidLoad;
    
}
@property(nonatomic,strong)PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *noDataLabel;
@end

@implementation DDNoticeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //初始化tableView
    if (isViewDidLoad)
    {
        //初始化tableView
        [_tableView launchRefreshing];
        isViewDidLoad=NO;
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    //设置下拉刷新tableview
    _tableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:kMainColor bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullingDelegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    isViewDidLoad = YES;
    
    // Do any additional setup after loading the view.
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"notice";
    if (!nibContent) {
        nibContent = [UINib nibWithNibName:@"DDNoticeTableViewCell" bundle:nil];
        [tableView registerNib:nibContent forCellReuseIdentifier:identifier];
    }
    DDNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary *dic = self.dataArray[indexPath.row];
    //    NSLog(@"DDNoticeTableViewCell%@",dic);
    cell.tittleLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
    
    cell.contentLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    double time=[[dic DYObjectForKey:@"publish_time"]doubleValue];
    if (time>0) {
        cell.timeLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DYInvestDetailIntroduceVC * vc=[[DYInvestDetailIntroduceVC alloc]initWithNibName:@"DYInvestDetailIntroduceVC" bundle:nil];
    vc.hidesBottomBarWhenPushed=YES;
    vc.tfText=[self.dataArray[indexPath.row] objectForKey:@"contents"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark- scrollViewDelegate
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
    
    [self refreshTableView:@1];
    
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
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"articles" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"publish_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"media" forKey:@"nid" atIndex:0];
//    [diyouDic insertObject:@"order" forKey:@"order_asc" atIndex:0];
//    [diyouDic insertObject:@"1" forKey:@"status" atIndex:0];
//    [diyouDic insertObject:@"all" forKey:@"limit" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (_tableView.headerView.isLoading)
         {
             [_tableView tableViewDidFinishedLoading];
         }
         if (_tableView.footerView.isLoading)
         {
             [_tableView tableViewDidFinishedLoading];
         }
         if (success==YES) {
             
             self.dataArray = [NSMutableArray new];
             self.dataArray = [object objectForKey:@"list"];
             [self.tableView reloadData];
             if (self.dataArray.count == 0) {
                 if (!_noDataLabel) {
                     self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kMainScreenHeight / 2 - 100, kMainScreenWidth, 30)];
                     self.noDataLabel.text = @"暂无公告";
                     _noDataLabel.textColor = [UIColor darkGrayColor];
                     _noDataLabel.textAlignment = NSTextAlignmentCenter;
                     [self.view addSubview:self.noDataLabel];
                 }
             }
             
         }
         else
         {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
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
