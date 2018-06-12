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

@property (nonatomic, weak) AddRecordHeaderView *headerView;
@property (nonatomic, weak) AddRecordFooterView *footerView;

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
    [self setupRecordModel];
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
    self.headerView = headerView;
    headerView.frame = CGRectMake(0, 0, kMainScreenWidth, 160);
    self.tableView.tableHeaderView = headerView;
}

- (void)setupTableViewFooter {
    AddRecordFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"AddRecordFooterView" owner:nil options:nil].firstObject;
    self.footerView = footerView;
    footerView.frame = CGRectMake(0, 0, kMainScreenWidth, 210);
    [footerView.sureButton addTarget:self action:@selector(sureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;
}

- (void)setupRecordModel {
    if (self.recordModel) {
        [self.goods removeAllObjects];
        
        [self.goods addObjectsFromArray:self.recordModel.goods];
        self.headerView.nickNameTextField.text = self.recordModel.nickName;
        self.headerView.mobileTextField.text = self.recordModel.mobile;
        self.headerView.postageTextField.text = self.recordModel.postage;
        [self.tableView reloadData];
        
        [self.footerView.sureButton setTitle:@"确认修改" forState:UIControlStateNormal];
    }
}

#pragma mark - private
- (void)sureButtonPressed:(UIButton *)button {
    AddRecordHeaderView *headerView = (AddRecordHeaderView *)self.tableView.tableHeaderView;
    AddRecordFooterView *footerView = (AddRecordFooterView *)self.tableView.tableFooterView;
    if (!headerView.nickNameTextField.text.length) {
        [MBProgressHUD errorHudWithView:self.view label:@"昵称不能为空" hidesAfter:1.0];
        return;
    }
    if (!headerView.mobileTextField.text.length) {
        [MBProgressHUD errorHudWithView:self.view label:@"手机号不能为空" hidesAfter:1.0];
        return;
    }
    if (!headerView.postageTextField.text.length) {
        [MBProgressHUD errorHudWithView:self.view label:@"邮费不能为空" hidesAfter:1.0];
        return;
    }
    if (!self.goods.count) {
        [MBProgressHUD errorHudWithView:self.view label:@"商品不能为空" hidesAfter:1.0];
        return;
    }
    
    ShellRecordModel *model = [ShellRecordModel new];
    model.nickName = headerView.nickNameTextField.text;
    model.mobile = headerView.mobileTextField.text;
    model.postage = headerView.postageTextField.text;
    if (footerView.textView.text.length) {
        model.remark = footerView.textView.text;
    }
    model.recordType = self.recordType;
    model.shippingStatus = GoodNotDispatched;
    model.goods = self.goods;
    
    if (self.recordModel) {
        [self.recordModel setValuesForKeysWithDictionary:[model convertDictionary]];
        [ShellModelTool modifyRecordModel:self.recordModel];
        [MBProgressHUD checkHudWithView:self.view label:@"修改记录成功" hidesAfter:1.0];
        return;
    }
    [ShellModelTool saveRecordModel:model];
    [MBProgressHUD checkHudWithView:self.view label:@"添加记录成功" hidesAfter:1.0];
    
}

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
