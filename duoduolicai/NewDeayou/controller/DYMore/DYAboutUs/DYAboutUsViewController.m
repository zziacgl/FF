//
//  DYAboutUsViewController.m
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/13.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYAboutUsViewController.h"
#import "DYMoreCell.h"
#import "DYDetailQuestionVC.h"


#define kCopyrightFont [UIFont systemFontOfSize:10]
#define kPhoneNumber         kefu_phone_title
#define kHomeUrl             @"www.51duoduo.com"
#define kAlertPhoneTag       101
#define kAlertPhone2Tag       103
#define kAlertUrlTag         102

//客服的电话
#define CUSTOMER_SERVICE_PHONE [NSURL URLWithString:kefu_phone]


@interface DYAboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *dicInfo;
}

@property (nonatomic,strong) NSArray     *imageArray;       //图标的数组
@property (nonatomic,strong) NSArray     *titleArray;       //标
@property (nonatomic,strong) UITableView *tableView;
@end


@implementation DYAboutUsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"丰丰简介";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self viewDidAfterLoad];
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    //表头
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    //
    //    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenSize.width-242)/2, 20, 242, 100)];
    //    logoImageView.image = [UIImage imageNamed:@"lolo.png"];
    //    [headView addSubview:logoImageView];
    
    
    
    UILabel *introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenSize.width-40, 200)];
    introduceLabel.backgroundColor = [UIColor clearColor];
    introduceLabel.font=[UIFont fontWithName:@"STXinwei" size:4];
    introduceLabel.text = @"   多多理财是浙江多多互联网金融信息服务有限公司旗下一家互联网金融服务平台，成立于2015年，在全国设有数十家汽车金融营业部，是旨在为有融资、投资需求的小微企业主或个人建立起高效、透明、安全、便捷的互联网金融服务的互联网金融信息服务平台。并在同年获得了兴乐集团参股（兴乐集团，上市公司恒天海龙的最大持股方）天使轮投资。\n    多多理财CEO屠清阳（屠甫）和核心管理团队均来自于全国知名的第三方支付平台、银行、投资和风险管理机构，凭借团队及合作伙伴在互联网及金融领域的权威性和丰富经验积累，以安全理财为核心，打造互联网金融产业链，实现“普惠金融”及“互联网+”的战略创新，为广大企业与个人提供安全、专业、高效的理财产品服务及投融资顾问服务，运用金融大数据分析，旨在打造一个为借款人与投资人同时提供安全便捷的资金对接信息平台。\n    面向未来，多多理财将继续利用大数据风控技术，挑战传统金融运营模式，在推动实现“普惠 金融”及“互联网+”的发展道路上坚定前行！";
    introduceLabel.textColor = [UIColor colorWithRed:109 /255.0 green:109/ 255.0 blue:109 / 255.0 alpha:1];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:introduceLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [introduceLabel.text length])];
    introduceLabel.attributedText = attributedString;
    introduceLabel.numberOfLines = 0;
    introduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    
    //设置字体
    introduceLabel.font = font;
    CGSize constraint = CGSizeMake(kScreenSize.width-40, 20000.0f);
    CGSize size = [introduceLabel.text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    introduceLabel.frame = CGRectMake(20, 20, size.width, size.height+200);
    [headView addSubview:introduceLabel];
    headView.frame = CGRectMake(0, 0, kScreenSize.width, CGRectGetMaxY(introduceLabel.frame));
    
    
    //表底部
    UIView  *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 150)];
    UILabel *copyrightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80,kScreenSize.width, 30)];
    copyrightLabel.backgroundColor = [UIColor clearColor];
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.font = [UIFont systemFontOfSize:7];
    copyrightLabel.text = @"Copyright © 2013-2015 Zhejiang Duoduo Investment Management Co., Ltd.";
    [footView addSubview:copyrightLabel];
    
    UILabel *accessoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenSize.width, 30)];
    accessoryLabel.textAlignment =NSTextAlignmentCenter;
    accessoryLabel.textColor = [UIColor grayColor];
    accessoryLabel.backgroundColor = [UIColor clearColor];
    accessoryLabel.text = [NSString stringWithFormat:@"版本号：v%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];//当前版本号kCurrentVersion
    [footView addSubview:accessoryLabel];
    
    //表格
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenSize.width, kScreenSize.height-44) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = headView;
    self.tableView.tableFooterView = footView;
    [self.view addSubview:self.tableView];
    
    self.imageArray = @[@"about_icon_1.png",@"about_icon_2.png"];
    
    self.titleArray = @[[NSString stringWithFormat:@"客服热线1：%@",kPhoneNumber],[NSString stringWithFormat:@"网站：%@",kHomeUrl]];
    self.tableView.backgroundColor = kCOLOR_R_G_B_A(246, 246, 246, 1);
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor clearColor]];
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)statRequst{
//    [MBProgressHUD hudWithView:self.view label:@"加载中..."];
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    //    [diyouDic insertObject:self.actionId forKey:@"id" atIndex:0];
    //    [diyouDic insertObject:[NSString stringWithFormat:@"%d" forKey:@"user_id" atIndex:0]
    //    [NSString stringWithFormat:@"%d",[DYUser GetUserID]]
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"content" forKey:@"q" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess) {
            
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //            [self.contentView loadHTMLString:[[object DYObjectForKey:@"content"]DYObjectForKey:@"content"] baseURL:nil];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [LeafNotification showInController:self withText:errorMessage];
        }
    } errorBlock:^(id error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"网络异常"];
    }];
}

#pragma mark - tableView datasource
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *inditifier = @"more";
    DYMoreCell *moreCell = [tableView dequeueReusableCellWithIdentifier:inditifier];
    if (moreCell == nil) {
        moreCell = [[DYMoreCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:inditifier];
    }
    
    
    UIImageView *accessoryView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 17)];
    accessoryView.image = [UIImage imageNamed:@"icon_into.png"];
    moreCell.accessoryView = accessoryView;
    moreCell.textLabel.adjustsFontSizeToFitWidth = YES;
    moreCell.textLabel.text = self.titleArray[indexPath.row];
    moreCell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    [moreCell hideTopImageView:indexPath.row != 0];
    
    return moreCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if ( [[UIApplication sharedApplication]canOpenURL:CUSTOMER_SERVICE_PHONE])
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否拨打客服热线" message:kPhoneNumber delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
            alertView.tag = kAlertPhoneTag;
            [alertView show];
        }
        else
        {
            [LeafNotification showInController:self withText:@"设备不支持打电话"];
        }
    }else{
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否打开官网" message:kHomeUrl delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开", nil];
            [alertView show];
        }
    }
    
}

#pragma mark - UIAlertViewDelegate
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        if (alertView.tag == kAlertPhoneTag) {
            [[UIApplication sharedApplication]openURL:CUSTOMER_SERVICE_PHONE];
        }else if(alertView.tag == kAlertPhone2Tag){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:kefu_phone2]];
        }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",kHomeUrl]]];
        }

    }
    
    
}
-(void)getData
{
    //————————————————————————个人中心->更多->常见问题接口——————————————————————————
    
//    [MBProgressHUD hudWithView:self.view label:@"数据加载中..."];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"articles" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"status" atIndex:0];
    [diyouDic insertObject:@"order_asc" forKey:@"order" atIndex:0];
    [diyouDic insertObject:@"25" forKey:@"type_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (success==YES) {
             //可用信用额度数据填充
             
             if ([[object objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                 
                 NSArray *aryQuestions=[object objectForKey:@"list"];
//                 NSLog(@"%@",aryQuestions);
                 for (NSDictionary *dic in aryQuestions) {
                     NSString *name=[dic objectForKey:@"name"];
                     if ([name isEqualToString:@"关于多多"]) {
                         dicInfo=dic;
                         
                     }
                 }
                 [_tableView reloadData];
                 
             }
             
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
