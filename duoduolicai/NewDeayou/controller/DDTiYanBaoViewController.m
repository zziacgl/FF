//
//  DDTiYanBaoViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/10/10.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDTiYanBaoViewController.h"
#import "PullingRefreshTableView.h"
#import "DDhasMoenyTableViewCell.h"

@interface DDTiYanBaoViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    int page;
    BOOL isViewDidLoad;
    UINib *nibContent;
    UIView *backView;
    
}
@property(nonatomic,strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation DDTiYanBaoViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"体验金记录";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
//    CGSize btnImageSize = CGSizeMake(22, 22);
    self.moneyLabel.text = self.typeStr;
    switch (self.type) {
        case 0:
            self.titleLabel.text = @"可投体验金";
            break;
        case 7:
            self.titleLabel.text = @"在投体验金";
            break;
        default:
            break;
    }
    isViewDidLoad = YES;
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 90, kMainScreenWidth, kMainScreenHeight - 64 - 90) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:[UIColor blackColor] bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullingDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64 - 90)];
    backView.backgroundColor = kCOLOR_R_G_B_A(240, 240, 240, 1);
    backView.alpha = 0;
    [self.tableView addSubview:backView];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3, kMainScreenHeight / 2 - kMainScreenWidth / 2, kMainScreenWidth / 3, kMainScreenWidth / 4)];
    backImage.image = [UIImage imageNamed:@"我的卡券（无可用优惠券）_03"];
    [backView addSubview:backImage];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backImage.frame) + 20, kMainScreenWidth, 20)];
    titleLab.text = @"暂无数据";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    [backView addSubview:titleLab];

    // Do any additional setup after loading the view from its nib.
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

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;//cell的高度
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *markinder = @"hasmoeny";
    if (!nibContent) {
        nibContent = [UINib nibWithNibName:@"DDhasMoenyTableViewCell" bundle:nil];
        [tableView registerNib:nibContent forCellReuseIdentifier:markinder];
    }
    
    DDhasMoenyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markinder];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataArray[indexPath.row];
    int myType = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"type"]] intValue];
    if (self.type == 0) {
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"remark"]];

            switch (myType) {
                case 12:
                    cell.nameLabel.text = @"分享送体验金";
                    break;
                case 13:
                    cell.nameLabel.text = @"充值100送体验金";
                    break;
                case 14:
                    cell.nameLabel.text = @"充值1000送体验金";
                    break;
                default:
                    break;
            }
            
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        double time=[[dic DYObjectForKey:@"addtime"]doubleValue];
        if (time>0) {
            cell.timeLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
        }
        float money = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"amount"]] floatValue];
        cell.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", money];
    }else {
         cell.nameLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"remark"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        double time=[[dic DYObjectForKey:@"addtime"]doubleValue];
        if (time>0) {
            cell.timeLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
        }
        float money = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"amount"]] floatValue];
        cell.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", money];
        if (myType == 5) {
            cell.moneyLabel.text = [NSString stringWithFormat:@"-%.2f", money];
        }
    }
    
    
    
    return cell;
    
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
-(void)GetUserInfomation:(BOOL)isRefreshing{
    if (isRefreshing)
    {
        page=1;
        DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
        [diyouDic1 insertObject:@"lqb" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"get_lqb_log" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d", self.type] forKey:@"type" atIndex:0];
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
//                 NSLog(@"tableViewDidFinishedLoading%@",object);
                 self.dataArray = [NSMutableArray new];
                 if (self.type == 0) {
                     //可投
                     self.dataArray = [object objectForKey:@"list"];
                 }else if (self.type == 7) {
                     //在投
                     NSArray * ary = [object objectForKey:@"list"];
//                     NSLog(@"aaaaaaaa%@", ary);
                     if (ary.count>0) {
                         
                         for (int i = 0; i<ary.count;i++ )
                         {
                             int type=[[ary[i] objectForKey:@"type"]intValue];
                             if (type!=12 && type!= 13 && type!= 14) {
                                 [self.dataArray addObject:ary[i]];
                                
                             }
                         }
                     }

                 }
                 
                 
                 
                 if (self.dataArray.count > 0) {
                     backView.alpha = 0;
                 }else {
                     backView.alpha = 1;
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
        
    }else
    {
        page++;
        DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
        [diyouDic1 insertObject:@"lqb" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"get_lqb_log" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d", self.type] forKey:@"type" atIndex:0];
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
