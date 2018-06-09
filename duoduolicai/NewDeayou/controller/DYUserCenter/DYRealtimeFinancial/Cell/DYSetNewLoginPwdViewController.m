//
//  DYSetNewLoginPwdViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/15.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYSetNewLoginPwdViewController.h"
#import "DYMyAcountMainVC.h"

@interface DYSetNewLoginPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *NewPwd;
@property (weak, nonatomic) IBOutlet UITextField *NewPwd_comfirm;

@end

@implementation DYSetNewLoginPwdViewController

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
    self.title = @"设置新登录密码";
    self.NewPwd.delegate=self;
    self.NewPwd_comfirm.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.NewPwd resignFirstResponder];
    [self.NewPwd_comfirm resignFirstResponder];
}
- (IBAction)Comfirm:(id)sender {
    if ([self.NewPwd.text length]<6||[self.NewPwd.text length]>16) {
        [MBProgressHUD errorHudWithView:nil label:@"登录密码必须是6到16位长度的字符或数字组合" hidesAfter:2];
        return;
    }
    if ([self.NewPwd.text isEqualToString:self.NewPwd_comfirm.text]) {
        DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:[NSString stringWithFormat:@"%@",self.phone] forKey:@"phone" atIndex:0];
        [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"find_password" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:self.NewPwd.text forKey:@"password" atIndex:0];
        
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
         {
             //wayne-test
             if (isSuccess)
             {
                 if ([self.isUpdate isEqualToString:@"1"]) {
                     //修改密码跳到我的账号
                     [MBProgressHUD errorHudWithView:nil label:@"修改成功" hidesAfter:1];
                     DYMyAcountMainVC * myAcount=[[DYMyAcountMainVC alloc]initWithNibName:@"DYMyAcountMainVC" bundle:nil];
                     myAcount.hidesBottomBarWhenPushed=YES;
                     myAcount.phone=self.phone;
                     [self.navigationController pushViewController:myAcount animated:YES];

                 }else{
                     //忘记密码跳到登录
                     [MBProgressHUD errorHudWithView:nil label:@"修改成功" hidesAfter:1];
                     [DYUser  loginShowLoginView];
                 }
             }
             else
             {
                 
                 [MBProgressHUD errorHudWithView:nil label:errorMessage hidesAfter:1];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideAllHUDsForView:nil animated:YES];
             [MBProgressHUD errorHudWithView:nil label:@"网络异常" hidesAfter:1];
         }];

    }else{
        [MBProgressHUD errorHudWithView:nil label:@"登录密码不一致" hidesAfter:1];
    }
}


@end
