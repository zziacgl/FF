//
//  FFCanUseCardViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/1/17.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "FFCanUseCardViewController.h"
#import "FFRedPacketTableViewCell.h"
@interface FFCanUseCardViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end
static NSString *identifer = @"FFRedPacketTableViewCell";

@implementation FFCanUseCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackColor;
    self.title = @"我的红包";
    NSLog(@"我的卡券%@", self.dataAry);
    [self layLoutTableView];
    
    UIButton * btnRightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.frame = CGRectMake(0, 0, 60, 20);
//    btnRightItem.titleLabel.textColor = [UIColor orangeColor];
    [btnRightItem setTitle:@"不使用" forState:UIControlStateNormal];
    [btnRightItem setTitleColor:kMainColor forState:UIControlStateNormal];
    btnRightItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnRightItem addTarget:self action:@selector(handleQuestion) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    // Do any additional setup after loading the view.
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)text:(newBlock)block
{
    self.block = block;
}
#pragma mark -- 卡券不用
- (void)handleQuestion {
    
    if (self.block != nil) {
        self.block(nil);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)layLoutTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"FFRedPacketTableViewCell" bundle:nil] forCellReuseIdentifier:identifer];
    
}
#pragma mark --- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFRedPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    FFRedPacketmodel *model = self.dataAry[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.block != nil) {
        FFRedPacketmodel *model = self.dataAry[indexPath.row];
        self.block(model);
        [self.navigationController popViewControllerAnimated:YES];
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
