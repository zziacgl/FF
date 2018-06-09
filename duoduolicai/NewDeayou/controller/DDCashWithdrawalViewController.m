//
//  DDCashWithdrawalViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 2017/12/1.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDCashWithdrawalViewController.h"
#import "PullingRefreshTableView.h"
#import "DDMyCardTableViewCell.h"
#import "DDNoCardTableViewCell.h"
#import "DYInvestSubmitVC.h"

@interface DDCashWithdrawalViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    BOOL isViewDidLoad;
    int page;
}
@property (nonatomic,strong) PullingRefreshTableView *cashWithdrawalTableView;
@property (nonatomic,strong) NSMutableArray *ticketAry;
@property (nonatomic,copy)NSString *isuse;
@property (nonatomic,copy)NSString *borrow_type;

@end

@implementation DDCashWithdrawalViewController

-(instancetype)init:(NSString *)str borrowtype:(NSString *)type{
    if(self = [super init]){
        self.isuse = str;
        self.borrow_type = type;
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(isViewDidLoad){
        [_cashWithdrawalTableView launchRefreshing];
        isViewDidLoad=NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cashWithdrawalTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60-64) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:kMainColor bottomBackgroundColor:nil];
    _cashWithdrawalTableView.delegate=self;
    _cashWithdrawalTableView.dataSource=self;
    _cashWithdrawalTableView.pullingDelegate=self;
    _cashWithdrawalTableView.backgroundColor=kCOLOR_R_G_B_A(236, 236, 236, 1);
    _cashWithdrawalTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cashWithdrawalTableView];
    [_cashWithdrawalTableView registerClass:[DDMyCardTableViewCell class] forCellReuseIdentifier:@"card"];
    [_cashWithdrawalTableView registerClass:[DDNoCardTableViewCell class] forCellReuseIdentifier:@"no"];
    isViewDidLoad=YES;
}
#pragma mark-－－－-scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.cashWithdrawalTableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.cashWithdrawalTableView tableViewDidEndDragging:scrollView];
    
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
    //    NSLog(@"ssssss%d", [object intValue]);
    [self getTicketData:[object intValue]];
}
#pragma mark - tableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.ticketAry.count > 0) {
        return self.ticketAry.count;
    } else {
        return 1;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ticketAry.count > 0) {
        return 110;
    } else {
        return kMainScreenHeight - 64 - 60;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.ticketAry.count > 0) {
        DDMyCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"card" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kCOLOR_R_G_B_A(236, 236, 236, 1);
        if (self.isuse) {
            cell.userInteractionEnabled = YES;
        }else {
            cell.userInteractionEnabled = NO;
        }
        cell.backImage.image = [UIImage imageWithColor:[UIColor whiteColor]];
        cell.myCountLabel.text=@"免费";
        cell.myCountLabel.font=[UIFont systemFontOfSize:25.0f];
        cell.myCountLabel.textColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
        cell.countLabel.hidden=NO;
        
        NSString *title =[NSString stringWithFormat:@"%@",[self.ticketAry[indexPath.row] objectForKey:@"ticket_type"]];
        if([title isEqualToString:@"wd_ticket"]){
            cell.titleLabel.text = @"推荐专享";
            
        }
        if([title isEqualToString:@"new_ticket"]){
            cell.titleLabel.text = @"新手专享";
        }
        if([title isEqualToString:@"activity_ticket"]){
            cell.titleLabel.text = @"活动专享";
        }
        cell.thirdLabel.hidden=YES;
        cell.firstLabel.text=@"提现金额50元起可用";
        cell.secondLabel.text = [NSString stringWithFormat:@"有效期：%@-%@", [self.ticketAry[indexPath.row] objectForKey:@"add_time"], [self.ticketAry[indexPath.row] objectForKey:@"end_time"]];

        NSString *status = [NSString stringWithFormat:@"%@",[self.ticketAry[indexPath.row] objectForKey:@"ticket_status"]];//ticket_status  0 未使用 1 ，2已冻结  3已使用
        NSString *life = [NSString stringWithFormat:@"%@",[self.ticketAry[indexPath.row] objectForKey:@"live_status"]];//live_status  0已过期  1没过期
        
        if ([status isEqualToString:@"3"]||[status isEqualToString:@"1"]||[status isEqualToString:@"2"]|| [life isEqualToString:@"0"]) {
            cell.coverView.alpha = 0.5;
            cell.pastImage.alpha = 1;
//            cell.backImage.image = [UIImage imageNamed:@"我的卡券"];
            cell.myCountLabel.textColor = [UIColor lightGrayColor];
            cell.countLabel.textColor=[UIColor lightGrayColor];
            if ([status isEqualToString:@"3"]) {
                //已使用
                cell.useLabel.alpha = 0;
                cell.useTypeLabel.alpha = 1;
                cell.useTypeLabel.text = @"已使用";
                cell.useTypeLabel.backgroundColor = [UIColor lightGrayColor];
                
            }
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
                //已冻结
                cell.useLabel.alpha = 0;
                cell.useTypeLabel.alpha = 1;
                cell.useTypeLabel.text = @"已冻结";
                cell.useTypeLabel.backgroundColor = [UIColor lightGrayColor];
                
            }
            if ([life isEqualToString:@"0"]) {
                //已过期
                cell.useLabel.alpha = 0;
                cell.useTypeLabel.alpha = 1;
                cell.useTypeLabel.text = @"已过期";
                cell.useTypeLabel.backgroundColor = [UIColor lightGrayColor];
            }
            
        }else {
            cell.coverView.alpha = 0;
            cell.pastImage.alpha = 0;
            cell.useLabel.alpha = 0;
            cell.useTypeLabel.text = @"未使用";
            cell.useTypeLabel.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
            cell.useTypeLabel.alpha = 1;
            cell.countLabel.textColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
        }
        
        return cell;
    }else {
        DDNoCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"no" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kCOLOR_R_G_B_A(246, 246, 246, 1);
        cell.userInteractionEnabled = NO;
        
        return cell;
    }
    
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell isKindOfClass:[DDMyCardTableViewCell class]]) {
//
//
//    DDMyCardTableViewCell *Dcell = ( DDMyCardTableViewCell *)cell;
//    if ([Dcell.contentView.subviews containsObject:Dcell.useLabel] ) {
//          [Dcell.useLabel removeFromSuperview];
//    }
//
//    if ([Dcell.contentView.subviews containsObject:Dcell.useTypeLabel] ) {
//          [Dcell .useTypeLabel removeFromSuperview];
//    }
//    }
//
//
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //some functions
    
    //    NSLog(@"11");
    // 取消选中状态
    NSString *time = [self.ticketAry[indexPath.row] objectForKey:@"period"] ;
    //    NSString *type = [self.ticketAry[indexPath.row] objectForKey:@"type"];
    //    NSLog(@"请查看卡券使用%@", self.borrow_type);
    //    NSLog(@"取消%@", self.isuse);
    if ([self.borrow_type isEqualToString:@"standard"]) {
        int time1 = [time intValue];
        int time2 = [self.isuse intValue];
        if (time1 == time2 || time2 > time1) {
            if ([self.delegate respondsToSelector:@selector(cashMessage:)]) {
                [self.delegate cashMessage:self.ticketAry[indexPath.row]];
            }
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [LeafNotification showInController:self withText:@"无法使用卡券，请查看卡券使用条件"];
        }
    }else {
        int time1 = [time intValue];
        int time2 = [self.isuse intValue];
        int time3 = time1 *30;
        if (time2 == time3 || time2   > time3) {
            if ([self.delegate respondsToSelector:@selector(cashMessage:)]) {
//                NSLog(@"%@",self.ticketAry[indexPath.row]);
                [self.delegate cashMessage:self.ticketAry[indexPath.row]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [LeafNotification showInController:self withText:@"无法使用卡券，请查看卡券使用条件"];
        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



- (void)getTicketData:(BOOL)isRefreshing {
    if (isRefreshing) {
        page = 1;
        DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"ticket" forKey:@"q" atIndex:0];
        if (!self.isuse) {
            [diyouDic insertObject:@"all" forKey:@"having" atIndex:0];//包含所有券
        }
        [diyouDic insertObject:self.borrowNid forKey:@"borrow_nid" atIndex:0];
        [diyouDic insertObject:@"add_withdraw_ticket" forKey:@"type" atIndex:0];//现金券，不加参数是加息券
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
//        [diyouDic insertObject:@"70" forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (_cashWithdrawalTableView.headerView.isLoading)
             {
                 [_cashWithdrawalTableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
                NSLog(@"add_withdraw_ticket%@", object);
                 
                 self.ticketAry = [NSMutableArray new];
                 self.ticketAry = [object objectForKey:@"list"];
                 
                 [self.cashWithdrawalTableView reloadData];
                 
             }
             else
             {
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }else {
        page++;
        DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"ticket" forKey:@"q" atIndex:0];
        if (!self.isuse) {
            [diyouDic insertObject:@"all" forKey:@"having" atIndex:0];//包含所有券
        }
        [diyouDic insertObject:self.borrowNid forKey:@"borrow_nid" atIndex:0];
        [diyouDic insertObject:@"add_withdraw_ticket" forKey:@"type" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (_cashWithdrawalTableView.footerView.isLoading)
             {
                 [_cashWithdrawalTableView tableViewDidFinishedLoading];
             }
             
             if (success==YES) {
                 //                 NSLog(@"cccc%@", object);
                 NSArray * ary=[object objectForKey:@"list"];
                 if (ary.count>0) {
                     
                     for (int i=0; i<ary.count;i++ )
                     {
                         [self.ticketAry addObject:ary[i]];
                     }
                 }else
                 {
                     [LeafNotification showInController:self withText:@"数据加载完了"];
                 }
                 [self.cashWithdrawalTableView reloadData];
             }
             else
             {
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
