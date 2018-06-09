//
//  DYIncomeDetailVC.m
//  NewDeayou
//
//  Created by wayne on 14/8/14.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYIncomeDetailVC.h"
#import "DYIncomeDetailCell.h"

@interface DYIncomeDetailVC ()<UITableViewDataSource,UITableViewDelegate>

{
    UINib *nibCell;
}

//tableView,headView,sectionView
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewSectionView;
@property (strong, nonatomic) IBOutlet UIView *viewTableHeadView;


//借款期限，利息，奖励

@property (strong, nonatomic) IBOutlet UILabel *labelDeadline;
@property (strong, nonatomic) IBOutlet UILabel *labelInterest;
@property (strong, nonatomic) IBOutlet UILabel *labelAward;


@property(nonatomic,assign)float interest;
@property(nonatomic,assign)float award;
@property(nonatomic,retain)NSArray * aryData;

@end

@implementation DYIncomeDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"收益详情";
    
    _tableView.tableHeaderView=_viewTableHeadView;
    
    _aryData=[_dicData objectForKey:@"list"];
    
    self.interest=[[_dicData objectForKey:@"lixi"]floatValue];
    self.award=[[_dicData objectForKey:@"award"]floatValue];
    self.labelDeadline.text=self.dealineTime;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark- setter
-(void)setAward:(float)award
{
    _award=award;
    NSString * stringBidTotal;
    float wan=award/10000.0f;
    if (wan>1)
    {
        stringBidTotal=[NSString stringWithFormat:@"￥%.2f万",wan];
    }
    else
    {
        stringBidTotal=[NSString stringWithFormat:@"￥%.2f",award];
    }
    _labelAward.text=stringBidTotal;
    
}


-(void)setInterest:(float)interest
{
    _interest=interest;
    NSString * stringBidTotal;
    float wan=interest/10000.0f;
    if (wan>1)
    {
        stringBidTotal=[NSString stringWithFormat:@"￥%.2f万",wan];
    }
    else
    {
        stringBidTotal=[NSString stringWithFormat:@"￥%.2f",interest];
    }
    _labelInterest.text=stringBidTotal;
}

#pragma mark- tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _viewSectionView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * mark=@"reuser";
    if (!nibCell)
    {
        nibCell=[UINib nibWithNibName:@"DYIncomeDetailCell" bundle:nil];
        [tableView registerNib:nibCell forCellReuseIdentifier:mark];
    }
    
    DYIncomeDetailCell * cell=[tableView dequeueReusableCellWithIdentifier:mark];
    [cell setAttributeWithDictionary:_aryData[indexPath.row]];
    
    return cell;
}


@end
