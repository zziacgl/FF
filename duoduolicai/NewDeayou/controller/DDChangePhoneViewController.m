//
//  DDChangePhoneViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/23.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDChangePhoneViewController.h"
#import "DDMakeSurePhoneViewController.h"
#import "DDOtherWayViewController.h"
#define kPhoneNumber         kefu_phone_title
#define CUSTOMER_SERVICE_PHONE [NSURL URLWithString:kefu_phone]


@interface DDChangePhoneViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *massageTF;
@property (weak, nonatomic) IBOutlet UIButton *getMassageBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation DDChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改手机号码";
    [self.nextBtn setBackgroundColor:kBtnColor];
    self.nextBtn.layer.cornerRadius = 5;
    self.nextBtn.layer.masksToBounds = YES;
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    //导航右边的按钮
    UIButton * btnRightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor = [UIColor clearColor];
    btnRightItem.frame = CGRectMake(0, 0, 30, 30);
    btnRightItem.titleLabel.font = [UIFont systemFontOfSize:15];
//    [btnRightItem setTitle:@"提现记录" forState:UIControlStateNormal];
    [btnRightItem setImage:[UIImage imageNamed:@"shouji_"] forState:UIControlStateNormal];
    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRightItem addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    

    
    self.getMassageBtn.backgroundColor = kBtnColor;
    [self.getMassageBtn setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(241, 143, 49, 1)] forState:UIControlStateHighlighted];
    self.getMassageBtn.layer.cornerRadius = 3;
    self.getMassageBtn.layer.masksToBounds = YES;
    [self.getMassageBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getMassageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.phoneLabel.text = self.phone;
    [self.getMassageBtn addTarget:self action:@selector(handleGetMassage) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)back{
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
#pragma mark -- 拨打电话
- (void)callPhone {
    if ( [[UIApplication sharedApplication]canOpenURL:CUSTOMER_SERVICE_PHONE])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"即将呼叫丰丰金融客服" message:kPhoneNumber delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        
        [alertView show];
    }
    else
    {
        [LeafNotification showInController:self withText:@"设备不支持打电话"];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication]openURL:CUSTOMER_SERVICE_PHONE];
    }
}

- (void)handleGetMassage {
    [self startTime];
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"unbund_code" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"cancel" forKey:@"type" atIndex:0];
    [diyouDic insertObject:[DYUser GetLoginKey] forKey:@"login_key" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
       
         if (isSuccess)
         {
//             NSLog(@"%@",object);
             
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

    
- (IBAction)gotoNext:(UIButton *)sender {
    NSString * phoneNumber=self.phoneLabel.text;
    NSString *code=self.massageTF.text;
    [MBProgressHUD hudWithView:self.view label:@"验证验证码..."];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:phoneNumber forKey:@"phone" atIndex:0];
    [diyouDic insertObject:@"phone" forKey:@"module" atIndex:0];
    [diyouDic insertObject:code forKey:@"code" atIndex:0];
    [diyouDic insertObject:@"check_code" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"cancel" forKey:@"type" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];

    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
              [self.massageTF resignFirstResponder];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             DDMakeSurePhoneViewController * setNewPwd=[[DDMakeSurePhoneViewController alloc]initWithNibName:@"DDMakeSurePhoneViewController" bundle:nil];
             setNewPwd.hidesBottomBarWhenPushed=YES;
             setNewPwd.massageStr = code;
             setNewPwd.comeView = @"oldPhone";
             setNewPwd.oldPhoneStr = self.phone;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.massageTF resignFirstResponder];
    
}
#pragma mark -- 其他方式修改手机号
- (IBAction)otherWayChangePhone:(UIButton *)sender {
    DDOtherWayViewController *otherWay = [[DDOtherWayViewController alloc] init];
    otherWay.oldPhoneNumber = self.phone;
    [self.navigationController pushViewController:otherWay animated:YES];
    
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
