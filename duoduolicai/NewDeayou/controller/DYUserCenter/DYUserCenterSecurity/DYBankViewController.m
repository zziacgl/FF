//
//  DYBankViewController.m
//  NewDeayou
//
//  Created by diyou on 14-8-11.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYBankViewController.h"
#import "DYBankCardVC.h"
#import "DYPayPasswordVC.h"



@interface DYBankViewController ()<UIActionSheetDelegate>
{
    BOOL isNameCofrim;
    BOOL isBankCofrim;
    BOOL isOK1;
    BOOL isOK2;
    
}
@property (strong, nonatomic) IBOutlet UIButton *btnCofirm;//提交按钮
@property (strong, nonatomic) IBOutlet UIView *viewContent;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBankTaye;
@property (strong, nonatomic) IBOutlet UILabel *labBankAccount;
@property (strong, nonatomic) IBOutlet UILabel *labBankName;

@end

@implementation DYBankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"银行卡认证";
    
    isOK1=NO;
    isOK2=NO;
    
    
    self.viewContent.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.viewContent.layer.borderWidth=0.5;
    self.viewContent.layer.cornerRadius=3;
    
    isNameCofrim=NO;
    isBankCofrim=NO;
    [self getData];
    
    self.btnCofirm.layer.cornerRadius=3;
    self.btnCofirm.layer.masksToBounds=YES;
    [self.btnCofirm setBackgroundColor:[UIColor lightGrayColor]];
    self.btnCofirm.enabled=NO;
    
    
}
-(void)getData
{
    
    [MBProgressHUD hudWithView:self.view label:@"数据请求中"];
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"mobile_get_user_result" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork2 operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (success==YES) {
             
             [DYUser DYUser].phone=[object objectForKey:@"phone"];
              //判断是否进行实名认证
             int realnameStatus=[[object objectForKey:@"realname_status"]intValue];
             if (realnameStatus==1) {
                 isNameCofrim=YES;
             }
             else
             {
                 isNameCofrim=NO;
             }
             isOK1=YES;
             [self btnCanClick];
         }
         else
         {
             
             [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
     }];
    
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"account" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_users_bank_one" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:@"get_bank" forKey:@"fields" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [DYNetWork ChineseOperationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
     {
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (success==YES) {
             
             [self fullData:object];
         }
         else
         {
             
             if ([[object objectForKey:@"account"]isKindOfClass:[NSString class]]&&[[object objectForKey:@"account"] isEqualToString:@""]==YES) {
                 
                 [self fullData:object];
             }
             
             
             [MBProgressHUD errorHudWithView:self.view label:error hidesAfter:2];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD errorHudWithView:self.view label:@"网络异常" hidesAfter:2];
     }];

    
    
    
}

//数据填充
-(void)fullData:(id)object
{
    if ([[object objectForKey:@"account"]isKindOfClass:[NSString class]]) {
        if ([[object objectForKey:@"account"]length]>0) {
            self.labBankAccount.text=[object DYObjectForKey:@"account"];
            self.labBankName.text=[object DYObjectForKey:@"bank_name"];
            [DYUser DYUser].accountBankAll=[object objectForKey:@"account_all"];
            [DYUser DYUser].accountBank=[object objectForKey:@"account"];
            [DYUser DYUser].bankID=[object objectForKey:@"id"];
            [self.btnCofirm setTitle:@"修改银行卡" forState:UIControlStateNormal];
            isBankCofrim=YES;
        }
        else
        {
            self.labBankAccount.text=@"您还未绑定银行卡";
            [self.btnCofirm setTitle:@"绑定银行卡" forState:UIControlStateNormal];
            isBankCofrim=NO;
            
        }
        isOK2=YES;
        [self btnCanClick];
    }
}
//银行卡绑定和修改银行卡
- (IBAction)btnBank:(id)sender {
    if (isNameCofrim==YES) {
        if (isBankCofrim==YES) {
            
            //判断支付密码是否设置
            DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
            [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
            [diyouDic insertObject:@"mobile_get_user_result" forKey:@"q" atIndex:0];
            [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
            [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
            [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
            [DYNetWork2 operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
             {
                 if (success==YES) {
                     
                     if ([[object objectForKey:@"paypassword_status"]intValue]==0) {
                         
                         UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"您还未设置密码，请先设置密码！" delegate:self cancelButtonTitle:@"下次" destructiveButtonTitle:@"设置密码" otherButtonTitles:nil, nil];
                         [sheet showInView:self.view];
                         
                         
                     }
                     else if([[object objectForKey:@"phone_status"]intValue]==0)
                     {
                         UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"您还未设置手机号，请先设置手机号！" delegate:self cancelButtonTitle:@"下次" destructiveButtonTitle:@"设置手机号" otherButtonTitles:nil, nil];
                         [sheet showInView:self.view];

                         
                     }else if([[object objectForKey:@"paypassword_status"]intValue]==1&&[[object objectForKey:@"phone_status"]intValue]==1)
                     {
//                         DYModifyBankCardsVC * nameVC=[[DYModifyBankCardsVC alloc]initWithNibName:@"DYModifyBankCardsVC" bundle:nil];
//                         nameVC.hidesBottomBarWhenPushed=YES;
//                         [self.navigationController pushViewController:nameVC animated:YES];
                     }
                     
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
        else
        {
            DYBankCardVC * nameVC=[[DYBankCardVC alloc]initWithNibName:@"DYBankCardVC" bundle:nil];
            nameVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:nameVC animated:YES];
        }
        
    }
    else
    {
        UIActionSheet * sheet=[[UIActionSheet alloc]initWithTitle:@"未进行实名认证,是否进行实名认证？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"实名认证" otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    NSString * title=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"实名认证"]==YES) {
//        DYNameSystemCertificationViewController * nameVC=[[DYNameSystemCertificationViewController alloc]initWithNibName:@"DYNameSystemCertificationViewController" bundle:nil];
//        nameVC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:nameVC animated:YES];
    }
    else if([title isEqualToString:@"设置密码"]==YES)
    {
       
        DYPayPasswordVC * passVC=[[DYPayPasswordVC alloc]initWithNibName:@"DYPayPasswordVC" bundle:nil];
        passVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:passVC animated:YES];

        
    }else if([title isEqualToString:@"设置手机号"]==YES)
    {
       
//        DYPhoneVerificationViewController * phoneVC=[[DYPhoneVerificationViewController alloc]initWithNibName:@"DYPhoneVerificationViewController" bundle:nil];
//        phoneVC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:phoneVC animated:YES];

        
        
        
    }

    
    
    
    
    
    
}
//判断按钮是否可以点击
-(void)btnCanClick
{
    
    if (isOK2==YES&&isOK1==YES) {
        self.btnCofirm.backgroundColor=kMainColor;
        self.btnCofirm.enabled=YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
