//
//  DDActionCenterViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/3.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDActionCenterViewController.h"
#import "DDActionCenterTableViewCell.h"
#import "PullingRefreshTableView.h"

@interface DDActionCenterViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    UINib *nibContent;
}
@property(nonatomic,strong)PullingRefreshTableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation DDActionCenterViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"活动中心";
    }
    return self;
}
-(void)loadView{
    [super loadView];
    
    _dataArr=[NSMutableArray new];
    //导航右边的按钮
    UIButton * btnRightItem=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor=[UIColor clearColor];
    btnRightItem.frame=CGRectMake(0, 0, 100.0f, 60.0f);
    [btnRightItem setTitle:@"刷新" forState:UIControlStateNormal];
    [btnRightItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnRightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    [btnRightItem addTarget:self action:@selector(refreshInformation) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    //设置下拉刷新tableview
    // 上拉，下拉，tableView
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:[UIColor blackColor] bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kCOLOR_R_G_B_A(241, 241 , 241, 1); // 背景颜色
    _tableView.headerOnly = YES;
    _tableView.pullingDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.headerView.backgroundColor=[UIColor clearColor]; // 头颜色
    _tableView.footerView.backgroundColor=[UIColor whiteColor]; // 脚颜色
    _tableView.hidden=YES;
    
    
    
}
   -(void)refreshInformation{
 [self.tableView launchRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //初始化tableView
   [_tableView launchRefreshing];// 实现自身的刷新
}
#pragma mark - tableView datasource
#pragma mark
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;//cell的高度
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *markReuse = @"markContent";
    if (!nibContent) {
        nibContent = [UINib nibWithNibName:@"DDActionCenterTableViewCell" bundle:nil];
        [tableView registerNib:nibContent forCellReuseIdentifier:markReuse];
    }
    DDActionCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markReuse];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    NSDictionary *dic=[self.dataArr objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"full_pic_url"]] placeholderImage:[UIImage imageNamed:@"lunbo_default.png"]];
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
    //    [self performSelector:@selector(testFrefreshTableView) withObject:nil afterDelay:2];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_tableView tableViewDidEndDragging:scrollView];
}

#pragma mark ------PullTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    //    [self queryDataIsRefresh:YES];
    [self performSelector:@selector(testFrefreshTableView) withObject:nil afterDelay:0];
}
-(void)testFrefreshTableView
{
    //————————————————————————我的主页->实时财务——————————————————————————
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"mobile_get_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"scrollpic" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"all" forKey:@"limit" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"status" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
          if (isSuccess)
          {
               if (_tableView.headerView.isLoading)
               {
                      [_tableView tableViewDidFinishedLoading];
               }
               self.dataArr=[object objectForKey:@"list"];
              [_tableView reloadData];
           }
           else
            {
                  [LeafNotification showInController:self withText:errorMessage];
            }
     } errorBlock:^(id error)
       {
          if (_tableView.headerView.isLoading)
          {
               [_tableView tableViewDidFinishedLoading];
           }
          [LeafNotification showInController:self withText:@"网络异常"];
       }];

  
    
    [self.view addSubview:_tableView];
    
    
    if (_tableView.headerView.isLoading)
    {
        [_tableView tableViewDidFinishedLoading];
        _tableView.hidden=NO;
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
