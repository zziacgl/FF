//
//  DDOtherVideoViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/10/28.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDOtherVideoViewController.h"
#import "DDOtherVideoCell.h"
#import "DDOtherVideoModel.h"
@interface DDOtherVideoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int _page;
}
@property(nonatomic,strong)UITableView*tableView;
@property (nonatomic, strong)NSMutableArray*dataArray;

@end
static NSString *cellID = @"DDOtherVideoCell";
@implementation DDOtherVideoViewController
- (NSMutableArray*)dataArray{
    if (_dataArray==nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"往期视频";
    self.view.backgroundColor = kBackColor;
//    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, kMainScreenWidth, kMainScreenHeight-64-15) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:cellID bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
    [self MJ_refresh];
    [self loadData];
}
- (void)MJ_refresh{
    MJRefreshNormalHeader*header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.textColor = [HeXColor colorWithHexString:@"#666666"];
    self.tableView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [HeXColor colorWithHexString:@"#666666"];
    
    self.tableView.mj_footer = footer;
    
}
- (void)loadMore{
    _page++;
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"video" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_video_list" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
    
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page" atIndex:0];
    
    [diyouDic1 insertObject:@"10" forKey:@"epage" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess) {
            NSArray *array = [DDOtherVideoModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];

            [self.tableView.mj_footer endRefreshing];
        }else{
            [LeafNotification showInController:self withText:errorMessage];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];

        }
        
        
    } fail:^{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];

    }];
    

    
}
- (void)loadData{
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"video" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_video_list" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
    
    [diyouDic1 insertObject:@"1" forKey:@"page" atIndex:0];
    
    [diyouDic1 insertObject:@"10" forKey:@"epage" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        _page = 1;
        if (isSuccess) {
            self.dataArray = [DDOtherVideoModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];

        }else{
            [LeafNotification showInController:self withText:errorMessage];
            [self.tableView.mj_header endRefreshing];

        }
        
        
        
    } fail:^{
        [self.tableView.mj_header endRefreshing];

    }];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDOtherVideoCell *cell = (DDOtherVideoCell*)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.returnBlock) {
        self.returnBlock(self.dataArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
