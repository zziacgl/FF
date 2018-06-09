//
//  DDGenderViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 16/2/24.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDGenderViewController.h"

@interface DDGenderViewController ()

@end

@implementation DDGenderViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"性别";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    int sex=[[NSString stringWithFormat:@"%@",[ud objectForKey:@"sex"]]intValue];
    switch (sex) {
        case 0:
        {
        }
            break;
        case 1:
        {
            self.sex1Bnt.hidden=NO;//男
        }
            break;
        case 2:
        {
            self.sex2Bnt.hidden=NO;//女
        }
            break;
        default:
            break;
    }
}
- (IBAction)sex1Choose:(id)sender {
    self.sex1Bnt.hidden=NO;
    self.sex2Bnt.hidden=YES;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"1" forKey:@"sex"];
     [self changeSex];
}
- (IBAction)sex2Choose:(id)sender {
    self.sex1Bnt.hidden=YES;
    self.sex2Bnt.hidden=NO;
   
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"2" forKey:@"sex"];
     [self changeSex];
}
- (void)changeSex {
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *sex=[NSString stringWithFormat:@"%@",[ud objectForKey:@"sex"]];
    
    NSString *niname=[NSString stringWithFormat:@"%@",[ud objectForKey:@"niname"]];
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
         //wayne-test
         if (isSuccess)
         {
             
             [self.navigationController popViewControllerAnimated:YES];
             
             
             
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
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
