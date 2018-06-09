//
//  DDInformManageViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 2017/11/30.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDInformManageViewController.h"
#import "DDInformManageTableViewCell.h"

@interface DDInformManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UINib *nibHead;//复用cell的nib
}
@property(nonatomic,strong) UITableView *tableView;     //tableview
@end

@implementation DDInformManageViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"推送通知";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    //        NSLog(@"%f", [UIScreen mainScreen].bounds.size.height);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=[UIColor clearColor];
    //        _tableView.scrollEnabled=NO;
    _tableView.showsVerticalScrollIndicator = false;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView datasource
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;//cell的高度
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *markReuse = @"markInform";
    if (!nibHead) {
        nibHead = [UINib nibWithNibName:@"DDInformManageTableViewCell" bundle:nil];
        [tableView registerNib:nibHead forCellReuseIdentifier:markReuse];
    }
    DDInformManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markReuse];
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            NSLog(@"推送关闭");
        }else{
            NSLog(@"推送打开");
            cell.informManage.text=@"您已开启丰丰金融最新活动消息，用户通知功能";
            cell.informStadusTitle.text=@"已开启";
            cell.SettingBtn.enabled=NO;
        }
    }else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            NSLog(@"推送关闭");
        }else{
            NSLog(@"推送打开");
            cell.informManage.text=@"您已开启丰丰金融最新活动消息，用户通知功能";
            cell.informStadusTitle.text=@"已开启";
            cell.SettingBtn.enabled=NO;
        }
    } 
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
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
