//
//  DYTransactionRecordsViewController_new.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/11.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYTransactionRecordsViewController_new.h"
#import "DYTransactionRecordsTableViewCell_new.h"
#import "PullingRefreshTableView.h"
#import "LeafNotification.h"
@interface DYTransactionRecordsViewController_new ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>{
    UINib * nibContent;
    int page;
    BOOL isViewDidLoad;
}
@property (nonatomic, strong)  NSMutableArray *aryList;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@end

@implementation DYTransactionRecordsViewController_new

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"投标情况";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //设置下拉刷新tableview
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
    leftLabel.text = @"投资用户";
    leftLabel.textColor = [UIColor lightGrayColor];
//    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:leftLabel];
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 160, 0, 150, 40)];
    rightLabel.text = @"投资金额（元）";
    rightLabel.textColor = [UIColor lightGrayColor];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:rightLabel];
    
    
    _tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-40) style:UITableViewStylePlain topTextColor:kBtnColor topBackgroundColor:nil bottomTextColor:kBtnColor bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullingDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    isViewDidLoad=YES;

}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
////    [self queryDataIsRefreshing:YES];
//   
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self testFrefreshTableView];
    
    if (isViewDidLoad)
    {
        //初始化tableView
        [_tableView launchRefreshing];
        isViewDidLoad=NO;
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
#pragma mark- -tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = _aryList[indexPath.row];
    //head
    NSString * mark = @"markHead";
    if (!nibContent)
    {
        nibContent = [UINib nibWithNibName:@"DYTransactionRecordsTableViewCell_new" bundle:nil];
        [tableView registerNib:nibContent forCellReuseIdentifier:mark];
    }
    DYTransactionRecordsTableViewCell_new * cell = [tableView dequeueReusableCellWithIdentifier:mark];
    //数据填充
    NSString *phoneAll=[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"username"]];
    NSString *phone = [[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"username"]] substringToIndex:3];
    NSString *phone2 = [[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"username"]] substringFromIndex:phoneAll.length-2];
    NSString *pwdphone = [NSString stringWithFormat:@"%@******%@",phone,phone2];
//    NSString *pwdphone = [NSString stringWithFormat:@"%@********",phone];
    cell.phone.text = pwdphone;
    cell.date.text = [DYUtils dataUnixTimeYYYYMMDDHHmm:[dic objectForKey:@"addtime"]];
    cell.investM.text = [NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"account"]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //去掉点击后的阴影
    return cell;
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
    [self GetUserInfomation:[object intValue]];
}
//获取数据接口
-(void)GetUserInfomation:(BOOL)isRefreshing
{
    
    //————————————————————————我的主页->实时财务->资金记录——————————————————————————
    
    if (isRefreshing)
    {
        page=1;
        DYOrderedDictionary * diyouDic = [[DYOrderedDictionary alloc]init];
        if ([self.borrowType isEqualToString:@"fragment"]) {
            [diyouDic insertObject:@"tender" forKey:@"module" atIndex:0];
            [diyouDic insertObject:@"fragment_invest_log" forKey:@"q" atIndex:0];
            [diyouDic insertObject:self.borrow_nid forKey:@"id" atIndex:0];

        }else {
            [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
            [diyouDic insertObject:@"get_tender_list" forKey:@"q" atIndex:0];
            [diyouDic insertObject:self.borrow_nid forKey:@"borrow_nid" atIndex:0];

        }
       
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }

             if (success == YES) {
                 //可用信用额度数据填充
                 if ([[object objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                     _aryList =[object objectForKey:@"list"];
                 }
                 [_tableView reloadData];
             }
             else
             {
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }else
    {
        page++;
        DYOrderedDictionary * diyouDic = [[DYOrderedDictionary alloc]init];
        if ([self.borrowType isEqualToString:@"fragment"]) {
            [diyouDic insertObject:@"tender" forKey:@"module" atIndex:0];
            [diyouDic insertObject:@"fragment_invest_log" forKey:@"q" atIndex:0];
            [diyouDic insertObject:self.borrow_nid forKey:@"id" atIndex:0];

        }else {
            [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
            [diyouDic insertObject:@"get_tender_list" forKey:@"q" atIndex:0];
            [diyouDic insertObject:self.borrow_nid forKey:@"borrow_nid" atIndex:0];

        }
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
//        [diyouDic insertObject:@"tender_addtime" forKey:@"order" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic insertObject:self.borrow_nid forKey:@"borrow_nid" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.footerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }

             if (success == YES) {
                 //可用信用额度数据填充
                 if ([[object objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
//                     _aryList =[object objectForKey:@"list"];
                     NSArray * ary = [object objectForKey:@"list"];
                     if (ary.count>0) {
                         
                         for (int i = 0; i<ary.count;i++ )
                         {
                             [self.aryList addObject:ary[i]];
                         }
                     }else
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
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }
}



@end
