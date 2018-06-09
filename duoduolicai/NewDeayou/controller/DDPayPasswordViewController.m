//
//  DDPayPasswordViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/30.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDPayPasswordViewController.h"
#import "DYMyAcountMainVC.h"

@interface DDPayPasswordViewController ()<UITextFieldDelegate>

@end

@implementation DDPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,[UIScreen mainScreen].bounds.size.width-20, 40)];
    label.text = @"请输入新支付密码";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:label];
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-20)/6;
    
//    if (self.isBank) {
//        NSLog(@"1");
//    }
    //底部的textfield
    UITextField *password = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+10, [UIScreen mainScreen].bounds.size.width-20, width)];
    password.tag=1000;
    password.hidden = YES;
    password.delegate=self;
    password.keyboardType = UIKeyboardTypeNumberPad;
    [password addTarget:self action:@selector(txChange:) forControlEvents:UIControlEventEditingChanged];
    [password becomeFirstResponder];
    [self.view addSubview:password];
    
    
    //for循环创建4个按钮
    for (int i = 0; i < 6; i++) {
        
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10+i*width, CGRectGetMaxY(label.frame)+10, width, width)];
        button.tag=i+1;
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        button.layer.borderWidth = 0.5;
        
        [self.view addSubview:button];
        
        
        
    }

}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)txChange:(UITextField*)tx
{
    
    NSString *text = tx.text;
    
    for (int i = 0; i < 6; i++) {
        
        int n=i+1;
        UIButton *btn = [self.view viewWithTag:n];
        
        
        NSString *str = @"";
        if (i < text.length) {
            
            
            //            str = [text substringWithRange:NSMakeRange(i, 1)];
            
            str=@"*";
        }
        
        [btn setTitle:str forState:UIControlStateNormal];
    }
    
}//监听，输入文
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];//得到输入框的内容
    if ([toBeString length]==6) {
//        NSLog(@"%@",toBeString);
        [MBProgressHUD hudWithView:self.view  label:@"提交信息中"];
        
        NSString * old=[NSString stringWithFormat:@"%@",toBeString];
        NSString * new=[NSString stringWithFormat:@"%@",toBeString];
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
                 
                 UITextField *tf = [self.view viewWithTag:10000];
                 [tf resignFirstResponder];
                 [DYUser DYUser].isSetApprove=YES;
                 [MBProgressHUD checkHudWithView:nil label:@"密码设置成功！" hidesAfter:2];
                 [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSuccessNotification object:nil];
                 //                 [self.navigationController popViewControllerAnimated:YES];
                 NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                 NSString *str = [NSString stringWithFormat:@"%@",[user objectForKey:@"UserName"]];
                 if (self.isInvest) {
                     [self.navigationController popViewControllerAnimated:YES];
                 }else{
                     [user setObject:@"1" forKey:@"paypassword_status"];
                    for (UIViewController*vc in self.navigationController.viewControllers) {
                         if ([vc isKindOfClass:[DYMyAcountMainVC class]]) {
                             DYMyAcountMainVC *VC = (DYMyAcountMainVC*)vc;
                             VC.phone=str;
                             VC.payPwdStatus=@"1";
                             VC.isBank=self.isBank;
                             [self.navigationController popToViewController:vc animated:YES];
                         }else {
                             [self.navigationController popToRootViewControllerAnimated:YES];
                         }
                     }

                 }
                 
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

    return YES;
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
