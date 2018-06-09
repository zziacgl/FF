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
#import "DDPrepaymentCell.h"
@interface RepaymentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,strong)NSMutableArray*repayArray;
@property(nonatomic,strong)DDRepayModel*model;
@end
static NSString *cellID = @"DDRepayCell";
static NSString *payCell = @"DDPrepaymentCell";
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
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    self.view.backgroundColor = kCOLOR_R_G_B_A(245, 245, 249, 1);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = false;
    UINib*nib = [UINib nibWithNibName:cellID bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
    [self loadData];
    
    UINib *nib1 = [UINib nibWithNibName:payCell bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:payCell];
    
}

- (void)loadData{
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"recover" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_list" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
   [diyouDic1 insertObject:_TouID forKey:@"id" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess) {
            NSLog(@"回款计划%@",object);
            self.model = [DDRepayModel mj_objectWithKeyValues:object];
            self.dataArray = [DDRepayOtherModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            [_tableView reloadData];
            
        }
        
    } fail:^{
        
    }];
 

}
- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


#pragma mark - 数据源代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    float money = [self.model.recover_advance_fine floatValue];
    if (money > 0) {
        return 2;
    }else {
        return 1;
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArray.count+1;
    }else {
        return 1;
    }
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DDRepayCell *cell = (DDRepayCell*)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        if (indexPath.row>0) {
            cell.otherModel = self.dataArray[indexPath.row-1];
            if (indexPath.row == self.dataArray.count) {
                cell.line.hidden = YES;
            }else {
                cell.line.hidden = false;
            }

            
        }else if(indexPath.row==0){
            cell.model = self.model;
            NSLog(@"数组个数%lu", (unsigned long)self.dataArray.count);
            if (self.dataArray.count!=0&&self.dataArray.count>1) {
//                cell.model  = _model;
                DDRepayOtherModel* otherM = self.dataArray[1];
                if ([otherM.recover_status isEqualToString:@"1"]) {
                    cell.line.backgroundColor = kCOLOR_R_G_B_A(83, 194, 154, 1);
                    cell.icon.image = [UIImage imageNamed:@"huankuan_icon_sel"];
                }else{
                    cell.line.backgroundColor = kCOLOR_R_G_B_A(83, 194, 154, 1);
                    cell.icon.image = [UIImage imageNamed:@"huankuan_icon_sel"];
                }
            }else if (self.dataArray.count==1){
                DDRepayOtherModel* otherM = self.dataArray[0];
                if ([otherM.recover_status isEqualToString:@"0"]) {
                    cell.line.backgroundColor = kCOLOR_R_G_B_A(83, 194, 154, 1);
                    cell.icon.image = [UIImage imageNamed:@"huankuan_icon_sel"];
                }else{
                    cell.line.backgroundColor = kCOLOR_R_G_B_A(83, 194, 154, 1);
                    cell.icon.image = [UIImage imageNamed:@"huankuan_icon_sel"];
                }
                
                
            }
            
        }
         return cell;
    }else  {
         DDPrepaymentCell *cell = (DDPrepaymentCell*)[tableView dequeueReusableCellWithIdentifier:payCell forIndexPath:indexPath];
        cell.prePayLabel.text = @"0000";
        
        NSString *moneyStr = self.model.recover_advance_fine;
        NSUInteger remainLen = [moneyStr length];
        NSMutableAttributedString *remainMoney = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"提前还款补偿收益%@元", moneyStr]];
        [remainMoney addAttribute:NSForegroundColorAttributeName value:kMainColor2 range:NSMakeRange(0, 4)];
        [remainMoney addAttribute:NSForegroundColorAttributeName value:kMainColor2 range:NSMakeRange(8, remainLen)];
        cell.prePayLabel.attributedText = remainMoney;
        return cell;
    }
   
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        LLDDRepayHeadView*header = [[NSBundle mainBundle] loadNibNamed:@"LLDDRepayHeadView" owner:nil options:nil].lastObject;
        header.model = _model;
        
        return header;
    }else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 156;
    }else {
        return 0;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 74;
    }else {
        return 40;
    }
    
}
@end
