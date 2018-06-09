//
//  DDMoneyCardViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/6/8.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMoneyCardViewController.h"
#import "PullingRefreshTableView.h"
#import "DDMyCardTableViewCell.h"
#import "DDNoCardTableViewCell.h"
#import "DYInvestSubmitVC.h"
@interface DDMoneyCardViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    BOOL isViewDidLoad;
    int page;
}
@property (nonatomic, strong) PullingRefreshTableView *moneyCardTableView;
@property (nonatomic, strong) NSMutableArray *ticketAry;
@property (nonatomic, copy) NSString *isuse;
@property (nonatomic, copy) NSString *borrow_type;
@end

@implementation DDMoneyCardViewController
- (instancetype)init:(NSString *)str borrowtype:(NSString *)type{
    if (self = [super init]) {
//        NSLog(@"%@", str);
        self.isuse = str;
        self.borrow_type = type;
    }
    return self;
}
//- (instancetype)init:(NSString *)str{
//    if (self = [super init]) {
//        NSLog(@"%@", str);
//        self.isuse = str;
//    }
//    return self;
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (isViewDidLoad)
    {
        //初始化tableView
        [_moneyCardTableView launchRefreshing];
        isViewDidLoad=NO;
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _moneyCardTableView =[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height- 60 - 64) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:kMainColor bottomBackgroundColor:nil];
    _moneyCardTableView.delegate=self;
    _moneyCardTableView.dataSource=self;
    _moneyCardTableView.pullingDelegate=self;
    _moneyCardTableView.backgroundColor = kCOLOR_R_G_B_A(236, 236, 236, 1);
    _moneyCardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.moneyCardTableView];
    [_moneyCardTableView registerClass:[DDMyCardTableViewCell class] forCellReuseIdentifier:@"card"];
    [_moneyCardTableView registerClass:[DDNoCardTableViewCell class] forCellReuseIdentifier:@"no"];
    isViewDidLoad=YES;
    
    // Do any additional setup after loading the view.
}
#pragma mark-－－－-scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.moneyCardTableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.moneyCardTableView tableViewDidEndDragging:scrollView];
    
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
        cell.backImage.image = [UIImage imageNamed:@"我的现金券"];
        NSString *str = [self.ticketAry[indexPath.row] objectForKey:@"award"];
        NSString *str2 = [NSString stringWithFormat:@"¥%@", str];
        NSUInteger len = [str length];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:str2];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(1, len)];
        cell.myCountLabel.attributedText = str1;
        cell.myCountLabel.textColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
        int title = [[self.ticketAry[indexPath.row] objectForKey:@"recom"] intValue];
        switch (title) {
            case 0:
                cell.titleLabel.text = @"新手专享";
                break;
            case 1:
                cell.titleLabel.text = @"推荐专享";
                break;
            case 2:
                cell.titleLabel.text = @"活动专享";
                break;
            default:
                break;
        }
        
        NSString *time = [self.ticketAry[indexPath.row] objectForKey:@"period_desc"] ;
        NSString *timeUnit = [self.ticketAry[indexPath.row] objectForKey:@"time_unit"];
        //time_unit字段为1是天，其他值就当做月吧
        if ([timeUnit isEqualToString:@"1"]) {
            cell.firstLabel.text = [NSString stringWithFormat:@"限投资%@以上标（新手标）", time];
        }else {
            cell.firstLabel.text = [NSString stringWithFormat:@"限投资%@(含)以上标", time];
        }
        
        cell.secondLabel.text = [NSString stringWithFormat:@"单笔最低投资%@元可使用", [self.ticketAry[indexPath.row] objectForKey:@"invest_account"]];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy/MM/dd"];//年应该用小写的yyyy不应该是大写的
        double add = 0;
        if ([self.ticketAry[indexPath.row] objectForKey:@"addtime"]!= nil && [self.ticketAry[indexPath.row] objectForKey:@"addtime"]!=[NSNull null]) {
            add = [[self.ticketAry[indexPath.row] objectForKey:@"addtime"] doubleValue];
        }
        double dead = 0;
        if ([self.ticketAry[indexPath.row] objectForKey:@"deadline"]!= nil && [self.ticketAry[indexPath.row] objectForKey:@"deadline"]!= [NSNull null]) {
            dead = [[self.ticketAry[indexPath.row] objectForKey:@"deadline"] doubleValue];
        }
        if (add!=0 && dead != 0) {
            cell.thirdLabel.text = [NSString stringWithFormat:@"有效期：%@-%@", [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:add]], [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:dead]]];
        }
        
        NSString *status = [NSString stringWithFormat:@"%@",[self.ticketAry[indexPath.row] objectForKey:@"status"]];
        NSString *life = [NSString stringWithFormat:@"%@",[self.ticketAry[indexPath.row] objectForKey:@"lifetstatus"]];
        if ([status isEqualToString:@"1"] || [life isEqualToString:@"1"]) {
            cell.coverView.alpha = 0.5;
            cell.pastImage.alpha = 1;
            cell.backImage.image = [UIImage imageNamed:@"我的卡券"];
            cell.myCountLabel.textColor = [UIColor lightGrayColor];
            if ([status isEqualToString:@"1"]) {
                //已使用
                cell.useLabel.alpha = 1;
                cell.useLabel.text = [NSString stringWithFormat:@"已用至%@",[self.ticketAry[indexPath.row] objectForKey:@"borrow_title"]];
                cell.useLabel.backgroundColor = [UIColor lightGrayColor];
                cell.useTypeLabel.alpha = 0;
                
            }
            if ([life isEqualToString:@"1"]) {
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
            if ([self.delegate respondsToSelector:@selector(moneyMassage:)]) {
                [self.delegate moneyMassage:self.ticketAry[indexPath.row]];
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
            if ([self.delegate respondsToSelector:@selector(moneyMassage:)]) {
                [self.delegate moneyMassage:self.ticketAry[indexPath.row]];
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
        [diyouDic insertObject:@"ticket" forKey:@"type" atIndex:0];//现金券，不加参数是加息券
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (_moneyCardTableView.headerView.isLoading)
             {
                 [_moneyCardTableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
//                 NSLog(@"aaa%@", object);
                 
                 self.ticketAry = [NSMutableArray new];
                 self.ticketAry = [object objectForKey:@"list"];
                 
                 [self.moneyCardTableView reloadData];
                 
             }
             else
             {
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             if (_moneyCardTableView.headerView.isLoading)
             {
                 [_moneyCardTableView tableViewDidFinishedLoading];
             }
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
        [diyouDic insertObject:@"ticket" forKey:@"type" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (_moneyCardTableView.footerView.isLoading)
             {
                 [_moneyCardTableView tableViewDidFinishedLoading];
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
                 [self.moneyCardTableView reloadData];
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
