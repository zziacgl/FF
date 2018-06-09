//
//  MakeSurePayPasswordViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/3/28.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "MakeSurePayPasswordViewController.h"
#import "SYPasswordView.h"
#import "TTPasswordView.h"
@interface MakeSurePayPasswordViewController ()
@property (nonatomic, strong) SYPasswordView *pasView;
@property (nonatomic, retain)TTPasswordView *password;
@property (nonatomic, copy) NSString *firstCode;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation MakeSurePayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置支付密码";
    self.view.backgroundColor = kBackColor;
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    self.password = [[TTPasswordView alloc] initWithFrame:CGRectMake(30, 80, kMainScreenWidth - 60, 50)];
    self.password.elementCount = 6;
    self.password.elementColor= [UIColor blackColor];
    [self.view addSubview:self.password];
    __block MakeSurePayPasswordViewController *weakself=self;
    self.password.passwordBlock = ^(NSString *password) {
        if (password.length==6) {
            [weakself enterCode:password];
        }
        
    };
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 140, kMainScreenWidth - 60, 20)];
    _tipLabel.textColor = kMainColor;
    _tipLabel.font = [UIFont systemFontOfSize:12];
     self.tipLabel.hidden = YES;
    [self.view addSubview:self.tipLabel];
//    self.pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(16, 100, self.view.frame.size.width - 32, 45)];
//    [self.view addSubview:_pasView];
    
    // Do any additional setup after loading the view.
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)enterCode:(NSString *)code
{
    
    if (!self.firstCode) {
        self.firstCode=code;
        self.tipLabel.text=@"请再次输入您的支付密码";
        self.tipLabel.hidden=NO;
        [self.password clearText];
        [self.password.textField becomeFirstResponder];
    }
    else if (self.firstCode&&[self.firstCode isEqualToString:code])
    {
        DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"set_pay_password" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:self.phone forKey:@"phone" atIndex:0];
        [diyouDic insertObject:self.codeStr forKey:@"code" atIndex:0];
        [diyouDic insertObject:code forKey:@"pay_password" atIndex:0];

        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
         {
             if (isSuccess)
             {
                 
                    NSLog(@"%@",object);
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"支付密码设置成功" preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                     [ self.navigationController popToRootViewControllerAnimated:YES];
                 }];
                 [alertController addAction:cancelAction];
                 [self presentViewController:alertController animated:YES completion:nil];
               
                 
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
        
        
       
        
        
        
    }
    else
    {
        self.tipLabel.text=@"您两次输入的安全码不匹配，请重新设置";
        [self.password clearText];
        [self.password.textField becomeFirstResponder];
        self.firstCode=nil;
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
