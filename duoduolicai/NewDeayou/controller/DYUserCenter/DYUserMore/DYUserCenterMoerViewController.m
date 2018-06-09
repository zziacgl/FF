//
//  DYUserCenterMoerViewController.m
//  NewDeayou
//
//  Created by diyou on 14-7-10.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYUserCenterMoerViewController.h"
#import "DYFrequentlyAskedQuestionsVC.h"
#import "DYAppDelegate.h"

@interface DYUserCenterMoerViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    NSArray * aryCount;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DYUserCenterMoerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView
{
    
    [super loadView];
    
    self.title=@"更多";
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    aryCount=@[@"常见问题",@"版本检测",@"退出当前用户"];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidAfterLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect bounds = self.view.bounds;
    bounds.size.height=kScreenSize.height-20-44;
    _tableView.frame = bounds;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return aryCount.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *mark=@"markContent";
    
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:mark];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
        
    }
    NSString * title =aryCount[indexPath.row];
    cell.textLabel.text=title;
    if ([title isEqualToString:@"版本检测"])
    {
        
        //获取当前本版本号
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
        lab.backgroundColor=[UIColor clearColor];
        lab.textColor=kCOLOR_R_G_B_A(147, 147, 147, 1);
        lab.font=[UIFont systemFontOfSize:14];
        lab.text=[NSString stringWithFormat:@"当前版本号v%@",app_Version];
        cell.accessoryView=lab;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    }    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * title =aryCount[indexPath.row];
    
    if ([title isEqualToString:@"常见问题"])
    {
        DYFrequentlyAskedQuestionsVC * questionVC=[[DYFrequentlyAskedQuestionsVC alloc]initWithNibName:@"DYFrequentlyAskedQuestionsVC" bundle:nil];
        questionVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:questionVC animated:YES];
    }
//    else if ([title isEqualToString:@"手机宝令"])
//    {
//        DYPhoneCommandVC * phoneCommandVC = [[DYPhoneCommandVC alloc]initWithNibName:@"DYPhoneCommandVC" bundle:nil];
//        phoneCommandVC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:phoneCommandVC animated:YES];
//    }
    else if ([title isEqualToString:@"版本检测"])
    {
        DYAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
        [appDelegate UpdateProjectAuto:NO];
    }
    else if ([title isEqualToString:@"退出当前用户"])
    {
        
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"确定注销当前用户？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alertView.delegate=self;
        alertView.tag=853;
        [alertView show];
    }
    
}

#pragma mark- alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==853)
    {
        if (buttonIndex==1)
        {
            //注销登录
            [DYUser loginCancelLogin];
        }
    }
}
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

@end
