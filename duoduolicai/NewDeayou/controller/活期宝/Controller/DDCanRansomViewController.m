//
//  DDCanRansomViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/11.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDCanRansomViewController.h"
#import "DDCanRansomTableViewCell.h"
#import "DDCanRansomModel.h"
#import "DDRansomDetailViewController.h"
@interface DDCanRansomViewController ()<UITableViewDelegate, UITableViewDataSource>{
    int _page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataAry;
@end
static NSString *identifier = @"DDCanRansomTableViewCell";
@implementation DDCanRansomViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64 - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kBackColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
    [self.view addSubview:self.tableView];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 90;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDCanRansomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    DDCanRansomModel *model = self.dataAry[indexPath.row];
    cell.canRansomModel = model;
    cell.ransomBtn.tag = indexPath.row;
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.ransomBtn addTarget:self action:@selector(handleRansom:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)handleRansom:(UIButton *)sender {
    DDRansomDetailViewController *ransomDetailVC = [[DDRansomDetailViewController alloc] initWithNibName:@"DDRansomDetailViewController" bundle:nil];
    
    DDCanRansomModel *model = self.dataAry[sender.tag];
    ransomDetailVC.model = model;
    [self.navigationController pushViewController:ransomDetailVC animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = kMainColor2;
    
    self.tableView.mj_footer = footer;
}

- (void)getData {
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"borrow" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_current_list" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d", [DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic1 insertObject:@"0" forKey:@"current_status" atIndex:0];
    [diyouDic1 insertObject:@"1" forKey:@"page" atIndex:0];
    [diyouDic1 insertObject:@"10" forKey:@"epage" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (_tableView.mj_header.isRefreshing)
        {
            [_tableView.mj_header endRefreshing];
        }

        if (isSuccess) {
                        _page = 1;
//            NSLog(@"%@", object);
            self.dataAry = [DDCanRansomModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
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
- (void)loadMore{
    _page++;
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"borrow" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_current_list" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d", [DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic1 insertObject:@"0" forKey:@"current_status" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page" atIndex:0];
    [diyouDic1 insertObject:@"10" forKey:@"epage" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess) {
            
//            NSLog(@"%@", object);
            NSArray *ary = [DDCanRansomModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
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
