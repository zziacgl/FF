//
//  DYWithdrawalViewController.m
//  NewDeayou
//
//  Created by diyou on 14-7-10.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYWithdrawalViewController.h"
#import "MBProgressHUD.h"
#import "DYWithdrawalRecordVC.h"


#define kDrawalMoney             @"drawal"       //体现金额
#define kFree                    @"free"         //手续费
#define kDaoZhangMoney           @"daozhang"     //到账金额
#define kPaymentPassWord         @"payment"      //支付密码
#define kVerification            @"verification" //验证码



@interface DYWithdrawalViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    int secondTotal;
    float money;
    NSString *paypassword;
    NSString *phone;
    MKNetworkOperation * opCountFee;

}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIView *viewHead;
@property (weak, nonatomic) IBOutlet UITextField *textWithdrawalAmount;   //提现
@property (weak, nonatomic) IBOutlet UITextField *textPaymentPassword;    //支付密码
@property (weak, nonatomic) IBOutlet UITextField *textVerification;       //验证码
@property (weak, nonatomic) IBOutlet UIButton *btnGetVerification;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) NSMutableDictionary * dicInfo;              //存储信息的字典
@property (strong, nonatomic) IBOutlet UITextField *textPassWord;
@property (strong, nonatomic) IBOutlet UITextField *textCode;
@property (weak, nonatomic) IBOutlet UILabel *BalanceLabel;//显示账号余额


@end

@implementation DYWithdrawalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView
{
    [super loadView];
    
    self.title = @"提现";
    
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    NSString *balance=[ud objectForKey:@"balance"];
    self.BalanceLabel.text=[NSString stringWithFormat:@"账户余额: %@",balance];
    
    //导航右边的按钮
    UIButton * btnRightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor = [UIColor clearColor];
    btnRightItem.frame = CGRectMake(0, 0, 80, 35);
    [btnRightItem setTitle:@"提现记录" forState:UIControlStateNormal];
    [btnRightItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnRightItem addTarget:self action:@selector(rightBarButtonItemActionMore) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRightItem];

    
    
    //确定按钮的状态
    _btnConfirm.layer.cornerRadius = 3;
//    [_btnConfirm setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
//    [_btnConfirm setBackgroundImage:[UIImage imageWithColor:kMainColor] forState:UIControlStateSelected];
//    [_btnConfirm setBackgroundImage:[UIImage imageWithColor:kMainColorHighlight] forState:UIControlStateHighlighted];
    _btnConfirm.layer.masksToBounds = YES;
//    _btnConfirm.enabled = NO;

    
    CGSize btnImageSize = CGSizeMake(44, 44);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    //设置textdelegate以及类型
   
    _textPaymentPassword.delegate = self;
    _textVerification.delegate = self;
    
    
    
    
    _viewHead.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _viewContent.layer.masksToBounds = YES;
    _viewHead.layer.borderWidth = 0.5;
    _viewHead.layer.cornerRadius = 5;
    
    _viewContent.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _viewContent.layer.borderWidth = 0.5;
    _viewContent.layer.cornerRadius = 5;
    
    
    self.dicInfo = [[NSMutableDictionary alloc]init];
    
    
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewDidAfterLoad];
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self performSelector:@selector(getUsersBankOne) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(getUsers) withObject:nil afterDelay:0.5];

    
    
    
    if (kScreenSize.height>_scrollView.contentSize.height) {
        
        _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height+60);

        
    }else
    {
       _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height+0.5);
    }
    
    
    //获取验证码按钮
    _btnGetVerification.layer.cornerRadius = 3.0;
    _btnGetVerification.layer.masksToBounds = YES;
    [_btnGetVerification setBackgroundImage:[UIImage imageWithColor:kOrangeColorNormal] forState:UIControlStateNormal];
    [_btnGetVerification setBackgroundImage:[UIImage imageWithColor:kOrangeColorHighlighted] forState:UIControlStateHighlighted];
    [_btnGetVerification setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
    [_btnGetVerification setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_btnGetVerification setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnGetVerification setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    
    [_btnGetVerification setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateSelected];
    _btnGetVerification.selected = NO;
    _btnGetVerification.userInteractionEnabled = YES;

    self.textCode.text = @"";
    self.textPaymentPassword.text = @"";
    self.textWithdrawalAmount.text = @"";
    UILabel * labFree = (UILabel*)[self.view viewWithTag:1001];
    UILabel * labDaoZhang = (UILabel*)[self.view viewWithTag:1002];
    labFree.text = @"";
    labDaoZhang.text = @"";
    if (self.dicInfo.allKeys.count > 0) {
        [self.dicInfo removeAllObjects];
    }
//    [self checkButtonEnable];
}

#pragma mark - scrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self softkeyboardRecycling];
}

#pragma mark - 获取数据

//获取开户信息
-(void)getUsersBankOne
{
    [MBProgressHUD hudWithView:self.view  label:@"数据请求中"];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_users_bank_one" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {[MBProgressHUD hideAllHUDsForView:self.view  animated:YES];

         if (success == YES) {
             
             UILabel * lab=(UILabel*)[self.view viewWithTag:10000];
//             lab.text=[[object objectForKey:@"realname"] stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
             lab=(UILabel*)[self.view viewWithTag:10001];
             lab.text=[NSString stringWithFormat:@"%@",[object DYObjectForKey:@"branch"]];
             lab=(UILabel*)[self.view viewWithTag:10002];
             lab.text=[DYUtils withMoreTenThousand:[object DYObjectForKey:@"balance"]];
         }
         else
         {
             [MBProgressHUD errorHudWithView:self.view  label:error hidesAfter:2];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
         [MBProgressHUD errorHudWithView:self.view  label:@"网络异常" hidesAfter:2];
     }];
    
}
//获取提现费用
-(void)getCashFee:(NSString*)account
{
    account=_textWithdrawalAmount.text;
    if (account.length<1) {
        return;
    }
    
    if (opCountFee)
    {
        [opCountFee cancel];
        opCountFee = nil;
    }
    
    DYOrderedDictionary * diyouDic = [[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_fee_value" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:@"cash" forKey:@"type" atIndex:0];
    [diyouDic insertObject:account forKey:@"account" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    opCountFee= [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success == YES)
         {
//             NSLog(@"%@",object);
             if (_textWithdrawalAmount.text.length < 1) {
                 return ;
             }
             UILabel * labFree = (UILabel*)[self.view viewWithTag:1001];
             UILabel * labDaoZhang = (UILabel*)[self.view viewWithTag:1002];
             labFree.text = [DYUtils withMoreTenThousand:[object objectForKey:@"account_fee"]];
             labDaoZhang.text = [DYUtils withMoreTenThousand:[object objectForKey:@"balance"]];
             [self.dicInfo setObject:labFree.text forKey:kFree];
             [self.dicInfo setObject:labDaoZhang.text forKey:kDaoZhangMoney];
             [self.dicInfo setObject:_textWithdrawalAmount.text forKey:kDrawalMoney];
             //检查按钮的状态
             [self performSelector:@selector(checkButtonEnable) withObject:nil afterDelay:0.2];
         }
         else
         {
             [MBProgressHUD errorHudWithView:self.view  label:error hidesAfter:2];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD errorHudWithView:self.view  label:@"网络异常" hidesAfter:2];
     }];
    
    
}
//获支付密码
-(void)getUsers
{
    
    DYOrderedDictionary * diyouDic = [[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"dyp2p" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_users" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success == YES) {
             NSDictionary * dic = [object objectForKey:@"user_result"];
             if ([[dic objectForKey:@"paypassword"] isKindOfClass:[NSString class]]) {
                 
                 if ([[dic objectForKey:@"paypassword"] isKindOfClass:[NSString class]]) {
                      paypassword = [dic objectForKey:@"paypassword"];
                 }
                 
                 if ([[dic objectForKey:@"phone"] isKindOfClass:[NSString class]]) {
                     phone = [dic objectForKey:@"phone"];

                 }
                 
                
             }
         }
         else
         {
             [MBProgressHUD errorHudWithView:self.view  label:error hidesAfter:2];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD errorHudWithView:self.view  label:@"网络异常" hidesAfter:2];
     }];

    
}

#pragma mark - textFieldDelegate
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    
//         int hight;
//   
//        if(textField == self.textPaymentPassword)
//        {
//            
//            hight = - 180;
//        }
//        else if(textField == self.textVerification)
//        {
//            hight = - 245;
//        }
//        else
//        {
//            hight = - 40;
//        }
//    
//        [UIView animateWithDuration:0.2
//                         animations:^()
//         {
//             _scrollView.contentOffset = CGPointMake(0, -hight);
//             //这里的坐标是与原始的比较；
//         }];
//}
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    if (textField.tag == 1000)
//    {
//        
//  
//        
//        if (string.length < 1&&textField.text.length == 1)
//        {
//            
//            
//            UILabel * labFree = (UILabel*)[self.view viewWithTag:1001];
//            UILabel * labDaoZhang = (UILabel*)[self.view viewWithTag:1002];
//            labFree.text = @"";
//            labDaoZhang.text = @"";
//            [self.dicInfo setObject:@"" forKey:kFree];
//            [self.dicInfo setObject:@"" forKey:kDaoZhangMoney];
//            [self.dicInfo setObject:@"" forKey:kDrawalMoney];
//            
//        }
//        else
//        {
//          
//            if ([string isEqualToString:@"0"] && textField.text.length < 1)
//            {
//                return NO;
//            }
//            if (string.length < 1)
//            {
//                [self performSelector:@selector(getCashFee:) withObject:nil afterDelay:0.1];
//                return YES;
//            }
//            
//            NSString * regex = @"^[0-9]";
//            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//            BOOL isMatch = [pred evaluateWithObject:string];
//            if (!(isMatch||[string isEqualToString:@"."]))
//            {
//                return NO;
//            }
//            
//            if (textField.text.length > 0 && [string isEqualToString:@"0"])
//            {
//                if ([textField.text isEqualToString:@"0"])
//                {
//                    return NO;
//                }
//                
//            }
//            
//            if ([textField.text rangeOfString:@"."].length > 0 && [string isEqualToString:@"."])
//            {
//                return NO;
//            }
//            
//            if ([textField.text rangeOfString:@"."].length > 0 && [textField.text rangeOfString:@"."].location+3==textField.text.length) {
//                return NO;
//            }
//            [self performSelector:@selector(getCashFee:) withObject:nil afterDelay:0.1];
//        }
//        
//    }else if(textField.tag == 1003)
//    {
//        
//        if (string.length < 1 && textField.text.length == 1)
//        {
//            [self.dicInfo setObject:@"" forKey:kPaymentPassWord];
//        }
//        
//    }else if(textField.tag == 1004)
//    {
//    
//        
//        if (string.length < 1 && textField.text.length == 1)
//        {
//           [self.dicInfo setObject:@"" forKey:kVerification];
//        }
//    }
//   [self performSelector:@selector(checkButtonEnable) withObject:nil afterDelay:0.2];
//    //检查按钮的状态
//    
//    return YES;
//}
//-(void)checkButtonEnable
//{
//    
//    if ([self.textPassWord.text length] > 0) {
//        [self.dicInfo setObject:self.textPassWord.text forKey:kPaymentPassWord];
//
//    }
//    if ([self.textCode.text length] > 0) {
//        [self.dicInfo setObject:self.textCode.text forKey:kVerification];
//    }
//    _btnConfirm.enabled = [self checkInfomation:NO];
//    _btnConfirm.selected = [self checkInfomation:NO];
//
//}
//软键盘回收以及试图还原
-(void)softkeyboardRecycling
{
    [_textWithdrawalAmount resignFirstResponder];
    [_textPaymentPassword resignFirstResponder];
    [_textVerification resignFirstResponder];
    
    [UIView animateWithDuration:0.2
                     animations:^()
     {
         _scrollView.contentOffset = CGPointMake(0, 0);//这里的坐标是与原始的比较；
     }];

    
}
-(BOOL)checkInfomation:(BOOL)show
{
   
    BOOL isOK=YES;
    NSString *drawal = [self.dicInfo objectForKey:kDrawalMoney];
    NSString *free = [self.dicInfo objectForKey:kFree];
    NSString *daozhang = [self.dicInfo objectForKey:kDaoZhangMoney];
    NSString *paymentPassWord = [self.dicInfo objectForKey:kPaymentPassWord];
//    NSString *verification = [self.dicInfo objectForKey:kVerification];

    if (!([drawal length] > 0 && [free length] > 0 && [daozhang length] > 0 && [paymentPassWord length] > 0 /*&& [verification length] > 0*/)) {
        isOK = NO;
        if (show == YES) {
            [MBProgressHUD errorHudWithView:self.view label:@"请完整信息" hidesAfter:2];
        }
    }
    return isOK;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取验证码
- (IBAction)getVerificatin:(id)sender {
    
    if ([phone length] < 1) {
        [MBProgressHUD errorHudWithView:self.view label:@"手机号码未绑定请先绑定" hidesAfter:2];
        return;
    }
    
    
    
    _btnGetVerification.selected = YES;
    _btnGetVerification.userInteractionEnabled=NO;
    [self softkeyboardRecycling];
    NSMutableString * phoneCode=[NSMutableString new];
    for (int i=0;i<6;i++)
    {
        int x=arc4random()%10;
        [phoneCode insertString:[NSString stringWithFormat:@"%d",x] atIndex:0];
    }
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:phone forKey:@"phone" atIndex:0];
    [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"send_code" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"cash_new" forKey:@"type" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%@:%@",[DYUtils stringToUnicode:@"您的验证码为"],phoneCode] forKey:@"contents" atIndex:0];
    [diyouDic insertObject:phoneCode forKey:@"code" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         [self setCountDownSecondTotal:60 ];
         [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
         if (isSuccess)
         {
             //关闭获取验证码交互开关
             [MBProgressHUD checkHudWithView:self.view  label:@"验证码已发送至短信" hidesAfter:1];
             
         }
         else
         {
             [MBProgressHUD errorHudWithView:self.view  label:errorMessage hidesAfter:1];
         }
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
         _btnGetVerification.selected=NO;
         _btnGetVerification.userInteractionEnabled=YES;
     }];

    
    
}
//确认提交
- (IBAction)confirmUpdata:(id)sender {
    
     [MBProgressHUD hudWithView:self.view label:@"提交中..."];
    int m=[self.textWithdrawalAmount.text intValue];
    if (m > KLastWithdrawalAmount || m == KLastWithdrawalAmount) {
        /*--------------------提现接口－－－－－－－－－－－－－*/
        NSDate *dat=[NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        
//        NSLog(@"%1.f",a);
        NSString *out_trade_no=[NSString stringWithFormat:@"%1.f%d",a,[DYUser GetUserID]];
//        NSLog(@"%@",out_trade_no);
        NSString *amount=self.textWithdrawalAmount.text;
        DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"account" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"mobile_cash_new" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"customer_id" atIndex:0];
        [diyouDic insertObject:out_trade_no forKey:@"out_trade_no" atIndex:0];
        [diyouDic insertObject:amount forKey:@"amount_str" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (success==YES) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [MBProgressHUD checkHudWithView:nil label:@"提交成功！" hidesAfter:2];
                 [self rightBarButtonItemActionMore];
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [MBProgressHUD errorHudWithView:self.view  label:error hidesAfter:2];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MBProgressHUD errorHudWithView:self.view  label:@"网络异常" hidesAfter:2];
         }];

    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *msg=[NSString stringWithFormat:@"提现金额不得低于%d元",KLastWithdrawalAmount];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
-(void)setCountDownSecondTotal:(int)total
{
    secondTotal=total;
    [self countDownForSendPhoneCode];
}

-(void)countDownForSendPhoneCode
{
    secondTotal--;
    if (secondTotal<=0)
    { //221 158 51
        [_btnGetVerification setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateSelected];
        _btnGetVerification.selected=NO;
        _btnGetVerification.userInteractionEnabled=YES;
        return;
    }
    [_btnGetVerification setTitle:[NSString stringWithFormat:@"重发(%d)",secondTotal] forState:UIControlStateSelected];
    [self performSelector:@selector(countDownForSendPhoneCode) withObject:nil afterDelay:1];
}

//提现记录
-(void)rightBarButtonItemActionMore
{
    DYWithdrawalRecordVC * withdrawalVC=[[DYWithdrawalRecordVC alloc]initWithNibName:@"DYWithdrawalRecordVC" bundle:nil];
    withdrawalVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:withdrawalVC animated:YES];
    
}


@end
