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
#import "DYMoreFootView.h"
#import "DDRemoveBankViewController.h"
//#import <CustomAlertView.h>
@interface DYBankInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UINib *nibcontent;
    NSString *authKey;
}

@property(nonatomic,strong)NSArray *dataArray;//
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *url_notify;
@property(nonatomic)BOOL isGetRecharge100;
@property(nonatomic)BOOL isGetRecharge1000;

@end

@implementation DYBankInfoViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的银行卡";
    }
    return self;
}
-(void)loadView
{
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
    if (self.isBindBank==1) {
        self.dataArray=@[@{@"bankname":bankname,@"account":account,@"image":image}];

        
        [ud setObject:@"0" forKey:@"Request_unwrap"];
        
        UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        _tableView.tableFooterView=footView;
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-150, 0, 150, 40)];
        [btn setTitle:@"更新预留手机号" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(updatePhone) forControlEvents:UIControlEventTouchDown];
        [btn setTitleColor:kCOLOR_R_G_B_A(134, 134, 134, 1) forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [footView addSubview:btn];
        

    } else {
        UIImageView *nullImage=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-([UIScreen mainScreen].bounds.size.height/4)*590/320/2, [UIScreen mainScreen].bounds.size.height/4, ([UIScreen mainScreen].bounds.size.height/4)*590/320, [UIScreen mainScreen].bounds.size.height/4)];
        nullImage.image=[UIImage imageNamed:@"bank"];
        [self.view addSubview:nullImage];
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-70, [UIScreen mainScreen].bounds.size.height/4+100, 140, 40)];
        lab.text=@"暂无银行卡信息";
        [lab setFont:[UIFont systemFontOfSize:15]];
        [self.view addSubview:lab];
        
        UIButton *bit=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-80, [UIScreen mainScreen].bounds.size.height/4+150, 160, 44)];
        [bit setTitle:@"立即绑卡" forState:UIControlStateNormal];
        [bit setBackgroundColor:kCOLOR_R_G_B_A(253, 83, 83, 1)];
        [bit.layer setMasksToBounds:YES];
        [bit.layer setCornerRadius:5.0f];
        [bit addTarget:self action:@selector(Bind) forControlEvents:UIControlEventTouchDown];
        [bit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:bit];
        
        [ud setObject:@"0" forKey:@"Request_unwrap"];
    }
    
    
    
}
-(void)updatePhone{
    //更新银行预留手机号
    int xw_status=[[DYUser getXW_Status] intValue];
    if (xw_status==0) {
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"弹窗原因"]=@"未注册新网";
        
    }else if(xw_status==1){
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"弹窗原因"]=@"未激活新网";
        
    }else{
    NSString *url=[NSString stringWithFormat:@"%@?service_name=modify_mobile_expand&login_key=%@",pcURL_XW,[DYUser GetLoginKey]];
//    NSLog(@"%@",url);
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.hidesBottomBarWhenPushed = YES;
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"更新银行预留手机号";
    [self.navigationController pushViewController:adVC animated:YES];
    }
}


-(void)Bind{
    int xw_status=[[DYUser getXW_Status] intValue];
    if (xw_status==0) {
         //在新网未注册
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"弹窗原因"]=@"未注册新网";
        
    
    }else if(xw_status==1){
         //在新网未激活
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"弹窗原因"]=@"未激活新网";
        
    }else{
        NSString *url=[NSString stringWithFormat:@"%@?service_name=personal_bind_bankcard_expand&login_key=%@",pcURL_XW,[DYUser GetLoginKey]];
//        NSLog(@"%@",url);
        ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
        adVC.hidesBottomBarWhenPushed = YES;
        adVC.myUrls = @{@"url":url};
        adVC.titleM =@"添加银行卡";
        [self.navigationController pushViewController:adVC animated:YES];
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect bounds = self.view.bounds;
    bounds.size.height = kScreenSize.height - 20 -94+44;
    bounds.size.width=kScreenSize.width;
    _tableView.frame = bounds;
    
//    [self getAuthKey];
    
    [_tableView reloadData];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    int updatePhone_success=[[ud objectForKey:@"updatePhone_success"] intValue];
    
    if (updatePhone_success==1) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
        [self.view addSubview:HUD];
        HUD.labelText=@"手机号码更新成功";
        HUD.mode =MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
        
        [HUD showAnimated:YES whileExecutingBlock:^{
            
            
            sleep(2);
            
        } completionBlock:^{
            [ud setObject:@"0" forKey:@"updatePhone_success"];
            [HUD removeFromSuperview];
            
        }];

    }
    
   
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
    cell.LogoImage.frame=CGRectMake(0, 0, 35, 35);
    cell.LogoImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.LogoImage.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    NSDictionary *dic=[self.dataArray objectAtIndex:0];
    cell.LogoImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[dic objectForKey:@"image"]]];
    cell.BankName.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"bankname"]];
    cell.BankNo.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"account"]];
    [cell.TerminationBtn addTarget:self action:@selector(Termination) forControlEvents:UIControlEventTouchDown];
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *Request_unwrap=[NSString stringWithFormat:@"%@",[ud objectForKey:@"Request_unwrap"]];
    int userid=[[NSString stringWithFormat:@"%@",[ud objectForKey:@"user_id"]] intValue];
    
    if (userid==[DYUser GetUserID]&&[Request_unwrap isEqualToString:@"1"]) {
//        [cell.TerminationBtn setTitle:@"申请解绑中" forState:U]
        [cell.TerminationBtn setTitle:@"申请解绑中" forState:UIControlStateNormal];
        [cell.TerminationBtn setEnabled:NO];
        [cell.TerminationBtn setBackgroundColor:[UIColor grayColor]];
    }
    return cell;
}
-(void)Termination{
    
    
    int xw_status=[[DYUser getXW_Status] intValue];
    if (xw_status==0) {
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"弹窗原因"]=@"未注册新网";
        
    }else if(xw_status==1){
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"弹窗原因"]=@"未激活新网";
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定解绑吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"解绑", nil];
        [alert show];

    }

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
//              DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
//        int Useid=[DYUser GetUserID];
//        [diyouDic insertObject:@"face" forKey:@"module" atIndex:0];
//        [diyouDic insertObject:@"apply" forKey:@"q" atIndex:0];
//      
//        [diyouDic insertObject:[NSString stringWithFormat:@"%d",Useid] forKey:@"user_id" atIndex:0];
//        
//        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
//         {
//             //wayne-test
//             if (isSuccess)
//             {
//                 NSLog(@"%@", object);
//                  NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
//                 [ud setObject:@"1" forKey:@"Request_unwrap"];
//                 [ud setObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id"];
//                 [_tableView reloadData];
//                 DDRemoveBankViewController *removeBank = [[DDRemoveBankViewController alloc] initWithNibName:@"DDRemoveBankViewController" bundle:nil];
//                 [self.navigationController pushViewController:removeBank animated:YES];
//
//             }
//             else
//             {
//                 NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
//                 [ud setObject:@"0" forKey:@"Request_unwrap"];
//                 [LeafNotification showInController:self withText:errorMessage];
//             }
//             
//         } errorBlock:^(id error)
//         {
//             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
//             [ud setObject:@"0" forKey:@"Request_unwrap"];
//             
//             [LeafNotification showInController:self withText:@"网络异常"];
//         }];

        NSString *url=[NSString stringWithFormat:@"%@?service_name=unbind_bankcard&login_key=%@",pcURL_XW,[DYUser GetLoginKey]];
//        NSLog(@"%@",url);
        ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
        adVC.hidesBottomBarWhenPushed = YES;
        adVC.myUrls = @{@"url":url};
        adVC.titleM =@"解绑银行卡";
        [self.navigationController pushViewController:adVC animated:YES];

    }
}

-(void)getAuthKey{
    
            DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
            int Useid=[DYUser GetUserID];
            [diyouDic insertObject:@"face" forKey:@"module" atIndex:0];
            [diyouDic insertObject:@"get_auth_key" forKey:@"q" atIndex:0];
            [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
            [diyouDic insertObject:[NSString stringWithFormat:@"%d",Useid] forKey:@"user_id" atIndex:0];
    
            [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
             {
                 //wayne-test
                 if (isSuccess)
                 {
                     NSDictionary *dic=object;
//                     NSLog(@"%@",dic);
                     authKey=[NSString stringWithFormat:@"%@",[dic objectForKey:@"auth_key"]];
                     self.url_notify=[NSString stringWithFormat:@"%@",[dic objectForKey:@"url_notify"]];
                 }
                 else
                 {
    
                     [LeafNotification showInController:self withText:errorMessage];
                 }
    
             } errorBlock:^(id error)
             {
                 [MBProgressHUD hideAllHUDsForView:nil animated:YES];
                 [LeafNotification showInController:self withText:@"网络异常"];
             }];

}

@end
