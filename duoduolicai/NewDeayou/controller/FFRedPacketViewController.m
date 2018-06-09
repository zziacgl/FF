//
//  FFRedPacketViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/1/18.
//  Copyright © 2018年 浙江多多投资管理有限公司.  rights reserved.
//

#import "FFRedPacketViewController.h"
#import "FFRedPacketmodel.h"
#import "FFRedPacketTableViewCell.h"
@interface FFRedPacketViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    int page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) NoDataView *backView;
@property (nonatomic, strong) UISegmentedControl *cardSeg;
@property (nonatomic, copy) NSString *cardType;
@end
static NSString *identifer = @"FFRedPacketTableViewCell";
@implementation FFRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的红包";
    self.view.backgroundColor = kBackColor;
     self.cardType = @"ticket";
    [self layoutTableView];
    [self getCardData];
    [self MJ_refresh];
    [self MJ_footerView];
    [self configuteNavView];
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    
    // Do any additional setup after loading the view.
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)layoutTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    self.backView = [[NoDataView alloc] initWithTitle:@"您还没有卡券" image:@"我的卡券（无可用优惠券）_03"];
    self.backView.frame = self.tableView.bounds;
    self.backView.alpha = 0;
    [self.view addSubview:self.backView];
    [self.tableView registerNib:[UINib nibWithNibName:@"FFRedPacketTableViewCell" bundle:nil] forCellReuseIdentifier:identifer];

}

- (void) configuteNavView {
    NSArray *tittleAry =@[@"返现红包",@"加息红包"];
    self.cardSeg = [[UISegmentedControl alloc] initWithItems:tittleAry];
    self.cardSeg.frame = CGRectMake(kMainScreenWidth / 4, 10, kMainScreenWidth / 2, 30);
    self.cardSeg.tintColor = kBtnColor;
    self.cardSeg.selectedSegmentIndex = 0;
    
//    self.cardSeg.backgroundColor = kMainColor;
    [self.cardSeg addTarget:self action:@selector(handleSegment:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.cardSeg;
    
}
- (void)handleSegment:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
            self.cardType = @"ticket";
             [self.tableView.mj_header beginRefreshing];
            break;
        case 1:
            self.cardType = @"rates";
            
            [self.tableView.mj_header beginRefreshing];

            break;
            
        default:
            break;
    }
    
}

- (void)MJ_refresh{
    MJRefreshNormalHeader*mheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCardData)];
    mheader.stateLabel.font = [UIFont systemFontOfSize:12];
    mheader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    mheader.stateLabel.textColor = kMainColor;
    mheader.lastUpdatedTimeLabel.textColor = kMainColor;
    self.tableView.mj_header = mheader;
    
    
}

- (void)MJ_footerView {
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 加载旧的数据，加载旧的未显示的数据
        
        [self getMoreCardData];
    }];
    
}


#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFRedPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.model = self.dataAry[indexPath.row];
    return cell;
}

- (void)getCardData{
    page = 1;
    NSLog(@"类型%@", self.cardType);
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"ticket" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"borrow_ticket" forKey:@"q" atIndex:0];
    [diyouDic insertObject:self.borrowNid forKey:@"borrow_nid" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"status" atIndex:0];

    [diyouDic insertObject: self.cardType forKey:@"type" atIndex:0];
     [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
    [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self.tableView.mj_header endRefreshing];

         if (success==YES) {
             myLog(@"我的卡券%@", object);
             self.dataAry = [FFRedPacketmodel mj_objectArrayWithKeyValuesArray:object[@"list"]];
             if (self.dataAry.count > 0) {
                 self.backView.alpha = 0;
                 [self.tableView reloadData];
             }else {
                 self.backView.alpha = 1;
             }
         }
         else
         {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         [self.tableView.mj_header endRefreshing];
         [LeafNotification showInController:self withText:@"网络异常"];
       
     }];
    
    
}
- (void)getMoreCardData{
    page++;
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"ticket" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"borrow_ticket" forKey:@"q" atIndex:0];
    [diyouDic insertObject:self.borrowNid forKey:@"borrow_nid" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"status" atIndex:0];

    [diyouDic insertObject: self.cardType forKey:@"type" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
    [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self.tableView.mj_footer endRefreshing];

         if (success==YES) {
             myLog(@"更多%@", object);
             NSArray *ary = [FFRedPacketmodel mj_objectArrayWithKeyValuesArray:object[@"list"]];
             if (ary.count > 0) {
//                 for (int i=0; i<ary.count;i++ )
//                 {
//                     [self.dataAry addObject:ary[i]];
//
//                 }
                 [self.dataAry addObjectsFromArray:ary];
                 
                 [self.tableView reloadData];
                 
             }else {
                 [LeafNotification showInController:self withText:@"数据已全部加载"];
             }
         }
         else
         {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         [self.tableView.mj_footer endRefreshing];
         [LeafNotification showInController:self withText:@"网络异常"];
         
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
