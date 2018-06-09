//
//  NewAboutViewController.m
//  NewDeayou
//
//  Created by apple on 15/11/19.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "NewAboutViewController.h"

#import "DYMoreCell.h"
#import "DYAboutUsViewController.h"
#import "DYFrequentlyAskedQuestionsVC.h"
#import "DYSafeViewController.h"


@interface NewAboutViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *moreTableView;
@property (nonatomic, strong) NSArray     *imageArray;       //图标的数组
@property (nonatomic, strong) NSArray     *titleArray;       //标题的数组

@end

@implementation NewAboutViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"关于多多";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kMainBgColor;
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    self.moreTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-(IOS7 ? 0 :113)) style:UITableViewStylePlain];
    self.moreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.moreTableView.dataSource = self;
    self.moreTableView.delegate = self;
    [self.view addSubview:self.moreTableView];
    
    self.titleArray = @[@"多多简介",@"团队介绍",@"多多新闻",@"公司资信"];
    self.moreTableView.backgroundColor = kMoreBackgroundColor;
    // Do any additional setup after loading the view.
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView datasource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [(NSArray *)self.titleArray[section] count];
    return self.titleArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *inditifier = @"more";
    
    DYMoreCell *moreCell = [tableView dequeueReusableCellWithIdentifier:inditifier];
    if (moreCell == nil) {
        moreCell = [[DYMoreCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:inditifier];
    }
    moreCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    moreCell.textLabel.text = self.titleArray[indexPath.row];
    [moreCell hideTopImageView:indexPath.row != 0];
    
    [moreCell setSelectionStyle:UITableViewCellSelectionStyleNone]; //去掉点击后的阴影
    [tableView setSeparatorInset:UIEdgeInsetsMake(10, 15, 0, 0)];
    return moreCell;
    
}
#pragma mark - tableview delegate
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        

        DYAboutUsViewController *aboutUsVC = [[DYAboutUsViewController alloc]init];
        aboutUsVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }else if (indexPath.row == 1) {
//        DYSafeViewController *safeVC = [[DYSafeViewController alloc] initWithNibName:@"DYSafeViewController" bundle:nil];
//        safeVC.weburl = @"https://www.51duoduo.com/ddjs/jieshaotuandui.html";
//        safeVC.title = @"团队介绍";
//        [self.navigationController pushViewController:safeVC animated:YES];
        
        ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
        adVC.myUrls = @{@"url":@"https://www.51duoduo.com/ddjs/jieshaotuandui.html"};
        adVC.titleM =@"团队介绍";
        adVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adVC animated:YES];
        
    } else if (indexPath.row == 2) {
        DYFrequentlyAskedQuestionsVC * questionVC=[[DYFrequentlyAskedQuestionsVC alloc]initWithNibName:@"DYFrequentlyAskedQuestionsVC" bundle:nil];
        questionVC.hidesBottomBarWhenPushed=YES;
        questionVC.isNew=1;
        [self.navigationController pushViewController:questionVC animated:YES];
    }else if(indexPath.row == 3){
        
//        DYSafeViewController *safeVC = [[DYSafeViewController alloc] init];
//        safeVC.hidesBottomBarWhenPushed = YES;
//        safeVC.title = @"公司资信";
//        safeVC.weburl=@"https://www.51duoduo.com/lqbbz/gszz.html";
//        [self.navigationController pushViewController:safeVC animated:YES];
        
        ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
        adVC.myUrls = @{@"url":@"https://www.51duoduo.com/lqbbz/gszz.html"};
        adVC.titleM =@"公司资信";
        adVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adVC animated:YES];
    }
}

@end
