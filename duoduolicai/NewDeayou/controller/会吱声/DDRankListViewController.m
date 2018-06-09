//
//  DDRankListViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/10/27.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDRankListViewController.h"
#import "DDRankListTableViewCell.h"
#import "DDRankListModel.h"

#define kCustom_Width   kMainScreenWidth - 20
@interface DDRankListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *rankListView;
@property (nonatomic, copy) NSString *videoID;
@property (nonatomic, strong) DDRankListModel *model;
@property (nonatomic,strong) NSMutableArray *allDataArray;
@property (nonatomic, strong) NSMutableArray *nowDataArray;
@end
static NSString *cellID = @"DDRankListTableViewCell";
@implementation DDRankListViewController
- (instancetype)init:(NSString *)videoID {
    if (self = [super init]) {
        self.videoID = videoID;
//        NSLog(@"dddddddddd%@",videoID);
    }
    return self;
}
- (NSMutableArray*)allDataArray{
    if (_allDataArray == nil) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}
- (NSMutableArray*)nowDataArray{
    if (_nowDataArray == nil) {
        _nowDataArray = [NSMutableArray array];
    }
    return _nowDataArray;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.rankListView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 20, kMainScreenHeight / 3 * 2 - 141) style:UITableViewStyleGrouped];
    _rankListView.backgroundColor = [UIColor whiteColor];
    _rankListView.dataSource = self;
    _rankListView.delegate = self;
    _rankListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.rankListView];
    UINib*nib = [UINib nibWithNibName:cellID bundle:nil];
    [self.rankListView registerNib:nib forCellReuseIdentifier:cellID];
    [self.view addSubview:self.rankListView];
   
    // Do any additional setup after loading the view.
} 
#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.nowDataArray.count;
    }else {
        return self.allDataArray.count;
    }
   
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return  44 ;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aview = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 20, 80)];
    UIImageView *firstImage = [[UIImageView alloc] initWithFrame:CGRectMake(kCustom_Width - 90, 30, 90, 20)];
//    firstImage.backgroundColor = [UIColor orangeColor];
    [aview addSubview:firstImage];
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstImage.frame), CGRectGetWidth(aview.frame), 30)];
    
    [aview addSubview:firstView];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    firstLabel.textColor = [UIColor darkGrayColor];
    firstLabel.text = @"名次";
    firstLabel.font = [UIFont systemFontOfSize:13];
    firstLabel.textAlignment = NSTextAlignmentCenter;
//    firstLabel.backgroundColor = [HeXColor colorWithHexString:@"#fff8ef"];
    [firstView addSubview:firstLabel];
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(firstLabel.frame) , 0, CGRectGetWidth(firstView.frame) - 165, 30)];
   
    secondLabel.textColor = [UIColor darkGrayColor];
    secondLabel.text = @"用户";
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.font = [UIFont systemFontOfSize:13];
//    secondLabel.backgroundColor = [HeXColor colorWithHexString:@"#fff8ef"];
    [firstView addSubview:secondLabel];
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondLabel.frame) , 0, 100, 30)];
    thirdLabel.textColor = [UIColor darkGrayColor];
    thirdLabel.text = @"打赏排行榜";
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.font = [UIFont systemFontOfSize:13];
//    thirdLabel.backgroundColor = [HeXColor colorWithHexString:@"#fff8ef"];
    [firstView addSubview:thirdLabel];
    if (section == 0) {
        firstView.backgroundColor = [HeXColor colorWithHexString:@"#fff8ef"];
        firstImage.image = [UIImage imageNamed:@"video_ranking list"];
        
    }else {
        firstView.backgroundColor = [HeXColor colorWithHexString:@"#fff7f6"];  
         firstImage.image = [UIImage imageNamed:@"video_total"];
    }
    
//    aview.backgroundColor = [UIColor orangeColor];
    return aview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     DDRankListTableViewCell *cell = (DDRankListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
   
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section == 0) {
        
        if (indexPath.row < 3) {
            self.rankListView.rowHeight = 50;
            cell.rankLabel.alpha = 0;
            if (indexPath.row == 0) {
                cell.phoneLabel.textColor = [HeXColor colorWithHexString:@"#fd5353"];
                cell.duomiLabel.textColor = [HeXColor colorWithHexString:@"#fd5353"];
            }else if (indexPath. row == 1) {
                cell.phoneLabel.textColor = [HeXColor colorWithHexString:@"#ff9600"];
                cell.duomiLabel.textColor = [HeXColor colorWithHexString:@"#ff9600"];
            }else if (indexPath.row == 2) {
                cell.phoneLabel.textColor = [HeXColor colorWithHexString:@"#5ac2fe"];
                cell.duomiLabel.textColor = [HeXColor colorWithHexString:@"#5ac2fe"];
            }
            
        }else {
            
            self.rankListView.rowHeight = 40;
            cell.rankLabel.alpha = 0;
            cell.rankLabel.textColor = [UIColor darkGrayColor];
            cell.phoneLabel.textColor = [UIColor darkGrayColor];
            cell.duomiLabel.textColor = [UIColor darkGrayColor];
        }
        
         cell.backgroundColor = [HeXColor colorWithHexString:@"#fff8ef"];
        cell.lineView.backgroundColor = [HeXColor colorWithHexString:@"#feecd6"];
        cell.model = self.nowDataArray[indexPath.row];
        
    }else {
         cell.backgroundColor = [HeXColor colorWithHexString:@"#fff7f6"];
        cell.lineView.backgroundColor = [HeXColor colorWithHexString:@"#fde4e1"];
        if (indexPath.row < 3) {
            self.rankListView.rowHeight = 50;
            cell.rankLabel.alpha = 0;
            if (indexPath.row == 0) {
                cell.phoneLabel.textColor = [HeXColor colorWithHexString:@"#fd5353"];
                cell.duomiLabel.textColor = [HeXColor colorWithHexString:@"#fd5353"];
            }else if (indexPath. row == 1) {
                cell.phoneLabel.textColor = [HeXColor colorWithHexString:@"#ff9600"];
                cell.duomiLabel.textColor = [HeXColor colorWithHexString:@"#ff9600"];
            }else if (indexPath.row == 2) {
                cell.phoneLabel.textColor = [HeXColor colorWithHexString:@"#5ac2fe"];
                cell.duomiLabel.textColor = [HeXColor colorWithHexString:@"#5ac2fe"];
            }

            
        }else {
            self.rankListView.rowHeight = 40;
             cell.rankLabel.alpha = 0;
            cell.rankLabel.textColor = [UIColor darkGrayColor];
            cell.phoneLabel.textColor = [UIColor darkGrayColor];
            cell.duomiLabel.textColor = [UIColor darkGrayColor];
        }
        
        cell.model = self.allDataArray[indexPath.row];
    }
    
    return cell;
    
}

- (void)loadData{
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"video" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"ranking_list" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject: self.videoID forKey:@"video_id" atIndex:0];
    [diyouDic1 insertObject:@"" forKey:@"limit" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess) {
//            NSLog(@"达瓦我段位%@",object);
            self.allDataArray = [DDRankListModel mj_objectArrayWithKeyValuesArray:object[@"all"]];
            self.nowDataArray = [DDRankListModel mj_objectArrayWithKeyValuesArray:object[@"now"]];
//            NSLog(@"%@", self.allDataArray);
            
            [self.rankListView reloadData];

            
        }
        
    } fail:^{
        
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
