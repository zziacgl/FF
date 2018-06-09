//
//  DDHomeMessageViewController.m
//  NewDeayou
//
//  Created by Tony on 2016/12/5.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDHomeMessageViewController.h"
#import "DDNoticeViewController.h"
#import "DDMailMessageViewController.h"
#import "CardViewController.h"
@interface DDHomeMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property (nonatomic, copy) NSString *messageCount;
@property (nonatomic, strong) UIView *reView;
@end
static NSString*cellID = @"cellDD";
@implementation DDHomeMessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"消息中心";
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
     self.view.backgroundColor = kBackgroundColor;
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 15, kMainScreenWidth, kMainScreenHeight-64-15) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=44;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
    

}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [HeXColor colorWithHexString:@"#333333"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        
    
        UIImageView*ima = [[UIImageView alloc]initWithFrame:CGRectMake(10, (cell.contentView.mj_h - 30)/2, 30, 30)];
        [cell.contentView addSubview:ima];
        ima.image = [UIImage imageNamed:@"消息中心_系统公告"];
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ima.frame)+10, (cell.contentView.mj_h - 30)/2, 100, 30)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [HeXColor colorWithHexString:@"333333"];
        [cell.contentView addSubview:label];
            label.text = @"系统公告";
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.row == 1){
        
        
        UIImageView*ima = [[UIImageView alloc]initWithFrame:CGRectMake(10, (cell.contentView.mj_h - 30)/2, 30, 30)];
        [cell.contentView addSubview:ima];
        ima.image = [UIImage imageNamed:@"消息中心_个人消息"];
       
        
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ima.frame)+10, (cell.contentView.mj_h - 30)/2, 100, 30)];
        label.textColor = [HeXColor colorWithHexString:@"333333"];
        label.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label];
        label.text = @"个人消息";
        self.reView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, 8, 8)];
        _reView.backgroundColor = kMainColor;
        _reView.layer.cornerRadius = 4;
        _reView.alpha = 0;
        _reView.layer.masksToBounds = YES;
        [label addSubview:self.reView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(8, 43, kMainScreenWidth-8, 1)];
    lineView.backgroundColor = kBackgroundColor;
    [cell.contentView addSubview:lineView];
    if (indexPath.row == 1 ) {
        lineView.hidden = YES;
    }else{
        lineView.hidden = false;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15 weight:0.1];
    return cell;
}

- (void)getData {
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"index" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"app" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    if([DYUser loginIsLogin]){
    
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    }
    
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess == YES) {
            
//            NSLog(@"报告%@", object);
            NSDictionary *dic = object;
            NSString *str = [NSString stringWithFormat:@"%@", [dic objectForKey:@"no_read_message"]];
            if ([str isEqualToString:@"1"]) {
                self.reView.alpha = 1;
            }else {
                self.reView.alpha = 0;
            }
            [self.tableView reloadData];
        }else {
            [LeafNotification showInController:self withText:errorMessage];
        }
        
        
    } fail:^{
        [LeafNotification showInController:self withText:@"网络异常"];
        
    }];

    
//    NSString *urlStr = [NSString stringWithFormat:@"https://www.51duoduo.com/mobile.php?overtime&q=interface&type=interface1&login_key=%@",[DYUser GetLoginKey]];
//    NSLog(@"%@", urlStr);
//    NSString *newURLStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:newURLStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    NSLog(@"运营%@", dic);
//    NSString *str = [NSString stringWithFormat:@"%@", [dic objectForKey:@"no_read_message"]];
//    
//    if ([str isEqualToString:@"1"]) {
//        self.alphaStr = @"1";
//    }else {
//        self.alphaStr = @"0";
//    }
 }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
//        CardViewController *nvc = [[CardViewController alloc]initWithNibName:@"CardViewController" bundle:nil];
//        [self.navigationController pushViewController:nvc animated:YES];
        DDNoticeViewController *VC = [[DDNoticeViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 1) {
        
        
        if(![DYUser loginIsLogin]){
            [DYUser  loginShowLoginView];
        }else {
            //已经登录跳转活动详情界面
            DDMailMessageViewController *mailVC = [[DDMailMessageViewController alloc] initWithNibName:@"DDMailMessageViewController" bundle:nil];
            
            [self.navigationController pushViewController:mailVC animated:YES];
            
        }
    }
}
@end
