//
//  CodeLoginViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/3/28.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "CodeLoginViewController.h"

@interface CodeLoginViewController ()

@end

@implementation CodeLoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor  = kBackColor;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor  = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机验证码登录";
    self.view.backgroundColor = kBackColor;
    self.getcodeBtn.layer.cornerRadius = 5;
    self.getcodeBtn.layer.masksToBounds = YES;
    self.getcodeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.getcodeBtn.layer.borderWidth = 0.5;
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)getCode:(UIButton *)sender {
    if (!(self.phoneTF.text.length == 11)) {
        [LeafNotification showInController:self withText:@"请输入正确的手机号"];
        return;
        
    }
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:self.phoneTF.text forKey:@"phone" atIndex:0];
    [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_code" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"login" forKey:@"type" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         //wayne-test
         if (isSuccess)
         {
             [self startTime];
             [self.coedTF resignFirstResponder];
         }
         else
         {
             
             if ([errorMessage isEqualToString:@"发送失败"]==YES) {
                 //关闭获取验证码交互开关
                 [MBProgressHUD checkHudWithView:self.view label:@"验证码已发送至短信" hidesAfter:1.5];
                 
                 
             }
             else
             {
                 self.getcodeBtn.enabled=YES;
                 [LeafNotification showInController:self withText:errorMessage];
             }
             
         }
         
     } errorBlock:^(id error)
     {
         self.getcodeBtn.enabled=YES;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}


- (IBAction)gotoLogin:(UIButton *)sender {
    
    if (!(self.phoneTF.text.length == 11)) {
        [LeafNotification showInController:self withText:@"请输入正确的手机号"];
        return;

    }
    if (self.coedTF.text.length < 1) {
        [LeafNotification showInController:self withText:@"请输入验证码"];
        return;
    }
    [MBProgressHUD hudWithView:self.view label:@"登录中"];
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"login_by_phone" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:self.phoneTF.text forKey:@"phone" atIndex:0];
    [diyouDic insertObject:self.coedTF.text forKey:@"code" atIndex:0];
    [diyouDic insertObject:@"ios" forKey:@"type" atIndex:0];

    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

         if (isSuccess)
         {
             NSLog(@"登录%@", object);
             [DYUser loginRemenberUserName:self.phoneTF.text password:nil];

             [DYUser userIDPersistence:object];
              [DYUser loginHiddenLoginView];
         }
         else
         {
            [LeafNotification showInController:self withText:errorMessage];
             
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
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
                
                [self.getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                self.getcodeBtn.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:1];
                
                [self.getcodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                
                [UIView commitAnimations];
                
                self.getcodeBtn.userInteractionEnabled = NO;
                
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
    
    
    
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
