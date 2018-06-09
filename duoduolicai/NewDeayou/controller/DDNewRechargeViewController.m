//
//  DDNewRechargeViewController.m
//  NewDeayou
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDNewRechargeViewController.h"
#import "DYBankInfoViewController.h"

#import "DYPush.h"

#import "LLPayUtil.h"

#import "DYReahargeRecordsVC.h"

#import "DYBankCardVC.h"



#define kScreen_Width   [UIScreen mainScreen].bounds.size.width
#define kScreen_Height  [UIScreen mainScreen].bounds.size.height
#define kBank_Left      40
#define kTopImage_Width  30
#define kBankLabel_Left  35
#define kNumber_Left     20
#define kBankLabel_Width 40
#define kBankLabel_Height 15
#define kNumber_Width    70

#define kCenterView_Width   100
#define kGold_Right    40
#define kGoldLabel_Right   30
#define kGoldLabel_Width   50


// TODO: 修改两个参数成商户自己的配置
static NSString *kLLOidPartner = @"201606211000919508";   // 商户号
static NSString *kLLPartnerKey = @"20150928100051850351duoduo_9911";   // 密钥

@interface DDNewRechargeViewController ()<UIScrollViewDelegate,LLPaySdkDelegate,UITextFieldDelegate>
{
    UIScrollView *ascrollView;
}
@property (nonatomic,strong) NSDictionary *UserInfo;
@property (nonatomic, strong) NSString *Order_no;//连连支付的订单号
@property (nonatomic, retain) NSMutableDictionary *orderParam;//连连支付要求参数
@property (nonatomic, strong) NSString *bank_code;//连连的银行卡类型编号
@property(nonatomic)int keyboardHeight;//键盘高度

@property(nonatomic)BOOL isGetRecharge100;
@property(nonatomic)BOOL isGetRecharge1000;


@end

@implementation DDNewRechargeViewController
- (void)dealloc
{
    self.sdk = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航右边的按钮
    UIButton * btnRightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor = [UIColor clearColor];
    btnRightItem.frame = CGRectMake(0, 0, 80, 35);
    [btnRightItem setTitle:@"充值记录" forState:UIControlStateNormal];
    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRightItem addTarget:self action:@selector(rightBarButtonItemActionMore) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"充值";
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
    _backView.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
    [self.view addSubview:self.backView];
    
    
    ascrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    ascrollView.contentSize = CGSizeMake(kScreen_Width, kScreen_Height * 1.2);
    ascrollView.contentOffset = CGPointMake(0, 0);
//    scrollView.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
    ascrollView.showsHorizontalScrollIndicator = NO;
    ascrollView.showsVerticalScrollIndicator = NO;
    ascrollView.delegate = self;
    [self.view addSubview:ascrollView];
    
    [ascrollView addSubview:self.redView];
    [ascrollView addSubview:self.bankImage];
    [ascrollView addSubview:self.bankLabel];
    [ascrollView addSubview:self.bankNumber];
    [ascrollView addSubview:self.moneyLabel];
    [ascrollView addSubview:self.shearImage];
    [ascrollView addSubview:self.arriveLabel];
    [ascrollView addSubview:self.goldImage];
    [ascrollView addSubview:self.goldLabel];
    [ascrollView addSubview:self.restLabel];
    [ascrollView addSubview:self.hundredBtn];
    [ascrollView addSubview:self.hundredImage];
    [ascrollView addSubview:self.thousandBtn];
    [ascrollView addSubview:self.thousandImage];
    [ascrollView addSubview:self.rmbImage];
    [ascrollView addSubview:self.moneyTF];
    [ascrollView addSubview:self.limitLabel];
    [ascrollView addSubview:self.nextBtn];
    [ascrollView addSubview:self.safeLabel];

    //获取用户实名信息和银行卡信息
//    [self getData];
//    
//    [self createOrder];
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
    
    
    
    // Do any additional setup after loading the view.
}

- (UIView *)redView {
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, CGRectGetMaxY(self.thousandBtn.frame) + 30)];
    _redView.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
    return _redView;
}

- (UIImageView *)bankImage {
    self.bankImage = [[UIImageView alloc] initWithFrame:CGRectMake(kBank_Left, kBank_Left / 3, kTopImage_Width, kTopImage_Width)];
    NSString *imageurl=@"";
    switch (self.BankType) {
        case 3:
        {
            imageurl=@"银行logo_工行.png";
        }
            break;
        case 4:
        {
            imageurl=@"银行logo_农业.png";
        }
            break;
        case 1:
        {
            imageurl=@"银行logo_建行.png";
        }
            break;
        case 11:
        {
            imageurl=@"银行logo_民生.png";
        }
            break;
        case 2:
        {
            imageurl=@"银行logo_中国银行.png";
        }
            break;
        case 6:
        {
            imageurl=@"银行logo_兴业银行.png";
        }
            break;
        case 10:
        {
            imageurl=@"银行logo_光大银行.png";
        }
            break;
        case 14:
        {
            imageurl=@"银行logo_中信银行.png";
        }
            break;
        case 7:
        {
            imageurl=@"银行logo_平安银行.png";
        }
            break;
        case 8:
        {
            imageurl=@"银行logo_邮政.png";
        }
            break;
        case 13:
        {
            imageurl=@"银行logo_交行.png";
        }
            break;
        case 9:
        {
            imageurl=@"招商银行logo_75.png";
        }
            break;
        case 16:
        {
            imageurl=@"银行logo_浦发.png";
        }
            break;
        case 15:
        {
            imageurl=@"银行logo_广发.png";
        }
            break;
        case 17:
        {
            imageurl=@"银行logo_华夏.png";
        }
            break;
            
        default:
            break;
    }
    _bankImage.image=[UIImage imageNamed:imageurl];
    _bankImage.backgroundColor=[UIColor whiteColor];
    _bankImage.layer.masksToBounds=YES;
    _bankImage.layer.cornerRadius=5.0;
    return _bankImage;
}

- (UILabel *)bankLabel {
    self.bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBankLabel_Left, CGRectGetMaxY(self.bankImage.frame) + 2, kBankLabel_Width, kBankLabel_Height)];
    _bankLabel.textAlignment = NSTextAlignmentCenter;
    _bankLabel.font = [UIFont systemFontOfSize:10];
    _bankLabel.textColor = [UIColor whiteColor];
//    _bankLabel.backgroundColor = [UIColor greenColor];
    
    NSString *bankname=@"";
    switch (self.BankType) {
        case 3:
        {
            bankname=@"工商银行";
        }
            break;
        case 4:
        {
            bankname=@"农业银行";
        }
            break;
        case 1:
        {
            bankname=@"建设银行";
        }
            break;
        case 11:
        {
            bankname=@"民生银行";
        }
            break;
        case 2:
        {
            bankname=@"中国银行";
        }
            break;
        case 6:
        {
            bankname=@"兴业银行";
        }
            break;
        case 10:
        {
            bankname=@"光大银行";
        }
            break;
        case 14:
        {
            bankname=@"中信银行";
        }
            break;
        case 7:
        {
            bankname=@"平安银行";
        }
            break;
        case 8:
        {
            bankname=@"中国邮政";
        }
            break;
        case 13:
        {
            bankname=@"交通银行";
        }
            break;
        case 9:
        {
            bankname=@"招商银行";
        }
            break;
        case 16:
        {
            bankname=@"浦发银行";
        }
            break;
        case 15:
        {
            bankname=@"广发银行";
        }
            break;
        case 17:
        {
            bankname=@"华夏银行";
        }
            break;
            
        default:
            break;
    }
    _bankLabel.text = bankname;
    return _bankLabel;
}

- (UILabel *)bankNumber {
    self.bankNumber = [[UILabel alloc] initWithFrame:CGRectMake(kNumber_Left, CGRectGetMaxY(self.bankLabel.frame), kNumber_Width, kBankLabel_Height)];
//    _bankNumber.backgroundColor = [UIColor yellowColor];
    _bankNumber.textAlignment = NSTextAlignmentCenter;
    _bankNumber.textColor = [UIColor whiteColor];
    _bankNumber.font = [UIFont systemFontOfSize:10];
    _bankNumber.text = [NSString stringWithFormat:@"储蓄卡(%@)",[self.Bankno substringFromIndex:self.Bankno.length-4]];;
    return _bankNumber;
}

- (UILabel *)moneyLabel {
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width / 2 - kCenterView_Width / 2, 25, kCenterView_Width, kBankLabel_Height)];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.textColor = [UIColor whiteColor];
    _moneyLabel.alpha = 0.5;
    _moneyLabel.font = [UIFont systemFontOfSize:13];
    _moneyLabel.text = @"金额";
    return _moneyLabel;
}

- (UIImageView *)shearImage {
    self.shearImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width / 2 - kCenterView_Width / 2, CGRectGetMaxY(self.moneyLabel.frame), kCenterView_Width, 5)];
    _shearImage.image = [UIImage imageNamed:@"提现页面_03.png"];
    return _shearImage;
}

- (UILabel *)arriveLabel {
    self.arriveLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width / 2 - kCenterView_Width / 2, CGRectGetMaxY(self.shearImage.frame), kCenterView_Width, kBankLabel_Height)];
    _arriveLabel.textAlignment = NSTextAlignmentCenter;
    _arriveLabel.alpha = 0.5;
    _arriveLabel.textColor = [UIColor whiteColor];
    _arriveLabel.font = [UIFont systemFontOfSize:13];
    _arriveLabel.text = @"实时到账";
    return _arriveLabel;
}

- (UIImageView *)goldImage {
    self.goldImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - kGold_Right - kTopImage_Width, kGold_Right / 3, kTopImage_Width, kTopImage_Width)];
    _goldImage.image = [UIImage imageNamed:@"充值页面2_05.png"];
    return _goldImage;
}

- (UILabel *)goldLabel {
    self.goldLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - kGoldLabel_Right - kGoldLabel_Width, CGRectGetMaxY(self.goldImage.frame) + 2, kGoldLabel_Width, kBankLabel_Height)];
    _goldLabel.textAlignment = NSTextAlignmentCenter;
    _goldLabel.textColor = [UIColor whiteColor];
    _goldLabel.font = [UIFont systemFontOfSize:10];
    _goldLabel.text = @"多多理财";
    return _goldLabel;
}

- (UILabel *)restLabel {
    self.restLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - kGoldLabel_Width - kGoldLabel_Right, CGRectGetMaxY(self.goldLabel.frame), kGoldLabel_Width, kBankLabel_Height)];
    _restLabel.textAlignment = NSTextAlignmentCenter;
    _restLabel.textColor = [UIColor whiteColor];
    _restLabel.font = [UIFont systemFontOfSize:10];
    _restLabel.text = @"(可用余额)";
    return _restLabel;
}

- (UIButton *)hundredBtn {
    self.hundredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _hundredBtn.frame = CGRectMake(kNumber_Left, CGRectGetMaxY(self.restLabel.frame) + 20, kScreen_Width - 2 * kNumber_Left, 60);
    [_hundredBtn setBackgroundImage:[UIImage imageNamed:@"充值100.png"] forState:UIControlStateNormal];
    [_hundredBtn addTarget:self action:@selector(handleHundred:) forControlEvents:UIControlEventTouchUpInside];
    _hundredBtn.tag=100;
    return _hundredBtn;
}

- (UIImageView *)hundredImage {
    self.hundredImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.hundredBtn.frame) - 50, CGRectGetMinY(self.hundredBtn.frame) + 15, 40, 30)];
    _hundredImage.image = [UIImage imageNamed:@"充值页面_06.png"];
    _hundredImage.hidden=YES;
    return _hundredImage;
}
//充值100按钮响应事件
- (void)handleHundred:(UIButton *)sender {
    sender.enabled=NO;
    _hundredImage.hidden=NO;
    UIButton *bnt=[self.view viewWithTag:1000];
    bnt.enabled=YES;
    _thousandImage.hidden=YES;
    _moneyTF.text=@"100";
}
- (UIButton *)thousandBtn {
    self.thousandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _thousandBtn.frame = CGRectMake(kNumber_Left, CGRectGetMaxY(self.hundredBtn.frame) + 20, kScreen_Width - 2 * kNumber_Left, 60);
    [_thousandBtn setBackgroundImage:[UIImage imageNamed:@"充值1000.png"] forState:UIControlStateNormal];
    [_thousandBtn addTarget:self action:@selector(handleThousand:) forControlEvents:UIControlEventTouchUpInside];
    _thousandBtn.tag=1000;
    return _thousandBtn;
}
- (UIImageView *)thousandImage {
    self.thousandImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.thousandBtn.frame) - 50, CGRectGetMinY(self.thousandBtn.frame) + 15, 40, 30)];
    _thousandImage.image = [UIImage imageNamed:@"充值页面_06.png"];
    _thousandImage.hidden=YES;
    return _thousandImage;
}
//充值1000按钮响应事件
- (void)handleThousand:(UIButton *)sender {
    UIButton *bnt=[self.view viewWithTag:100];
    bnt.enabled=YES;
    _hundredImage.hidden=YES;
    sender.enabled=NO;
    _thousandImage.hidden=NO;
    _moneyTF.text=@"1000";
}
- (UIImageView *)rmbImage {
    self.rmbImage = [[UIImageView alloc] initWithFrame:CGRectMake(kNumber_Left, CGRectGetMaxY(self.redView.frame) + 8, 30, 30)];
    _rmbImage.image = [UIImage imageNamed:@"充值页面_15@2x.png"];
    
    return _rmbImage;
}

- (UITextField *)moneyTF {
    self.moneyTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.rmbImage.frame) + 5, CGRectGetMaxY(self.redView.frame) + 3, kScreen_Width - CGRectGetMaxX(self.rmbImage.frame) - 3, 40)];
    _moneyTF.placeholder = @"输入充值金额";
    _moneyTF.delegate = self;
//    _moneyTF.borderStyle = UITextBorderStyleRoundedRect;
    _moneyTF.text=@"200";
    _moneyTF.font = [UIFont systemFontOfSize:14];
    return _moneyTF;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [_moneyTF resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self ComfirmBnt:self.RechargeBnt];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *s=@"";
    if (range.length==1) {
        s=[_moneyTF.text substringToIndex:_moneyTF.text.length-1];
    }else{
        s=[NSString stringWithFormat:@"%@%@",_moneyTF.text,string];
    }
    
    if ([s intValue]==100) {
        _thousandBtn.enabled=YES;
        _hundredBtn.enabled=NO;
        _hundredImage.hidden=NO;
        _thousandImage.hidden=YES;
    }else if([s intValue]==1000){
        _thousandBtn.enabled=NO;
        _hundredBtn.enabled=YES;
        _hundredImage.hidden=YES;
        _thousandImage.hidden=NO;
    }else{
        _thousandBtn.enabled=YES;
        _hundredBtn.enabled=YES;
        _hundredImage.hidden=YES;
        _thousandImage.hidden=YES;
        
    }
    NSArray *array=[s componentsSeparatedByString:@"."];
    if (array.count==2) {
        NSString *s2=[NSString stringWithFormat:@"%@",array[1]];
        if (s2.length>2) {
            _moneyTF.text=[NSString stringWithFormat:@"%.2f",[s floatValue]];
            return NO;
        }
    }
    return YES;
}

- (UILabel *)limitLabel {
    self.limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(kNumber_Left, CGRectGetMaxY(self.moneyTF.frame) + 10, kScreen_Width - kNumber_Left, 20)];
    _limitLabel.font = [UIFont systemFontOfSize:13];
    
    NSString *LimtMoney=@"";
    switch (self.BankType) {
        case 3:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
        case 4:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
        case 1:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
        case 11:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
        case 2:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
        case 6:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
        case 10:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
        case 14:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
        case 7:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
        case 8:
        {
            LimtMoney=@"充值限额: 单笔5000，单日5000，单月15万";
        }
            break;
        case 13:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
        case 9:
        {
            LimtMoney=@"充值限额: 单笔1万，单日1万，单月不限";
        }
            break;
        case 16:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
        case 15:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
        case 17:
        {
            LimtMoney=@"充值限额: 单笔5万，单日5万，单月20万";
        }
            break;
            
        default:
            break;
    }
    _limitLabel.text = LimtMoney;
    return _limitLabel;
}

- (UIButton *)nextBtn {
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(40, CGRectGetMaxY(self.limitLabel.frame) + 20, kScreen_Width - 2 * 40, 40);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
    
    [_nextBtn.layer setMasksToBounds:YES];
    [_nextBtn.layer setCornerRadius:5.0];
    return _nextBtn;
}

- (UILabel *)safeLabel {
    self.safeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kNumber_Left, CGRectGetMaxY(self.nextBtn.frame) + 20, kScreen_Width - kNumber_Left, 20)];
    _safeLabel.font = [UIFont systemFontOfSize:13];
    _safeLabel.text = @"账户资金安全由人保PICC保险保障";
    return _safeLabel;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
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
    NSString *txtMoney=self.moneyTF.text;
    if (self.isGetRecharge100&&self.isGetRecharge1000) {
//        txtMoney=self.TxtMoney2.text;
    }
    self.orderParam[@"money_order"] = txtMoney;
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
                if (self.isLingqianBao) {
                    NSString * amount=self.moneyTF.text;
                    if (self.isGetRecharge100&&self.isGetRecharge1000) {
//                        amount=self.TxtMoney2.text;
                    }
                    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
                    [diyouDic insertObject:@"lqb" forKey:@"module" atIndex:0];
                    [diyouDic insertObject:@"info_lqb" forKey:@"q" atIndex:0];
                    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
                    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
                    [diyouDic insertObject:amount forKey:@"amount" atIndex:0];
                    [diyouDic insertObject:@"1" forKey:@"type" atIndex:0];//余额转入
                    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
                    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
                     {
                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                         if (success==YES) {
                             //可用信用额度数据填充
                             [self.tabBarController setSelectedIndex:1];//0:首页，1：零钱包，2：投资，3：更多
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
                    
                }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];//回到我的多多页面
                }
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
