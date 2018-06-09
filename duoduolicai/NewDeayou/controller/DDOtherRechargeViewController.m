//
//  DDOtherRechargeViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/5/12.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDOtherRechargeViewController.h"
#import "LLPayUtil.h"
#import "DYPush.h"
#import "DYReahargeRecordsVC.h"
#import "DYBankCardVC.h"
// TODO: 修改两个参数成商户自己的配置
static NSString *kLLOidPartner = @"201509281000518503";   // 商户号
static NSString *kLLPartnerKey = @"20150928100051850351duoduo_9911";   // 密钥

@interface DDOtherRechargeViewController ()<LLPaySdkDelegate,UITextFieldDelegate>
@property (nonatomic,strong) NSDictionary *UserInfo;
@property(nonatomic)int keyboardHeight;//键盘高度
@property (nonatomic, strong) NSString *Order_no;//连连支付的订单号
@property (nonatomic, retain) NSMutableDictionary *orderParam;//连连支付要求参数
@property (nonatomic, strong) NSString *bank_code;//连连的银行卡类型编号



@end

@implementation DDOtherRechargeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"充值";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recharegeBtn.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
    self.recharegeBtn.layer.masksToBounds = YES;
    self.recharegeBtn.layer.cornerRadius = 5.0;
    
    UIButton * btnRightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor = [UIColor clearColor];
    btnRightItem.frame = CGRectMake(0, 0, 80, 35);
    [btnRightItem setTitle:@"充值记录" forState:UIControlStateNormal];
    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRightItem addTarget:self action:@selector(rightBarButtonItemActionMore) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRightItem];

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
    
    CGSize btnImageSize = CGSizeMake(44, 44);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];

    // Do any additional setup after loading the view from its nib.
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.keyboardHeight=height;
    
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
    if ([UIScreen mainScreen].bounds.size.height==568) {
        [UIView animateWithDuration:0.2
                         animations:^()
         {
             self.view.transform = CGAffineTransformMakeTranslation(0, -self.keyboardHeight/2+20);//这里的坐标是与原始的比较；
             
         }];
    }else if([UIScreen mainScreen].bounds.size.height==480){
        [UIView animateWithDuration:0.2
                         animations:^()
         {
             self.view.transform = CGAffineTransformMakeTranslation(0, -self.keyboardHeight/2-50);//这里的坐标是与原始的比较；
             
         }];
    }
    
    
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.2
                     animations:^()
     {
         self.view.transform = CGAffineTransformMakeTranslation(0, 0);//这里的坐标是与原始的比较；
         
     }];
}

//充值记录
-(void)rightBarButtonItemActionMore
{
    DYReahargeRecordsVC * rechargeRecordVC=[[DYReahargeRecordsVC alloc]initWithNibName:@"DYReahargeRecordsVC" bundle:nil];
    rechargeRecordVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:rechargeRecordVC animated:YES];
    
}

#pragma mark -------获取数据


//获取用户实名信息和银行卡信息
-(void)getData
{
    
    [MBProgressHUD hudWithView:self.view label:@"数据请求中..."];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_users_bankandcert" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         self.UserInfo=object;
         //         NSLog(@"%@",self.UserInfo);
         NSString *realname=[NSString stringWithFormat:@"%@",[self.UserInfo objectForKey:@"realname"]];
         
         //         NSString *certNo = [NSString stringWithFormat:@"%@",[self.UserInfo objectForKey:@"account_all"]];
         //         NSLog(@"%@",certNo);
         if (![self isBlankString:realname]) {
             self.isBindBank=true;
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
}
//判断字符串是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if([string length]==0){
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}
#pragma mark 连连支付

//创建连连支付订单
- (void)createOrder
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *simOrder = [dateFormater stringFromDate:[NSDate date]];
    
    //生成订单号规则
    NSString *date =[NSString stringWithFormat:@"%1.f", [[NSDate date] timeIntervalSince1970]];
    int rand = (arc4random() % 9000) + 1000;
    self.Order_no = [NSString stringWithFormat:@"%@%d%d",date,rand,[DYUser GetUserID]];//订单号等于时间戳+4位随机数+用户id;
    
    NSString *signType = @"MD5";    // MD5 || RSA
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setDictionary:@{
                           @"sign_type":signType,
                           //签名方式	partner_sign_type	是	String	RSA  或者 MD5
                           @"busi_partner":@"101001",
                           //商户业务类型	busi_partner	是	String(6)	虚拟商品销售：101001
                           @"dt_order":simOrder,
                           //商户订单时间	dt_order	是	String(14)	格式：YYYYMMDDH24MISS  14位数字，精确到秒
                           //                           @"money_order":@"0.10",
                           //交易金额	money_order	是	Number(8,2)	该笔订单的资金总额，单位为RMB-元。大于0的数字，精确到小数点后两位。 如：49.65
                           @"notify_url":@"http://www.51duoduo.com/llpay/notify_url.php",
                           //服务器异步通知地址	notify_url	是	String(64)	连连钱包支付平台在用户支付成功后通知商户服务端的地址，如：http://payhttp.xiaofubao.com/back.shtml
                           @"no_order":self.Order_no,
                           //商户唯一订单号	no_order	是	String(32)	商户系统唯一订单号
                           @"name_goods":@"多多理财ios版充值",
                           //商品名称	name_goods	否	String(40)
                           @"info_order":simOrder,
                           //订单附加信息	info_order	否	String(255)	商户订单的备注信息
                           @"valid_order":@"10080",
                           //分钟为单位，默认为10080分钟（7天），从创建时间开始，过了此订单有效时间此笔订单就会被设置为失败状态不能再重新进行支付。
                           //                           @"shareing_data":@"201412030000035903^101001^10^分账说明1|201310102000003524^101001^11^分账说明2|201307232000003510^109001^12^分账说明3"
                           // 分账信息数据 shareing_data  否 变(1024)
                           
                           //                           @"risk_item":@"{\"user_info_bind_phone\":\"13958069593\",\"user_info_dt_register\":\"20131030122130\"}",
                           //风险控制参数 否 此字段填写风控参数，采用json串的模式传入，字段名和字段内容彼此对应好
                           //                           @"risk_item" : [LLPayUtil jsonStringOfObj:@{@"user_info_dt_register":@"20131030122130"}],
                           //                           @"user_id":@"",
                           //商户用户唯一编号 否 该用户在商户系统中的唯一编号，要求是该编号在商户系统中唯一标识该用户
                           // user_id，一个user_id标示一个用户
                           // user_id为必传项，需要关联商户里的用户编号，一个user_id下的所有支付银行卡，身份证必须相同
                           // demo中需要开发测试自己填入user_id, 可以先用自己的手机号作为标示，正式上线请使用商户内的用户编号
                           
                           //                           @"id_no":@"339005198403100026",
                           //证件号码 id_no 否 String
                           //                           @"acct_name":@"测试号",
                           //银行账号姓名 acct_name 否 String
                           //                           @"flag_modify":@"1",
                           //修改标记 flag_modify 否 String 0-可以修改，默认为0, 1-不允许修改 与id_type,id_no,acct_name配合使用，如果该用户在商户系统已经实名认证过了，则在绑定银行卡的输入信息不能修改，否则可以修改
                           //                           @"card_no":@"6227001540670034271",
                           //银行卡号 card_no 否 银行卡号前置，卡号可以在商户的页面输入
                           //                           @"no_agree":@"2014070900123076",
                           //签约协议号 否 String(16) 已经记录快捷银行卡的用户，商户在调用的时候可以与pay_type一块配合使用
                           }];
    
    
    //    param[@"money_order"] = _MoneyText.text;
    
    self.orderParam = param;
}
- (void)payOrder{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *simOrder = [dateFormater stringFromDate:[NSDate date]];
    
    self.orderParam[@"oid_partner"] = kLLOidPartner;
    self.orderParam[@"acct_name"]= [self.UserInfo objectForKey:@"realname"];
    self.orderParam[@"id_no"] = [self.UserInfo objectForKey:@"card_id"];//身份证
    self.orderParam[@"flag_modify"] = @"0";//是否实名认证
    self.orderParam[@"user_id"]= [NSString stringWithFormat:@"%d",[DYUser GetUserID]];
    self.orderParam[@"money_order"] = self.inPutMoney.text;
    self.orderParam[@"card_no"]= [self.UserInfo objectForKey:@"account_all"];//银行卡
    self.orderParam[@"risk_item"]=[LLPayUtil jsonStringOfObj:@{
                                                               @"frms_ware_category":@"2009",
                                                               @"user_info_mercht_userno":[NSString stringWithFormat:@"%d",[DYUser GetUserID]],
                                                               @"user_info_dt_register":simOrder,
                                                               @"use r_info_full_name":[self.UserInfo objectForKey:@"realname"],
                                                               @"user_info_id_no":[self.UserInfo objectForKey:@"card_id"],
                                                               @"user_info_identify_type":@"1",
                                                               @"us er_info_identify_state":@"1"
                                                               }];
    //    NSLog(@"%@",self.orderParam);
    LLPayUtil *payUtil = [[LLPayUtil alloc] init];
    //    payUtil.signKeyArray = @[@"acct_name",@"card_no",@"id_no",
    //                             @"id_type",@"oid_partner",@"risk_item",@"sign_type",@"user_id"];
    
    NSDictionary *signedOrder = [payUtil signedOrderDic:self.orderParam andSignKey:kLLPartnerKey];
    
    [self payWithSignedOrder:signedOrder];
}

- (void)payWithSignedOrder:(NSDictionary*)signedOrder
{
    self.sdk = [[LLPaySdk alloc] init];
    self.sdk.sdkDelegate = self;
    /*
     // 切换认证支付与快捷支付，假如并不需要切换，可以不调用这个方法（此方法为老版本使用）
     [LLPaySdk setVerifyPayState:self.bVerifyPayState];
     */
    
    //认证支付、快捷支付、预授权切换，0快捷 1认证 2预授权。假如不需要切换，可以不调用这个方法
    [LLPaySdk setLLsdkPayState:1];
    
    [self.sdk presentPaySdkInViewController:self withTraderInfo:signedOrder];
}
#pragma -mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic
{
    NSString *msg = @"支付异常";
    
    switch (resultCode) {
        case kLLPayResultSuccess:
        {
            msg = @"支付成功";
            //              NSLog(@"%@",dic);
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"])
            {
                //
                //                NSString *payBackAgreeNo = dic[@"agreementno"];
                //                _agreeNumField.text = payBackAgreeNo;
                [self.navigationController popToRootViewControllerAnimated:YES];//回到我的多多页面
            }
            else if ([result_pay isEqualToString:@"PROCESSING"])
            {
                msg = @"支付单处理中";
            }
            else if ([result_pay isEqualToString:@"FAILURE"])
            {
                msg = @"支付单失败";
            }
            else if ([result_pay isEqualToString:@"REFUND"])
            {
                msg = @"支付单已退款";
            }
        }
            break;
        case kLLPayResultFail:
        {
            msg = @"支付失败";
        }
            break;
        case kLLPayResultCancel:
        {
            msg = @"支付取消";
            [self.navigationController popToRootViewControllerAnimated:YES];//回到我的多多页面
        }
            break;
        case kLLPayResultInitError:
        {
            msg = @"sdk初始化异常";
        }
            break;
        case kLLPayResultInitParamError:
        {
            msg = dic[@"ret_msg"];
        }
            break;
        default:
            break;
    }
    [[[UIAlertView alloc] initWithTitle:@"结果"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"确认"
                      otherButtonTitles:nil] show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //    [MBProgressHUD errorHudWithView:self.view label:msg hidesAfter:2];
}

- (IBAction)toRecharge:(UIButton *)sender {
    [self.inPutMoney resignFirstResponder];
    NSLog(@"%lu,%f",(unsigned long)[self.inPutMoney.text length],[self.inPutMoney.text floatValue]);
    if([self.inPutMoney.text length]>0&&[self.inPutMoney.text floatValue]>0){
        DYBankCardVC *bankVC=[[DYBankCardVC alloc]initWithNibName:@"DYBankCardVC" bundle:nil];
        bankVC.hidesBottomBarWhenPushed=YES;
        bankVC.PayMoney=self.inPutMoney.text;
        bankVC.type=1;
        bankVC.isBindBank=self.isBindBank;
        bankVC.BankType=self.BankType;
        bankVC.BankNo=self.BankNo;
        bankVC.gotexpgold=self.gotexpgold;
        [self.navigationController pushViewController:bankVC animated:YES];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"请输入金额"];
    }

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.inPutMoney resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self toRecharge:self.recharegeBtn];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *s=[NSString stringWithFormat:@"%@%@",self.inPutMoney.text,string];

        NSArray *array=[s componentsSeparatedByString:@"."];
    if (array.count==2) {
        NSString *s2=[NSString stringWithFormat:@"%@",array[1]];
        if (s2.length>2) {
            _inPutMoney.text=[NSString stringWithFormat:@"%.2f",[s floatValue]];
            return NO;
        }
    }
    
    return YES;
}
//提交信息
-(void)checkInfoMation
{
    //    NSLog(@"%@",self.UserInfo);
    NSString * realname=[self.UserInfo objectForKey:@"realname"];
    NSString * amount=self.inPutMoney.text;
    
    NSString *cardno=[self.UserInfo objectForKey:@"account_all"];//银行卡号
    
    NSString *userid=[NSString stringWithFormat:@"%d",[DYUser GetUserID]];
    NSString *certNo=[self.UserInfo objectForKey:@"card_id"];//身份证号
    //将身份证号里面小写的x改成大写的X
    NSMutableString *certno=[NSMutableString stringWithFormat:@"%@",certNo];
    [certno replaceOccurrencesOfString:@"x" withString:@"X" options:NSLiteralSearch range:NSMakeRange(0, [certno length])];
    
    NSLog(@"%lu,%lu,%lu,%lu,%lu",(unsigned long)[realname length],(unsigned long)[amount length],(unsigned long)[cardno length],(unsigned long)[userid length],(unsigned long)[certNo length]);
    
    if (!([realname length]>0&&[amount length]>0&&[cardno length]>0&&[userid length]>0&&[certNo length]>0)) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"请填写完整信息！"];
    }
    else
    {
        
        if ([self.bank_code isEqualToString:@""]||[self.bank_code length] == 0) {
            
            DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
            [diyouDic insertObject:[NSString stringWithFormat:@"%@",cardno] forKey:@"CertNo" atIndex:0];
            [DYPush operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
             {
                 
                 if (success) {
                     NSDictionary *data=object;
                     self.bank_code = [NSString stringWithFormat:@"%@",data[@"bank_code"]];
                     NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                     [ud setObject:self.bank_code forKey:@"bank_code"];
                     
                     DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
                     [diyouDic1 insertObject:@"account" forKey:@"module" atIndex:0];
                     [diyouDic1 insertObject:@"recharge_lianlian_submit" forKey:@"q" atIndex:0];
                     [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
                     [diyouDic1 insertObject:self.Order_no forKey:@"no_order" atIndex:0];
                     [diyouDic1 insertObject:realname forKey:@"real_name" atIndex:0];
                     [diyouDic1 insertObject:amount forKey:@"account" atIndex:0];
                     [diyouDic1 insertObject:cardno forKey:@"card_no" atIndex:0];
                     [diyouDic1 insertObject:userid forKey:@"user_id" atIndex:0];
                     [diyouDic1 insertObject:certno forKey:@"cert_no" atIndex:0];
                     [diyouDic1 insertObject:self.bank_code forKey:@"bank_code" atIndex:0];
                     [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
                     [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
                      {
                          if (success==YES) {
                              //                              NSLog(@"%@",object);
                              [self payOrder];//操作连连支付的SDK
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
                 
             } errorBlock:^(id error)
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [LeafNotification showInController:self withText:@"网络异常"];
             }];
            
        }else{
            DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
            [diyouDic1 insertObject:@"account" forKey:@"module" atIndex:0];
            [diyouDic1 insertObject:@"recharge_lianlian_submit" forKey:@"q" atIndex:0];
            [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
            [diyouDic1 insertObject:self.Order_no forKey:@"no_order" atIndex:0];
            [diyouDic1 insertObject:realname forKey:@"real_name" atIndex:0];
            [diyouDic1 insertObject:amount forKey:@"account" atIndex:0];
            [diyouDic1 insertObject:cardno forKey:@"card_no" atIndex:0];
            [diyouDic1 insertObject:userid forKey:@"user_id" atIndex:0];
            [diyouDic1 insertObject:certno forKey:@"cert_no" atIndex:0];
            [diyouDic1 insertObject:self.bank_code forKey:@"bank_code" atIndex:0];
            [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
            [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
             {
                 if (success==YES) {
                     //                     NSLog(@"%@",object);
                     [self payOrder];//操作连连支付的SDK
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
        
    }
    
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
