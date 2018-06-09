//
//  DYPayPasswordVC2.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/14.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYPayPasswordVC2.h"
#import "DYMyAcountMainVC.h"

@interface DYPayPasswordVC2 ()<UITextFieldDelegate>

#define KOLDPASSWORD      @"old";//旧密码
#define KNEWPASSWORD      @"new";//新密码
#define KREPEATPASSWORD   @"repeat";//重复密码

@property (strong, nonatomic) IBOutlet UIButton *btnCofirm;
@property (strong, nonatomic) IBOutlet UIView *viewContent;
@property (strong, nonatomic) NSMutableDictionary *dicInfo;//提交信息


@end

@implementation DYPayPasswordVC2

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
//    if (self.isBank) {
//        NSLog(@"1");
//    }
    _btnCofirm.layer.cornerRadius=5;
    _viewContent.layer.cornerRadius=5;
    _viewContent.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _viewContent.layer.borderWidth=0.5;
    _dicInfo=[[NSMutableDictionary alloc]init];
    
    _btnCofirm.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
    
    
    _btnCofirm.layer.cornerRadius=3.0f;
    _btnCofirm.layer.masksToBounds=YES;
    
    
      self.title=@"设置支付密码";
    
} 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    switch (textField.tag)
    {
        case 10000:
            if ([textField.text length]>0) {
                
                [_dicInfo  setObject:textField.text  forKey:@"old"];
            }
            else
            {
                [_dicInfo  setObject:@""  forKey:@"old"];
            }
            
            break;
        case 10001:
            
            if ([textField.text length]>0) {
                [_dicInfo  setObject:textField.text  forKey:@"new"];
            }else
            {
                [_dicInfo  setObject:@""  forKey:@"new"];
            }
            
            
            break;
        case 10002:
            if ([textField.text length]>0) {
                [_dicInfo  setObject:textField.text  forKey:@"repeat"];
            }else
            {
                [_dicInfo  setObject:@""  forKey:@"repeat"];
            }
            
            break;
            
        default:
            break;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    [self performSelector:@selector(checkButtonEnable) withObject:nil afterDelay:0.2];
    return YES;
}

- (IBAction)updataAction:(id)sender {
    UITextField *text=(UITextField*)[self.view viewWithTag:10000];
    [text resignFirstResponder];
    text=(UITextField*)[self.view viewWithTag:10001];
    [text resignFirstResponder];
    text=(UITextField*)[self.view viewWithTag:10002];
    [text resignFirstResponder];
    
    if ([self checkInfoShowMessage:YES]==YES) {
        
        [MBProgressHUD hudWithView:self.view  label:@"提交信息中"];
        
        NSString * old=[NSString stringWithFormat:@"%@",[_dicInfo objectForKey:@"old"]];
        NSString * new=[_dicInfo objectForKey:@"new"];
        //————————————————————————设置支付密码接口——————————————————————————
        DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"update_paypassword" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:old forKey:@"oldpassword" atIndex:0];
        [diyouDic insertObject:new forKey:@"paypassword" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
             
             if (success==YES) {
                 //可用信用额度数据填充
                 [DYUser DYUser].isSetApprove=YES;
                 [MBProgressHUD checkHudWithView:nil label:@"密码设置成功！" hidesAfter:2];
                 [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSuccessNotification object:nil];
//                 [self.navigationController popViewControllerAnimated:YES];
                 NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                 NSString *str = [NSString stringWithFormat:@"%@",[user objectForKey:@"UserName"]];
                 NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                 [ud setObject:@"1" forKey:@"paypassword_status"];
                // DYMyAcountMainVC *VC = [[DYMyAcountMainVC alloc]initWithNibName:@"DYMyAcountMainVC" bundle:nil];
                 //VC.hidesBottomBarWhenPushed = YES;
                 //VC.phone=str;
                 //VC.payPwdStatus=@"1";
                 //VC.isBank=self.isBank;
                 //[self.navigationController pushViewController:VC animated:YES];
                 for (UIViewController*vc in self.navigationController.viewControllers) {
                     if ([vc isKindOfClass:[DYMyAcountMainVC class]]) {
                         DYMyAcountMainVC *VC = (DYMyAcountMainVC*)vc;
                         VC.phone=str;
                         VC.payPwdStatus=@"1";
                         VC.isBank=self.isBank;
                         [self.navigationController popToViewController:vc animated:YES];
                     }
                 }


             }
             else
             {
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
        
    }

}
-(BOOL)checkInfoShowMessage:(BOOL)show
{
    BOOL isOk=NO;
    UITextField *textF=(UITextField*)[self.view viewWithTag:10000];
    if ([textF.text length]>0) {
        [_dicInfo  setObject:textF.text  forKey:@"old"];
        
    }
    textF=(UITextField*)[self.view viewWithTag:10001];
    if ([textF.text length]>0) {
        [_dicInfo  setObject:textF.text  forKey:@"new"];
    }
    textF=(UITextField*)[self.view viewWithTag:10002];
    if ([textF.text length]>0) {
        [_dicInfo  setObject:textF.text  forKey:@"repeat"];
    }
    
    
    
    NSString * new=[_dicInfo objectForKey:@"new"];
    NSString * repeat=[_dicInfo objectForKey:@"repeat"];
    
    if (!([new length]<=16&&[new length]>=6&&[repeat length]<=16&&[repeat length]>=6))
    {
        
        if (show)
        {
            [LeafNotification showInController:self withText:@"请填写正确的信息"];
        }
    }
    else
    {
        if([new isEqualToString:repeat]==YES)
        {
            isOk=YES;
            
        }else
        {
            if (show)
            {
                [LeafNotification showInController:self withText:@"再次支付密码不正确"];
            }
            
        }
    }
    
    return isOk;
}

-(BOOL)checkCanClick
{
    BOOL isOk=NO;
    UITextField *textF=(UITextField*)[self.view viewWithTag:10000];
    if ([textF.text length]>0) {
        [_dicInfo  setObject:textF.text  forKey:@"old"];
    }else
    {
        [_dicInfo  setObject:@""  forKey:@"old"];
    }
    
    textF=(UITextField*)[self.view viewWithTag:10001];
    if ([textF.text length]>0) {
        [_dicInfo  setObject:textF.text  forKey:@"new"];
    }
    else
    {
        [_dicInfo  setObject:@""  forKey:@"new"];
    }
    textF=(UITextField*)[self.view viewWithTag:10002];
    if ([textF.text length]>0) {
        [_dicInfo  setObject:textF.text  forKey:@"repeat"];
    }else
    {
        [_dicInfo  setObject:@""  forKey:@"repeat"];
    }
    NSString * old=[_dicInfo objectForKey:@"old"];
    NSString * new=[_dicInfo objectForKey:@"new"];
    NSString * repeat=[_dicInfo objectForKey:@"repeat"];
    
    if (([old length]>0&&[new length]>0&&[repeat length]>0))
    {
        isOk=YES;
    }else
    {
        isOk=NO;
    }
    return isOk;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}


@end
