//
//  DDWalletTurnOutViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/16.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDWalletTurnOutViewController.h"
#import "LeafNotification.h"
@interface DDWalletTurnOutViewController ()<UITextFieldDelegate>

@property(nonatomic)int keyboardHeight;//键盘高度
@property (weak, nonatomic) IBOutlet UILabel *BalanceLabel;//可转出金额

@end

@implementation DDWalletTurnOutViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"转出";
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.BalanceLabel.text=self.balance;
    UIButton *bin=[[UIButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44-64, [UIScreen mainScreen].bounds.size.width, 44)];
    [bin setBackgroundImage:[UIImage imageNamed:@"投资详情_02"] forState:UIControlStateNormal];
    [bin setTitle:@"确认转出" forState:UIControlStateNormal];
    bin.enabled=NO;
    bin.tag=10;
    [bin addTarget:self action:@selector(TurnOut) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:bin];
    
    self.TextMoney.delegate=self;
    self.TextMoney.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"充值页面_15@2x"]];
    self.TextMoney.leftViewMode=UITextFieldViewModeAlways;
    
    self.HeadView.backgroundColor=kCOLOR_R_G_B_A(253, 83, 83, 1);
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    self.isDone=[[ud objectForKey:@"isDone"]intValue];
    if (self.isDone!=1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)TurnOut{
    [MBProgressHUD hudWithView:self.view label:@"数据请求中"];
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"lqb" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"out_of_lqb" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:self.TextMoney.text forKey:@"amount" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"type" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (success==YES) {
             //可用信用额度数据填充
//             [self.navigationController popToRootViewControllerAnimated:YES];//回到上一页
             [self.tabBarController setSelectedIndex:3];//跳到账户
             
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:@"1" forKey:@"BalaneDone"];
             [ud setObject:self.TextMoney.text forKey:@"BalanceEnd"];
             [ud setObject:@"2" forKey:@"key"];
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
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.keyboardHeight=height;
    
    UIButton *btn=[self.view viewWithTag:10];
    btn.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-22-64-self.keyboardHeight);

}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    UIButton *btn=[self.view viewWithTag:10];
    btn.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-22-64);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.TextMoney.text=[NSString stringWithFormat:@"    "];

  //输入框开始输入时
    return true;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    float m=0;
    NSString *s=@"";
    if (range.length==1) {
        m=[[self.TextMoney.text substringToIndex:self.TextMoney.text.length-1] floatValue];
        s=[self.TextMoney.text substringToIndex:self.TextMoney.text.length-1];
    }else{
        m=[[NSString stringWithFormat:@"%@%@",self.TextMoney.text,string] floatValue];
        s=[NSString stringWithFormat:@"%@%@",self.TextMoney.text,string];
    }
    float a=[self.annual floatValue];
    float n=m*a/365*30/100;
    self.Alert.text=[NSString stringWithFormat:@"%.2f",n];
    UIButton *btn=[self.view viewWithTag:10];
    if ([self.balance floatValue]>=m&&[self.balance floatValue]>0&&m>0) {
        btn.enabled=YES;
    }else{
        btn.enabled=NO;
    }
    
    NSArray *array=[s componentsSeparatedByString:@"."];
    if (array.count==2) {
        NSString *s2=[NSString stringWithFormat:@"%@",array[1]];
        if (s2.length>2) {
            self.TextMoney.text=[NSString stringWithFormat:@"    %.2f",m];
            return NO;
        }
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.TextMoney resignFirstResponder];
    UIButton *btn=[self.view viewWithTag:10];
    btn.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-22-64);

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
