//
//  DDRechargeViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/20.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDRechargeViewController.h"
#import "DYBankInfoViewController.h"
#import "DDPassWordAlertView.h"
#import "DYPush.h"
#import "DYSafeViewController.h"

#import "DYReahargeRecordsVC.h"
#import "DYInvestSubmitVC.h"
//#import <CustomAlertView.h>
#define kPhoneNumber         kefu_phone_title
#define CUSTOMER_SERVICE_PHONE [NSURL URLWithString:kefu_phone]


@interface DDRechargeViewController ()<UITextFieldDelegate>
{
    DDPassWordAlertView * alertview;
    UIView * background;
}
@property (nonatomic,strong) NSDictionary *UserInfo;
@property (nonatomic) BOOL isHaveDian;
@property (nonatomic, strong) NSString *Order_no;//连连支付的订单号
@property (nonatomic, retain) NSMutableDictionary *orderParam;//连连支付要求参数
@property (nonatomic, strong) NSString *bank_code;//连连的银行卡类型编号

@property (weak, nonatomic) IBOutlet UIImageView *BankLogo;//银行图片
@property (weak, nonatomic) IBOutlet UILabel *BankNameLabel;//银行名称
@property (weak, nonatomic) IBOutlet UILabel *BankNo;//储蓄卡(7599)
@property(nonatomic)int keyboardHeight;//键盘高度

@property (nonatomic, strong) NSDictionary *orderDic;
@property (weak, nonatomic) IBOutlet UILabel *PayType2;

@property (weak, nonatomic) IBOutlet UIButton *kefu2Btn;
@property (nonatomic, strong) NSDictionary *bankDic;
@property (nonatomic, strong) NSDictionary *bankIcon;
@end

@implementation DDRechargeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"充值";
        
        
        
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"account_chongzhi1"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    CGRect frame = CGRectMake(0, 0, kMainScreenWidth,[UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height);
    UIImage *image = [DYUtils gradientImageWithBounds:frame andColors:@[kShallowColor,kDeepColor] andGradientType:1];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.barTintColor  = kBtnColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:17]}];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"account_chongzhi1"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.barTintColor  = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:17]}];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
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
     self.icon.transform = CGAffineTransformMakeScale(.6, .6);
    // Do any additional setup after loading the view from its nib.
    self.TopView.backgroundColor= kBtnColor;
    UIImage *image = [DYUtils gradientImageWithBounds:self.topImage.bounds andColors:@[kShallowColor,kDeepColor] andGradientType:1];
    self.topImage.image = image;
    
    [self.kefu2Btn addTarget:self action:@selector(openPhone) forControlEvents:UIControlEventTouchDown];
    
    self.BankLogo.layer.masksToBounds=YES;
    [self.BankLogo.layer setCornerRadius:5.0];
    CALayer *layer = [self.RechargeBnt2 layer];
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.3;
    self.RechargeBnt2.backgroundColor = kBtnColor;
    
    
    self.TxtMoney2.delegate = self;
    
    if (self.Bankno) {
        self.BankLogo.image = [UIImage imageNamed:[self.bankIcon objectForKey:self.Bankno]];
        self.BankNameLabel.text = [self.bankDic objectForKey:self.Bankno];
        NSString *bankNumber = [self.mybankNumber substringFromIndex:self.mybankNumber.length- 4 ];
        self.BankNo.text = [NSString stringWithFormat:@"储蓄卡%@", bankNumber];
        
    }
    
    //导航右边的按钮
    UIButton * btnRightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor = [UIColor clearColor];
    btnRightItem.frame = CGRectMake(0, 0, 80, 35);
    [btnRightItem setTitle:@"充值记录" forState:UIControlStateNormal];
    btnRightItem.titleLabel.textAlignment = NSTextAlignmentRight;
    btnRightItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRightItem addTarget:self action:@selector(rightBarButtonItemActionMore) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    
    //    self.isBindBank=false;
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
   
    
//    self.BankNo.text=[NSString stringWithFormat:@"储蓄卡(%@)",[self.Bankno substringFromIndex:self.Bankno.length-4]];
    
    
    
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"whiteback"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
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
    
//    NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
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
- (IBAction)ComfirmBnt:(id)sender {
    
    
    [self.TxtMoney2 resignFirstResponder];
    float money = [self.TxtMoney2.text floatValue];
    if (money < 100) {
        [LeafNotification showInController:self withText:@"最低充值金额100元"];
        return;
    }
    [MobClick event:@"account_chongzhi2"];
    NSString *url=[NSString stringWithFormat:@"%@/action/recharge/mobilePay?money=%@&login_key=%@",ffwebURL,self.TxtMoney2.text,[DYUser GetLoginKey]];
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.hidesBottomBarWhenPushed = YES;
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"充值";
    [self.navigationController pushViewController:adVC animated:YES];
    

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
    [self.TxtMoney2 resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }else{
        self.isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHaveDian && single == '.') {
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    return NO;
                }
            }
        }
        
    }
    
    return YES;
//    NSString *s=@"";
//    if (range.length==1) {
//        s=[self.TxtMoney2.text substringToIndex:self.TxtMoney2.text.length-1];
//    }else{
//        s=[NSString stringWithFormat:@"%@%@",self.TxtMoney2.text,string];
//    }
//    NSArray *array=[s componentsSeparatedByString:@"."];
//    if (array.count==2) {
//        NSString *s2=[NSString stringWithFormat:@"%@",array[1]];
//        if (s2.length>2) {
//            
//            _TxtMoney2.text=[NSString stringWithFormat:@"%.2f",[s floatValue]];
//            return NO;
//        }
//    }
//    return YES;
}
#pragma  mark 限额说明
- (IBAction)limitDetail:(UIButton *)sender {


    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":@"https://www.fengfengjinrong.com/action/activity/static/bank"};
    adVC.titleM =@"银行限额";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:adVC animated:YES];
}

- (IBAction)servicePhone:(UIButton *)sender {
    if ( [[UIApplication sharedApplication]canOpenURL:CUSTOMER_SERVICE_PHONE])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"即将呼叫丰丰金融客服" message:kPhoneNumber delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        alertView.tag=1;
        [alertView show];
    }
    else
    {
        [LeafNotification showInController:self withText:@"设备不支持打电话"];
    }

}
-(void)openPhone{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kefu_phone2]]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"即将呼叫丰丰金融客服" message:kefu_phone_title2 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        alertView.tag=2;
        [alertView show];
    }else{
        [LeafNotification showInController:self withText:@"设备不支持打电话"];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex == 1) {
        
        if (alertView.tag==1) {
            [[UIApplication sharedApplication]openURL:CUSTOMER_SERVICE_PHONE];
        }else{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:kefu_phone]];
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
