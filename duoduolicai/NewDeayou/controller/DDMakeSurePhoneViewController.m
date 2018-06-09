//
//  DDMakeSurePhoneViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/23.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMakeSurePhoneViewController.h"
#import "DDChangePhoneLastViewController.h"
@interface DDMakeSurePhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *changeNewPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *yourMassageTF;

@property (weak, nonatomic) IBOutlet UIButton *getMassageBtn;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;

@end

@implementation DDMakeSurePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    
    self.getMassageBtn.layer.cornerRadius = 3;
    self.getMassageBtn.layer.masksToBounds = YES;
    self.getMassageBtn.backgroundColor = [UIColor orangeColor];
     [self.getMassageBtn setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(241, 143, 49, 1)] forState:UIControlStateHighlighted];
    [self.getMassageBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getMassageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.getMassageBtn addTarget:self action:@selector(handleGetNewMassage) forControlEvents:UIControlEventTouchUpInside];
   
    
    
    self.makeSureBtn.layer.cornerRadius = 5;
    self.makeSureBtn.layer.masksToBounds = YES;
    self.makeSureBtn.backgroundColor = kBtnColor;
    // Do any additional setup after loading the view from its nib.
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    
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
                
                [self.getMassageBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                self.getMassageBtn.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:1];
                
                [self.getMassageBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                
                [UIView commitAnimations];
                
                self.getMassageBtn.userInteractionEnabled = NO;
                
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
    
    
    
}


- (void)handleGetNewMassage {
    
    NSString *newPhone = self.changeNewPhoneTF.text;
    if (!(newPhone.length == 11)) {
        [LeafNotification showInController:self withText:@"请输入正确的手机号"];
        return;
    }
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"approve_code_new" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:newPhone forKey:@"phone" atIndex:0];
    [diyouDic insertObject:@"add" forKey:@"type" atIndex:0];
    [diyouDic insertObject:[DYUser GetLoginKey] forKey:@"login_key" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         
         if (isSuccess)
         {
//             NSLog(@"%@",object);
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
                 self.getMassageBtn.enabled=YES;
                 [LeafNotification showInController:self withText:errorMessage];
             }
             
         }
         
     } errorBlock:^(id error)
     {
         self.getMassageBtn.enabled=YES;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];

}
- (IBAction)makeSureYourPhone:(UIButton *)sender {
    NSString *newPhone = self.changeNewPhoneTF.text;
    if (!(newPhone.length == 11)) {
        [LeafNotification showInController:self withText:@"请输入正确的手机号"];
        return;
    }
   
    [MBProgressHUD hudWithView:self.view label:@"验证验证码..."];
    
    if ([self.comeView isEqualToString:@"message"]) {
        DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"up_phone_verify_code" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
        [diyouDic insertObject:self.messageId forKey:@"id" atIndex:0];
        [diyouDic insertObject:self.yourMassageTF.text forKey:@"bind_code" atIndex:0];
        [diyouDic insertObject:self.changeNewPhoneTF.text forKey:@"bind_phone" atIndex:0];
        [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        
        [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (isSuccess == YES) {
//                NSLog(@"dawdawdawda   %@", object);
                DDChangePhoneLastViewController *lastiew = [[DDChangePhoneLastViewController alloc] init];
                [self.navigationController pushViewController:lastiew animated:YES];
            
            
            }else {
                [LeafNotification showInController:self withText:errorMessage];
            }
            
            
        } fail:^{
            [LeafNotification showInController:self withText:@"网络异常"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];

    }else {
        DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"change_phone" forKey:@"q" atIndex:0];
        [diyouDic insertObject:self.massageStr forKey:@"cancel_code" atIndex:0];
        [diyouDic insertObject:self.yourMassageTF.text forKey:@"bind_code" atIndex:0];
        
        [diyouDic insertObject:self.changeNewPhoneTF.text forKey:@"bind_phone" atIndex:0];
        
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[DYUser GetLoginKey] forKey:@"login_key" atIndex:0];
        
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
             if (success==YES) {
                 
                 [MBProgressHUD checkHudWithView:self.view label:@"手机号修改成功" hidesAfter:1.5];
                 [self.navigationController popToRootViewControllerAnimated:YES];
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
