//
//  RepaymentViewController.m
//  NewDeayou
//
//  Created by Tony on 2016/10/27.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "RepaymentViewController.h"
#import "DDRepayCell.h"
#import "LLDDRepayHeadView.h"
#import "DDRepayModel.h"
#import "DDRepayOtherModel.h"
@interface RepaymentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,strong)NSMutableArray*repayArray;
@property(nonatomic,strong)DDRepayModel*model;
@end
static NSString *cellID = @"DDRepayCell";
@implementation RepaymentViewController
- (NSArray*)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
- (NSMutableArray*)repayArray{
    if (_repayArray == nil) {
        _repayArray = [NSMutableArray array];
    }
    return _repayArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回款计划";
    self.view.backgroundColor = kCOLOR_R_G_B_A(245, 245, 249, 1);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = false;
    UINib*nib = [UINib nibWithNibName:cellID bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (void)loadData{
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"borrow" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_recover_list" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
   [diyouDic1 insertObject:_TouID forKey:@"id" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess) {
            self.model = [DDRepayModel mj_objectWithKeyValues:object];
            self.dataArray = [DDRepayOtherModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            [_tableView reloadData];
            
        }
        
    } fail:^{
        
    }];
 

}



#pragma mark - 数据源代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count+1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDRepayCell *cell = (DDRepayCell*)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.row>0) {
        cell.otherModel = self.dataArray[indexPath.row-1];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[cell.otherModel.recover_time doubleValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSString *timeString = [formatter stringFromDate:date];
        cell.time.text = [NSString stringWithFormat:@"%@ 第%ld期回款",timeString,(long)indexPath.row];

        if (indexPath.row == self.dataArray.count) {
            cell.line.hidden = YES;
            if ([cell.otherModel.recover_status isEqualToString:@"1"]) {
                 cell.icon.image = [UIImage imageNamed:@"huankuan_icon_sel"];
            }else{
                 cell.icon.image = [UIImage imageNamed:@"huankuan_icon_nor"];
            }
        }else{
            cell.line.hidden = false;
            DDRepayOtherModel * repayModel = self.dataArray[indexPath.row];
        

               if ([cell.otherModel.recover_status isEqualToString:@"1"]&&[repayModel.recover_status isEqualToString:@"0"]) {
            cell.icon.image = [UIImage imageNamed:@"huankuan_icon_sel"];
            cell.line.backgroundColor = kCOLOR_R_G_B_A(221, 221, 221, 1);
            
        }else if([cell.otherModel.recover_status isEqualToString:@"1"]&&[repayModel.recover_status isEqualToString:@"1"]){
            cell.icon.image = [UIImage imageNamed:@"huankuan_icon_sel"];
            cell.line.backgroundColor = kCOLOR_R_G_B_A(83, 194, 154, 1);
        }else{
            cell.icon.image = [UIImage imageNamed:@"huankuan_icon_nor"];
            cell.line.backgroundColor = kCOLOR_R_G_B_A(221, 221, 221, 1);
        }
        }
        
    }else if(indexPath.row==0){
    
        if (self.dataArray.count!=0&&self.dataArray.count>1) {
            cell.model  = _model;
            DDRepayOtherModel* otherM = self.dataArray[1];
            if ([otherM.recover_status isEqualToString:@"1"]) {
                cell.line.backgroundColor = kCOLOR_R_G_B_A(83, 194, 154, 1);
            }else{
                cell.line.backgroundColor = kCOLOR_R_G_B_A(221, 221, 221, 1);
            }
        }else if (self.dataArray.count==1){
            DDRepayOtherModel* otherM = self.dataArray[0];
            if ([otherM.recover_status isEqualToString:@"0"]) {
                 cell.line.backgroundColor = kCOLOR_R_G_B_A(221, 221, 221, 1);
            }else{
                cell.line.backgroundColor = kCOLOR_R_G_B_A(83, 194, 154, 1);
            }
            

        }
   
    }
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LLDDRepayHeadView*header = [[NSBundle mainBundle] loadNibNamed:@"LLDDRepayHeadView" owner:nil options:nil].lastObject;
    header.model = _model;
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}
@end
