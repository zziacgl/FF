//
//  DDTopImageSetViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 16/2/24.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDTopImageSetViewController.h"

@interface DDTopImageSetViewController ()

@end

@implementation DDTopImageSetViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"头像设置";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *avatar=[NSString stringWithFormat:@"%@",[ud objectForKey:@"avatar"]];
//    NSLog(@"%@",avatar);//http://www.51duoduo.com/dyupfiles/avatar/default/avatar_11.png
    if ([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_7.png"]) {
        self.right1Bnt.hidden=NO;
    }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_9.png"])
    {
        self.right2Bnt.hidden=NO;
    }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_11.png"])
    {
        self.right3Bnt.hidden=NO;
    }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_16.png"])
    {
        self.right4Bnt.hidden=NO;
    }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_17.png"])
    {
        self.right5Bnt.hidden=NO;
    }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_18.png"])
    {
        self.right6Bnt.hidden=NO;
    }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_22.png"])
    {
        self.right7Bnt.hidden=NO;
    }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_23.png"])
    {
        self.right8Bnt.hidden=NO;
    }else if([avatar isEqualToString:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_24.png"])
    {
        self.right9Bnt.hidden=NO;
    }
}
- (IBAction)right1Choose:(id)sender {
    self.right1Bnt.hidden=NO;
    self.right2Bnt.hidden=YES;
    self.right3Bnt.hidden=YES;
    self.right4Bnt.hidden=YES;
    self.right5Bnt.hidden=YES;
    self.right6Bnt.hidden=YES;
    self.right7Bnt.hidden=YES;
    self.right8Bnt.hidden=YES;
    self.right9Bnt.hidden=YES;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_7.png" forKey:@"avatar"];
}
- (IBAction)right2Choose:(id)sender {
    self.right1Bnt.hidden=YES;
    self.right2Bnt.hidden=NO;
    self.right3Bnt.hidden=YES;
    self.right4Bnt.hidden=YES;
    self.right5Bnt.hidden=YES;
    self.right6Bnt.hidden=YES;
    self.right7Bnt.hidden=YES;
    self.right8Bnt.hidden=YES;
    self.right9Bnt.hidden=YES;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_9.png" forKey:@"avatar"];
}
- (IBAction)right3Choose:(id)sender {
    self.right1Bnt.hidden=YES;
    self.right2Bnt.hidden=YES;
    self.right3Bnt.hidden=NO;
    self.right4Bnt.hidden=YES;
    self.right5Bnt.hidden=YES;
    self.right6Bnt.hidden=YES;
    self.right7Bnt.hidden=YES;
    self.right8Bnt.hidden=YES;
    self.right9Bnt.hidden=YES;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_11.png" forKey:@"avatar"];

}
- (IBAction)right4Choose:(id)sender {
    self.right1Bnt.hidden=YES;
    self.right2Bnt.hidden=YES;
    self.right3Bnt.hidden=YES;
    self.right4Bnt.hidden=NO;
    self.right5Bnt.hidden=YES;
    self.right6Bnt.hidden=YES;
    self.right7Bnt.hidden=YES;
    self.right8Bnt.hidden=YES;
    self.right9Bnt.hidden=YES;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_16.png" forKey:@"avatar"];

}
- (IBAction)right5Choose:(id)sender {
    self.right1Bnt.hidden=YES;
    self.right2Bnt.hidden=YES;
    self.right3Bnt.hidden=YES;
    self.right4Bnt.hidden=YES;
    self.right5Bnt.hidden=NO;
    self.right6Bnt.hidden=YES;
    self.right7Bnt.hidden=YES;
    self.right8Bnt.hidden=YES;
    self.right9Bnt.hidden=YES;

    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_17.png" forKey:@"avatar"];

}
- (IBAction)right6Choose:(id)sender {
    self.right1Bnt.hidden=YES;
    self.right2Bnt.hidden=YES;
    self.right3Bnt.hidden=YES;
    self.right4Bnt.hidden=YES;
    self.right5Bnt.hidden=YES;
    self.right6Bnt.hidden=NO;
    self.right7Bnt.hidden=YES;
    self.right8Bnt.hidden=YES;
    self.right9Bnt.hidden=YES;

    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_18.png" forKey:@"avatar"];

}
- (IBAction)right7Choose:(id)sender {
    self.right1Bnt.hidden=YES;
    self.right2Bnt.hidden=YES;
    self.right3Bnt.hidden=YES;
    self.right4Bnt.hidden=YES;
    self.right5Bnt.hidden=YES;
    self.right6Bnt.hidden=YES;
    self.right7Bnt.hidden=NO;
    self.right8Bnt.hidden=YES;
    self.right9Bnt.hidden=YES;

    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_22.png" forKey:@"avatar"];

}
- (IBAction)right8Choose:(id)sender {
    self.right1Bnt.hidden=YES;
    self.right2Bnt.hidden=YES;
    self.right3Bnt.hidden=YES;
    self.right4Bnt.hidden=YES;
    self.right5Bnt.hidden=YES;
    self.right6Bnt.hidden=YES;
    self.right7Bnt.hidden=YES;
    self.right8Bnt.hidden=NO;
    self.right9Bnt.hidden=YES;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_23.png" forKey:@"avatar"];

}
- (IBAction)right9Choose:(id)sender {
    self.right1Bnt.hidden=YES;
    self.right2Bnt.hidden=YES;
    self.right3Bnt.hidden=YES;
    self.right4Bnt.hidden=YES;
    self.right5Bnt.hidden=YES;
    self.right6Bnt.hidden=YES;
    self.right7Bnt.hidden=YES;
    self.right8Bnt.hidden=YES;
    self.right9Bnt.hidden=NO;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"https://www.51duoduo.com/dyupfiles/avatar/default/avatar_24.png" forKey:@"avatar"];


}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self updateTopImage];
}
-(void)updateTopImage{
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
    [diyouDic insertObject:avatar2 forKey:@"avatar" atIndex:0];
    [diyouDic insertObject:sex forKey:@"sex" atIndex:0];
    [diyouDic insertObject:niname forKey:@"niname" atIndex:0];
    
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         //wayne-test
         if (isSuccess)
         {
             
             
             
             
             
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
