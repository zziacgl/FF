//
//  DYRegistComfirmViewController.m
//  NewDeayou
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYRegistComfirmViewController.h"
#import "DYMyAcountMainVC.h"
#import "DYRegistPolicyVC.h"
#import "DYLoginVC.h"
#import "FMDeviceManager.h"
#import "UIDevice+IdentifierAddition.h"
#import <AdSupport/AdSupport.h>
#define kCornerRadius 3.0f
#define kBorderColor [UIColor lightGrayColor].CGColor


//记录用户填写信息的key
//手机注册
#define kUserInfoPhoneNumber                 @"kUserInfoPhoneNumber"
#define kUserInfoAuthCodePhone               @"kUserInfoAuthCodePhone"
#define kUserInfoUserNameTypePhone           @"kUserInfoUserNameTypePhone"
#define kUserInfoPasswordTypePhone           @"kUserInfoPasswordTypePhone"
#define kUserInfoPasswordEnsureTypePhone     @"kUserInfoPasswordEnsureTypePhone"
#define kPhoneTuiJianRen                     @"kPhoneTuiJianRen"

@interface DYRegistComfirmViewController ()

@property (weak, nonatomic) IBOutlet UITextField *NewPwd; // 登录密码
@property (weak, nonatomic) IBOutlet UITextField *inviteCode; // 邀请码
@property (weak, nonatomic) IBOutlet UILabel *codeLine;
@property (weak, nonatomic) IBOutlet UIButton *controlBtn;
@property (weak, nonatomic) IBOutlet UIButton *controlBtn2;


@property(nonatomic,retain)NSMutableDictionary * dicInfo; // 记录用户的填写信息
@property(nonatomic,retain)NSArray * aryRegistType; // 所有注册类型的数组
@property(nonatomic,retain)UIView * viewRegistContentView; // 当前注册类型的内容视图
@property (weak, nonatomic) IBOutlet UIButton *RegistBnt;//注册按钮
@property (nonatomic, copy) NSString *blockBox;
@property (nonatomic)Boolean isup;
@end

@implementation DYRegistComfirmViewController
{
    CGRect  rectMarkMainView; // 记录self.view的初始frame
    NSString * policyContent;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    rectMarkMainView = self.view.frame;

    self.navigationController.navigationBar.barTintColor  = kBackColor;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor  = kMainColor;
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackColor;
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
//    // 获取设备管理器实例
//    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
//
//    // 准备SDK初始化参数
//    NSMutableDictionary *options = [NSMutableDictionary dictionary];
//
//    // SDK具有防调试功能，当使用xcode运行时，请取消此行注释，开启调试模式
//    // 否则使用xcode运行会闪退，(但直接在设备上点APP图标可以正常运行)
//    // 上线Appstore的版本，请记得删除此行，否则将失去防调试防护功能！
//    [options setValue:@"allowd" forKey:@"allowd"];  // TODO
//
//    // 指定对接同盾的测试环境，正式上线时，请删除或者注释掉此行代码，切换到同盾生产环境
//    [options setValue:@"sandbox" forKey:@"env"]; // TODO
//
//    // 指定合作方标识
//    [options setValue:@"51duoduo" forKey:@"partner"];
//
//    // 使用上述参数进行SDK初始化
//    manager->initWithOptions(options);
//
//    //     获取设备指纹黑盒数据，请确保在应用开启时已经对SDK进行初始化，切勿在get的时候才初始化
//    self.blockBox = manager->getDeviceInfo();
//
//
//    // 将blackBox随业务请求提交到你的服务端，服务端调用同盾风险决策API时需要带上这个参数
//
//
    //初始化用户信息
    _dicInfo = [NSMutableDictionary new];
    
    [self.RegistBnt setBackgroundColor:kBtnColor];
    [self.RegistBnt.layer setMasksToBounds:YES];
    [self.RegistBnt.layer setCornerRadius:22];
    
    self.isup=true;
    [self.controlBtn2 addTarget:self action:@selector(upOrdown) forControlEvents:UIControlEventTouchDown];
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)upOrdown{
    if (self.isup) {
        
        [self.controlBtn setBackgroundImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
        self.isup=false;
        self.inviteCode.hidden=false;
        self.codeLine.hidden=false;
    }else{
        [self.controlBtn setBackgroundImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        self.isup=true;
        self.inviteCode.hidden=true;
        self.codeLine.hidden=true;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark- buttonActions

- (IBAction)privacyPolicy:(UIButton *)sender
{
    
    [MBProgressHUD hudWithView:self.view label:@""];
    DYOrderedDictionary *diyouDic = [[DYOrderedDictionary alloc]init];
    
    [diyouDic insertObject:@"articles" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_one_page" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"privacy" forKey:@"nid" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (isSuccess)
         {
             policyContent= [object DYObjectForKey:@"contents"];
             DYRegistPolicyVC * vc = [[DYRegistPolicyVC alloc]init];
             vc.title = @"网站服务协议";
             vc.contents = policyContent;
             [self.navigationController pushViewController:vc animated:YES];
         }
         else
         {
             [LeafNotification showInController:self withText:errorMessage];
         }
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [LeafNotification showInController:self withText:error];
     }];
}

- (IBAction)registRightNow:(UIButton *)sender
{

    
    NSString * password=self.NewPwd.text;
    
    if (!(password.length >= 6 && password.length <= 16))
    {
        [LeafNotification showInController:self withText:@"用户名或密码长度不正确"];
        return ;
    }
    //注册
    sender.userInteractionEnabled=YES;
    [MBProgressHUD hudWithView:nil label:@"注册中..."];
    
    //    NSString *inviteCode=_inviteCode.text;//邀请码
    
    NSString *udid=[[NSUUID UUID] UUIDString];;
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *udids=[NSString stringWithFormat:@"%@",[ud objectForKey:@"udid"]];
    if (udids!=nil&&![udids isEqualToString:@""]&&![udids isEqualToString:@"(null)"]) {
        udid=udids;
    }else{
        [ud setObject:udid forKey:@"udid"];
    }
    
    NSString *idfa = [NSString stringWithFormat:@"%@",[ud objectForKey:@"idfa"]];
   
    
    
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    NSString* userName=@"";
//    NSString* password=@"";
    
//    NSLog(@"d电话号码%@", self.phone);
    //手机注册
    [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"reg" forKey:@"q" atIndex:0];//从新网银行的版本开始，注册接口的q参数值从reg_all改为reg
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"ios" forKey:@"activity" atIndex:0];
    [diyouDic insertObject:self.phone forKey:@"phone" atIndex:0];
    [diyouDic insertObject:self.phone_code  forKey:@"phone_code" atIndex:0];
    [diyouDic insertObject:self.phone forKey:@"username" atIndex:0];
    [diyouDic insertObject:self.NewPwd.text forKey:@"password" atIndex:0];
    [diyouDic insertObject:udid forKey:@"udid" atIndex:0];
    [diyouDic insertObject:idfa forKey:@"idfa" atIndex:0];
//    [diyouDic insertObject:self.blockBox forKey:@"black_box" atIndex:0];
    [diyouDic insertObject:@"register_ios" forKey:@"event_id" atIndex:0];
    
    if ([self.inviteCode.text length]>0)
    {
        [diyouDic insertObject:self.inviteCode.text forKey:@"tuijian_phone" atIndex:0];
    }
    userName=self.phone;
    password=self.NewPwd.text;
    
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        [MBProgressHUD hideHUDForView:nil animated:YES];
        if (isSuccess == YES) {
            
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            dic[@"是否为他人邀请"]=@"否";
            if (self.inviteCode.text.length>0) {
                dic[@"是否为他人邀请"]=@"是";
            }
            dic[@"手机号"]=self.phone;
            dic[@"邀请码"]=self.inviteCode.text;
            
            [MBProgressHUD checkHudWithView:nil label:@"注册成功,请登录" hidesAfter:1];
             [MobClick event:@"register_Success"];
            [self.loginVC registSuccessWithUserName:userName password:password];
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
            [ud setObject:@"10" forKey:@"firstLogin"];
            [ud setObject:self.phone forKey:@"firstName"];
            DYLoginVC * loginVC=[[DYLoginVC alloc]initWithNibName:@"DYLoginVC" bundle:nil];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
            
            NSDictionary *userinfo=@{@"isfirstSetShouShi":@"1"};
            [ud setObject:userinfo forKey:self.phone];
            
        }else {
            
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            dic[@"失败原因"]=errorMessage;
            dic[@"手机号"]=self.phone;
            [MobClick event:@"Click_fail"];
            
            [LeafNotification showInController:self withText:errorMessage];
        }
    } fail:^{
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"失败原因"]=@"网络异常";
        dic[@"手机号"]=self.phone;
        
        [MBProgressHUD hideHUDForView:nil animated:YES];
        [LeafNotification showInController:self withText:@"网络异常"];
    }];

}

#pragma mark- textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self animationRecover];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    [self setUserInfoWithTag:textField.tag andText:textField.text];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // 256
    CGRect rect= [self.viewRegistContentView convertRect:textField.frame toView:[UIApplication sharedApplication].keyWindow];
    float originX=rect.origin.y+rect.size.height;
    [self animationWithOriginY:originX];
    return YES;
}

//适应键盘的animation,改变self.view的frame
-(void)animationWithOriginY:(float)originY
{
    float overDistance=kScreenSize.height-originY-256-50;
    if (overDistance<0)
    {
        [UIView animateWithDuration:0.38f animations:^
         {
             self.view.frame=CGRectMake(rectMarkMainView.origin.x, self.view.frame.origin.y+overDistance, rectMarkMainView.size.width, rectMarkMainView.size.height);
             
         }];
    }
    else
    {
        float overDistance2=self.view.frame.origin.y+overDistance;
        if (self.view.frame.origin.y<rectMarkMainView.origin.y)
        {
            if (overDistance2>rectMarkMainView.origin.y)
            {
                overDistance2=rectMarkMainView.origin.y;
            }
            [UIView animateWithDuration:0.38f animations:^
             {
                 self.view.frame=CGRectMake(rectMarkMainView.origin.x, overDistance2, rectMarkMainView.size.width, rectMarkMainView.size.height);
             }];
            
        }
    }
}

//恢复self.view的frame
-(void)animationRecover
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.38f animations:^
     {
         self.view.frame=rectMarkMainView;
     }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
