//
//  DDDrawForstViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/12/2.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDDrawForstViewController.h"
#import "PullingRefreshTableView.h"
#import "DDForstTableViewCell.h"
#import "DDNoCardTableViewCell.h"


@interface DDDrawForstViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    BOOL isViewDidLoad;
    int page;
}
@property (nonatomic, copy) NSString *allMoneyStr;

@property(nonatomic,strong)PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *drawAry;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIView *backView;


@end
static NSString *identifier = @"DDForstTableViewCell";
static NSString *identifier1 = @"DDNoCardTableViewCell";
@implementation DDDrawForstViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 45 - 64 - 90) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:kMainColor bottomBackgroundColor:nil];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.pullingDelegate=self;
    _tableView.backgroundColor = [HeXColor colorWithHexString:@"#f2f2f2"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [self.view addSubview:self.tableView];
    //    [_tableView registerClass:[DDForstTableViewCell class] forCellReuseIdentifier:@"frost"];
        [_tableView registerClass:[DDNoCardTableViewCell class] forCellReuseIdentifier:@"no"];
    
    UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
    
//    UINib *nib1 = [UINib nibWithNibName:identifier1 bundle:nil];
//    [self.tableView registerNib:nib1 forCellReuseIdentifier:identifier1];
    
    [self.view addSubview:self.tableView];
    isViewDidLoad=YES;
    if (isViewDidLoad)
    {
        //初始化tableView
        [_tableView launchRefreshing];
        isViewDidLoad=NO;
    }
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 45- 64 - 90)];
    _backView.backgroundColor = [HeXColor colorWithHexString:@"#f2f2f2"];
    _backView.alpha = 0;
    [self.tableView addSubview:self.backView];
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3, kMainScreenHeight / 2 - kMainScreenWidth / 2, kMainScreenWidth / 3, kMainScreenWidth / 4)];
    backImage.image = [UIImage imageNamed:@"我的卡券（无可用优惠券）_03"];
    [self.backView addSubview:backImage];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backImage.frame) + 20, kMainScreenWidth, 20)];
    titleLab.text = @"暂无数据";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    [self.backView addSubview:titleLab];

    // Do any additional setup after loading the view.
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
    
    [self getRatesData:[object intValue]];
}
- (void)getRatesData:(BOOL)isRefreshing {
    if (isRefreshing) {
        page = 1;
        DYOrderedDictionary *diyou = [[DYOrderedDictionary alloc] init];
        [diyou insertObject:@"account" forKey:@"module" atIndex:0];
        [diyou insertObject:@"get_frost" forKey:@"q" atIndex:0];
        [diyou insertObject:@"post" forKey:@"method" atIndex:0];
        [diyou insertObject:[NSString stringWithFormat:@"%d", [DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyou insertObject:@"cash" forKey:@"type" atIndex:0];
        [diyou insertObject:[NSString stringWithFormat:@"%d", page] forKey:@"page" atIndex:0];
        [diyou insertObject:@"20" forKey:@"epage" atIndex:0];
        [DDNetWoringTool postJSONWithUrl:nil parameters:diyou success:^(id object, BOOL isSuccess, NSString *errorMessage) {
            if (_tableView.headerView.isLoading)
            {
                [_tableView tableViewDidFinishedLoading];
            }
            if (isSuccess) {
                self.allMoneyStr = [NSString stringWithFormat:@"%@元", [object objectForKey:@"frost_total"]];
//                NSLog(@"aaa%@",object);
                self.drawAry = [NSMutableArray new];
                self.drawAry = [object objectForKey:@"list"];
                if (self.drawAry.count >0) {
                    [self.tableView reloadData];
                }else {
                    self.backView.alpha = 1;
                }

                [self.tableView reloadData];
                
                
            }else{
                [LeafNotification showInController:self withText:errorMessage];
                
                
            }
            
            
            
        } fail:^{
            [LeafNotification showInController:self withText:@"网络异常"];
        }];
        
        
    }else {
        page++;
        DYOrderedDictionary *diyou = [[DYOrderedDictionary alloc] init];
        [diyou insertObject:@"account" forKey:@"module" atIndex:0];
        [diyou insertObject:@"get_frost" forKey:@"q" atIndex:0];
        [diyou insertObject:@"post" forKey:@"method" atIndex:0];
        [diyou insertObject:[NSString stringWithFormat:@"%d", [DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyou insertObject:@"cash" forKey:@"type" atIndex:0];
        [diyou insertObject:[NSString stringWithFormat:@"%d", page] forKey:@"page" atIndex:0];
        [diyou insertObject:@"20" forKey:@"epage" atIndex:0];
        [DDNetWoringTool postJSONWithUrl:nil parameters:diyou success:^(id object, BOOL isSuccess, NSString *errorMessage) {
            if (_tableView.footerView.isLoading)
            {
                [_tableView tableViewDidFinishedLoading];
            }
            if (isSuccess) {
                
                self.allMoneyStr = [NSString stringWithFormat:@"%@", [object objectForKey:@"frost_total"]];
                NSArray * ary=[object objectForKey:@"list"];
                if (ary.count>0) {
                    
                    for (int i=0; i<ary.count;i++ )
                    {
                        [self.drawAry addObject:ary[i]];
                        
                    }
                }else
                {
                    
                    [LeafNotification showInController:self withText:@"数据加载完了"];
                }
                

               [self.tableView reloadData];
                
                
            }else{
                [LeafNotification showInController:self withText:errorMessage];
                
                
            }
            
            
            
        } fail:^{
            [LeafNotification showInController:self withText:@"网络异常"];
        }];
        
        
    }
    
    
}
#pragma mark - tableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  
        return self.drawAry.count;
        
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [HeXColor colorWithHexString:@"#f2f2f2"];
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth, 45)];
    _moneyLabel.backgroundColor = [HeXColor colorWithHexString:@"#f2f2f2"];
//    _moneyLabel.text = self.allMoneyStr;
    NSString *money = [NSString stringWithFormat:@"%@", self.allMoneyStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"提现中金额(元)：%@", money]];
    [str addAttribute:NSForegroundColorAttributeName value:kMainColor range:NSMakeRange(9, money.length)];
    _moneyLabel.attributedText = str;
    _moneyLabel.font = [UIFont systemFontOfSize:15];
    [aView addSubview:self.moneyLabel];
    return aView;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        return 65;
    

    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        DDForstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic = self.drawAry[indexPath.row];
        
        cell.tittleLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@""]];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@", [dic objectForKey:@"addtime"]] doubleValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSString *startTime = [formatter stringFromDate:date];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@",startTime];
        cell.tittleLabel.text = @"提现中";
        cell.myMoneyLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"money"]];
        return cell;

    
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
