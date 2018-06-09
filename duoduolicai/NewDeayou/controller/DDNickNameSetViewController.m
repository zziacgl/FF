//
//  DDNickNameSetViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 16/2/24.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDNickNameSetViewController.h"
#import "DDUITextField.h"
@interface DDNickNameSetViewController ()<UITextFieldDelegate>

@end

@implementation DDNickNameSetViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"昵称";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text.delegate=self;
    self.niname=[self.niname stringByReplacingOccurrencesOfString:@" " withString:@""];
//    self.text.text=self.niname;
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:kMainColor forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 38, 38);
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightBtn addTarget:self action:@selector(handleSave) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (BOOL)textFieldShouldBeginEditing:(DDUITextField *)textField{
    //返回一个BOOL值，指定是否循序文本字段开始编辑
//    textField.text=@"      ";
    return YES;
}
- (BOOL)textField:(DDUITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString *nickname=[self.text.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (range.length==1) {
        nickname=[nickname substringToIndex:nickname.length-1];
    }else{
        nickname=[NSString stringWithFormat:@"%@%@",nickname,string];
    }

    if (nickname.length>8) {
        self.alertLabel.hidden=NO;
    }else{
        self.alertLabel.hidden=YES;
    }
    
    return YES;
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [MobClick beginLogPageView:@"昵称设置"];//("PageOne"为页面名称，可自定义)
}
- (void)handleSave {
    NSString *nickname=[self.text.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (nickname.length>8) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"昵称修改失败" message:@"昵称不得大于8个汉字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        
        NSString *sex=[NSString stringWithFormat:@"%@",[ud objectForKey:@"sex"]];
        
        NSString *niname=@"";
        if ([self.text.text isEqualToString:@"      "]||[self.text.text isEqualToString:@""]) {
            niname=[NSString stringWithFormat:@"%@",[ud objectForKey:@"niname"]];
        }else{
            niname=[self.text.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            [ud setObject:niname forKey:@"niname"];
        }
//        NSLog(@"%@",niname);
        NSString *avatar2=[NSString stringWithFormat:@"%@",[ud objectForKey:@"avatar"]];
        NSString *avatar=[NSString stringWithFormat:@"%@",[ud objectForKey:@"avatar"]];
        if ([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_7.png"]) {
            avatar2=@"avatar_7.png";
        }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_9.png"])
        {
            avatar2=@"avatar_9.png";
        }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_11.png"])
        {
            avatar2=@"avatar_11.png";
        }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_16.png"])
        {
            avatar2=@"avatar_16.png";
        }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_17.png"])
        {
            avatar2=@"avatar_17.png";
        }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_18.png"])
        {
            avatar2=@"avatar_18.png";
        }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_22.png"])
        {
            avatar2=@"avatar_22.png";
        }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_23.png"])
        {
            avatar2=@"avatar_23.png";
        }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_24.png"])
        {
            avatar2=@"avatar_24.png";
        }
        
        DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
        [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
        [diyouDic insertObject:@"update_user_info" forKey:@"q" atIndex:0];
        [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic insertObject:@"" forKey:@"avatar" atIndex:0];
        [diyouDic insertObject:sex forKey:@"sex" atIndex:0];
        [diyouDic insertObject:niname forKey:@"niname" atIndex:0];
        
        
        [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
         {
             if (isSuccess)
             {
                 
                [self.navigationController popToRootViewControllerAnimated:YES];
                 
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

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
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
