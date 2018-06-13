//
//  ShellHomeViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/7.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "ShellHomeViewController.h"
#import "NYSegmentedControl.h"
#import "AddRecordViewController.h"

#import "ShellNoDataView.h"
#import "RecordMoneyCell.h"

#import "ShellModelTool.h"
#import "ShellRecordModel.h"

@interface ShellHomeViewController ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, weak) YUFoldingTableView *foldingTableView;
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) ShellNoDataView *nodataBackView;
@property (nonatomic, strong) NYSegmentedControl *foursquareSegmentedControl;
@property (nonatomic, strong) UIButton *bottomSelectButton;
@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation ShellHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记账";
    self.view.backgroundColor = kBackColor;
    [self configView];
    self.arrowPosition = 1;
    self.selectArray = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self reloadData];
}

- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        self.dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

- (void)configView {
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth / 74 * 42)];
    self.topImageView.image = [UIImage imageNamed:@"overtop"];
    _topImageView.backgroundColor = kMainColor;
    [self.view addSubview:self.topImageView];
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 44)];
    [self.view addSubview:topView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(20, 10, 24, 24);
    [leftBtn addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"moreChose"] forState:UIControlStateNormal];
    [topView addSubview:leftBtn];
    
    NYSegmentedControl *foursquareSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"出售", @"进货"]];
    self.foursquareSegmentedControl = foursquareSegmentedControl;
    foursquareSegmentedControl.titleTextColor = [UIColor blackColor];
    foursquareSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    foursquareSegmentedControl.selectedTitleFont = [UIFont systemFontOfSize:16.0f];
    foursquareSegmentedControl.segmentIndicatorBackgroundColor = kCOLOR_R_G_B_A(224, 72, 22, 1);
    foursquareSegmentedControl.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    [foursquareSegmentedControl addTarget:self action:@selector(handleACticity:) forControlEvents:UIControlEventValueChanged];
    foursquareSegmentedControl.borderWidth = 0.0f;
    foursquareSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    foursquareSegmentedControl.segmentIndicatorInset = 1.0f;
    foursquareSegmentedControl.segmentIndicatorBorderColor = self.view.backgroundColor;
    [foursquareSegmentedControl sizeToFit];
    foursquareSegmentedControl.cornerRadius = 16;
    foursquareSegmentedControl.frame = CGRectMake(0, 0, kMainScreenWidth / 2, 32);
    foursquareSegmentedControl.center = CGPointMake(topView.center.x, topView.center.y - 20.0f);
//    topView.center = foursquareSegmentedControl.center;
    [topView addSubview:foursquareSegmentedControl];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kMainScreenWidth - 44, 10, 24, 24);
//    rightBtn.backgroundColor = [UIColor darkGrayColor];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"addgoods"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(handleRight) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topImageView.frame), kMainScreenWidth, kMainScreenHeight - kMainScreenWidth / 74 * 42)];
    _foldingTableView = foldingTableView;
    foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [foldingTableView registerNib:[UINib nibWithNibName:@"RecordMoneyCell" bundle:nil] forCellReuseIdentifier:@"RecordMoneyCell"];
    [self.view addSubview:foldingTableView];
    foldingTableView.foldingState = YUFoldingSectionStateShow;
    foldingTableView.foldingDelegate = self;
    
    self.nodataBackView = [[ShellNoDataView alloc] initWithTitle:@"暂无记录\n点击右上角“+”号开始记录" image:@"shellNoData"];
    self.nodataBackView.frame = self.foldingTableView.frame;
    self.nodataBackView.alpha = 0;
    [self.view addSubview:self.nodataBackView];
    
    self.bottomSelectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.bottomSelectButton.frame = CGRectMake(15, CGRectGetMaxY(foldingTableView.frame), ScreenWidth - 30, 40);
    self.bottomSelectButton.backgroundColor = kCOLOR_R_G_B_A(224, 72, 22, 1);
    self.bottomSelectButton.layer.cornerRadius = 20;
    [self.bottomSelectButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.bottomSelectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomSelectButton addTarget:self action:@selector(bottomButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomSelectButton];
}

- (void)reloadData {
    [self.dataAry removeAllObjects];
    [self.dataAry addObjectsFromArray:[ShellModelTool getRecord:self.foursquareSegmentedControl.selectedSegmentIndex]];
    [self.foldingTableView reloadData];
    self.nodataBackView.alpha = self.dataAry.count == 0;
}

#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    return self.dataAry.count;
}
- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
{
    return [(NSArray *)self.dataAry[section] count];
}
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section
{
    return 60;
}

- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RecordMoneyCell";
    RecordMoneyCell *cell = [yuTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = yuTableView.editing ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[RecordMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    ShellRecordModel *model = self.dataAry[indexPath.section][indexPath.row];
    cell.nickNameLabel.text = [NSString stringWithFormat:@"客户昵称：%@",model.nickName];
    cell.goodNameLabel.text = [NSString stringWithFormat:@"邮   费：%@",model.postage];
    NSString *remark = model.remark.length ? model.remark : @"暂无";
    cell.remark.text = [NSString stringWithFormat:@"备   注：%@",remark];
    NSString *postage = @"";
    if (model.shippingStatus == GoodNotDispatched) {
        postage = @"未发货";
    }
    if (model.shippingStatus == GoodHasDispatched) {
        postage = @"已发货";
    }
    cell.postStatusLabel.text = postage;
    return cell;
}

#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
{
    ShellRecordModel *model = [self.dataAry[section] firstObject];
    return model.createDate;
}

- (void)yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShellRecordModel *model = self.dataAry[indexPath.section][indexPath.row];
    if (yuTableView.editing) {
        [self.selectArray addObject:model];
    }else {
        [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
        AddRecordViewController *addVC = [[AddRecordViewController alloc] init];
        addVC.hidesBottomBarWhenPushed = YES;
        addVC.recordModel = model;
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

- (void)yuFoldingTableView:(YUFoldingTableView *)yuTableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (yuTableView.editing) {
        ShellRecordModel *model = self.dataAry[indexPath.section][indexPath.row];
        [self.selectArray removeObject:model];
    }
}

// 返回箭头的位置
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    // 没有赋值，默认箭头在左
    return self.arrowPosition ? :YUFoldingSectionHeaderArrowPositionLeft;
}

- (UIImage *)yuFoldingTableView:(YUFoldingTableView *)yuTableView arrowImageForSection:(NSInteger )section {
    UIImage *image = [UIImage imageNamed:@"packup"];
    return [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationLeft];
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView backgroundColorForHeaderInSection:(NSInteger)section {
    return [UIColor whiteColor];
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForTitleInSection:(NSInteger )section {
    return [UIColor blackColor];
}

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section
{
    return @"";
}

#pragma mark - Actions
- (void)leftButtonPressed:(UIButton *)button {
    [self.foldingTableView setEditing:!self.foldingTableView.editing];
    [self.foldingTableView reloadData];
    [UIView animateWithDuration:0.25 animations:^{
        BOOL editing = self.foldingTableView.editing;
        if (editing) {
            self.tabBarController.tabBar.mj_y += self.tabBarController.tabBar.height;
            self.bottomSelectButton.mj_y -= 49;
        }else {
            self.tabBarController.tabBar.mj_y -= self.tabBarController.tabBar.height;
            self.bottomSelectButton.mj_y += 49;
        }
    }];
}

- (void)bottomButtonPressed:(UIButton *)button {
    if (!self.selectArray.count) {
        [MBProgressHUD errorHudWithView:self.view label:@"请选择记录" hidesAfter:1.0];
        return;
    }
    
    for (ShellRecordModel *model in self.selectArray) {
        model.shippingStatus = GoodHasDispatched;
        [ShellModelTool modifyRecordModel:model];
    }
    [self leftButtonPressed:nil];
    [self reloadData];
    [self.selectArray removeAllObjects];
}

- (void)handleACticity:(UISegmentedControl*)sender {
    [self.selectArray removeAllObjects];
    [self reloadData];
}

- (void)handleRight {
    if (self.foldingTableView.editing) [self leftButtonPressed:nil];
    AddRecordViewController *addVC = [[AddRecordViewController alloc] init];
    addVC.hidesBottomBarWhenPushed = YES;
    addVC.recordType = self.foursquareSegmentedControl.selectedSegmentIndex;
    [self.navigationController pushViewController:addVC animated:YES];
}


@end
