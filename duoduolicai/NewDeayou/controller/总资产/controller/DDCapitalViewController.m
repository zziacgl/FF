//
//  DDCapitalViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/12/8.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDCapitalViewController.h"
#import "DDhasMoenyTableViewCell.h"
#import "DDCapitalModel.h"

@interface DDCapitalViewController ()<UITableViewDelegate, UITableViewDataSource>{
    int _page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataAry;

@end
static NSString *identifier = @"DDhasMoenyTableViewCell";
@implementation DDCapitalViewController

- (void)viewDidLoad {
    self.title = @"待收本金";
    [super viewDidLoad];
    CGSize btnImageSize = CGSizeMake(22, 22);
    self.topView.backgroundColor = [UIColor whiteColor];
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    self.capitalLabel.text = self.capitalMoney;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, kMainScreenWidth, kMainScreenHeight - 64 - 90) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kBackColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
    [self.view addSubview:self.tableView];
    [self MJ_headerView];
    [self MJ_footerView];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        self.dataAry = [NSMutableArray array];
    }
    return _dataAry;
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDhasMoenyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDCapitalModel *model = self.dataAry[indexPath.row];
    cell.model = model;
    return cell;
}


- (void)getData {
    DYOrderedDictionary *diyouDic = [[DYOrderedDictionary alloc] init];
    
    [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_await" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d", [DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:@"capital" forKey:@"type" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"page" atIndex:0];
    [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (_tableView.mj_header.isRefreshing)
        {
            [_tableView.mj_header endRefreshing];
        }
        if (isSuccess) {
            _page = 1;
//            NSLog(@"%@", object);
            self.dataAry = [DDCapitalModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            [self.tableView reloadData];
            
        }else {
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
    [diyouDic insertObject:@"get_await" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d", [DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:@"capital" forKey:@"type" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page" atIndex:0];
    [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess) {
            NSArray *ary = [DDCapitalModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            [self.dataAry addObjectsFromArray:ary];
            [self.tableView.mj_footer endRefreshing];
            
            [self.tableView reloadData];
            
        }else {
            [LeafNotification showInController:self withText:errorMessage];
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
