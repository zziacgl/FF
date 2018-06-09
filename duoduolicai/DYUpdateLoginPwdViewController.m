//
//  DYUpdateLoginPwdViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/15.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYUpdateLoginPwdViewController.h"
#import "DYSetNewLoginPwdViewController.h"
#import "LeafNotification.h"
@interface DYUpdateLoginPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *PhoneText;
@property (weak, nonatomic) IBOutlet UITextField *PhoneCodeText;
@property (weak, nonatomic) IBOutlet UIButton *PhoneCodeBtn;

@property (nonatomic) NSString *phonecode;
@property (nonatomic) NSString *UserName;
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
    self.view.backgroundColor = kBackColor;
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    [self.btnConfirm setBackgroundColor:kBtnColor];
    
    [_PhoneCodeBtn setBackgroundImage:[UIImage imageWithColor:kBtnColor] forState:UIControlStateNormal];
    [_PhoneCodeBtn setBackgroundImage:[UIImage imageWithColor:kBtnColor] forState:UIControlStateHighlighted];
    [_PhoneCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    _PhoneCodeBtn.layer.cornerRadius=1.50f;
    _PhoneCodeBtn.layer.masksToBounds=YES;
    [_PhoneCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [_PhoneCodeBtn setTitle:@"正在发送" forState:UIControlStateDisabled];
    [_PhoneCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_PhoneCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    
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
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
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
-(void)startTime{
    
    __block int timeout= 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [self.PhoneCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                self.PhoneCodeBtn.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:1];
                
                [self.PhoneCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                
                [UIView commitAnimations];
                
                self.PhoneCodeBtn.userInteractionEnabled = NO;
                
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
    
    
    
}

- (IBAction)getPhoneCode:(id)sender {
    [self GetUserNameByPhone];
    NSString * phoneNumber=_PhoneText.text;
    if (phoneNumber.length!=11)
    {
        [LeafNotification showInController:self withText:@"请输入正确手机号码"];
        return;
    }
    

    
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:phoneNumber forKey:@"phone" atIndex:0];
    [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"send_code" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"updatepwd" forKey:@"type" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         //wayne-test
         if (isSuccess)
         {
             [self startTime];
         }
         else
         {
             
             if ([errorMessage isEqualToString:@"发送失败"]==YES) {
                 //关闭获取验证码交互开关
                 [MBProgressHUD checkHudWithView:self.view label:@"验证码已发送至短信" hidesAfter:1.5];
                 
                 
             }
             else
             {
                 _PhoneCodeBtn.enabled=YES;
                 [LeafNotification showInController:self withText:errorMessage];
             }
             
         }
         
     } errorBlock:^(id error)
     {
         _PhoneCodeBtn.enabled=YES;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];

}


- (IBAction)Next:(id)sender {
    NSString * phoneNumber=_PhoneText.text;
    NSString *code=self.PhoneCodeText.text;
    [MBProgressHUD hudWithView:self.view label:@"验证验证码..."];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:phoneNumber forKey:@"phone" atIndex:0];
    [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
    [diyouDic insertObject:code forKey:@"phone_code" atIndex:0];
    [diyouDic insertObject:@"check_code" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"updatepwd" forKey:@"type" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
             
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.PhoneText resignFirstResponder];
             [self.PhoneCodeText resignFirstResponder];

             if(self.type==1){
                
             }else{
                 DYSetNewLoginPwdViewController * setNewPwd=[[DYSetNewLoginPwdViewController alloc]initWithNibName:@"DYSetNewLoginPwdViewController" bundle:nil];
                 setNewPwd.hidesBottomBarWhenPushed=YES;
                 setNewPwd.phone=self.UserName;
                 setNewPwd.isUpdate=self.isUpdate;
                 setNewPwd.isBank=self.isBank;
                 [self.navigationController pushViewController:setNewPwd animated:YES];
             }

         
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
-(void)GetUserNameByPhone{
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:self.PhoneText.text forKey:@"phone" atIndex:0];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_username_by_phone" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         //wayne-test
         if (isSuccess)
         {
             
//             NSLog(@"%@",object);
             
             NSDictionary *dic=object;
             self.UserName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
             
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
