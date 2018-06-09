//
//  DDFundRecordViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/12/5.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

//@"recharge（充值）, tender_recover_yes(投资收到还款), auto_interest_lqb(体验宝每日自动计息), auto_interest_ticket(卡卷奖励), tender(投标冻结),cash(提现),other(其他),"

#import "DDFundRecordViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "DDFundRecordTableViewCell.h"
#import "DDCapitalRecordModel.h"
@interface DDFundRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIView *backView;
    UIView *tanView;
    int _page;
}

@property (nonatomic, strong) UIButton *navBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, copy) NSString *accountType;
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, copy) NSString *totalMoney;
@end
static int navNumber;
static NSString *identifier = @"DDFundRecordTableViewCell";
@implementation DDFundRecordViewController

- (void)viewDidLoad {
    self.accountType = @"recharge";
    [super viewDidLoad];
    navNumber = 1;
    self.view.backgroundColor = [HeXColor colorWithHexString:@"#f3f3f4"];
    [self configNav];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kBackColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
    [self.view addSubview:self.tableView];
    [self getData];
    [self MJ_headerView];
    [self MJ_footerView];
    // Do any additional setup after loading the view.
}
- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        self.dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

- (void)configNav {
    self.navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _navBtn.frame = CGRectMake(0, 0, 100, 30);
//    _navBtn.backgroundColor = [UIColor whiteColor];
    [_navBtn setTitle:@"资金记录" forState:UIControlStateNormal];
    _navBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_navBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_navBtn addTarget:self action:@selector(handleBtn) forControlEvents:UIControlEventTouchUpInside];
    [_navBtn setImage:[UIImage imageNamed:@"资金明细1_"] forState:UIControlStateNormal];
    [self.navBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5.0];
    [self.navigationItem setTitleView:self.navBtn];
    
    
    
}
- (void)handleBtn {
    if (navNumber == 2) {
        [_navBtn setImage:[UIImage imageNamed:@"资金明细1_"] forState:UIControlStateNormal];
        navNumber = 1;
        [self moveView];
    } else {
        [_navBtn setImage:[UIImage imageNamed:@"资金明细2_"] forState:UIControlStateNormal];
        navNumber = 2;
        
        [self configChoseView];
    }
    
    
}

- (void)configChoseView {
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0;
    [self.view addSubview:backView];
    
    tanView = [[UIView alloc] initWithFrame:CGRectMake(0, -280, kMainScreenWidth, 280)];
    tanView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tanView];
    NSArray *ary = @[@"充值",@"提现",@"投资",@"回款",@"卡券奖励",@"体验宝",@"其他"];
    for (int i = 0; i < 7; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i * 40, kMainScreenWidth, 40);
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        btn.tag = 101 + i;
        [btn addTarget:self action:@selector(handleChose:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[HeXColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [tanView addSubview:btn];
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, i * 39.5, kMainScreenWidth, 0.5);
        lineView.alpha = 0.5;
        lineView.backgroundColor = [HeXColor colorWithHexString:@"#666666"];
        [tanView addSubview:lineView];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        backView.alpha = 0.4;
        tanView.frame = CGRectMake(0, 0, kMainScreenWidth, 280);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)moveView {
    [UIView animateWithDuration:0.5 animations:^{
        tanView.frame = CGRectMake(0, -280, kMainScreenWidth, 280);
        backView.alpha = 0;
    } completion:^(BOOL finished) {
        [tanView removeFromSuperview];
        [backView removeFromSuperview];
    }];
}
- (void)handleChose:(UIButton *)sender {
    NSUInteger a = sender.tag;
    switch (a) {
        case 101:
            [_navBtn setImage:[UIImage imageNamed:@"资金明细1_"] forState:UIControlStateNormal];
            navNumber = 1;
             self.accountType = @"recharge";
            [self moveView];
            [self getData];
            break;
            
        case 102:
            [_navBtn setImage:[UIImage imageNamed:@"资金明细1_"] forState:UIControlStateNormal];
            navNumber = 1;
             self.accountType = @"cash";
            [self moveView];
            [self getData];
            break;
        case 103:
            [_navBtn setImage:[UIImage imageNamed:@"资金明细1_"] forState:UIControlStateNormal];
            navNumber = 1;
            self.accountType = @"tender";
            [self moveView];
            [self getData];
            break;
        case 104:
            [_navBtn setImage:[UIImage imageNamed:@"资金明细1_"] forState:UIControlStateNormal];
            self.accountType = @"tender_recover_yes";
            navNumber = 1;
            [self moveView];
            [self getData];
            break;
        case 105:
            [_navBtn setImage:[UIImage imageNamed:@"资金明细1_"] forState:UIControlStateNormal];
            self.accountType = @"auto_interest_ticket";
            navNumber = 1;
            [self moveView];
            [self getData];
            break;
        case 106:
            [_navBtn setImage:[UIImage imageNamed:@"资金明细1_"] forState:UIControlStateNormal];
            self.accountType = @"auto_interest_lqb";
            navNumber = 1;
            [self moveView];
            [self getData];
            break;
        case 107:
            [_navBtn setImage:[UIImage imageNamed:@"资金明细1_"] forState:UIControlStateNormal];
            self.accountType = @"other";
            navNumber = 1;
            [self moveView];
            [self getData];
            break;
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = [HeXColor colorWithHexString:@"#f2f2f2"];
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 36)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [myView addSubview:whiteView];
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, kMainScreenWidth - 8, 36)];
    _headerLabel.textColor = [UIColor darkGrayColor];
    NSString *mystr = @"";
    if ([self.accountType isEqualToString:@"recharge" ]) {
        mystr = @"充值金额(元)：";
    }else if ([self.accountType isEqualToString:@"cash" ]) {
         mystr = @"提现金额(元)：";
    }else if ([self.accountType isEqualToString:@"tender" ]) {
         mystr = @"投资金额(元)：";
    }else if ([self.accountType isEqualToString:@"tender_recover_yes" ]) {
         mystr = @"收到还款金额(元)：";
    }else if ([self.accountType isEqualToString:@"auto_interest_ticket" ]) {
         mystr = @"卡券奖励金额(元)：";
    }else if ([self.accountType isEqualToString:@"auto_interest_lqb" ]) {
         mystr = @"体验宝金额(元)：";
    }else if ([self.accountType isEqualToString:@"other" ]) {
         mystr = @"其他金额(元)：";
    }
    
    NSInteger len = [self.totalMoney length];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", mystr, self.totalMoney]];
    [str addAttribute:NSForegroundColorAttributeName value:kMainColor2 range:NSMakeRange(mystr.length, len)];
    _headerLabel.attributedText = str;
    _headerLabel.backgroundColor = [UIColor whiteColor];
    _headerLabel.font = [UIFont systemFontOfSize:15];
    [myView addSubview:self.headerLabel];
    return myView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDFundRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDCapitalRecordModel *model = self.dataAry[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)MJ_headerView{
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
        
    }];
    
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.textColor =  kMainColor2;
    header.lastUpdatedTimeLabel.textColor = kMainColor2;
    
    self.tableView.mj_header = header;
    
    
}
- (void)MJ_footerView {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = kMainColor2;
    
    self.tableView.mj_footer = footer;
}

- (void)getData {
    DYOrderedDictionary *diyouDic = [[DYOrderedDictionary alloc] init];
    [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_log" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d", [DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:self.accountType forKey:@"type" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"page" atIndex:0];
    [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
   
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (_tableView.mj_header.isRefreshing)
        {
            [_tableView.mj_header endRefreshing];
        }
       _page = 1;
        if (isSuccess) {
//            NSLog(@"%@", object);
            self.totalMoney = [NSString stringWithFormat:@"%@", [object objectForKey:@"sum_money"]];
            self.dataAry = [DDCapitalRecordModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            [self.tableView reloadData];

        }else{
            [LeafNotification showInController:self withText:errorMessage];
            
            
        }
        
    } fail:^{
        if (_tableView.mj_header.isRefreshing)
        {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreData {
    _page++;
    DYOrderedDictionary *diyouDic = [[DYOrderedDictionary alloc] init];
    [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_log" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d", [DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:self.accountType forKey:@"type" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d", _page] forKey:@"page" atIndex:0];
    [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
    
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
       
        if (isSuccess) {
            NSArray *ary = [DDCapitalRecordModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            [self.dataAry addObjectsFromArray:ary];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [LeafNotification showInController:self withText:errorMessage];
            [self.tableView.mj_footer endRefreshing];
            
        }
        
    } fail:^{
        [self.tableView.mj_footer endRefreshing];
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
