//
//  DYExChangeViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/10/7.
//  Copyright © 2015年 wayne. All rights reserved.
//

#import "DYExChangeViewController.h"

@interface DYExChangeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ExchangeNum;//需要兑换的多米数
@property (weak, nonatomic) IBOutlet UILabel *Balance_DuoMi;//剩余多米数
@property (weak, nonatomic) IBOutlet UIButton *ComfirmBtn;//提交按钮

@end

@implementation DYExChangeViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"兑换现金";
    }
    return self;
}
-(void)loadView{
    [super loadView];
    self.ExchangeNum.delegate=self;
    [self.ComfirmBtn.layer setMasksToBounds:YES];
    [self.ComfirmBtn.layer setCornerRadius:5.0];
    self.Balance_DuoMi.text=self.Balance_DuoMiAmount;
}
//提交
- (IBAction)ComFirm:(id)sender {
    [self.ExchangeNum resignFirstResponder];

    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"exchange_duomi" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:self.ExchangeNum.text forKey:@"exchange_number" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success==YES) {
             //可用信用额度数据填充
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"兑换成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
             [alert show];
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         else
         {
             [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
         }
         
     } errorBlock:^(id error)
     {
        [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
     }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark---textfielddelegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.ExchangeNum resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self ComFirm:self.ComfirmBtn];
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
