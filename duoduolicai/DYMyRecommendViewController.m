//
//  DYMyRecommendViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/10/7.
//  Copyright © 2015年 wayne. All rights reserved.
//

#import "DYMyRecommendViewController.h"
#import "DYHeadTableViewCell.h"
#import "DYContentTableViewCell.h"
#import "DYContentTableViewCell.h"
#import "DYExChangeViewController.h"
#import "PullingRefreshTableView.h"
#import "DYMessageCenterViewController.h"
#import "DYHelpCenterViewController.h"
#import "DYClassViewController.h"

#import "JSON.h"
#import "DYAppDelegate.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialScreenShoter.h"

#import "DYTeamListTableViewCell.h"



@interface DYMyRecommendViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UMSocialShakeDelegate>
{
    UINib *nibHead;//复用cell的nib
    UINib *nibContent;
    
    NSArray *aryCellData;//标记cell的个数和高度


    UIView * BlackView;
    UITableView * table;
    NSDictionary * dataDict;
    BOOL ShowRedDot;
    
    NSString *shareURL;
    NSString *shareText;
    UIImage *shareImage;
    NSArray *snsNames;
}
@property(nonatomic,strong) PullingRefreshTableView *tableView;//tableview
@property (nonatomic, strong) UITableView *teamListTableView;
@property (nonatomic, strong) UIView *underLine;

@end
static int isRefresh2=1;
@implementation DYMyRecommendViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"推荐";
    }
    return self;
}


-(void)loadView{
    [super loadView];
    
    //导航右边的按钮
    UIButton * btnRightItem=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor=[UIColor clearColor];
    btnRightItem.frame=CGRectMake(0, 0, 100.0f, 60.0f);
    [btnRightItem setTitle:@"刷新" forState:UIControlStateNormal];
    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    [btnRightItem addTarget:self action:@selector(refreshInformation) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    
    CGSize btnImageSize = CGSizeMake(44, 44);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    //设置下拉刷新tableview
    // 上拉，下拉，tableView
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain topTextColor:[UIColor whiteColor] topBackgroundColor:nil bottomTextColor:[UIColor blackColor] bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor]; // 背景颜色
    _tableView.headerOnly = YES;
    _tableView.pullingDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.headerView.backgroundColor=kMainColor2; // 头颜色
    _tableView.footerView.backgroundColor=[UIColor whiteColor]; // 脚颜色
    _tableView.hidden=YES;
   
    
    //设置cell的个数和高度
    aryCellData = @[@"130",@"414"];
    
    
    
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)refreshInformation{
    [self.tableView launchRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect bounds = self.view.bounds;
    bounds.size.height = kScreenSize.height - 64;
    bounds.size.width = [UIScreen mainScreen].bounds.size.width;
    NSLog(@"%f", bounds.size.width);
    _tableView.frame = bounds;
    
    if (![DYUser loginIsLogin])
    {
        //未登录
        //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"用户未登录" delegate:self cancelButtonTitle:@"去登录" otherButtonTitles:nil];
        //        [alert show];
        [self firstpressed];
    }

}
- (void)firstpressed
{
    [DYUser  loginShowLoginView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *isRefreshAcount=[NSString stringWithFormat:@"%@",[ud objectForKey:@"isRefreshTuiJian"]];
    if ([isRefreshAcount isEqualToString:@"1"]) {
        isRefresh2=1;
        [ud setObject:@"0" forKey:@"isRefreshTuiJian"];
    }
    //初始化tableView
//    if (isRefresh2==1) {
//        [_tableView launchRefreshing];// 实现自身的刷新
//        isRefresh2=2;
//        
//    }
     [_tableView launchRefreshing];// 实现自身的刷新
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewDidAfterLoad];//视图在加载完之后出现
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getShareData {
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"share" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_share_info" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"recommend" forKey:@"name" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
             
             NSLog(@"dddd%@",object);
//             NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//             NSString *str = [NSString stringWithFormat:@"%@",[user objectForKey:@"UserName"]];
//             shareURL=[NSString stringWithFormat:@"http://www.51duoduo.com/mobile.php?user&q=reg&tuijian_phone=%@",str];
//             shareText=[NSString stringWithFormat: @"每推荐用户投资可获3.5%%推荐奖励，50元起投，平均13%%以上年化收益，银行资金实时监管，中国人保全额承保！。http://www.51duoduo.com/mobile.php?user&q=reg&tuijian_phone=%@",str];
//             shareImage = [UIImage imageNamed:@"appicon_share"];
             shareURL=[object objectForKey:@"url"];
             shareText = [object objectForKey:@"content"];
             shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[object objectForKey:@"image"]]]];;//分享内嵌图片
             snsNames=@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToEmail,UMShareToSms];
             
             //设置微信AppId，设置分享url，默认使用友盟的网址
             [UMSocialWechatHandler setWXAppId:WXAppKey appSecret:WXAppSecret url:shareURL];
             //设置分享到QQ空间的应用Id，和分享url 链接
             [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:shareURL];

             
             
             
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return aryCellData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [aryCellData[indexPath.row] floatValue];//cell的高度
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        NSString *markReuse = @"markHead";
        if (!nibHead) {
            nibHead = [UINib nibWithNibName:@"DYHeadTableViewCell" bundle:nil];
            [tableView registerNib:nibHead forCellReuseIdentifier:markReuse];
          }
        DYHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markReuse];
        if (dataDict!=nil) {
            cell.TotalM.text=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"total"]];
            cell.selectionStyle = UITableViewCellAccessoryNone;
        }
        return cell;

    }else{
        NSString *markReuse = @"markContent";
        if (!nibContent) {
            nibContent = [UINib nibWithNibName:@"DYContentTableViewCell" bundle:nil];
            [tableView registerNib:nibContent forCellReuseIdentifier:markReuse];
        }
        DYContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markReuse];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.myListView.backgroundColor = [UIColor orangeColor];
        cell.tag = 200;
        self.teamListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, cell.myListView.frame.size.height) style:UITableViewStylePlain];
        [cell.myListView addSubview:self.teamListTableView];
        [self.teamListTableView registerClass:[DYTeamListTableViewCell class] forCellReuseIdentifier:@"aa"];
        if (dataDict!=nil) {
            cell.Balance_DuoMi.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"balance"]];
            cell.Used_DuoMi.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"exchanged"]];
            NSLog(@"%@",[dataDict objectForKey:@"tuijian_one"]);
            cell.ATotal.text=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"tuijian_one"]];
            
            cell.BTotal.text=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"tuijian_two"]];
            cell.CTotal.text=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"tuijian_three"]];
            [cell.AClassBtn addTarget:self action:@selector(showAClass:) forControlEvents:UIControlEventTouchUpInside];
            self.underLine = [[UIView alloc] initWithFrame:CGRectMake(cell.AClassBtn.frame.origin.x, CGRectGetMaxY(cell.AClassBtn.frame) + cell.AClassBtn.frame.size.height, CGRectGetWidth(cell.AClassBtn.frame), 1)];
            _underLine.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
            [cell addSubview:self.underLine];
            [cell.BClassBtn addTarget:self action:@selector(showBClass:) forControlEvents:UIControlEventTouchUpInside];
            [cell.CClassBtn addTarget:self action:@selector(showCClass:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.RecommendFriendBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
            [cell.HelperCenterBtn addTarget:self action:@selector(showHelpCenter) forControlEvents:UIControlEventTouchUpInside];
            [cell.MessageCenterBtn addTarget:self action:@selector(MessageCenter) forControlEvents:UIControlEventTouchUpInside];
            [cell.exchangeBtn addTarget:self action:@selector(Exchange) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
}
-(void)showAClass:(UIButton *) sender{
    [UIView animateWithDuration:1 animations:^{
        DYContentTableViewCell *cell = [self.view viewWithTag:200];
        [self.underLine removeFromSuperview];
        self.underLine.frame = CGRectMake(sender.frame.origin.x, self.underLine.frame.origin.y, CGRectGetWidth(self.underLine.frame), CGRectGetHeight(self.underLine.frame));
        self.underLine.backgroundColor = [UIColor grayColor];
        [cell addSubview:self.underLine];
    } completion:^(BOOL finished) {
        
    }];

//    DYClassViewController *classVC=[[DYClassViewController alloc] initWithNibName:@"DYClassViewController" bundle:nil];
//    classVC.hidesBottomBarWhenPushed=YES;
//    classVC.GroupClass=1;
//    [self.navigationController pushViewController:classVC animated:YES];
}
-(void)showBClass:(UIButton *) sender{
    [UIView animateWithDuration:1 animations:^{
        DYContentTableViewCell *cell = [self.view viewWithTag:200];
        [self.underLine removeFromSuperview];
        self.underLine.frame = CGRectMake(sender.frame.origin.x, self.underLine.frame.origin.y, CGRectGetWidth(self.underLine.frame), CGRectGetHeight(self.underLine.frame));
        self.underLine.backgroundColor = [UIColor grayColor];
        [cell addSubview:self.underLine];
    } completion:^(BOOL finished) {
        
    }];

//    DYClassViewController *classVC=[[DYClassViewController alloc] initWithNibName:@"DYClassViewController" bundle:nil];
//    classVC.hidesBottomBarWhenPushed=YES;
//    classVC.GroupClass=2;
//    [self.navigationController pushViewController:classVC animated:YES];
}
-(void)showCClass:(UIButton *) sender{
    [UIView animateWithDuration:1 animations:^{
        DYContentTableViewCell *cell = [self.view viewWithTag:200];
        [self.underLine removeFromSuperview];
        self.underLine.frame = CGRectMake(sender.frame.origin.x, self.underLine.frame.origin.y, CGRectGetWidth(self.underLine.frame), CGRectGetHeight(self.underLine.frame));
        self.underLine.backgroundColor = [UIColor grayColor];
        [cell addSubview:self.underLine];
    } completion:^(BOOL finished) {
        
    }];


//    DYClassViewController *classVC=[[DYClassViewController alloc] initWithNibName:@"DYClassViewController" bundle:nil];
//    classVC.hidesBottomBarWhenPushed=YES;
//    classVC.GroupClass=3;
//    [self.navigationController pushViewController:classVC animated:YES];
}
-(void)MessageCenter{
    DYMessageCenterViewController *messagecenterVC=[[DYMessageCenterViewController alloc]initWithNibName:@"DYMessageCenterViewController" bundle:nil];
    messagecenterVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:messagecenterVC animated:YES];
}
-(void)showHelpCenter{
    DYHelpCenterViewController *helpcenterVC=[[DYHelpCenterViewController alloc]initWithNibName:@"DYHelpCenterViewController" bundle:nil];
    helpcenterVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:helpcenterVC animated:YES];
}
-(void)Exchange{
    
    DYExChangeViewController *exchangeVC=[[DYExChangeViewController alloc]initWithNibName:@"DYExChangeViewController" bundle:nil];
    exchangeVC.hidesBottomBarWhenPushed=YES;
    exchangeVC.Balance_DuoMiAmount=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"balance"]];
    [self.navigationController pushViewController:exchangeVC animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //去掉点击后的阴影

}
#pragma mark- scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView tableViewDidScroll:scrollView];
//    [self performSelector:@selector(testFrefreshTableView) withObject:nil afterDelay:2];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_tableView tableViewDidEndDragging:scrollView];
}

#pragma mark ------PullTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
//    [self queryDataIsRefresh:YES];
    [self performSelector:@selector(testFrefreshTableView) withObject:nil afterDelay:0];
}
-(void)testFrefreshTableView
{
    //————————————————————————我的主页->实时财务——————————————————————————
    [MBProgressHUD hudWithView:self.view label:@"数据请求中"];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_duomi" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (success==YES) {
             //可用信用额度数据填充
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             dataDict=object;
             NSLog(@"%@,%@",dataDict,object);
             if (dataDict!=nil) {
                 [_tableView reloadData];
             }
             
             
         }
         else
         {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         if (_tableView.headerView.isLoading)
         {
             [_tableView tableViewDidFinishedLoading];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
    [self.view addSubview:_tableView];
    
    
    if (_tableView.headerView.isLoading)
    {
        [_tableView tableViewDidFinishedLoading];
        _tableView.hidden=NO;
    }
    
}

#pragma share

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"didClose is %d",fromViewControllerType);
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
//摇一摇的回调
-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    NSLog(@"finish share with response is %@",response);
}

-(void)showShareView{
   
//    //可以设置响应摇一摇阈值，数值越低越灵敏，默认是0.8
//    [UMSocialShakeService setShakeThreshold:1.5];
//    
//    //下面设置delegate为self，执行摇一摇成功的回调，不执行回调可以设为nil
//    [UMSocialShakeService setShakeToShareWithTypes:nil
//                                         shareText:shareText
//                                      screenShoter:[UMSocialScreenShoterDefault screenShoter]
//                                  inViewController:self
//                                          delegate:self];
    

//    NSString *shareText = @"首次投资200即送10元，50元起投，平均10%以上年化收益，银行资金实时监管，中国人保全额承保！。";             //分享内嵌文字
    
    
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:snsNames
                                       delegate:self];

   }


@end
