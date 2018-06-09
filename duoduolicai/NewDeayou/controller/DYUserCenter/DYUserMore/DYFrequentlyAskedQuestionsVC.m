//
//  DYFrequentlyAskedQuestionsVC.m
//  NewDeayou
//
//  Created by diyou on 14-7-9.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYFrequentlyAskedQuestionsVC.h"
#import "DYQuestionTableViewCell.h"
#import "DYDetailQuestionVC.h"
//#import "WYWebProgressLayer.h"
//#import "UIView+Frame.h"

@interface DYFrequentlyAskedQuestionsVC ()<UITableViewDataSource,UITableViewDelegate>
{
//    WYWebProgressLayer *_progressLayer;

     UINib * nibCell;     //复用cell的nib
     NSArray *aryQuestions;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DYFrequentlyAskedQuestionsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    self.title=@"帮助中心";
    if (self.isNew==1) {
        self.title=@"丰丰新闻";
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    [self getDate];
   
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
#pragma mark ---tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return aryQuestions.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  0.5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * mark=@"markContent";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:mark];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *name=[aryQuestions[indexPath.row] objectForKey:@"name"];
    cell.textLabel.text=name;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DYDetailQuestionVC * detailVC=[[DYDetailQuestionVC alloc]init];
   // detailVC.dicInfo=aryQuestions[indexPath.row];
    detailVC.idStr = [NSString stringWithFormat:@"%@", [aryQuestions[indexPath.row] objectForKey:@"id"]];
    detailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
#pragma mark---数据请求
-(void)getDate
{
    NSString *sitenid=@"help";
    if (self.isNew==1) {
        sitenid=@"dongtai";
    }
    //————————————————————————个人中心->更多->常见问题接口——————————————————————————
    
//    [MBProgressHUD hudWithView:self.view label:@"数据加载中..."];
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"articles" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_mobile_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"status" atIndex:0];
    [diyouDic insertObject:@"order_asc" forKey:@"order" atIndex:0];
    if (self.isNew==1) {
        [diyouDic insertObject:sitenid forKey:@"site_nid" atIndex:0];
    }else{
        [diyouDic insertObject:@"25" forKey:@"type_id" atIndex:0];
    }
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (success==YES) {
             //可用信用额度数据填充
//                NSLog(@"可用信用%@", object);
                if ([[object objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                    
                    aryQuestions=[object objectForKey:@"list"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
