//
//  SetPayPasswordViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/3/28.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "SetPayPasswordViewController.h"
#import "MakeSurePayPasswordViewController.h"
@interface SetPayPasswordViewController ()

@end

@implementation SetPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"设置支付密码";
    self.view.backgroundColor = kBackColor;
    self.myPhoneTF.text = self.phone;
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.codeTF resignFirstResponder];
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
                
                [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                self.getCodeBtn.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:1];
                
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                
                [UIView commitAnimations];
                
                self.getCodeBtn.userInteractionEnabled = NO;
                
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
    
    
    
}

- (IBAction)handleGetCode:(UIButton *)sender {
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:self.myPhoneTF.text forKey:@"phone" atIndex:0];
    [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_code" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"set_pay_password" forKey:@"type" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];

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
                 self.getCodeBtn.enabled=YES;
                 [LeafNotification showInController:self withText:errorMessage];
             }
             
         }
         
     } errorBlock:^(id error)
     {
         self.getCodeBtn.enabled=YES;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];

}

- (IBAction)handleNext:(UIButton *)sender {
   
    NSString * phoneNumber = self.myPhoneTF.text;
    
    NSLog(@"验证码%@", self.codeTF.text);
    [MBProgressHUD hudWithView:self.view label:@"验证验证码..."];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:phoneNumber forKey:@"phone" atIndex:0];
    [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"check_code" forKey:@"q" atIndex:0];
    [diyouDic insertObject:self.codeTF.text forKey:@"phone_code" atIndex:0];
    [diyouDic insertObject:@"set_pay_password" forKey:@"type" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];

    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

         if (success==YES) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];


             MakeSurePayPasswordViewController *makeSureVC = [[MakeSurePayPasswordViewController alloc] init];
             makeSureVC.phone = self.myPhoneTF.text;
             makeSureVC.codeStr = self.codeTF.text;
             [self.navigationController pushViewController:makeSureVC animated:YES];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
