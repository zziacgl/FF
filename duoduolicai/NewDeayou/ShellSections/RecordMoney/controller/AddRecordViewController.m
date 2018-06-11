//
//  AddRecordViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/8.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "AddRecordViewController.h"

#import "IQKeyboardManager.h"

#import "TopTitleCell.h"
#import "AddGoodsCell.h"
#import "AddRecordHeaderView.h"
#import "AddRecordFooterView.h"
#import "WriteGoodsInfoView.h"

#import "ShellModelTool.h"
#import "ShellRecordModel.h"
#import "ShellGoodsModel.h"

@interface AddRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AddRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加记录";
    self.view.backgroundColor = kBackColor;
    [self setUpTableView];
    [self setupTableViewHeader];
    [self setupTableViewFooter];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
//    ShellRecordModel *recordModel = [ShellRecordModel new];
//    recordModel.nickName = @"zhoubiwen";
//    recordModel.mobile = @"123456";
//    recordModel.postage = @"50";
//    recordModel.remark = @"你们好";
//    NSMutableArray *arr = [NSMutableArray new];
//    ShellGoodsModel *model = [ShellGoodsModel new];
//    model.goodsName = @"hahaha";
//    model.buyingPrice = @"11";
//    model.sellingPrice = @"22";
//    model.goodsName = @"10";
//
//    recordModel.goods = arr;
//    
//    [ShellModelTool saveRecordModel:recordModel];
//    
//    NSArray *modelArr = [ShellModelTool getRecord:Sale];
    
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TopTitleCell" bundle:nil] forCellReuseIdentifier:@"TopTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddGoodsCell" bundle:nil] forCellReuseIdentifier:@"AddGoodsCell"];
}

- (void)setupTableViewHeader {
    AddRecordHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"AddRecordHeaderView" owner:nil options:nil].firstObject;
    headerView.frame = CGRectMake(0, 0, kMainScreenWidth, 160);
    self.tableView.tableHeaderView = headerView;
}

- (void)setupTableViewFooter {
    AddRecordFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"AddRecordFooterView" owner:nil options:nil].firstObject;
    footerView.frame = CGRectMake(0, 0, kMainScreenWidth, 150);
    self.tableView.tableFooterView = footerView;
}

#pragma mark - private


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddGoodsCell" forIndexPath:indexPath];
        [(AddGoodsCell *)cell addGoodsAction:^{
            [WriteGoodsInfoView showViewSureButtonAction:^(ShellGoodsModel *shellGoodsModel) {
                
            }];
        }];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TopTitleCell" forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }
    return 90;
}

@end
