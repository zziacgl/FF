//
//  ActicityViewController.m
//  NewDeayou
//
//  Created by apple on 15/11/18.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "ActicityViewController.h"
#import "DYNetWork.h"
#import "ActivityDetailViewController.h"
#import "PullingRefreshTableView.h"
#import "UIImageView+WebCache.h"
#import "DDActivityAreaTableViewCell.h"
#import "NoDataView.h"

#define kScreen_Width   [UIScreen mainScreen].bounds.size.width
#define kScreen_Height  [UIScreen mainScreen].bounds.size.height
static NSString *identifier=@"acticity";

@interface ActicityViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    UINib * nibCell;
    int page;
    BOOL isViewDidLoad;
    UIView *backView;
    UIImageView *tanImageView;
    UIImageView *avartImage;
    UILabel *firstLabel;
    UILabel *secondLabel;
    UILabel *thirdLabel;
    UIButton *cancalBtn;
    NSTimeInterval timeUserValue;
    __block int timeout;
}
@property(nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)NSMutableArray *aryActvityImages;//活动中心
@property (nonatomic,strong)NSMutableArray *aryActivityUrls;//活动中心
@property (nonatomic,strong) NSMutableArray * urlArray;//图片urls
@property (nonatomic, strong) NSArray *allData;
@property(nonatomic,strong)PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UISegmentedControl *segment ;
@property (nonatomic, copy) NSString *isOver;
@property (nonatomic, strong) NoDataView *nodatabackView;

@end

@implementation ActicityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if(![DYUser loginIsLogin]){
        [self firstpressed];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)firstpressed
{
    [DYUser  loginShowLoginView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //初始化tableView
    if (isViewDidLoad)
    {
        //初始化tableView
        [_tableView launchRefreshing];
        isViewDidLoad=NO;
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isOver = @"0";
    
    self.title=@"活动中心";
    self.view.backgroundColor = kBackColor;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreen_Width - 30, kScreen_Height / 3);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    NSArray *titles = @[@"进行中",@"已结束"];
    self.segment = [[UISegmentedControl alloc] initWithItems:titles];
    _segment.frame = CGRectMake(kMainScreenWidth / 5, 10, kMainScreenWidth / 5 * 2, 30);
    _segment.tintColor = kBtnColor;
    _segment.selectedSegmentIndex = 0;
    
    _segment.backgroundColor = kMainColor;
    [self.segment addTarget:self action:@selector(handleSegment:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment;
    
    //设置下拉刷新tableview
    _tableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:kMainColor bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullingDelegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    nibCell = [UINib nibWithNibName:@"DDActivityAreaTableViewCell" bundle:nil];
    [_tableView registerNib:nibCell forCellReuseIdentifier:identifier];
    
    [self.view addSubview:_tableView];
    isViewDidLoad = YES;
    
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.nodatabackView = [[NoDataView alloc] initWithTitle:@"暂时没有活动" image:@"no_data"];
    self.nodatabackView.frame = self.tableView.bounds;
    self.nodatabackView.alpha = 0;
    [self.view addSubview:self.nodatabackView];
    
}
#pragma mark -- 分段控件
- (void)handleSegment:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;

    if (index == 0) {
        self.isOver = @"0";
        [self.tableView launchRefreshing];
    }else if (index == 1){
       self.isOver = @"1";
        [self.tableView launchRefreshing];
    }
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return (kMainScreenWidth - 20) / 160 *69 + 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DDActivityAreaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    if (self.dataArray.count > 0  ) {
        [cell setAttributeWithDictionary:self.dataArray[indexPath.row]];
        NSDictionary *dic = self.dataArray[indexPath.row];
        
        cell.tittleLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
        NSString *str = [NSString stringWithFormat:@"%@", [dic objectForKey:@"activity_status_name"]];
        cell.typeLabel.text = str;
        NSString *str1 = [NSString stringWithFormat:@"%@", [dic objectForKey:@"activity_status"]];
        if ([str1 isEqualToString:@"2"]) {
            cell.typeLabel.backgroundColor = [UIColor lightGrayColor];
            cell.userInteractionEnabled = YES;
            cell.coverView.alpha = 0.3;
        }else {
            cell.typeLabel.backgroundColor = kTextColor;
            cell.coverView.alpha = 0;
        }
        
//        [cell.activityIamge sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"icon"]]];
        [cell.activityIamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"ffbackImage"]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        double starttime = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"starttime"]] doubleValue];
        double endtime = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"endtime"]] doubleValue];
        if (starttime &&endtime) {
            cell.timeLabel.text=[NSString stringWithFormat:@"%@-%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:starttime]], [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endtime]]];
        }
        
        
        
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *str1 = [NSString stringWithFormat:@"%@", [dic objectForKey:@"activity_status"]];
    if ([str1 isEqualToString:@"0"]) {
        
        NSString *time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"rest_time"]];
        double resttime = [time doubleValue];
//        [LeafNotification showInController:self withText:@"网络异常"];
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.7;
        [self.tabBarController.view addSubview:backView];
        
        cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancalBtn.frame = CGRectMake(kMainScreenWidth / 7 * 6 - 30, kMainScreenHeight / 2 - 100 - 64, 30, 50);
        [cancalBtn setImage:[UIImage imageNamed:@"活动专区-倒计时活动_03"] forState:UIControlStateNormal];
        [cancalBtn addTarget:self action:@selector(handleCancal) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarController.view addSubview:cancalBtn];
        tanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 7, CGRectGetMaxY(cancalBtn.frame), kMainScreenWidth / 7 * 5, 0)];
        tanImageView.image = [UIImage imageNamed:@"活动专区-倒计时活动_03_03"];
        [self.tabBarController.view addSubview:tanImageView];
        [UIView animateWithDuration:0.5 animations:^{
            tanImageView.frame =CGRectMake(kMainScreenWidth / 7, CGRectGetMaxY(cancalBtn.frame), kMainScreenWidth / 7 * 5, 230);
        } completion:^(BOOL finished) {
            
            avartImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tanImageView.frame) / 2  - 35, 20, 70, 70)];
            avartImage.image = [UIImage imageNamed:@"活动专区-倒计时活动_07"];
            [tanImageView addSubview:avartImage];
            
            firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(avartImage.frame) + 20, CGRectGetWidth(tanImageView.frame) - 20, 20)];
            firstLabel.text = @"来的好早啊!想必是期待很久啦!";
            firstLabel.textColor = [UIColor whiteColor];
            firstLabel.font = [UIFont systemFontOfSize:14];
            firstLabel.textAlignment = NSTextAlignmentCenter;
            [tanImageView addSubview:firstLabel];
            
            secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(firstLabel.frame) + 15, CGRectGetWidth(tanImageView.frame) - 20, 20)];
            if (resttime > 0) {
                
                [self countDown:(int)resttime];
                
            }

//            secondLabel.text = @"离活动开始还有23:10:30";
            secondLabel.textColor = [UIColor whiteColor];
            secondLabel.textAlignment = NSTextAlignmentCenter;
            secondLabel.font = [UIFont systemFontOfSize:13];
            [tanImageView addSubview:secondLabel];
            
            thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(secondLabel.frame) + 5, CGRectGetWidth(tanImageView.frame) - 20, 20)];
            thirdLabel.text = @"准时来哦，我们不见不散！";
            thirdLabel.textColor = [UIColor whiteColor];
            thirdLabel.textAlignment = NSTextAlignmentCenter;
            thirdLabel.font = [UIFont systemFontOfSize:13];
            [tanImageView addSubview:thirdLabel];

            
            
        }];
        
        
        
        return;
    }
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = self.dataArray[indexPath.row];
//    NSLog(@"self.urlArray%@",adVC.myUrls);
    
    [self.navigationController pushViewController:adVC animated:YES];
    
    
}

- (void)handleCancal {
    avartImage.alpha = 0;
    firstLabel.alpha = 0;
    secondLabel.alpha = 0;
    thirdLabel.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        
        tanImageView.frame =CGRectMake(kMainScreenWidth / 7, CGRectGetMaxY(cancalBtn.frame), kMainScreenWidth / 7 * 5, 0);
    } completion:^(BOOL finished) {
        [cancalBtn removeFromSuperview];
        [avartImage removeFromSuperview];
        [firstLabel removeFromSuperview];
        [secondLabel removeFromSuperview];
        [thirdLabel removeFromSuperview];
        [tanImageView removeFromSuperview];
        [backView removeFromSuperview];
    }];
}

- (void)countDown:(int)timeInterval{
    if (timeout>0) {
        return;
    }
    timeout=timeInterval; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_time,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_time, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_time);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self handleCancal];
                
            });
        }else{
            // int day = (timeout/3600)/24;
            int hour = timeout/3600;
            int minute = (timeout-hour*3600)/60;
            int second = (int)(timeout-hour*3600)%60;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                
                NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"离活动开始还有%.2d:%.2d:%.2d",hour,minute, second]];
                NSRange contentRange = {7,[noteStr length] - 7};
                [noteStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
                [ secondLabel setAttributedText:noteStr] ;
                
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_time);
    
}

-(void)setCountDownTime:(NSTimeInterval)time{
//    NSLog(@"timetimetime%f",time);
    timeUserValue = time;
}


#pragma mark- scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_tableView tableViewDidEndDragging:scrollView];
}
#pragma mark - pullingTableViewDelegate

-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    
    [self refreshTableView:@0];
    
}
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    
    [self refreshTableView:@1];
    
}
-(void)refreshTableView:(id)object
{
    [self GetUserInfomation:[object intValue]];
}
//获取数据接口
-(void)GetUserInfomation:(BOOL)isRefreshing
{
    if (isRefreshing)
    {
        page=1;
        DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"get_activity" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"activity" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
        [diyouDic insertObject:self.isOver forKey:@"over_status" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
                 NSLog(@"tableViewDidFinishedLoading%@",object);
                 self.dataArray = [NSMutableArray new];
                 self.dataArray = [object objectForKey:@"list"];
                 if (self.dataArray.count > 0) {
                     self.nodatabackView.alpha = 0;

                 }else {
                     self.nodatabackView.alpha = 1;

                     
                 }
                 [self.tableView reloadData];
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }else
    {
        page++;
        
        DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"get_activity" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"activity" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic insertObject:self.isOver forKey:@"over_status" atIndex:0];

        [diyouDic insertObject:@"10" forKey:@"epage" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.footerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             
             if (success==YES) {
//                 NSLog(@"ssssssss%@",object);
                 NSArray * ary=[object objectForKey:@"list"];
                 if (ary.count>0) {
                     
                     for (int i=0; i<ary.count;i++ )
                     {
                         [self.dataArray addObject:ary[i]];
                     }
                 }else
                 {
                     [LeafNotification showInController:self withText:@"数据加载完了"];
                 }
                 
                 
                 [self.tableView reloadData];
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
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
