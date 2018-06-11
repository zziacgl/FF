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
@property (nonatomic, strong) NSMutableArray *goods;

@end

@implementation AddRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加记录";
    self.goods = [NSMutableArray new];
    self.view.backgroundColor = kBackColor;
    [self setUpTableView];
    [self setupTableViewHeader];
    [self setupTableViewFooter];
    [[IQKeyboardManager sharedManager] setEnable:YES];
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
    return self.goods.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddGoodsCell" forIndexPath:indexPath];
        [(AddGoodsCell *)cell addGoodsAction:^{
            [WriteGoodsInfoView showWithView:self.navigationController.view sureButtonAction:^(ShellGoodsModel *shellGoodsModel) {
                [self.goods addObject:shellGoodsModel];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.goods.count inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            }];
        }];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TopTitleCell" forIndexPath:indexPath];
        if (indexPath.row > 0) {
            [(TopTitleCell *)cell setGoodsModel:self.goods[indexPath.row - 1]];
        }
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
