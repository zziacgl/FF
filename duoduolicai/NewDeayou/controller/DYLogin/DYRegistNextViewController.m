//
//  DYRegistNextViewController.m
//  NewDeayou
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYRegistNextViewController.h"
#import "DYMyAcountMainVC.h"
#import "DYRegistPolicyVC.h"
#import "DYLoginVC.h"

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
@interface DYRegistNextViewController ()<UIActionSheetDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *NewPwd; // 登录密码
@property (weak, nonatomic) IBOutlet UITextField *NewPwd_comfirm; // 确认密码
@property (weak, nonatomic) IBOutlet UITextField *inviteCode; // 邀请码

@property (strong, nonatomic) IBOutlet UIView *viewStipulation;//条款说明界面
@property (strong, nonatomic) IBOutlet UIImageView *imgPolicy; // 是否同意、

@property(nonatomic,retain)NSMutableDictionary * dicInfo;//记录用户的填写信息
@property(nonatomic,retain)NSArray * aryRegistType;//所有注册类型的数组
@property(nonatomic,retain)UIView * viewRegistContentView;//当前注册类型的内容视图


@end

@implementation DYRegistNextViewController
{
   
    CGRect  rectMarkMainView;//记录self.view的初始frame
    NSString * policyContent;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    
    //使用条款按钮
    _imgPolicy.highlighted=YES;
    
    //初始化用户信息
    _dicInfo=[NSMutableDictionary new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    rectMarkMainView=self.view.frame;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self animationRecover];
    
}
#pragma mark- buttonActions

- (IBAction)agreeDeal:(UIButton *)sender
{
    _imgPolicy.highlighted = _imgPolicy.isHighlighted?NO:YES;
}
- (IBAction)privacyPolicy:(UIButton *)sender
{
    if (policyContent)
    {
        DYRegistPolicyVC * vc=[[DYRegistPolicyVC alloc]init];
        vc.title = @"网站服务协议";
        vc.contents = policyContent;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [MBProgressHUD hudWithView:self.view label:@""];
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    
    [diyouDic insertObject:@"articles" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_one_page" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"privacy" forKey:@"nid" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (isSuccess)
         {
             policyContent= [object DYObjectForKey:@"contents"];
             DYRegistPolicyVC * vc = [[DYRegistPolicyVC alloc]init];
             vc.title = @"网站服务协议";
             vc.contents = policyContent;
             [self.navigationController pushViewController:vc animated:YES];
         }
         else
         {
             [MBProgressHUD errorHudWithView:self.view label:errorMessage hidesAfter:1];
         }
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:1];
     }];
}

- (IBAction)registRightNow:(UIButton *)sender
{
    sender.userInteractionEnabled=NO;
//    [self animationRecover];
    
    //检测注册信息
    NSString * text=[self checkUserInfo];
    if (text!=nil)
    {
        [MBProgressHUD errorHudWithView:nil label:text hidesAfter:1.5];
        sender.userInteractionEnabled=YES;
        return;
    }
    
    if (_imgPolicy.isHighlighted==NO)
    {
        sender.userInteractionEnabled=YES;
        [MBProgressHUD errorHudWithView:self.view label:@"同意协议才可注册" hidesAfter:1];
        return;
    }
    //注册
    sender.userInteractionEnabled=YES;
    [MBProgressHUD hudWithView:nil label:@"注册中..."];
    
    NSString *inviteCode=_inviteCode.text;//邀请码
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    NSString* userName=@"";
    NSString* password=@"";
}

//记录填写用户信息
-(void)setUserInfoWithTag:(NSInteger)tag andText:(NSString*)text
{
    // tag:  1:手机号码  2:手机验证码  3:邮箱  13:用户名 14:密码 15:确认密码 16:验证码
    
    NSString * key=@"";

    RegistTypePhone:
        {
            switch (tag)
            {
                case 1:
                {
                    key=kUserInfoPhoneNumber;
                }break;
                case 2:
                {
                    key=kUserInfoAuthCodePhone;
                }break;
                case 13:
                {
                    key=kUserInfoUserNameTypePhone;
                }break;
                case 14:
                {
                    key=kUserInfoPasswordTypePhone;
                }break;
                case 15:
                {
                    key=kUserInfoPasswordEnsureTypePhone;
                }break;
                case 16:
                {
                    key=kPhoneTuiJianRen;
                }break;
                    
                default:
                    break;
            }
    if([text length]>0)
    {
        [_dicInfo setObject:text forKey:key];
    }

}
}
//检查用户信息是否填写符合格式
- (NSString *)checkUserInfo
{
            NSString * phoneNumber=[_dicInfo DYObjectForKey:kUserInfoPhoneNumber];
            NSString * phoneAuthCode=[_dicInfo DYObjectForKey:kUserInfoAuthCodePhone];
            //            NSString * userName=[_dicInfo DYObjectForKey:kUserInfoUserNameTypePhone];
            NSString * password=[_dicInfo DYObjectForKey:kUserInfoPasswordTypePhone];
            NSString * passwordEnsure=[_dicInfo DYObjectForKey:kUserInfoPasswordEnsureTypePhone];
            
            //判断是否有填写完整
            if (!(phoneNumber.length>0&&phoneAuthCode.length>0&&password.length>0&&passwordEnsure.length>0))
            {
                return @"请完整信息";
            }
            
            if (!(password.length>=6&&password.length<=15))
            {
                return @"用户名或密码长度不正确";
            }
            
            int num = 0;
            //判断是否是数字
            NSString * regex = @"(^[0-9]{6,15}$)";
            NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if([pred evaluateWithObject:password]==YES)
            {
                num++;
            }
            //判断是否是字母
            NSString * regex1 = @"(^[a-zA-Z]{6,15}$)";
            NSPredicate * pred1      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
            if([pred1 evaluateWithObject:password]==YES)
            {
                num++;
            }
            //判断是否是字母特殊字符
            NSString * regex2 = @"(^[-.!@#$%^&*()+?><]{6,15}$)";
            NSPredicate * pred2      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
            if([pred2 evaluateWithObject:password]==YES)
            {
                num++;
            }
            //            if (num>=1) {
            //
            //                return @"密码格式不正确，请输入字母、数字或特殊字符的混合式！";
            //            }
            
            //判断两次的输入密码是否一致
            if(![passwordEnsure isEqualToString:password])
            {
                return @"密码不一致";
            }
    return self;
}

#pragma mark- textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self animationRecover];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setUserInfoWithTag:textField.tag andText:textField.text];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // 256
    CGRect rect= [self.viewRegistContentView convertRect:textField.frame toView:[UIApplication sharedApplication].keyWindow];
    float originX=rect.origin.y+rect.size.height;
    [self animationWithOriginY:originX];
    return YES;
}

//适应键盘的animation,改变self.view的frame
-(void)animationWithOriginY:(float)originY
{
    float overDistance=kScreenSize.height-originY-256-50;
    if (overDistance<0)
    {
        [UIView animateWithDuration:0.38f animations:^
         {
             self.view.frame=CGRectMake(rectMarkMainView.origin.x, self.view.frame.origin.y+overDistance, rectMarkMainView.size.width, rectMarkMainView.size.height);
             
         }];
    }
    else
    {
        float overDistance2=self.view.frame.origin.y+overDistance;
        if (self.view.frame.origin.y<rectMarkMainView.origin.y)
        {
            if (overDistance2>rectMarkMainView.origin.y)
            {
                overDistance2=rectMarkMainView.origin.y;
            }
            [UIView animateWithDuration:0.38f animations:^
             {
                 self.view.frame=CGRectMake(rectMarkMainView.origin.x, overDistance2, rectMarkMainView.size.width, rectMarkMainView.size.height);
             }];
            
        }
    }
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
