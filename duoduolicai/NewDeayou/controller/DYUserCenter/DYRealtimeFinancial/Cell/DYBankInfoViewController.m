//
//  DYBankInfoViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/8/28.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYBankInfoViewController.h"
#import "DYBankInfoTableViewCell.h"
#import "DYMyAcountMainVC.h"
#import "DYBankCardVC.h"
#import "DYMoreFootView.h"

@interface DYBankInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UINib *nibcontent;
}

@property(nonatomic,strong)NSArray *dataArray;//
@property(nonatomic,strong)UITableView *tableView;


@end

@implementation DYBankInfoViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"我的银行卡";
    }
    return self;
}
-(void)loadView{
    [super loadView];


    
    //设置下拉刷新tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *bankname=[NSString stringWithFormat:@"%@",[ud objectForKey:@"bankname"]];
    NSString *account=[NSString stringWithFormat:@"%@",[ud objectForKey:@"account"]];
    NSString *image=[NSString stringWithFormat:@"%@",[ud objectForKey:@"image"]];
//    NSLog(@"%@",image);
    if ([bankname length]>0) {
        self.dataArray=@[@{@"bankname":bankname,@"account":account,@"image":image}];

////        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0,100, 200, 44)];
//        [self.AlertBtn setTitle:@"如需绑定银行卡，请先充值" forState:UIControlStateNormal];
//        [self.AlertBtn addTarget:self action:@selector(Bind) forControlEvents:UIControlEventTouchDown];
////        [self.view addSubview:btn];
//        DYMoreFootView *moreFootView = [[DYMoreFootView alloc]initWithFrame:CGRectMake(0, 10, kScreenSize.width,60)];
//        [moreFootView.exitButton setTitle:@"解绑之后如需提现，请先充值认证" forState:UIControlStateNormal];
//        [moreFootView.exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [moreFootView.exitButton setBackgroundColor:[UIColor whiteColor]];
//        [moreFootView.exitButton addTarget:self action:@selector(Bind) forControlEvents:UIControlEventTouchDown];
//        self.tableView.tableFooterView = moreFootView;
//        //    self.view.backgroundColor = [UIColor greenColor];
//        self.tableView.backgroundColor = [UIColor whiteColor];
//        [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor clearColor]];

    }else{
        UIImageView *nullImage=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-([UIScreen mainScreen].bounds.size.height/4)*590/320/2, [UIScreen mainScreen].bounds.size.height/4, ([UIScreen mainScreen].bounds.size.height/4)*590/320, [UIScreen mainScreen].bounds.size.height/4)];
        nullImage.image=[UIImage imageNamed:@"nobank.png"];
        [self.view addSubview:nullImage];
        
        UIButton *bit=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-([UIScreen mainScreen].bounds.size.height/4)*590/320/2, [UIScreen mainScreen].bounds.size.height/4+180, ([UIScreen mainScreen].bounds.size.height/4)*590/320, 44)];
        [bit setTitle:@"绑卡需充值进行" forState:UIControlStateNormal];
        [bit setBackgroundColor:[UIColor colorWithRed:175 / 255.0 green:0  blue:21 / 255.0 alpha:1]];
        [bit addTarget:self action:@selector(Bind) forControlEvents:UIControlEventTouchDown];
        [bit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:bit];
    }
    
    
}
-(void)Bind{
    DYBankCardVC *VC = [[DYBankCardVC alloc]initWithNibName:@"DYBankCardVC" bundle:nil];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect bounds = self.view.bounds;
    bounds.size.height = kScreenSize.height - 20 -94+44;
    _tableView.frame = bounds;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - tableView datasource
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *markRuse=@"bankinfo";
    if (!nibcontent) {
        nibcontent = [UINib nibWithNibName:@"DYBankInfoTableViewCell" bundle:nil];
        [tableView registerNib:nibcontent forCellReuseIdentifier:markRuse];
    }
    DYBankInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markRuse];
    cell.imageView.frame=CGRectMake(0, 0, 35, 35);
    cell.selectionStyle = UITableViewCellAccessoryNone;
    NSDictionary *dic=[self.dataArray objectAtIndex:0];
    cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[dic objectForKey:@"image"]]];
    cell.BankName.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"bankname"]];
    cell.BankNo.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"account"]];
    [cell.TerminationBtn addTarget:self action:@selector(Termination) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}
-(void)Termination{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定解绑吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"解绑", nil];
    [alert show];
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        //银行卡解绑
        DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
        int Useid=[DYUser GetUserID];
        [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"unbund_user_bank" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",Useid] forKey:@"user_id" atIndex:0];
        
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
         {
             //wayne-test
             if (isSuccess)
             {
                 [MBProgressHUD errorHudWithView:nil label:@"解绑成功" hidesAfter:1];
                 DYMyAcountMainVC * myAcount=[[DYMyAcountMainVC alloc]initWithNibName:@"DYMyAcountMainVC" bundle:nil];
                 myAcount.hidesBottomBarWhenPushed=YES;
                 myAcount.phone=self.phone;
                 [self.navigationController pushViewController:myAcount animated:YES];
             }
             else
             {
                 
                 [MBProgressHUD errorHudWithView:nil label:errorMessage hidesAfter:1];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideAllHUDsForView:nil animated:YES];
             [MBProgressHUD errorHudWithView:nil label:@"网络异常" hidesAfter:1];
         }];

    }
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"%ld",(long)indexPath.section);
//    
//  
//}

@end
