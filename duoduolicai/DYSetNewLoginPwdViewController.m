//
//  DYSetNewLoginPwdViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/15.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYSetNewLoginPwdViewController.h"
#import "DYMyAcountMainVC.h"
#import "LeafNotification.h"
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
//        self.title = @"设置新登录密码";
        self.title = @"设置密码";
    }
    return self; 
}  
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kBackColor;

    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    self.NewPwd.delegate=self;
    self.NewPwd_comfirm.delegate=self;
    [self.btnConfirm setBackgroundColor:kBtnColor];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
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
        
        [LeafNotification showInController:self withText:@"登录密码必须是6到16位长度的字符或数字组合"];
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
                 [self.NewPwd resignFirstResponder];
                 [self.NewPwd_comfirm resignFirstResponder];
                 if ([self.isUpdate isEqualToString:@"1"]) {
                     //修改密码跳到我的账号
                     [LeafNotification showInController:self withText:@"修改成功"];
                     
                     for (UIViewController*vc in self.navigationController.viewControllers) {
                         if ([vc isKindOfClass:[DYMyAcountMainVC class]]) {
                             DYMyAcountMainVC *VC = (DYMyAcountMainVC*)vc;
                             VC.phone=self.phone;
                             VC.isBank=self.isBank;
                             [self.navigationController popToViewController:vc animated:YES];
                             
                             
                         }
                     }
                     

                 }else{
                     //忘记密码跳到登录
                     [LeafNotification showInController:self withText:@"修改成功"];
                     [DYUser  loginShowLoginView];
                 }
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

    }else{
        [LeafNotification showInController:self withText:@"登录密码不一致"];
    }
}


@end
