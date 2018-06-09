//
//  DDDrawMoneyViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2017/2/10.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDDrawMoneyViewController.h"
#import "MBProgressHUD.h"
#import "DYWithdrawalRecordVC.h"
#import "DDPassWordAlertView.h"
#import "DYUpdateLoginPwdViewController.h"
//#import <CustomAlertView.h>
#import "FFgetMoneyView.h"
#define kDrawalMoney             @"drawal"       //体现金额
#define kFree                    @"free"         //手续费
#define kDaoZhangMoney           @"daozhang"     //到账金额
#define kPaymentPassWord         @"payment"      //支付密码
#define kVerification            @"verification" //验证码


@interface DDDrawMoneyViewController ()
{
    FFgetMoneyView *headerView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *myCardDic;
@property (nonatomic, strong) NSDictionary *bankDic;
@property (nonatomic, strong) NSDictionary *bankIcon;
@end

@implementation DDDrawMoneyViewController



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor  = kNormalColor;
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.barTintColor  = kMainColor;
    
}

- (NSDictionary *)bankDic {
    if (!_bankDic) {
        self.bankDic = @{@"1":@"工商银行",@"2":@"建设银行",@"3":@"民生银行",@"4":@"光大银行",@"5":@"招商银行",@"6":@"中国银行",@"7":@"交通银行",@"8":@"浦发银行",@"9":@"兴业银行",@"10":@"中信银行",@"11":@"北京银行",@"12":@"广发银行",@"13":@"平安银行",@"14":@"微商银行",@"15":@"天津银行",@"16":@"中国邮政银行",@"17":@"农业银行"};
    }
    return _bankDic;
}

- (NSDictionary *)bankIcon {
    if (!_bankIcon) {
        self.bankIcon = @{@"1":@"gs",@"2":@"js",@"3":@"ms",@"4":@"gd",@"5":@"zs",@"6":@"zg",@"7":@"jt",@"8":@"pf",@"9":@"xy",@"10":@"zx",@"11":@"bj",@"12":@"gf",@"13":@"pa",@"14":@"ws",@"15":@"tj",@"16":@"yzcx",@"17":@"ny"};
    }
    return _bankIcon;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    self.view.backgroundColor = kBackColor;
    //导航右边的按钮
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    UIButton * btnRightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor = [UIColor clearColor];
    btnRightItem.frame = CGRectMake(0, 0, 80, 35);
    btnRightItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnRightItem setTitle:@"提现记录" forState:UIControlStateNormal];
    [btnRightItem setTitleColor:kBtnColor forState:UIControlStateNormal];
    [btnRightItem addTarget:self action:@selector(rightBarButtonItemActionMore) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth , kMainScreenHeight) style:UITableViewStylePlain];
    //    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = false;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    headerView = [[NSBundle mainBundle]loadNibNamed:@"FFgetMoneyView" owner:nil options:nil].lastObject;

    headerView.model = self.model;
    self.tableView.tableHeaderView = headerView;
    headerView.backgroundColor = kBackColor;
    
//    //增加监听，当键盘出现或改变时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    //增加监听，当键退出时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
   
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)btnTiXian{

    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"apply_cash" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"cash" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:self.myBranch forKey:@"branch" atIndex:0];
    [diyouDic insertObject:self.myCity forKey:@"city" atIndex:0];

//    [diyouDic insertObject:headerView.drawMoneyTF.text forKey:@"money" atIndex:0];

    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess == YES) {
           [MBProgressHUD checkHudWithView:self.view label:@"提现成功" hidesAfter:1];
            [self performSelector:@selector(GotoBack) withObject:nil afterDelay:1];
        }else {
            [LeafNotification showInController:self withText:errorMessage];
        }
        
        
    } fail:^{
        [LeafNotification showInController:self withText:@"网络异常"];
        
    }];
    
}
- (void)GotoBack {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
//    float change = kMainScreenHeight - headerView.nextBtn.frame.origin.y;
//    NSLog(@"键盘%f", change);
//    if ( headerView.cityTF.editing) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.view.transform = CGAffineTransformMakeTranslation(0, -height + change - 30);
//        }];
//    }else if (headerView.branchTF.editing){
//        [UIView animateWithDuration:0.5 animations:^{
//            self.view.transform = CGAffineTransformMakeTranslation(0, -height + change - 60);
//        }];
//    }else if (headerView.moneyTF.editing){
//        [UIView animateWithDuration:0.5 animations:^{
//            self.view.transform = CGAffineTransformMakeTranslation(0, -height + change - 90);
//        }];
//    }
    
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);//这里的坐标是与原始的比较；
        
    }];
}

#pragma mark -- 提现记录

-(void)rightBarButtonItemActionMore
{
    DYWithdrawalRecordVC * withdrawalVC=[[DYWithdrawalRecordVC alloc]initWithNibName:@"DYWithdrawalRecordVC" bundle:nil];
    withdrawalVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:withdrawalVC animated:YES];
    
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
