//
//  DYRegistViewController.m
//  NewDeayou
//
//  Created by 尹宁 on 15/9/15.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYRegistViewController.h"
#import "DYLoginVC.h"
#import "DYRegistPolicyVC.h"
#import "DYRegistNextViewController.h"
#import "DYRegistComfirmViewController.h"

#define kCornerRadius 3.0f
#define kBorderColor [UIColor lightGrayColor].CGColor


//记录用户填写信息的key
//手机注册
#define kUserInfoPhoneNumber                 @"kUserInfoPhoneNumber"
#define kUserInfoAuthCodePhone               @"kUserInfoAuthCodePhone"
#define kUserInfoUserNameTypePhone           @"kUserInfoUserNameTypePhone"
#define kUserInfoPasswordTypePhone           @"kUserInfoPasswordTypePhone"
#define kUserInfoPasswordEnsureTypePhone     @"kUserInfoPasswordEnsureTypePhone"
#define kPhoneTuiJianRen                     @"kPhoneTuiJianRen"


@interface DYRegistViewController ()<UIActionSheetDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNumber; // 注册手机号码
@property (weak, nonatomic) IBOutlet UITextField *PhoneCodeText; // 验证码
@property (weak, nonatomic) IBOutlet UIButton *btnPhoneCode; // 获取验证码
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic) NSString *phonecode;
@end

@implementation DYRegistViewController
{
    int secondTotal;//获取验证码倒计时秒数
    NSString *phone;
    CGRect  rectMarkMainView;//记录self.view的初始frame
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor  = kBackColor;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor  = kMainColor;
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewDidAfterLoad];
    self.title = @"注册";
    self.view.backgroundColor = kBackColor;

    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    

    [_btnPhoneCode setTitleColor:kBtnColor forState:UIControlStateNormal];
    _btnPhoneCode.layer.cornerRadius=1.50f;
    _btnPhoneCode.layer.masksToBounds=YES;
    [_btnPhoneCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.tfPhoneNumber.text = phone;
    if([phone length] > 0){
        self.tfPhoneNumber.enabled = NO;
        self.title = @"注册";
    }
    
    [self.nextBtn setBackgroundColor:kBtnColor];
    [self.nextBtn.layer setMasksToBounds:YES];
    [self.nextBtn.layer setCornerRadius:25];
    
    [self.loginBtn setTitleColor:kBtnColor forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)login{
    [self.navigationController popViewControllerAnimated:YES];
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
                
                [self.btnPhoneCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                self.btnPhoneCode.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:1];
                
                [self.btnPhoneCode setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                
                [UIView commitAnimations];
                
                self.btnPhoneCode.userInteractionEnabled = NO;
                
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
    
    
    
}

- (IBAction)getPhoneCode:(id)sender
{
    NSString * phoneNumber=_tfPhoneNumber.text;
    
    NSMutableDictionary *properties=[NSMutableDictionary dictionary];
    properties[@"手机号"]=phoneNumber;
    
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
    [diyouDic insertObject:@"reg" forKey:@"type" atIndex:0];

    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         //wayne-test
         if (isSuccess)
         {
             [MBProgressHUD checkHudWithView:self.view label:@"验证码已发送至短信" hidesAfter:1.5];

             [self startTime];
        
         }
         else
         {
             
//             if ([errorMessage isEqualToString:@"发送失败"]==YES) {
//                 //关闭获取验证码交互开关
//                 [self startTime];
//
//
//                 [self setCountDownSecondTotal:60];
//
//             }
//             else
//             {
                 _btnPhoneCode.enabled=YES;
                 [LeafNotification showInController:self withText:errorMessage];
//             }
             
         }
         
     } errorBlock:^(id error)
     {
         _btnPhoneCode.enabled=YES;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)setCountDownSecondTotal:(int)total
{
    secondTotal=total;
    [self countDownForSendPhoneCode];
} 

-(void)countDownForSendPhoneCode
{
    secondTotal--;
    if (secondTotal<=0)
    {
        _btnPhoneCode.enabled=YES;
        [_btnPhoneCode setTitle:@"" forState:UIControlStateDisabled];
    }
    else
    {
        [self performSelector:@selector(countDownForSendPhoneCode) withObject:nil afterDelay:1];
    }
    [_btnPhoneCode setTitle:[NSString stringWithFormat:@"%@",secondTotal==0?@"正在发送":[NSString stringWithFormat:@"重发(%d)",secondTotal]] forState:UIControlStateDisabled];
    ;
}

- (IBAction)Next:(id)sender
{

    
    NSString * phoneNumber=_tfPhoneNumber.text;
     NSString *code=self.PhoneCodeText.text;
    [MBProgressHUD hudWithView:self.view label:@"验证验证码..."];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:phoneNumber forKey:@"phone" atIndex:0];
    [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
    [diyouDic insertObject:code forKey:@"phone_code" atIndex:0];
    [diyouDic insertObject:@"check_code" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"reg" forKey:@"type" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             DYRegistComfirmViewController * setNewPwd=[[DYRegistComfirmViewController alloc]initWithNibName:@"DYRegistComfirmViewController" bundle:nil];
             setNewPwd.hidesBottomBarWhenPushed = YES;
             setNewPwd.phone = self.tfPhoneNumber.text;
             setNewPwd.phone_code = self.PhoneCodeText.text;
             [self.navigationController pushViewController:setNewPwd animated:YES];
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

#pragma mark- textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self animationRecover];
    return YES;
}

//恢复self.view的frame
-(void)animationRecover
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.38f animations:^
     {
         self.view.frame=rectMarkMainView;
     }];
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
