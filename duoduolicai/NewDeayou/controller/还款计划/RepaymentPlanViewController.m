//
//  RepaymentPlanViewController.m
//  NewDeayou
//
//  Created by apple on 15/11/17.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "RepaymentPlanViewController.h"
#import "RepaymentPlanCell.h"
#import "PullingRefreshTableView.h"
#import "FirstRepaymentPlanCell.h"
#import "LeafNotification.h"
@interface RepaymentPlanViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>

{
    UINib * nibContent;
    UINib * secondContent;
    int page;
    BOOL isViewDidLoad;
}
@property (nonatomic, strong) PullingRefreshTableView *tableView;

@property (nonatomic,strong)NSArray *RepayList;//还款计划列表
@property(nonatomic,strong)NSString *RepayNumber;//还款次数
@property(nonatomic,strong)NSString *RepayStyle;//还款方式
@end

@implementation RepaymentPlanViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"回款计划";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];

    //设置下拉刷新tableview
    _tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain topTextColor:kBtnColor topBackgroundColor:nil bottomTextColor:kBtnColor bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.headerOnly = YES;
    _tableView.pullingDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    isViewDidLoad=YES;
    
}
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
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark- -tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.RepayList count]+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }else {
        return 65;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        NSString *mark1 = @"markFirst";
        if (!nibContent) {
            nibContent = [UINib nibWithNibName:@"FirstRepaymentPlanCell" bundle:nil];
            [tableView registerNib:nibContent forCellReuseIdentifier:mark1];
        }
        FirstRepaymentPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:mark1];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //去掉点击后的阴影
        cell.RepaymentStyle.text=self.RepayStyle;
        if (self.RepayNumber) {
            cell.RepaymentNumber.text=[NSString stringWithFormat:@"%@次",self.RepayNumber];
        }
        
        return cell;
    } else {
        NSString *mark2 = @"markSecond";
        if (!secondContent) {
            
            secondContent = [UINib nibWithNibName:@"RepaymentPlanCell" bundle:nil];
            [tableView registerNib:secondContent forCellReuseIdentifier:mark2];
        }
        RepaymentPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:mark2];
        NSDictionary *dataDic=[self.RepayList objectAtIndex:indexPath.row-1];
        cell.RepaymentAmount.text=[NSString stringWithFormat:@"还款金额：%.2f元",[[dataDic objectForKey:@"money"]floatValue]];
        cell.RepaymentTime.text=[NSString stringWithFormat:@"还款时间：%@",[dataDic objectForKey:@"repay_time"]];
        cell.repayType.text = [NSString stringWithFormat:@"还款类型：%@", [dataDic objectForKey:@"name"]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //去掉点击后的阴影
        return cell;
        
    }
    
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
    [MBProgressHUD hudWithView:self.view label:@"数据请求中"];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    if ([self.borrowType isEqualToString:@"fragment"]) {
        [diyouDic insertObject:@"repay" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"log" forKey:@"q" atIndex:0];
        [diyouDic insertObject:self.borrowId forKey:@"id" atIndex:0];

    }else {
        [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get_repay_info" forKey:@"q" atIndex:0];
        [diyouDic insertObject:self.borrowId forKey:@"borrow_nid" atIndex:0];

    }
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (success==YES) {
             NSLog(@"%@", object);
             //可用信用额度数据填充
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
//             NSLog(@"%@",object);
             self.RepayList=[object objectForKey:@"list"];
             self.RepayStyle=[object objectForKey:@"borrow_style"];
             self.RepayNumber=[object objectForKey:@"count"];
             [_tableView reloadData];
             
         }
         else
         {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         if (_tableView.headerView.isLoading)
         {
             [_tableView tableViewDidFinishedLoading];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
