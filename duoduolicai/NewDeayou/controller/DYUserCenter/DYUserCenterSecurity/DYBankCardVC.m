//
//  DYBankCardVC.m
//  NewDeayou
//
//  Created by diyou on 14-8-9.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYBankCardVC.h"
#import "DYPayPasswordVC.h"
#import "DYBankInfoViewController.h"

#import "DYPush.h"

#import "LLPayUtil.h"


// TODO: 修改两个参数成商户自己的配置
static NSString *kLLOidPartner = @"201509281000518503";   // 商户号
static NSString *kLLPartnerKey = @"20150928100051850351duoduo_9911";   // 密钥

#define kBankCard         @"bankCard" //当前卡号
#define kBank             @"newBank"//银行
#define kOpenLocation     @"openLocation"//开户所在省
#define kOpenCity         @"opencity"//开户所在市
#define kOpenBank         @"openBank"//开户行




@interface DYBankCardVC ()<UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate,LLPaySdkDelegate>
{
    
    BOOL isSelectCity;
}
@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (strong, nonatomic) IBOutlet UIView *viewContent;
@property (strong, nonatomic) IBOutlet UIView *viewPeople;
@property (strong, nonatomic) IBOutlet UIView *viewMoney;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong,nonatomic)NSArray *aryBankList;
@property (strong,nonatomic)NSArray *arycitylist;
@property (strong,nonatomic)NSArray *arylist;
@property (strong,nonatomic)NSMutableDictionary * dicInfo;


@property (weak, nonatomic) IBOutlet UITextField *CertNoText;//银行卡号
@property (weak, nonatomic) IBOutlet UITextField *MoneyText;//金额
@property (weak, nonatomic) IBOutlet UITextField *CardIDText;//身份证号
@property (weak, nonatomic) IBOutlet UITextField *RealNameText;//开户名
@property (strong,nonatomic)NSDictionary *UserInfo;//用户实名信息和银行卡信息

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (nonatomic) int isFirst;

@property (nonatomic, strong) NSString *Order_no;//连连支付的订单号
@property (nonatomic, retain) NSMutableDictionary *orderParam;//连连支付要求参数
@property (nonatomic, strong) NSString *bank_code;//连连的银行卡类型编号
@end

@implementation DYBankCardVC

- (void)dealloc
{
    self.sdk = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"充值";
    }
    return self;
}
-(void)loadView
{
    [super loadView];
    
    self.viewHead.layer.cornerRadius=5;
    self.viewHead.layer.borderWidth=0.5;
    self.viewHead.layer.borderColor=[[UIColor lightGrayColor]CGColor];

    
    self.viewContent.layer.cornerRadius=5;
    self.viewContent.layer.borderWidth=0.5;
    self.viewContent.layer.borderColor=[[UIColor lightGrayColor]CGColor];

    self.viewPeople.layer.cornerRadius = 5;
    self.viewPeople.layer.borderWidth = 0.5;
    self.viewPeople.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    self.viewMoney.layer.cornerRadius = 5;
    self.viewMoney.layer.borderWidth = 0.5;
    self.viewMoney.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.btnConfirm.layer.cornerRadius=5;
    
    self.MoneyText.delegate=self;
    [self.MoneyText addTarget:self action:@selector(backgroundTap) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    if (self.isFirstName == 1) {
        //假如是实名认证过来的
       
    }
    
    CGSize btnImageSize = CGSizeMake(44, 44);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    self.bank_code= [NSString stringWithFormat:@"%@",[ud objectForKey:@"bank_code"]];
    [self createOrder];
    
}
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
    self.orderParam[@"acct_name"]= _RealNameText.text;
    self.orderParam[@"id_no"] = _CardIDText.text;
    self.orderParam[@"flag_modify"] = @"0";//是否实名认证
    self.orderParam[@"user_id"]= [NSString stringWithFormat:@"%d",[DYUser GetUserID]];
    self.orderParam[@"money_order"] = _MoneyText.text;
    self.orderParam[@"card_no"]= _CertNoText.text;
    self.orderParam[@"risk_item"]=[LLPayUtil jsonStringOfObj:@{
                                                               @"frms_ware_category":@"2009",
                                                               @"user_in fo_mercht_userno":[NSString stringWithFormat:@"%d",[DYUser GetUserID]],
                                                               @"user_inf o_dt_register":simOrder,
                                                               @"use r_info_full_name":_RealNameText.text,
                                                               @"user_info_id_no":_CardIDText.text,
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
                NSString *payBackAgreeNo = dic[@"agreementno"];
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

- (void)backgroundTap{
    [self.MoneyText resignFirstResponder];
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)setInfoWithDic:(NSDictionary *)dic{
    if ([[dic objectForKey:@"num"] length]>0) {
        self.RealNameText.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realname"]];
        self.CardIDText.text   = [NSString stringWithFormat:@"%@",[dic objectForKey:@"certNo"]];
        self.CertNoText.text   = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cardno"]];
        self.MoneyText.text    = [NSString stringWithFormat:@"%@",[dic objectForKey:@"amount"]];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获取用户信息
    [self getUserData];
    //获取银行类型
    _aryBankList=@[@{@"id":@"3",@"bankName":@"中国工商银行"},
                   @{@"id":@"4",@"bankName":@"中国农业银行"},
                   @{@"id":@"1",@"bankName":@"中国建设银行"},
                   @{@"id":@"11",@"bankName":@"民生银行"},
                   @{@"id":@"2",@"bankName":@"中国银行"},
                   @{@"id":@"6",@"bankName":@"兴业银行"},
                   @{@"id":@"10",@"bankName":@"光大银行"},
                   @{@"id":@"14",@"bankName":@"中信银行"},
                   @{@"id":@"7",@"bankName":@"平安银行"},
                   @{@"id":@"8",@"bankName":@"中国邮政"},
                   @{@"id":@"13",@"bankName":@"交通银行"}];
    
    //获取用户实名信息和银行卡信息
    [self getData];
    
    isSelectCity=NO;
    
    self.dicInfo=[[NSMutableDictionary alloc]init];
        self.viewHead.frame=CGRectMake(8, 14, [UIScreen mainScreen].bounds.size.width-10, self.viewHead.bounds.size.height);
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
         self.isFirst=1;
         
         self.UserInfo=object;
//         NSLog(@"%@",self.UserInfo);
         NSString *realname=[NSString stringWithFormat:@"%@",[self.UserInfo objectForKey:@"realname"]];
         
         NSString *certNo = [NSString stringWithFormat:@"%@",[self.UserInfo objectForKey:@"account_all"]];
//         NSLog(@"%@",certNo);
         if (![self isBlankString:realname]) {
             self.isFirst=0;
             self.RealNameText.text=realname;//开户名
             self.RealNameText.userInteractionEnabled=NO;//设置为只读
             self.CardIDText.text=[NSString stringWithFormat:@"%@",[self.UserInfo objectForKey:@"card_id"]];//身份证号
             self.CardIDText.userInteractionEnabled=NO;
         }else{
             self.RealNameText.text=@"";//开户名
             self.CardIDText.text=@"";
         }
         self.isFirst=1;
         if (![self isBlankString:certNo]) {
             self.isFirst=0;
             self.CertNoText.text=[NSString stringWithFormat:@"%@",[self.UserInfo objectForKey:@"account_all"]];//银行卡账号
             self.CertNoText.userInteractionEnabled=NO;
         }

             if ([[self.dic objectForKey:@"num"] length]>0) {
                 self.RealNameText.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"realname"]];
                 self.CardIDText.text   = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"certNo"]];
                 self.CertNoText.text   = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"cardno"]];
                 self.MoneyText.text    = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"amount"]];
            }

                
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
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
//获取用户信息
-(void)getUserData
{
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"dyp2p" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_users" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success==YES) {
             NSDictionary * dic=[object objectForKey:@"user_result"];
//             NSLog(@"姓名为%@",dic);
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]] forKey:@"userid"];//本地存储userid
             

             NSString *paypassword=[NSString stringWithFormat:@"%@",[dic objectForKey:@"paypassword"]];
             if([paypassword length]>0){
             }else{
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"未设置支付密码" message:@"未设置支付密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                 [alert show];
             }
         }
         else
         {
             [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
     }];

    
}
//解绑
- (IBAction)Unbind:(id)sender {
    DYBankInfoViewController *VC = [[DYBankInfoViewController alloc]initWithNibName:@"DYBankInfoViewController" bundle:nil];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark---UIAlertviewdelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    DYPayPasswordVC * setPasswordVC=[[DYPayPasswordVC alloc]initWithNibName:@"DYPayPasswordVC" bundle:nil];
    setPasswordVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:setPasswordVC animated:YES];
}
#pragma mark---textfielddelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGFloat hight;
  
    int height=[UIScreen mainScreen].bounds.size.height;
    if (textField.tag==10001||textField.tag==10000||textField.tag==10002) {
        hight=0;
    }
    else
    {
        if (height==480) {
             hight=-100;
        }
       
    }
 
     [UIView animateWithDuration:0.2
                     animations:^()
     {
         self.view.transform = CGAffineTransformMakeTranslation(0, hight);//这里的坐标是与原始的比较；
         
     }];

    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 10001:
        {
             [_dicInfo setObject:textField.text forKey:kBankCard];
            
        }
            break;
        case 10005:
        {
//            [_dicInfo setObject:textField.text forKey:kOpenBank];
        }
            break;
        case 10002:
        {
            DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
            [diyouDic insertObject:self.CertNoText.text forKey:@"CertNo" atIndex:0];
            [DYPush operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
             {
                 
                 if (success) {
                     NSDictionary *data=object;
//                     self.CertTypeText.text=[NSString stringWithFormat:@"%@",data[@"ret_msg"]];
                     self.bank_code = [NSString stringWithFormat:@"%@",data[@"bank_code"]];
                     NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                     [ud setObject:self.bank_code forKey:@"bank_code"];
                 }
                 
             } errorBlock:^(id error)
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
             }];

        }
            break;
    
        default:
            break;
    }
    
}
- (IBAction)btnActiin:(id)sender {
    
    UIButton * btn=sender;
    
    switch (btn.tag) {
        case 1000://选择银行卡类别
        {
            
//            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
//            sheet.tag=btn.tag;
//            for (int i=0; i<self.aryBankList.count; i++) {
//                NSDictionary * dic=self.aryBankList[i];
//                [sheet addButtonWithTitle:[dic objectForKey:@"bankName"]];
//            }
//            
//            [sheet showInView:self.view];
        }
            
            break;
        default:
            break;
    }
    
    
}
//提交信息
- (IBAction)cofirmUpdata:(id)sender {
    
    [self.MoneyText resignFirstResponder];
    [MBProgressHUD hudWithView:self.view label:@"提交中..."];
    
//    [UIView animateWithDuration:0.2 animations:^(){
//        self.view.transform = CGAffineTransformMakeTranslation(0, 0);//这里的坐标是与原始的比较；
//    }];
   
    [self checkInfoMation];
   
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.MoneyText resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.MoneyText resignFirstResponder];
    return YES;
}
#pragma mark--actionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (actionSheet.tag) {
        case 1000:
        {
            NSDictionary * dic=self.aryBankList[buttonIndex];
            UILabel * lab=(UILabel*)[self.view viewWithTag:10002];
            lab.text=[dic objectForKey:@"bankName"];
            lab.textColor=[UIColor blackColor];
            [_dicInfo setObject:dic forKey:kBank];
            
        }
            break;
        default:
            break;
    }

    
}

//提交信息
-(void)checkInfoMation
{
    NSString * realname=self.RealNameText.text;
    NSString * amount=self.MoneyText.text;
    
    NSString *cardno=self.CertNoText.text;//银行卡号

    NSString *userid=[NSString stringWithFormat:@"%d",[DYUser GetUserID]];
    NSString *certNo=self.CardIDText.text;//身份证号
    //将身份证号里面小写的x改成大写的X
    NSMutableString *certno=[NSMutableString stringWithFormat:@"%@",certNo];
    [certno replaceOccurrencesOfString:@"x" withString:@"X" options:NSLiteralSearch range:NSMakeRange(0, [certno length])];
    
    
    if (!([realname length]>0&&[amount length]>0&&[cardno length]>0&&[userid length]>0&&[certNo length]>0)) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD errorHudWithView:self.view label:@"请填写完整信息！" hidesAfter:1];
        
        
        
    }
    else
    {
 
        if ([self.bank_code isEqualToString:@""]||[self.bank_code length] == 0) {
            
            DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
            [diyouDic insertObject:[NSString stringWithFormat:@"%@",self.CertNoText.text] forKey:@"CertNo" atIndex:0];
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
                              [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
                          }
                          
                      } errorBlock:^(id error)
                      {
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
                      }];
                     
                     
                 }
                 
             } errorBlock:^(id error)
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
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
                     [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
                 }
                 
             } errorBlock:^(id error)
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
             }];
            
            
        }
        
     }

 }



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
