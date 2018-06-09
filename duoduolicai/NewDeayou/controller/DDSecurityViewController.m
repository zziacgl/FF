//
//  DDSecurityViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 2017/8/29.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDSecurityViewController.h"
#import "DYAuthenticationTableViewCell.h"
#import "SCSecureHelper.h"
//#import <SVProgressHUD.h>
#import "SCGestureSetController.h"
#import "DYUpdateLoginPwdViewController.h"
//#import <CustomAlertView.h>

@interface DDSecurityViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UINib *nibHead;//复用cell的nib
    
    NSString *phoneStatus;//1认证，非1没有认证
    NSString *nameStatus;
    
    NSString *phone;
}
@property(nonatomic,strong) UITableView *tableView;     //tableview
@end

@implementation DDSecurityViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"密码管理";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kMainBgColor;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    phoneStatus=[NSString stringWithFormat:@"%@",[ud objectForKey:@"phone_status"]];
    if ([phoneStatus isEqualToString:@"1"]) {
        phone=[NSString stringWithFormat:@"%@",[ud objectForKey:@"phone"]];
    }
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     [self.view addSubview:_tableView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_tableView) {
        [_tableView reloadData];
    }
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - tableView datasource
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 194;//cell的高度
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *markReuse = @"markhead";
    if (!nibHead) {
        nibHead = [UINib nibWithNibName:@"DYAuthenticationTableViewCell" bundle:nil];
        [tableView registerNib:nibHead forCellReuseIdentifier:markReuse];
    }
    DYAuthenticationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markReuse];
    [cell.pwdSet setTitle:@"修改" forState:UIControlStateNormal];
    [cell.pwdSet addTarget:self action:@selector(updateLoginPwd) forControlEvents:UIControlEventTouchDown];
    
    int xw_status=[[DYUser getXW_Status]intValue];
    if (xw_status==2) {
        //修改
        [cell.payPwdSet setTitle:@"修改" forState:UIControlStateNormal];
        [cell.payPwdSet addTarget:self action:@selector(setPwd) forControlEvents:UIControlEventTouchDown];
    }else{
        [cell.payPwdSet setTitle:@"未设置" forState:UIControlStateNormal];
        [cell.payPwdSet addTarget:self action:@selector(setPwd2) forControlEvents:UIControlEventTouchDown];
    }
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    
    [cell.LockSwitch addTarget:self action:@selector(showDanChu:) forControlEvents:UIControlEventValueChanged];
    
    cell.LockSwitch.tag=98;
    if([SCSecureHelper gestureOpenStatus]){
        cell.LockSwitch.on = YES;
    }else{
        cell.LockSwitch.on = NO;
    }
    
    [cell.TouchLockSwitch addTarget:self action:@selector(showDanChu:) forControlEvents:UIControlEventValueChanged];
    cell.TouchLockSwitch.tag=99;
    if ([SCSecureHelper touchIDOpenStatus]) {
        cell.TouchLockSwitch.on = YES;
    }else{
        cell.TouchLockSwitch.on = NO;
    }

    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
    
}
-(void)showDanChu:(UISwitch *)sender{
    if (sender.tag==98) {
        //点击手势
        if([SCSecureHelper touchIDOpenStatus]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"继续开启手势解锁功能将关闭指纹解锁" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"取消", nil];
            alert.tag=84;
            [alert show];
        }else{
            [self switchCornorRadius:sender];
        }
        
    }else{
        if ([SCSecureHelper gestureOpenStatus]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"继续开启指纹解锁功能将关闭手势解锁" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"取消", nil];
            alert.tag=85;
            [alert show];
        }else{
            [self switchCornorRadius2:sender];
        }
        
    }
}
#pragma mark - UIAlertViewDelegate
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==84) {
        //点击手势
        UISwitch *sender=(UISwitch *)[self.view viewWithTag:98];
        if(buttonIndex == 0){
            //继续
            [self switchCornorRadius:sender];
            
        }else{
            [sender setOn:NO animated:YES];
        }
    }else if(alertView.tag==85){
        //点击指纹
        UISwitch *sender=(UISwitch *)[self.view viewWithTag:99];
        if(buttonIndex == 0){
            //继续
            [self switchCornorRadius2:sender];
        }else{
            [sender setOn:NO animated:YES];
        }
        
    }
    
    
}

- (void)switchCornorRadius:(UISwitch *)sender{
    
    NSMutableDictionary *p=[NSMutableDictionary dictionary];
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    if (sender.on) {
        
        [SCSecureHelper touchIDOpen:NO];
        
        BOOL isOpen = [SCSecureHelper gestureOpenStatus];
        // isOpen是YES代表之前是开启的，现在关闭，setType为SCGestureSetTypeDelete;
        // isOpen是NO代表之前是关闭的，现在开启，setType为SCGestureSetTypeSetting;
        SCGestureSetType  setType = isOpen ? SCGestureSetTypeDelete : SCGestureSetTypeSetting;
        
        SCGestureSetController *controller = [[SCGestureSetController alloc] init];
        controller.gestureSetType = setType;
        kWeakSelf
        [controller gestureSetComplete:^(BOOL success) {
            [weakSelf showSwitchOnStatus:sender handleSuccess:success];
            
            NSMutableDictionary *p=[NSMutableDictionary dictionary];
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
            [ud setObject:@"1" forKey:@"isLock"];
            p[@"状态"]=@"打开手势";
        }];
        [self.navigationController pushViewController:controller animated:YES];
        
        
    }else{
        
        BOOL isOpen = [SCSecureHelper gestureOpenStatus];
        // isOpen是YES代表之前是开启的，现在关闭，setType为SCGestureSetTypeDelete;
        // isOpen是NO代表之前是关闭的，现在开启，setType为SCGestureSetTypeSetting;
        SCGestureSetType  setType = isOpen ? SCGestureSetTypeDelete : SCGestureSetTypeSetting;
        
        SCGestureSetController *controller = [[SCGestureSetController alloc] init];
        controller.gestureSetType = setType;
        kWeakSelf
        [controller gestureSetComplete:^(BOOL success) {
            [weakSelf showSwitchOnStatus:sender handleSuccess:success];
            
            NSMutableDictionary *p=[NSMutableDictionary dictionary];
            p[@"状态"]=@"关闭手势";
        }];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}
/// handleResult 手势操作结果 success是操作结果yes成功，no 失败
- (void)showSwitchOnStatus:(UISwitch *)sender handleSuccess:(BOOL)success {
    
    BOOL isOpen = [SCSecureHelper gestureOpenStatus];
    if (!success) {
        // 不成功，依旧为当前的值
        [sender setOn:isOpen animated:YES];
        return;
    }
    
    // isOpen是YES代表之前是开启的，现在关闭，nowOpenStatus为NO; isOpen是NO代表之前是关闭的，现在开启，nowOpenStatus为YES;
    BOOL nowOpenStatus = isOpen ? NO : YES;
    [SCSecureHelper openGesture:nowOpenStatus];
    [sender setOn:nowOpenStatus animated:YES];
    if (!isOpen) {
        
        
    }
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *m=[NSString stringWithFormat:@"duoduo%d",[DYUser GetUserID]];
    NSDictionary *userinfo=[ud objectForKey:m];
    NSString *isShouShiLock=[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"isShouShiLock"]];
    NSString *isTouchIDLock=[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"isTouchIDLock"]];
    
    if (nowOpenStatus) {
        NSDictionary *u=@{@"isShouShiLock":@"1",@"isTouchIDLock":isTouchIDLock};
        [ud setObject:u forKey:m];
        
    }else{
        NSDictionary *u=@{@"isShouShiLock":@"0",@"isTouchIDLock":isTouchIDLock};
        [ud setObject:u forKey:m];
       
    }
    
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)switchCornorRadius2:(UISwitch *)sender{
    if (sender.on) {
        if ([SCSecureHelper gestureOpenStatus]) {
            
            UISwitch *sender_shoushi=(UISwitch *)[self.view viewWithTag:98];
            
            BOOL isOpen = [SCSecureHelper gestureOpenStatus];
            // isOpen是YES代表之前是开启的，现在关闭，setType为SCGestureSetTypeDelete;
            // isOpen是NO代表之前是关闭的，现在开启，setType为SCGestureSetTypeSetting;
            SCGestureSetType  setType = isOpen ? SCGestureSetTypeDelete : SCGestureSetTypeSetting;
            
            SCGestureSetController *controller = [[SCGestureSetController alloc] init];
            controller.gestureSetType = setType;
            
            __weak UISwitch *weakSwitch_shoushi = sender_shoushi;
            __weak UISwitch *weakSwitch_TouchID = sender;
            kWeakSelf
            [controller gestureSetComplete:^(BOOL success) {
                [weakSelf showSwitchOnStatus:weakSwitch_shoushi handleSuccess:success];
                
                if (success) {
                    
                   

                    __weak UISwitch *weakSwitch = weakSwitch_TouchID;
                    kWeakSelf
                    [[SCSecureHelper shareInstance] openTouchID:^(BOOL success, BOOL inputPassword, NSString *message) {
                        
                        if (inputPassword && !success) {
                            // inputPassword是yes的话，调用登录页面，进行输入登录密码进行验证，相当于退出了登录，重新登录
                            [weakSelf changeTouchIDByPassword:sender];
                            
                            
                            return ;
                        }
                        // 如果其他结果
                        [weakSelf showTouchIDSwitchOnStatus:weakSwitch handleSuccess:success];
                    }];
                }
                
                
            }];
            [self.navigationController pushViewController:controller animated:YES];
            
            
            
        }else{
            __weak UISwitch *weakSwitch = sender;
            kWeakSelf
            [[SCSecureHelper shareInstance] openTouchID:^(BOOL success, BOOL inputPassword, NSString *message) {
                
                if (inputPassword && !success) {
                    // inputPassword是yes的话，调用登录页面，进行输入登录密码进行验证，相当于退出了登录，重新登录
                    [weakSelf changeTouchIDByPassword:sender];
                    return ;
                }
                // 如果其他结果
                [weakSelf showTouchIDSwitchOnStatus:weakSwitch handleSuccess:success];
            }];
            
            
        }
        
        
    }else{
        __weak UISwitch *weakSwitch = sender;
        kWeakSelf
        [[SCSecureHelper shareInstance] openTouchID:^(BOOL success, BOOL inputPassword, NSString *message) {
            
            if (inputPassword && !success) {
                // inputPassword是yes的话，调用登录页面，进行输入登录密码进行验证，相当于退出了登录，重新登录
                [weakSelf changeTouchIDByPassword:sender];
                return ;
            }
            // 如果其他结果
            [weakSelf showTouchIDSwitchOnStatus:weakSwitch handleSuccess:success];
        }];
        
    }
    
    
}
// 验证登录密码，来改变指纹识别的开闭
// 跳转到登录页面，登录成功的block回调里面处理,和指纹识别类似的判断
- (void)changeTouchIDByPassword:(UISwitch *)sender {
    
    // 弱引用
    //kWeakSelf
    
    // 以下代码是在登录结果的block里进行的处理
    BOOL success = YES;
    [self showSwitchOnStatus:sender handleSuccess:success];
}

/// handleResult 指纹识别/登录成功的操作结果 success是操作结果yes成功，no 失败
- (void)showTouchIDSwitchOnStatus:(UISwitch *)sender handleSuccess:(BOOL)success {
    BOOL isOpen = [SCSecureHelper touchIDOpenStatus];
    if (isOpen) {
        // isOpen是YES，代表之前是开启状态
        if (success) {
            // 之前是开启状态，验证成功后就是关闭状态
//            [SVProgressHUD showSuccessWithStatus:@"指纹验证已关闭"];
            [SCSecureHelper touchIDOpen:NO];
            [sender setOn:NO animated:YES];
            UISwitch *sw=(UISwitch *)[self.view viewWithTag:99];
            sw.on = NO;
        } else {
            // 之前是开启状态，验证失败后仍是开启状态
            [sender setOn:YES animated:YES];
        }
    } else {
        // isOpen是NO，代表之前是关闭状态
        if (success) {
            // 之前是关闭状态，验证成功后就是开启状态
//            [SVProgressHUD showSuccessWithStatus:@"指纹验证开启成功"];
            [SCSecureHelper touchIDOpen:YES];
            [sender setOn:YES animated:YES];
            UISwitch *sw=(UISwitch *)[self.view viewWithTag:99];
            sw.on = YES;
        } else {
            // 之前是关闭状态，验证失败后仍是关闭状态
            [sender setOn:NO animated:YES];
        }
    }
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *m=[NSString stringWithFormat:@"duoduo%d",[DYUser GetUserID]];
    NSDictionary *userinfo=[ud objectForKey:m];
    NSString *isShouShiLock=[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"isShouShiLock"]];
    NSString *isTouchIDLock=[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"isTouchIDLock"]];
    
    if (!isOpen) {
        NSDictionary *u=@{@"isShouShiLock":isShouShiLock,@"isTouchIDLock":@"1"};
        [ud setObject:u forKey:m];
       
    }else{
        NSDictionary *u=@{@"isShouShiLock":isShouShiLock,@"isTouchIDLock":@"0"};
        [ud setObject:u forKey:m];
      
    }
    
}
-(void)updateLoginPwd{
    //修改登录密码
    DYUpdateLoginPwdViewController * updatePasswordVC=[[DYUpdateLoginPwdViewController alloc]initWithNibName:@"DYUpdateLoginPwdViewController" bundle:nil];
    updatePasswordVC.hidesBottomBarWhenPushed=YES;
    updatePasswordVC.phone=phone;
    updatePasswordVC.isBank = self.isBank;
    updatePasswordVC.isUpdate=@"1";
    [self.navigationController pushViewController:updatePasswordVC animated:YES];
}
-(void)setPwd{
    
    NSString *url=[NSString stringWithFormat:@"%@?service_name=reset_password&login_key=%@",pcURL_XW,[DYUser GetLoginKey]];
    //    NSLog(@"%@",url);
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.hidesBottomBarWhenPushed = YES;
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"交易密码";
    [self.navigationController pushViewController:adVC animated:YES];
    
}
-(void)setPwd2{
    int xw_status=[[DYUser getXW_Status] intValue];
    //    NSLog(@"xw_%d",xw_status);
    
    if (xw_status == 0) {
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"弹窗原因"]=@"未注册新网";
        
    }else if(xw_status == 1){
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"弹窗原因"]=@"未激活新网";
        
    }else{
        NSString *url=[NSString stringWithFormat:@"%@?service_name=reset_password&login_key=%@",pcURL_XW,[DYUser GetLoginKey]];
        //        NSLog(@"%@",url);
        ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
        adVC.hidesBottomBarWhenPushed = YES;
        adVC.myUrls = @{@"url":url};
        adVC.titleM =@"交易密码";
        [self.navigationController pushViewController:adVC animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
