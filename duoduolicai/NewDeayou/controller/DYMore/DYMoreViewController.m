//
//  DYMoreViewController.m
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/11.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYMoreViewController.h"
#import "DYMoreCell.h"
#import "DYMoreFootView.h"
#import "DYFrequentlyAskedQuestionsVC.h"
#import "DYAboutUsViewController.h"
#import "DYFeedbackViewController.h"
#import "DYSafeViewController.h"
#import "DDSystemInfoViewController.h"

#import "NewAboutViewController.h"
#import "DDServiceCenterViewController.h"
#import "SZKCleanCache.h"

@interface DYMoreViewController ()<UITableViewDelegate, UITableViewDataSource, UITableViewDataSource>
{
    NSString *shareURL;
    NSString *shareTitle;
    NSString *shareText;
    UIImage *shareImage;
    NSArray *snsNames;
}
@property (nonatomic, strong) UITableView *moreTableView;
@property (nonatomic, strong) NSArray     *imageArray;       //图标的数组
@property (nonatomic, strong) NSArray     *titleArray;       //标题的数组
@property (nonatomic, strong) NSArray     *typeArray;        //类型的数组
@property (nonatomic, strong) UIImageView *backImage;
@end

@implementation DYMoreViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"更多";
    }
    return self;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        self.titleArray = @[@[@"服务中心"],  @[@"系统检测"]];
    }
    return _titleArray;
    
}
- (NSArray *)imageArray {
    if (!_imageArray) {
        self.imageArray = @[@[@"service"],  @[@"system check"]];
    }
    return _imageArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = kBackColor;

    self.moreTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - 64) style:UITableViewStylePlain];
    self.moreTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.moreTableView.dataSource = self;
    self.moreTableView.delegate = self;
    self.moreTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.moreTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.moreTableView setTableFooterView:v];
    
//    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor clearColor]];
    
    

    
}


-(void)GetShareData{
    //获取分享标题和内容
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"share" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_share_info" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"lqb_share" forKey:@"name" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
             NSDictionary *dic=object;
//             NSLog(@"%@",dic);
             shareTitle = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
             shareText = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
             
             NSString *fileURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
             NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
             shareImage = [UIImage imageWithData:data];
             
             shareURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
             
           
         }
         else
         {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
}

#pragma mark - tableView datasource
#pragma mark
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }else {
        
        return 10;
    }
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kBackColor;
    return view;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else {
        return 1;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *inditifier = @"more";
    
    UITableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:inditifier];
    if (moreCell == nil) {
        moreCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:inditifier];
    }
    moreCell.textLabel.textColor = [UIColor darkGrayColor];
    moreCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    moreCell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    moreCell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.section][indexPath.row]];
    [tableView setSeparatorInset:UIEdgeInsetsMake(10, 15, 0, 0)];
    
    return moreCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   if (indexPath.section == 0 && indexPath.row == 0) {
       
        DDServiceCenterViewController *serviceCenterVC = [[DDServiceCenterViewController alloc]init];
        serviceCenterVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:serviceCenterVC animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        
        

        
        ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
        adVC.myUrls = @{@"url":@"https://www.51duoduo.com/lqbbz/gszz.html"};
        adVC.titleM =@"公司资信";
        adVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adVC animated:YES];

    }else if (indexPath.section == 1 && indexPath.row == 0) {
        DDSystemInfoViewController *systeminfoVC = [[DDSystemInfoViewController alloc]init];
        systeminfoVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:systeminfoVC animated:YES];
        
//        [self showShareView];
    }else if(indexPath.section == 2 && indexPath.row == 0){
        
        DDSystemInfoViewController *systeminfoVC = [[DDSystemInfoViewController alloc]init];
        systeminfoVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:systeminfoVC animated:YES];
    }    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showShareView{
  


}
@end
