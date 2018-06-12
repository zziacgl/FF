//
//  ShellOverViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/7.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "ShellOverViewController.h"
#import "ShellOverViewCell.h"
#import "TrendViewController.h"
#import "StatisticalViewController.h"
#import "AddGoodsViewController.h"
@interface ShellOverViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleAry;
@property (nonatomic, strong) NSArray *imageAry;
@end
static NSString *inentifier = @"footcell";

@implementation ShellOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpOverView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)setUpOverView {
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth / 74 * 42)];
    _topImageView.image = [UIImage imageNamed:@"overtop"];
    _topImageView.backgroundColor = kMainColor;
    [self.view addSubview:self.topImageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kMainScreenWidth, self.navigationController.navigationBar.frame.size.height)];
    titleLabel.text = @"总览";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [self.topImageView addSubview:titleLabel];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topImageView.frame), kMainScreenWidth, kMainScreenHeight - CGRectGetHeight(self.topImageView.frame)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    //    self.mineTableView.contentInset = UIEdgeInsetsMake(-1000, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"ShellOverViewCell" bundle:nil] forCellReuseIdentifier:inentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor clearColor]];
    
    
}

-(NSArray *)titleAry {
    if (!_titleAry) {
        self.titleAry = @[@"趋势", @"进货统计", @"增加商品", @"用户统计信息"];
    }
    
    return _titleAry;
}
- (NSArray *)imageAry {
    if (!_imageAry) {
        self.imageAry = @[@"qushi", @"jinhuo", @"shangpin", @"overuser"];
    }
    return _imageAry;
    
}
#pragma mark -- UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        return 260;
    }else {
        return 55;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        ShellOverViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        return cell;
    }else {
        static NSString *inditifier = @"mine";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inditifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:inditifier];
        }
        [tableView setSeparatorInset:UIEdgeInsetsMake(10, 15, 0, 10)];
        cell.textLabel.text = self.titleAry[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:self.imageAry[indexPath.row]];
        cell.textLabel.textColor = kCOLOR_R_G_B_A(224, 72, 22, 1);
        if (indexPath.row == 2) {
            cell.detailTextLabel.text = @"点击右上角“+”添加商品";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            TrendViewController *trendVC = [[TrendViewController alloc] init];
            trendVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:trendVC animated:YES];
        }
            
            break;
        case 1:{
            UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"该功能暂未开放，敬请期待" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK Action");
            }];
            
            [alerVC addAction:okAction];

            [self presentViewController:alerVC animated:YES completion:nil];
        }
            break;
        case 2:{
            AddGoodsViewController *addVC = [[AddGoodsViewController alloc] init];
            addVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addVC animated:YES];
        }
            
            break;
        case 3:{
            StatisticalViewController *statistVC = [[StatisticalViewController alloc] init];
            statistVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:statistVC animated:YES];
        }
        
            break;
        default:
            break;
    }
    
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
