//
//  DDBondDetailViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/8/10.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDBondDetailViewController.h"
#import "DDBondDetailTableViewCell.h"
#import "DDChoseTimeTableViewController.h"
#import "DYSafeViewController.h"
#define poundage  0.005 //手续费


@interface DDBondDetailViewController ()<UITableViewDelegate, UITableViewDataSource,DDChoseTimeTableViewControllerDelegate , UITextFieldDelegate>
{
    UINib * nibHead;     // 复用cell的nib
    NSString *moneyStr;
}
@property (nonatomic, strong) UITableView *bondDetailTableView;
@property (nonatomic, strong) NSString *timeStr;

@end
static float maxcount;//最大范围
static float investMoney;//原始投资金额
static int myDay;//持有时间
static float oldAnnual;//原始年化
static float oldDay;//原标时间
static float oldMonth;//原始月数
static float inputM;//输入金额
@implementation DDBondDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"确认转让信息";
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];

    
    //配置导航栏
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    self.bondDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
    _bondDetailTableView.dataSource = self;
    _bondDetailTableView.delegate = self;
    _bondDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.bondDetailTableView];
    
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 500;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *markreuse = @"detail";
    if (!nibHead) {
        nibHead = [UINib nibWithNibName:@"DDBondDetailTableViewCell" bundle:nil];
        [tableView registerNib:nibHead forCellReuseIdentifier:markreuse];
        
    }
    DDBondDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markreuse];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.tag = 200;
    [cell.choseTime addTarget:self action:@selector(handleTime:) forControlEvents:UIControlEventTouchUpInside];
    [cell.dealBtn addTarget:self action:@selector(handleDeal) forControlEvents:UIControlEventTouchUpInside];
    cell.transferPriceTF.delegate = self;
    [cell.transferPriceTF resignFirstResponder];
    if (self.timeStr) {
        cell.timeLabel.text = [NSString stringWithFormat:@"%@",self.timeStr];
    }
    if (self.detailDic) {
        
        NSLog(@"%@", self.detailDic);
        float annual = [[NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"borrow_apr"]] floatValue];//年化
        oldAnnual = annual;
        NSString *dataMoney = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"account"]];
        double money = [dataMoney doubleValue];//原标投资金额
        
//        NSLog(@"moneymoneymoneymoneymoney%f", money);
        investMoney = money;
//        NSString *startTime = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"reverify_time"]];//标的开始时间
//        NSString *str = [DYUtils dataUnixTimeYYYYMMDD:startTime];
//        NSString *str1 = [DYUtils datatotimestamp:str];//标开始当天凌晨时间戳
////        NSLog(@"000000%@", str1);
//        NSString *recoverTime = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"recover_time"]];//原始标还款时间
//        NSString *periodTime = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"borrow_period"]];//标的原始时间月或者天
//        NSString *allWillGetMoney = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"recover_interest"]];//原始预计总收益
//        float allrecoverMoney = [allWillGetMoney floatValue];
//        float markoldTime = [periodTime floatValue];
//        oldMonth = markoldTime;

//        NSString *timeSp = [DYUtils datazerotime];
////        NSLog(@"timeSp:%@",timeSp); //当天凌晨时间戳的值
//        float start = [startTime floatValue];
//        float zeroStarttime = [str1 floatValue];
//        float now = [timeSp floatValue];
//        float day = (now - zeroStarttime) / 3600 / 24;
//        float rec = [recoverTime floatValue];
//        oldDay = [[NSString stringWithFormat:@"%f",((rec - start) / 3600 / 24)] floatValue];//天标原始总天数
//        float newDay = [[NSString stringWithFormat:@"%f", day] floatValue];
//        myDay = newDay ;//持有时间
        
//        NSLog(@"凌晨时间相减%d", myDay);
       
        //判断天标还是月标
        NSString *periodType = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"borrow_style"]];
        float minM=[[self.detailDic objectForKey:@"min_account"] floatValue];
        float maxM=[[self.detailDic objectForKey:@"max_account"] floatValue];
        maxcount = maxM;
        
        NSString *str = [NSString stringWithFormat:@"%.2f~%.2f", minM,maxM];
        NSUInteger len = [str length];
        NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"转让价格只能设置在%@之间", str]];
        [str4 addAttribute:NSForegroundColorAttributeName value:kMainColor range:NSMakeRange(9,len)];
        cell.moneyInterVal.attributedText = str4;
//
//        if ([periodType isEqualToString:@"day"]) {
////            float earnings = myDay / oldDay * allrecoverMoney;//已获收益
//           
////            int a = earnings * 100;
////            float b = a;
////            float c = b / 100;
////            float maxMoney = c + money;
//            maxcount = maxM;
////            NSLog(@"earningsearningsearnings%.2lf",maxcount);
//            
//            
//            NSString *str = [NSString stringWithFormat:@"%.2f~%.2f", minM,maxM];
//            NSUInteger len = [str length];
//            NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"转让价格只能设置在%@之间", str]];
//            [str4 addAttribute:NSForegroundColorAttributeName value:kCOLOR_R_G_B_A(253, 83, 83, 1) range:NSMakeRange(9,len)];
//            cell.moneyInterVal.attributedText = str4;
//        }else if([periodType isEqualToString:@"month"]) {
////            float earnings = myDay / oldDay * allrecoverMoney ;
////            NSLog(@"money%f annual%f myDay%d markoldTime%f oldDay%f",money,annual,myDay,markoldTime,oldDay);
////            int a = earnings * 100;
////            float b = a;
////            float c = b / 100;
////            float maxMoney = c + money;
//            maxcount = maxM;
////            NSLog(@"earningsearningsearnings%f",earnings);
//            NSString *str = [NSString stringWithFormat:@"%.2f~%.2f", minM,maxM];
//            NSUInteger len = [str length];
//            NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"转让价格只能设置在%@之间", str]];
//            [str4 addAttribute:NSForegroundColorAttributeName value:kCOLOR_R_G_B_A(253, 83, 83, 1) range:NSMakeRange(9,len)];
//            cell.moneyInterVal.attributedText = str4;
//            
//        }
        

        cell.FEELabel.text = [NSString stringWithFormat:@"%@%%", [self.detailDic objectForKey:@"borrow_apr"]];
        [cell.isSureBtn addTarget:self action:@selector(handleTransfer:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return cell;
}
//协议
- (void)handleDeal {
//    DYSafeViewController *safeVC = [[DYSafeViewController alloc] initWithNibName:@"DYSafeViewController" bundle:nil];
    DDBondDetailTableViewCell *cell = [self.view viewWithTag:200];
    NSString *loginkey = [DYUser GetLoginKey];
    NSString *idstr = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"id"]];
    moneyStr = cell.transferPriceTF.text;
    NSString *url = [NSString stringWithFormat:@"%@/action/transfer/protocol?id=%@&login_key=%@&money=%@",ffwebURL,idstr, loginkey,moneyStr];
//    safeVC.weburl = url;
    NSLog(@"借款协议%@", url);
//    safeVC.title = @"借款协议";
//    [self.navigationController pushViewController:safeVC animated:YES];
    
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"借款协议";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:adVC animated:YES];
}
- (void)handleTransfer:(UIButton *)sender {
    UIImageView *readImage = [self.view viewWithTag:150];
    if (readImage.isHighlighted==YES)
    {
        [MBProgressHUD errorHudWithView:self.view label:@"同意协议才能申请转让" hidesAfter:2];
        return;
        
    }

    
    NSString *idstr = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"id"]];
    UITextField *myTf = [self.view viewWithTag:110];
    NSString *tfNumber = myTf.text;
    NSString *mytime = @"";
    if ([self.timeStr isEqualToString:@"48小时"]) {
        mytime = @"2";
    }else {
        mytime = @"1";
    }
    NSLog(@"tfNumber%@",tfNumber);
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"transfer" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"start_transfer" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:idstr forKey:@"tender_id" atIndex:0];
    [diyouDic insertObject:tfNumber forKey:@"borrow_money" atIndex:0];
    [diyouDic insertObject:mytime forKey:@"borrow_valid_time" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         
         if (success==YES) {
             if ([self.delegate respondsToSelector:@selector(refrech:)]) {
                 [self.delegate refrech:YES];
                 [self.navigationController popViewControllerAnimated:YES];
                 
             }

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
- (void)handleTime:(UIButton *)sender {
    DDChoseTimeTableViewController *choseVC = [[DDChoseTimeTableViewController alloc] init];
    choseVC.delegate = self;
    [self.navigationController pushViewController:choseVC animated:YES];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.view endEditing:YES];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    UITextField *moneyTF = [self.view viewWithTag:110];
    
    float max = [[NSString stringWithFormat:@"%.2f", maxcount] floatValue];
    
    NSString *s = @"";
    float m = 0;
    if (range.length == 1) {
        m = [[moneyTF.text substringToIndex:moneyTF.text.length - 1] floatValue];
        s = [moneyTF.text substringToIndex:moneyTF.text.length - 1];
        
    }else {
        m=[[NSString stringWithFormat:@"%@%@",moneyTF.text,string] floatValue];
        s=[NSString stringWithFormat:@"%@%@",moneyTF.text,string];

    }

//    NSLog(@"nnnnnnn%f", m);
    UILabel *getMoneyLabel = [self.view viewWithTag:120];
    float charge = m * poundage;
    getMoneyLabel.text = [NSString stringWithFormat:@"%.2f", (m - charge)];
    UILabel *chargeLabel = [self.view viewWithTag:130];
    chargeLabel.text = [NSString stringWithFormat:@"%.2f", charge];
    
//    NSString *periodType = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"period_type"]];//判断天标月标
    
//    if ([periodType isEqualToString:@"day"]) {
//    
//        float allMoney = investMoney + (investMoney * oldAnnual * oldDay / 360 /100);//到期后总还款
////        NSLog(@"oldAnnual%.2f oldDay%.2f investMoney%.2f allMoney%.2f myDay%d  oldDay%f",oldAnnual,oldDay, investMoney,allMoney, myDay, oldDay);
//        float realy = (allMoney - m) *360 / m / (oldDay - myDay) * 100;
//        if(realy <= 100){
//            realyLabel.text = [NSString stringWithFormat:@"%.2f%%", realy];
//        }else{
//            realyLabel.text = @"0.00%";
//        }
//        
//    }else if ([periodType isEqualToString:@"month"]){
//        
//        float allMoney = investMoney + (investMoney * oldAnnual * oldMonth / 12 /100);//到期后总还款
////         NSLog(@"oldAnnual%.2f oldDay%.2f investMoney%.2f allMoney%.2f myDay%d  oldDay%f",oldAnnual,oldDay, investMoney,allMoney, myDay, oldDay);
//        float realy = (allMoney - m) *360 / m / (oldDay - myDay) * 100;
//        if (realy <= 100) {
//            realyLabel.text = [NSString stringWithFormat:@"%.2f%%", realy];
//        }else{
//            realyLabel.text = @"0.00%";
//        }
//        
//    }
    
    
    if (m > max) {
        m = max;
        moneyTF.text = [NSString stringWithFormat:@"%.2f", max];
        UILabel *getMoneyLabel = [self.view viewWithTag:120];
        float charge = m * poundage;
        getMoneyLabel.text = [NSString stringWithFormat:@"%.2f", (m - charge)];
        UILabel *chargeLabel = [self.view viewWithTag:130];
        chargeLabel.text = [NSString stringWithFormat:@"%.2f", charge];
//        UILabel *realyLabel = [self.view viewWithTag:140];

//        NSString *periodType = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"period_type"]];
//        if ([periodType isEqualToString:@"day"]) {
//            
//            float allMoney = investMoney + (investMoney * oldAnnual *oldDay / 360 / 100 );//到期后总还款
////            NSLog(@"oldAnnual%foldDay%f",oldAnnual,oldDay);
//            float realy = (allMoney - m) *360 / m / (oldDay - myDay) * 100;
//            realyLabel.text = [NSString stringWithFormat:@"%.2f%%", realy];
//        }else if ([periodType isEqualToString:@"month"]){
//            float allMoney = investMoney + (investMoney * oldAnnual * oldMonth / 12 /100);//到期后总还款
//            float realy = (allMoney - m) *360 / m / (oldDay - myDay) * 100;
//            realyLabel.text = [NSString stringWithFormat:@"%.2f%%", realy];
//
//        }

        return NO;
    }
     NSArray *array=[s componentsSeparatedByString:@"."];
    if (array.count==2) {
        NSString *s2=[NSString stringWithFormat:@"%@",array[1]];
        if (s2.length>2) {
            moneyTF.text=[NSString stringWithFormat:@"%.2f",m];
            return NO;
        }
    }
    
    inputM=m;
    [self getYearParier];
   

    return YES;
}

-(void)getYearParier{
    __block float yearhua=0.00;
    
    
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"transfer" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_transfer_data" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:@"0" forKey:@"transfer_status" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"id"]] forKey:@"tender_id" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%.2f",inputM] forKey:@"borrow_money" atIndex:0];
    [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
     {

         if (success==YES) {
             NSLog(@"hhhhh%@",object);
             
             yearhua=[[object objectForKey:@"borrow_apr"] floatValue];
             NSLog(@"%f",yearhua);
             if (yearhua<100) {
                 UILabel *realyLabel = [self.view viewWithTag:140];
                 realyLabel.text=[NSString stringWithFormat:@"%.2f%%",yearhua];

             }else{
                 UILabel *realyLabel = [self.view viewWithTag:140];
                 realyLabel.text=@"0.00%";

             }
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
#pragma mark -- choseVC delegate
//代理传值获得选择的时间
- (void)choseTime:(NSString *)time {
    self.timeStr = time;
    [self.bondDetailTableView reloadData];
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
