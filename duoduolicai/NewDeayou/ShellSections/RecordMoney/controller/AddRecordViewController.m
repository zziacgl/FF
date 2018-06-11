//
//  AddRecordViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/8.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "AddRecordViewController.h"

#import "TopTitleCell.h"
#import "AddGoodsCell.h"
#import "AddRecordHeaderView.h"

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
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TopTitleCell" bundle:nil] forCellReuseIdentifier:@"TopTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddGoodsCell" bundle:nil] forCellReuseIdentifier:@"AddGoodsCell"];
}

- (void)setupTableViewHeader {
//  AddRecordHeaderView
    
}

- (void)setupTableViewFooter {}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [tableView dequeueReusableCellWithIdentifier:@"TopTitleCell" forIndexPath:indexPath];
    }
    if (indexPath.section == 2) {
        return [tableView dequeueReusableCellWithIdentifier:@"AddGoodsCell" forIndexPath:indexPath];
    }
    return nil;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

@end
