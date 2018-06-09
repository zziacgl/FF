//
//  DYInvestSubmitVC.m
//  NewDeayou
//
//  Created by wayne on 14/7/24.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYInvestSubmitVC.h"
#import "DYIncomeDetailVC.h"
#import "DYInvestmentMainVC.h"
#import "HKPieChartView.h"
#import "DYPush.h"
#import "UIColor+FFCustomColor.h"
#import "DDPassWordAlertView.h"
#import "DYUpdateLoginPwdViewController.h"
#import "FFInvestSuccessViewController.h"
#import "LeafNotification.h"
#import "FFCanUseCardViewController.h"
#import "DDRechargeViewController.h"
#import "DDMyCardVoucherViewController.h"
//#import <CustomAlertView.h>
#import "WYWebProgressLayer.h"
#import "FFRedPacketmodel.h"
#import "DYSafeViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "DCPaymentView.h"
#import "SetPayPasswordViewController.h"
@interface DYInvestSubmitVC ()<UIScrollViewDelegate,UITextFieldDelegate>

{
    BOOL isHiddenKeyborad;
    UIActivityIndicatorView *activityIndicator;
    int standCardid;
    NSDictionary *ticket;
    UIView *payBackView;
    UIView *payTanView;
    UIButton *setPayBtn;
    UIButton *paycloseBtn;
}

//投资金额，支付密码，投资密码，预期收益,最高可投资金额
@property (strong, nonatomic) DYInvestmentMainVC * mainVC;
@property (strong, nonatomic) IBOutlet UILabel *labelIncomeMoney;//预计收益
@property (nonatomic,assign)CGFloat income;
@property (nonatomic,retain)NSDictionary * dicIncome;
@property (nonatomic, strong) UIAlertView * alert;
//立即投资，信息界面
@property (strong, nonatomic) IBOutlet UIButton *btnBuyInvestNow;

@property (weak, nonatomic) IBOutlet UILabel *BalanceLabel;//账号余额


@property (nonatomic, strong) NSString *RealName;
@property (nonatomic, strong) NSString *RechangeM;
@property (nonatomic, strong) HKPieChartView *pieChartView;

@property (weak, nonatomic) IBOutlet UIView *FootView;

@property (weak, nonatomic) IBOutlet UIView *HeadView;
@property (weak, nonatomic) IBOutlet UIView *topVView;

//标
@property (weak, nonatomic) IBOutlet UILabel *BorrowDescript;//可投金额

@property (weak, nonatomic) IBOutlet UIButton *AllInvestBnt;//全投

@property (nonatomic)BOOL isHasBalance;//ture:余额不足，false:余额可投
@property (nonatomic,strong)NSString *nid;//投标成功之后返回的标识
@property (nonatomic, strong)  NSMutableAttributedString *str4;
@property (nonatomic, strong) NSDictionary *orderDic;
@property (nonatomic) BOOL isHaveDian;
@property (nonatomic, strong) NSMutableArray *canUseCardAry;

@property (nonatomic, copy) NSString *choseCardID;
@property (nonatomic, strong) FFRedPacketmodel *choseCardModel;

@property (nonatomic)int isSelected;
@property (nonatomic, strong) DCPaymentView *payAlert;
@end

static NSString *willInComeMoney;

@implementation DYInvestSubmitVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.barTintColor  = [UIColor whiteColor];
//    [self.navigationController.navigationBar.layer removeFromSuperlayer];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:17]}];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    CGRect frame = CGRectMake(0, 0, kMainScreenWidth,[UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height);

    UIImage *image = [DYUtils gradientImageWithBounds:frame andColors:@[kShallowColor,kDeepColor] andGradientType:1];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

//    self.navigationController.navigationBar.barTintColor  = kBtnColor;
//    [self.navigationController.navigationBar.layer addSublayer:[UIColor setGradualChangingColor:self.navigationController.navigationBar fromColor:@"fb9903" toColor:@"f76405"]];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:17]}];
}

- (NSMutableArray *)canUseCardAry {
    if (!_canUseCardAry) {
        self.canUseCardAry = [NSMutableArray array];
    }
    return _canUseCardAry;
    
}

#pragma mark- network

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidAfterLoad];
    CALayer *layer = [self.coverView layer];
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.3;
    self.coverView.layer.cornerRadius = 5;
//    self.coverView.layer.masksToBounds = YES;
    
    [self.AllInvestBnt.layer addSublayer:[UIColor setGradualChangingColor:self.AllInvestBnt fromColor:@"fb9903" toColor:@"f76405"]];
    self.topVView.backgroundColor = kBtnColor;
    [self.topVView.layer addSublayer:[UIColor setGradualChangingColor:self.topVView fromColor:@"fb9903" toColor:@"f76405"]];
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//     [statusBar.layer addSublayer:[UIColor setGradualChangingColor:statusBar fromColor:@"fb9903" toColor:@"f76405"]];

    self.myCardLabel.text = @"无";
    self.choseCardID = @"";
    self.tfInvestMoney.delegate = self;
    [self.tfInvestMoney addTarget:self action:@selector(moneytextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    self.DeadLineLabel.text=self.deadLine;
    float borApr =[self.extraNianHua floatValue];
    NSLog(@"额外年化%@", self.borrow_type);
    if (borApr > 0) {
        NSUInteger len = [self.extraNianHua length];
        NSUInteger len1 = [self.nianHua length];
        NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%+%@%%", self.nianHua,self.extraNianHua]];
        [str4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(len1 + 1,len+2)];
        self.nianHuaLabel.attributedText = str4;
    }else {
        NSUInteger len1 = [self.nianHua length];
        NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%", self.nianHua]];
        [str4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(len1,1)];
        self.nianHuaLabel.attributedText = str4;//年化收益
        
    }
    
    self.LimstLabel.text=self.limst;
    
    
    self.title=[NSString stringWithFormat:@"%@",[_dicData DYObjectForKey:@"name"]];
    
   

    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"whiteback"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    NSString *agreeStr = @"投标即表明已阅读并同意《投资合同》和《风险揭示及确认书》。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:agreeStr];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[HeXColor colorWithHexString:@"#00a2e8"] range:NSMakeRange(11, 6)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[HeXColor colorWithHexString:@"#00a2e8"] range:NSMakeRange(18, 10)];
    self.agreeMnetLabel.attributedText = attributedString;
    [self.agreeMnetLabel yb_addAttributeTapActionWithStrings:@[@"《投资合同》",@"《风险揭示及确认书》"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
                ActivityDetailViewController *mywebVC = [[ActivityDetailViewController alloc] init];
                NSString *loginKey = [DYUser GetLoginKey];
                if (index == 0) {
                    if ([self.borrowType isEqualToString:@"transfer"]) {
                        NSString *url = [NSString stringWithFormat:@"%@/action/tender/show_protocol?template=users_protocol_transfer&tender_id=%@&login_key=%@",ffwebURL,[_dicData DYObjectForKey:@"borrow_nid"],loginKey];
                        mywebVC.myUrls = @{@"url":url};
                        mywebVC.titleM = @"投资合同";
                    }else {
                        NSString *url = [NSString stringWithFormat:@"%@/action/tender/show_protocol?tender_id=1602532&login_key=%@",ffwebURL,loginKey];
                        mywebVC.myUrls = @{@"url":url};
                        mywebVC.titleM = @"投资合同";
                    }
                }else {
                    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/safe/risk", ffwebURL];
                    mywebVC.myUrls = @{@"url":url};
                    mywebVC.titleM = @"风险揭示及确认书";
        
                }
                [self.navigationController pushViewController:mywebVC animated:YES];
    }];
    
    
    
    
    self.AllInvestBnt.layer.cornerRadius = 5;
    self.AllInvestBnt.layer.masksToBounds = YES;
    // 我的卡券
    
    
    self.BorrowDescript.text=[NSString stringWithFormat:@"%@",self.Borrow_ShenYu];
    
    
    
    
    
    [self.btnBuyInvestNow setBackgroundColor:kBtnColor];
    
    
    self.limit=[[_dicData DYObjectForKey:@"tender_account_min"] floatValue];
    
    NSString *str=[NSString stringWithFormat:@"账户余额:%@",self.balance];
    NSMutableAttributedString *astr=[[NSMutableAttributedString alloc] initWithString:str];
    NSInteger m=str.length-5;
    [astr addAttribute:NSForegroundColorAttributeName value:kBtnColor range:NSMakeRange(5,m)];
    self.BalanceLabel.attributedText=astr;
    CALayer *balancelayer = [self.btnBuyInvestNow layer];
    balancelayer.shadowOffset = CGSizeMake(0, 3);
    balancelayer.shadowRadius = 5.0;
    balancelayer.shadowColor = [UIColor grayColor].CGColor;
    balancelayer.shadowOpacity = 0.3;
    

    
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
    
   
    //设置是否有点击效果，默认是YES
    self.agreeMnetLabel.enabledTapEffect = NO;

    self.agereeMentImage.userInteractionEnabled = YES;
    self.agereeMentImage.highlighted = NO;

}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    if (self.tfInvestMoney.editing) {
        [UIView animateWithDuration:0.2
                         animations:^()
         {
             
             self.FootView.transform = CGAffineTransformMakeTranslation(0, -height);
         }];
    }
    
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    [UIView animateWithDuration:0.1
                     animations:^()
     {
         self.FootView.transform = CGAffineTransformMakeTranslation(0, 0);
         
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isHiddenKeyborad)
    {
        isHiddenKeyborad=NO;
        [self endEdtingWithAnimationComeBack];
    }
}


#pragma mark--textDelegate
- (void)moneytextFieldDidChange:(UITextField *)textField {
    
//    [self makeMoney:textField.text];
    [self getBestCard:textField.text];
}

#pragma mark -- 全投

- (IBAction)handleAllInMoney:(UIButton *)sender {
    float remainMoney = [self.Borrow_ShenYu floatValue];
    float money = [self.balance floatValue];
    if (remainMoney > money) {
        self.tfInvestMoney.text = self.balance;
        
    }else {
        self.tfInvestMoney.text = [NSString stringWithFormat:@"%.2f", remainMoney];
    }
    self.choseCardID = @"";
   [self getBestCard:self.tfInvestMoney.text];
    
    
}

#pragma mark -- 计算收益
- (void)makeMoney:(NSString *)string {
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    if ([self.borrowType isEqualToString:@"fragment"]) {
        [diyouDic insertObject:@"calculate_tender_fragment" forKey:@"q" atIndex:0];
        [diyouDic insertObject:[_dicData DYObjectForKey:@"borrow_nid"] forKey:@"id" atIndex:0];
    }else {
        [diyouDic insertObject:@"get_income" forKey:@"q" atIndex:0];
        [diyouDic insertObject:[_dicData DYObjectForKey:@"borrow_nid"] forKey:@"borrow_nid" atIndex:0];
    }
    
    [diyouDic insertObject:self.tfInvestMoney.text forKey:@"account" atIndex:0];
    
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success==YES) {
            
             NSLog(@"计算收益%@", object);
         }
         else
         {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
}
#pragma mark -- 获取卡券收益
- (void)getBestCard:(NSString *)money {
    
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    
    [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
//    [diyouDic insertObject:@"calculate_tender" forKey:@"q" atIndex:0];
//    [diyouDic insertObject:[_dicData DYObjectForKey:@"borrow_nid"] forKey:@"borrow_nid" atIndex:0];
    if ([self.borrowType isEqualToString:@"fragment"]) {
        [diyouDic insertObject:@"calculate_tender_fragment" forKey:@"q" atIndex:0];
        [diyouDic insertObject:self.borrowId forKey:@"id" atIndex:0];
    }else {
        [diyouDic insertObject:@"calculate_tender" forKey:@"q" atIndex:0];
        [diyouDic insertObject:[_dicData DYObjectForKey:@"borrow_nid"] forKey:@"borrow_nid" atIndex:0];
    }
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:self.tfInvestMoney.text forKey:@"account" atIndex:0];
    
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success==YES) {
             
             NSLog(@"卡券收益%@", object);
            willInComeMoney = [NSString stringWithFormat:@"%@", [object objectForKey:@"income"]];
             self.labelIncomeMoney.text = [NSString stringWithFormat:@"%.2f", [willInComeMoney floatValue]];
             
             if ([object[@"can_use_ticket"] isKindOfClass:[NSArray class]]) {
                 self.canUseCardAry = [FFRedPacketmodel mj_objectArrayWithKeyValuesArray:[object objectForKey:@"can_use_ticket"]];
                 
                 [self.myCardBtn addTarget:self action:@selector(handleGoToMyCard) forControlEvents:UIControlEventTouchUpInside];
                 
                 self.choseCardModel = [FFRedPacketmodel mj_objectWithKeyValues:[object objectForKey:@"ticket"]];
                 
                 NSString *cardType = [NSString stringWithFormat:@"%@", self.choseCardModel.type];
                 if ([cardType isEqualToString:@"ticket"]) {//返现券
                     self.myCardLabel.text = [NSString stringWithFormat:@"￥%@返现券", self.choseCardModel.award];
                 }else {
                     self.myCardLabel.text = [NSString stringWithFormat:@"%@%%加息券", self.choseCardModel.award];
                 }
                 self.choseCardID = self.choseCardModel.cardID;
                 float cardMoney = [self.choseCardModel.award_money floatValue];
                 float myicomeMoney = [willInComeMoney floatValue];
                 float gotMoeny = cardMoney + myicomeMoney;
                 self.labelIncomeMoney.text = [NSString stringWithFormat:@"%.2f", gotMoeny];
             }
             NSLog(@"%@", self.canUseCardAry);
         }
         else
         {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
}

#pragma mark -- 卡券界面
- (void)handleGoToMyCard {
    [MobClick event:@"product_shiyongHB"];
    FFCanUseCardViewController *cardVC = [[FFCanUseCardViewController alloc] init];
    cardVC.dataAry = self.canUseCardAry;
    cardVC.block = ^(FFRedPacketmodel *model) {
        if (model) {
            self.choseCardID = model.cardID;
            NSString *cardType = [NSString stringWithFormat:@"%@", model.type];
            if ([cardType isEqualToString:@"ticket"]) {//返现券
                self.myCardLabel.text = [NSString stringWithFormat:@"￥%@返现红包", model.award];
            }else {
                self.myCardLabel.text = [NSString stringWithFormat:@"%@%%加息红包", model.award];
            }
            
            float cardMoney = [model.award_money floatValue];
            float myicomeMoney = [willInComeMoney floatValue];
            float gotMoeny = cardMoney + myicomeMoney;
            self.labelIncomeMoney.text = [NSString stringWithFormat:@"%.2f", gotMoeny];
        }else {
            self.choseCardID = @"";
            self.myCardLabel.text = @"不使用";
            self.labelIncomeMoney.text = [NSString stringWithFormat:@"%.2f", [willInComeMoney floatValue]];

        }
    };
    [self.navigationController pushViewController:cardVC animated:YES];
    
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //test
    if (textField==_tfInvestMoney)
    {
        // 判断是否有小数点
        float m=0;
        if (range.length==1) {
            m=[[textField.text substringToIndex:textField.text.length-1] floatValue];
            if (m == 0) {
              
                self.labelIncomeMoney.text = @"0.00";
                
            }
        }
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
    }
    
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.tfInvestMoney resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return NO;
}
#pragma mark- keyBoradAnimation

//键盘收下来时，调整视图正常
-(void)endEdtingWithAnimationComeBack
{
    [self.view endEditing:YES];
}


#pragma mark -- 投标
- (IBAction)investNow:(UIButton *)sender

{
    
    
    [self.tfInvestMoney resignFirstResponder];
    [self endEdtingWithAnimationComeBack];
    
    if ([self.ffmodel.pay_password_status isEqualToString:@"1"]) {
        self.payAlert = [[DCPaymentView alloc]init];
        self.payAlert.title = @"请输入支付密码";
        self.payAlert.detail = @"投标";
        self.payAlert.amount= [self.tfInvestMoney.text floatValue];
        [self.payAlert show];
        [self.payAlert.forgetBtn addTarget:self action:@selector(handleForgetPassword) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        
        self.payAlert.completeHandle = ^(NSString *inputPwd) {
            NSLog(@"密码是%@",inputPwd);
            [weakSelf gotoInvest:inputPwd];
        };
        
        
    }else {
        
        payBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        payBackView.backgroundColor = [UIColor blackColor];
        payBackView.alpha = 0.5;
        [self.tabBarController.view addSubview:payBackView];
        
        payTanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 80, 200)];
        payTanView.backgroundColor = [UIColor whiteColor];
        payTanView.center = payBackView.center;
        payTanView.layer.cornerRadius = 5;
        payTanView.layer.masksToBounds = YES;
         [self shakeToShow:payTanView];
        [self.tabBarController.view addSubview:payTanView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, kMainScreenWidth- 120, 60)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        titleLabel.text = @"您还未设置支付密码，为了您的支付安全，请先设置支付密码";
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [payTanView addSubview:titleLabel];
        
        paycloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        paycloseBtn.frame = CGRectMake(kMainScreenWidth - 55, CGRectGetMinY(payTanView.frame) - 15, 30, 30);
        [paycloseBtn setImage:[UIImage imageNamed:@"payclose"] forState:UIControlStateNormal];
        [paycloseBtn addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarController.view addSubview:paycloseBtn];
        
        setPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setPayBtn.frame = CGRectMake(20, 140, kMainScreenWidth - 120, 40);
        setPayBtn.layer.cornerRadius = 5;
        setPayBtn.layer.masksToBounds = YES;
        setPayBtn.backgroundColor = kMainColor;
        [setPayBtn setTitle:@"去设置" forState:UIControlStateNormal];
        [setPayBtn addTarget:self action:@selector(handlesetPassword) forControlEvents:UIControlEventTouchUpInside];
        [payTanView addSubview:setPayBtn];
        
        
    }
    

}
- (void)handlesetPassword{
    [self handleClose];
    SetPayPasswordViewController *payVC = [[SetPayPasswordViewController alloc] initWithNibName:@"SetPayPasswordViewController" bundle:nil];
    payVC.phone = [DYUser loginGetUserNameAndPassword][0];
    payVC.title = @"设置支付密码";
    [self.navigationController pushViewController:payVC animated:YES];
    
}
- (void)handleClose {
    [paycloseBtn removeFromSuperview];
    [payBackView removeFromSuperview];
    [payTanView removeFromSuperview];
    
}
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
#pragma mark -- 投标
- (void)gotoInvest:(NSString *)password {
    float investMoeny = [self.tfInvestMoney.text floatValue];//投资金额
    float balanceMoney = [self.balance floatValue];//可用余额
    float remainMoney  = [self.Borrow_ShenYu floatValue];//可投金额
    if (self.tfInvestMoney.text.length == 0) {
        [LeafNotification showInController:self withText:@"请输入投资金额"];
        return;
    }
    if (investMoeny < [self.LimstLabel.text floatValue]) {
        [LeafNotification showInController:self withText:@"低于起投金额"];
        return;
    }
    if (investMoeny > remainMoney) {
        [LeafNotification showInController:self withText:@"投资金额大于剩余金额"];
        return;
    }
    if (investMoeny > balanceMoney) {
        [LeafNotification showInController:self withText:@"余额不足，请充值"];
        return;
    }
   
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    if ([self.borrowType isEqualToString:@"fragment"]) {
        [diyouDic insertObject:@"tender" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"fragment_invest_password" forKey:@"q" atIndex:0];
        [diyouDic insertObject:self.borrowId forKey:@"id" atIndex:0];

    }else {
        [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"invest_password" forKey:@"q" atIndex:0];
        [diyouDic insertObject:[_dicData DYObjectForKey:@"borrow_nid"] forKey:@"borrow_nid" atIndex:0];

    }
//    [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
//    [diyouDic insertObject:@"tender" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:password forKey:@"paypassword" atIndex:0];

    [diyouDic insertObject:self.choseCardID forKey:@"rest_ticket_id" atIndex:0];
    
    [diyouDic insertObject:[_dicData DYObjectForKey:@"borrow_nid"] forKey:@"borrow_nid" atIndex:0];
    [diyouDic insertObject:self.tfInvestMoney.text forKey:@"account" atIndex:0];
    
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (success==YES) {
             [MobClick event:@"product_TB_Success"];
             FFInvestSuccessViewController *ffVC = [[FFInvestSuccessViewController alloc] initWithNibName:@"FFInvestSuccessViewController" bundle:nil];
             [self.navigationController pushViewController:ffVC animated:YES];
//             [MBProgressHUD checkHudWithView:nil label:@"投标成功" hidesAfter:1];
//             [self performSelector:@selector(GotoBack) withObject:nil afterDelay:1];
            
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
#pragma mark -- 忘记支付密码
- (void)handleForgetPassword {
     [self.payAlert dismiss];
    SetPayPasswordViewController *payVC = [[SetPayPasswordViewController alloc] initWithNibName:@"SetPayPasswordViewController" bundle:nil];
    payVC.phone = [DYUser loginGetUserNameAndPassword][0];
    payVC.title = @"忘记支付密码";
    [self.navigationController pushViewController:payVC animated:YES];
    
}

- (void)GotoBack {
    
    self.navigationController.navigationBar.barTintColor  = kMainColor;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- 协议

- (IBAction)handleXieYi:(UIButton *)sender {
    self.agereeMentImage.highlighted = self.agereeMentImage.isHighlighted ? NO : YES;
    if (self.agereeMentImage.highlighted) {
        _btnBuyInvestNow.backgroundColor = [UIColor lightGrayColor];
        _btnBuyInvestNow.userInteractionEnabled = NO;
    }else {
        _btnBuyInvestNow.backgroundColor = kBtnColor;
        _btnBuyInvestNow.userInteractionEnabled = YES;
    }
}



@end
