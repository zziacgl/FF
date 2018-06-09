//
//  DDPersonalPageMainVC2.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/2.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDPersonalPageMainVC2.h"
#import "PullingRefreshTableView.h"
#import "DDPersonalPageMainTableViewCell.h"

@interface DDPersonalPageMainVC2 ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    UINib *nibContent;
    NSMutableArray * aryOperation;// 请求的集合
    MKNetworkOperation* operation;
    
}
@property(nonatomic,retain)PullingRefreshTableView *tableView;
@property (strong, nonatomic) NSMutableDictionary * bidDic;                 //标的内容
@property (nonatomic,retain) NSMutableArray * aryADImages; //轮播图片数组
@property (nonatomic,retain) NSMutableArray * aryUrls;//轮播图片urls
@end

static int isRefresh = 1;
@implementation DDPersonalPageMainVC2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"多多理财";
        self.title = @"首页";
        if (IOS7)
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }

    }
    return self;
}
- (void)loadView
{
    [super loadView];
    aryOperation = [NSMutableArray array];
    //设置下拉刷新tableView
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:[UIColor blackColor] bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kCOLOR_R_G_B_A(241, 241 , 241, 1); // 背景颜色
    _tableView.headerOnly = YES;
    _tableView.pullingDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.headerView.backgroundColor=[UIColor clearColor]; // 头颜色
    _tableView.footerView.backgroundColor=[UIColor whiteColor]; // 脚颜色
    _tableView.hidden = YES;
    
    [self.view addSubview:_tableView];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //初始化tableView
    if (isRefresh==1) {
        [_tableView launchRefreshing];
        isRefresh=2;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark- tableViewDelegate
// 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1; // cell的个数
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.height-64-44; // cell的高度
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * mark1 = @"markContent";
    if (!nibContent)
    {
        nibContent = [UINib nibWithNibName:@"DDPersonalPageMainTableViewCell" bundle:nil];
        [tableView registerNib:nibContent forCellReuseIdentifier:mark1];
    }
    DDPersonalPageMainTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mark1];
    
//    [self DYRealtimeFianacailContentTableViewCell:cell dic:objectData];
//    [cell.depositBtn addTarget:self action:@selector(withdrawalMoney) forControlEvents:UIControlEventTouchDown];
//    [cell.rechargeBtn addTarget:self action:@selector(rechargeMoney) forControlEvents:UIControlEventTouchDown];
//    [cell.safeBut addTarget:self action:@selector(gotoMyAcount) forControlEvents:UIControlEventTouchDown];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *str = [NSString stringWithFormat:@"%@",[user objectForKey:@"UserName"]];
//    cell.MyAcountLabel.text = str;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
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
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(testFrefreshTableView) withObject:nil afterDelay:0];
}

-(void)testFrefreshTableView
{
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"get_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"invest" forKey:@"showstatus" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"epage" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"page" atIndex:0];
    operation= [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
                {
                    if (isSuccess)
                    {
                       
                        
                        if (_tableView.headerView.isLoading)
                        {
                            [_tableView tableViewDidFinishedLoading];
                            _tableView.hidden = NO;
                        }
                        self.bidDic=[[object DYObjectForKey:@"list"]objectAtIndex:0];//首页内容。
                        [_tableView reloadData];
                    }
                    else
                    {
                        [MBProgressHUD errorHudWithView:self.view label:errorMessage hidesAfter:1];
                        
                    }
                    
                } errorBlock:^(id error)
                {
                    if (_tableView.headerView.isLoading)
                    {
                        [_tableView tableViewDidFinishedLoading];
                    }
                    [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:1];
                }];

    if (_tableView.headerView.isLoading)
    {
        [_tableView tableViewDidFinishedLoading];
        _tableView.hidden = NO;
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
