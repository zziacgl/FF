//
//  DDAllMoneyViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/24.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDAllMoneyViewController.h"
#import "DDAllMoneyTableViewCell.h"
#import "SCChart.h"
#import "DDAllMoneyModel.h"
@interface DDAllMoneyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *allDataDic;
@property (nonatomic, strong) DDAllMoneyModel *allModel;
@end
static NSString *cellID=@"DDAllMoneyTableViewCell";
@implementation DDAllMoneyViewController

- (void)viewDidLoad {
    self.title = @"总资产";
    [super viewDidLoad];
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    self.topView.backgroundColor = [UIColor whiteColor];
    self.allMoneyLabel.text = self.allMoney;
    [self configTableView];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (NSDictionary *)allDataDic {
    if (!_allDataDic) {
        self.allDataDic = [NSDictionary dictionary];
    }
    return _allDataDic;
}

- (void)configTableView {
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 90, kMainScreenWidth, kMainScreenHeight - 90 - 64) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    UINib *nib=[UINib nibWithNibName:cellID bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellID];
    
    [self.view addSubview:self.tableView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 470;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDAllMoneyTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDAllMoneyModel *moedl = self.allModel;
    if (moedl) {
        cell.model = moedl;
    }
    
    return cell;
}

- (void)getData {
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"account" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_all" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d", [DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess) {
            
            
            self.allModel = [DDAllMoneyModel mj_objectWithKeyValues:object];
            self.allMoneyLabel.text = [NSString stringWithFormat:@"%@", [object objectForKey:@"total"]];
            [self.tableView reloadData];
            
            
        }else{
            [LeafNotification showInController:self withText:errorMessage];
            
            
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
