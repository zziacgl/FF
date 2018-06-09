//
//  DYMessageCenterViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/10/14.
//  Copyright © 2015年 wayne. All rights reserved.
//

#import "DYMessageCenterViewController.h"
#import "DYMessageCenterTableViewCell.h"
#import "PullingRefreshTableView.h"

@interface DYMessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>{
    UINib *nibContent;
    int page;
    BOOL isViewDidLoad;
}
@property(nonatomic,retain) PullingRefreshTableView *tableView;//tableview
@property(nonatomic,strong) NSMutableArray *data;
@end

@implementation DYMessageCenterViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"奖励记录";
    }
    return self;
}
-(void)loadView{
    [super loadView];
    //设置下拉刷新tableview
    // 上拉，下拉，tableView
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:[UIColor blackColor] bottomBackgroundColor:nil];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.pullingDelegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    isViewDidLoad=YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    CGRect bounds = self.view.bounds;
//    bounds.size.height = kScreenSize.height - 20 -94+10;
//    _tableView.frame = bounds;
    
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewDidAfterLoad];//视图在加载完之后出现
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView datasource
#pragma mark
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;//cell的高度
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *markReuse = @"markContent";
    if (!nibContent) {
        nibContent = [UINib nibWithNibName:@"DYMessageCenterTableViewCell" bundle:nil];
        [tableView registerNib:nibContent forCellReuseIdentifier:markReuse];
    }
    NSDictionary *dic=[self.data objectAtIndex:indexPath.row];
    DYMessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markReuse];
    cell.MesaageTextView.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"contents"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    cell.Currentdate.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"addtime"] doubleValue]]]];
    float duomi=[[dic objectForKey:@"dmcount"] floatValue];
    if (duomi>0) {
        cell.DuoMi.text=[NSString stringWithFormat:@"+%0.2f多米",duomi];
    }else{
        cell.DuoMi.text=[NSString stringWithFormat:@"%0.2f多米",duomi];
    }
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.MesaageTextView.editable=NO;
    cell.userInteractionEnabled=NO;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //去掉点击后的阴影
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //去掉点击后的阴影
    
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
        [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get_duomi_log_page" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
                 //可用信用额度数据填充
                 if (_tableView.headerView.isLoading)
                 {
                     [_tableView tableViewDidFinishedLoading];
                 }
                 NSDictionary *dic=[object objectForKey:@"data"];
                 self.data=[dic objectForKey:@"list"];
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
        page++;
        DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get_duomi_log_page" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.footerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
                 //可用信用额度数据填充
                 if (_tableView.headerView.isLoading)
                 {
                     [_tableView tableViewDidFinishedLoading];
                 }
                 NSDictionary *dic=[object objectForKey:@"data"];
                 NSArray * ary=[dic objectForKey:@"list"];
                 if (ary.count>0) {
                     
                     for (int i=0; i<ary.count;i++ )
                     {
                         [self.data addObject:ary[i]];
                     }
                 }else
                 {
                     [MBProgressHUD errorHudWithView:self.view label:@"数据加载完了" hidesAfter:2];
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
        
        
    }
}


@end
