//
//  DYUpdateLoginPwdViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/15.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYUpdateLoginPwdViewController.h"
#import "DYSetNewLoginPwdViewController.h"
#import "DYPayPasswordVC2.h"

@interface DYUpdateLoginPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *PhoneText;
@property (weak, nonatomic) IBOutlet UITextField *PhoneCodeText;
@property (weak, nonatomic) IBOutlet UIButton *PhoneCodeBtn;

@property (nonatomic) NSString *phonecode;
@end

@implementation DYUpdateLoginPwdViewController
{
    int secondTotal;//获取验证码倒计时秒数
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidAfterLoad];
    self.title=@"找回密码";
    
    [_PhoneCodeBtn setBackgroundImage:[UIImage imageWithColor:kOrangeColorNormal] forState:UIControlStateNormal];
    [_PhoneCodeBtn setBackgroundImage:[UIImage imageWithColor:kOrangeColorHighlighted] forState:UIControlStateHighlighted];
    [_PhoneCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    _PhoneCodeBtn.layer.cornerRadius=1.50f;
    _PhoneCodeBtn.layer.masksToBounds=YES;
    [_PhoneCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_PhoneCodeBtn setTitle:@"正在发送" forState:UIControlStateDisabled];
    [_PhoneCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_PhoneCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    
    self.PhoneText.text = _phone;
    if([_phone length] > 0){
        self.PhoneText.enabled =NO;
        self.title = @"修改登录密码";
    }
    self.PhoneText.delegate=self;
    self.PhoneCodeText.delegate=self;
    if (self.type==1) {
         self.title = @"修改支付密码";
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.PhoneText resignFirstResponder];
    [self.PhoneCodeText resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getPhoneCode:(id)sender {
    NSString * phoneNumber=_PhoneText.text;
    if (phoneNumber.length!=11)
    {
        [MBProgressHUD errorHudWithView:nil label:@"输入正确手机号码" hidesAfter:1];
        return;
    }
    
    _PhoneCodeBtn.enabled=NO;
    
    NSMutableString * phoneCode=[NSMutableString new];
    for (int i=0;i<6;i++)
    {
        int x=arc4random()%10;
        [phoneCode insertString:[NSString stringWithFormat:@"%d",x] atIndex:0];
    }
//    NSLog(@"%@",phoneCode);
    self.phonecode=phoneCode;
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:phoneNumber forKey:@"phone" atIndex:0];
    [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"send_code" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"updatepwd" forKey:@"type" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%@:%@",[DYUtils stringToUnicode:@"手机验证码"],phoneCode] forKey:@"contents" atIndex:0];
    [diyouDic insertObject:phoneCode forKey:@"code" atIndex:0];
    [diyouDic insertObject:@"0" forKey:@"user_id" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         //wayne-test
         if (isSuccess)
         {
             
             
             
             
             
         }
         else
         {
             
             if ([errorMessage isEqualToString:@"发送失败"]==YES) {
                 //关闭获取验证码交互开关
                 [MBProgressHUD checkHudWithView:self.view label:@"验证码已发送至短信" hidesAfter:1.5];
                 [self setCountDownSecondTotal:60];
             }
             else
             {
                 _PhoneCodeBtn.enabled=YES;
                 [MBProgressHUD errorHudWithView:self.view label:errorMessage hidesAfter:1];
             }
             
         }
         
     } errorBlock:^(id error)
     {
         _PhoneCodeBtn.enabled=YES;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];

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
    {
        _PhoneCodeBtn.enabled=YES;
        [_PhoneCodeBtn setTitle:@"" forState:UIControlStateDisabled];
    }
    else
    {
        [self performSelector:@selector(countDownForSendPhoneCode) withObject:nil afterDelay:1];
    }
    [_PhoneCodeBtn setTitle:[NSString stringWithFormat:@"%@",secondTotal==0?@"正在发送":[NSString stringWithFormat:@"重发(%d)",secondTotal]] forState:UIControlStateDisabled];
    ;
}
- (IBAction)Next:(id)sender {
    NSString *code=self.PhoneCodeText.text;
    NSLog(@"%@",self.isUpdate);
    if ([code isEqualToString:self.phonecode]) {
        //进入下一页
        if(self.type==1){
            DYPayPasswordVC2 * setPasswordVC=[[DYPayPasswordVC2 alloc]initWithNibName:@"DYPayPasswordVC2" bundle:nil];
            setPasswordVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:setPasswordVC animated:YES];
        }else{
            DYSetNewLoginPwdViewController * setNewPwd=[[DYSetNewLoginPwdViewController alloc]initWithNibName:@"DYSetNewLoginPwdViewController" bundle:nil];
            setNewPwd.hidesBottomBarWhenPushed=YES;
            setNewPwd.phone=self.PhoneText.text;
            setNewPwd.isUpdate=self.isUpdate;
            [self.navigationController pushViewController:setNewPwd animated:YES];
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码错误,请填写正确的验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

@end
