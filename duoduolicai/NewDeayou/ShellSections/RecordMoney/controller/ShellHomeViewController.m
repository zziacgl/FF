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

#import "ShellModelTool.h"
#import "ShellRecordModel.h"

@interface ShellHomeViewController ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, weak) YUFoldingTableView *foldingTableView;
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) ShellNoDataView *nodataBackView;
@property (nonatomic, strong) NYSegmentedControl *foursquareSegmentedControl;

@end

@implementation ShellHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记账";
    self.view.backgroundColor = kBackColor;
    [self configView];
    self.arrowPosition = 1;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];

//    self.fd_prefersNavigationBarHidden = YES;
    // Do any additional setup after loading the view.
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
//    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(20, 10, 24, 24);
    [leftBtn setImage:[UIImage imageNamed:@"moreChose"] forState:UIControlStateNormal];
    [topView addSubview:leftBtn];
    
    NYSegmentedControl *foursquareSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"出售", @"进货"]];
    self.foursquareSegmentedControl = foursquareSegmentedControl;
    foursquareSegmentedControl.titleTextColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:1.0f];
    foursquareSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    foursquareSegmentedControl.selectedTitleFont = [UIFont systemFontOfSize:16.0f];
    foursquareSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:1.0f];
    foursquareSegmentedControl.backgroundColor = [UIColor colorWithRed:0.31f green:0.53f blue:0.72f alpha:1.0f];
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
    
    [self.view addSubview:foldingTableView];
    foldingTableView.foldingState = YUFoldingSectionStateShow;
    foldingTableView.foldingDelegate = self;
    
    self.nodataBackView = [[ShellNoDataView alloc] initWithTitle:@"暂无数据" image:@"no_data"];
    self.nodataBackView.frame = self.foldingTableView.bounds;
    self.nodataBackView.alpha = 0;
    [self.view addSubview:self.nodataBackView];
    
}

- (void)reloadData {
    [self.dataAry removeAllObjects];
    [self.dataAry addObjectsFromArray:[ShellModelTool getRecord:self.foursquareSegmentedControl.selectedSegmentIndex]];
    [self.foldingTableView reloadData];
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
    return 50;
}

- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [yuTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld -- section %ld", (long)indexPath.row, (long)indexPath.section];
    
    ShellRecordModel *model = self.dataAry[indexPath.section][indexPath.row];
    cell.textLabel.text = model.nickName;
    return cell;
}
#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
{
    ShellRecordModel *model = [self.dataAry[section] firstObject];
    return model.createDate;
}

- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
    AddRecordViewController *addVC = [[AddRecordViewController alloc] init];
    addVC.hidesBottomBarWhenPushed = YES;
    addVC.recordModel = self.dataAry[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:addVC animated:YES];
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

- (void)handleACticity:(UISegmentedControl*)sender {
    [self reloadData];
    
    NSUInteger index = sender.selectedSegmentIndex;
    
    switch (index) {
        case 0:
            NSLog(@"1");
            break;
        case 1:
            NSLog(@"2");
            break;
        default:
            break;
    }
    
}

- (void)handleRight {
    AddRecordViewController *addVC = [[AddRecordViewController alloc] init];
    addVC.hidesBottomBarWhenPushed = YES;
    addVC.recordType = self.foursquareSegmentedControl.selectedSegmentIndex;
    [self.navigationController pushViewController:addVC animated:YES];
}


@end
