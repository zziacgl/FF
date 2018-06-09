//
//  DYDrawPatternLockVC.m
//  NewDeayou
//
//  Created by wayne on 14-7-17.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYDrawPatternLockVC.h"
#import "DrawPatternLockView.h"
#import "DYAppDelegate.h"
#import "DYMyAcountMainVC.h"


#define MATRIX_SIZE 3  //图片的行数和列数

#define kGapLeft    30.0f   //图片左间距
#define kGapRight   30.0f   //图片右间距
#define kGapTop     0.0f   //图片上间距
#define kGapBottom  0.0f   //图片下间距


@interface DYDrawPatternLockVC ()<UIAlertViewDelegate>

{
    CGSize sizeImage; //图片尺寸
    BOOL isCheckInitPassword; //
}

@property (strong, nonatomic) IBOutlet DrawPatternLockView *viewLock;

//@property (strong, nonatomic) IBOutlet UIButton *btnLeftBarButton;
//@property (strong, nonatomic) IBOutlet UIButton *btnRightBarButton;
//@property (strong, nonatomic) IBOutlet UILabel *labelTitle;


@property(nonatomic,retain)NSMutableArray * aryImgViews; //装着所有按钮的数组
@property(nonatomic,retain)NSString * firstPasswords;    //记录重置密码时，第一次输入的密码
@property(nonatomic,retain)NSMutableArray *paths;        //记录绘制路线
@property(nonatomic,assign)LockViewType lockType;//手势锁屏类型

@property(nonatomic,retain)IBOutlet UILabel * labelAlert;//提示信息的label
@property (strong, nonatomic) IBOutlet UIButton *btnForgetPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UIButton *btnTouchID;

@end

@implementation DYDrawPatternLockVC


-(id)initWithLockType:(LockViewType)lockType
{
    self=[super initWithNibName:@"DYDrawPatternLockVC" bundle:nil];
    if (self)
    {
        self.lockType=lockType;
//        self.fd_interactivePopDisabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidAfterLoad];
    _viewLock.backgroundColor=[UIColor clearColor];
    
    self.imgLogo.layer.masksToBounds = YES;
    self.imgLogo.layer.cornerRadius = self.imgLogo.bounds.size.height/2;
    
    //创建label
    _labelAlert.hidden=YES;
    if(self.Lock_Type==1){
        _labelAlert.text=@"点击指纹解锁";
        _labelAlert.textColor=[UIColor blackColor];
        _labelAlert.hidden=NO;
    }
    
    //根据类型设置标题和barButton
    if (self.lockType==LockViewTypeSetPasswords)
    {
        //        UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        //        self.navigationItem.leftBarButtonItem=rightItem;
        self.title=@"设置密码";
    }
    else if (self.lockType==LockViewTypeDeblocking)
    {
        self.title=@"解锁屏幕";
        
        UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:_btnForgetPassword];
        self.navigationItem.rightBarButtonItem=rightItem;
        UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:_btnTouchID];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    else if(self.lockType==LockViewTypeResetPasswords)
    {
        self.title=@"重置密码";
        isCheckInitPassword=NO;
        UIButton * leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * imageNormal=[UIImage imageNamed:@"back_bar_normal"];
        leftButton.frame=CGRectMake(0, 0, imageNormal.size.width, imageNormal.size.height);
        [leftButton setBackgroundImage:imageNormal forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(dismissLockViewController) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem=leftItem;
    }else if (self.lockType == LockViewTypeVerifyPasswords){
        
        
    }
    
    
    //创建iamgeViews
    _aryImgViews=[NSMutableArray new];
    for (int i=0; i<MATRIX_SIZE; i++)
    {
        for (int j=0; j<MATRIX_SIZE; j++)
        {
            UIImage *dotImage = [UIImage imageNamed:@"point"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:dotImage
                                                       highlightedImage:[UIImage imageNamed:@"point_on"]];
            imageView.frame = CGRectMake(0, 0, dotImage.size.width, dotImage.size.height);
            sizeImage=imageView.frame.size;
            imageView.userInteractionEnabled = YES;
            imageView.tag = j*MATRIX_SIZE + i + 1;
            [_aryImgViews addObject:imageView];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.lockType==LockViewTypeResetPasswords)
    {
        [self jitterAnimationWithInformation:@"请输入原始手势密码" textColor:kMainColor andIsAnimation:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.Lock_Type==1){
        //指纹
        [DYUser showTouchID:self];
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, self.imgLogo.bounds.origin.y+150, 100, 100)];
        [btn setBackgroundImage:[UIImage imageNamed:@"Touch"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showTouchID) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:btn];
    }else{
        //手势
        [self layoutImageViews];
    }
}
-(void)showTouchID{
    [DYUser showTouchID:self];
}

#pragma mark- BarButtonAction

- (void)dismissLockViewController
{
    
    if (self.lockType==LockViewTypeDeblocking)
    {
        DYAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
        if (appDelegate.window.rootViewController!=self.navigationController)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
            //            [UIView transitionFromView:self.view toView:appDelegate.mainTabBarVC.view duration:1 options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL finished)
            //             {
            //                 [self dismissViewControllerAnimated:NO completion:nil];
            //             }];
        }
        else
        {
            [appDelegate.window addSubview:appDelegate.mainTabBarVC.view];
            [appDelegate.window sendSubviewToBack:appDelegate.mainTabBarVC.view];
            
            [UIView transitionFromView:appDelegate.window.rootViewController.view toView:appDelegate.mainTabBarVC.view duration:1 options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL finished)
             {
                 appDelegate.window.rootViewController=appDelegate.mainTabBarVC;
             }];
        }
    }
    else if (self.lockType==LockViewTypeResetPasswords)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.lockType==LockViewTypeSetPasswords)
    {
        [DYUser loginHiddenLoginView];
    }
}
- (IBAction)UseTouchID:(id)sender {
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *isTouch=[ud objectForKey:@"isTouch"];
    if ([isTouch isEqualToString:@"1"]) {
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        [DYUser showTouchID:self];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"未开启丰丰金融指纹解锁" message:@"请在我的丰丰-我的账户,开启Touch ID指纹锁定" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark-

//布置圆形按钮
-(void)layoutImageViews
{
    //先移除原有的drawView
    for (UIView * view in self.viewLock.subviews)
    {
        if ([view isKindOfClass:[DrawPatternLockView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    CGSize sizeLockView=CGSizeMake(_viewLock.frame.size.width, _viewLock.frame.size.height);
    //行间距
    float rowGap=(sizeLockView.height-3*sizeImage.height-kGapBottom-kGapTop)/(MATRIX_SIZE-1);
    float gapTop=0;
    if (rowGap>=50)
    {
        rowGap=50;
        gapTop=(sizeLockView.height-rowGap*2-MATRIX_SIZE*sizeImage.height)*0.2;
        _labelAlert.center=CGPointMake(_labelAlert.center.x, _labelAlert.center.y+gapTop/2);
    }
    //列间距
    float lineGap=rowGap;
    float grapLeft=(sizeLockView.width-(MATRIX_SIZE-1)*rowGap-MATRIX_SIZE*sizeImage.width)/2;
    
    if (grapLeft<30) {
        grapLeft=30;
        lineGap=(sizeLockView.width-3*sizeImage.height-kGapLeft-kGapRight)/(MATRIX_SIZE-1);
    }
    
    //排序添加drawView
    for (int i=0; i<MATRIX_SIZE; i++)
    {
        for (int j=0; j<MATRIX_SIZE; j++)
        {
            UIView * view=_aryImgViews[i*MATRIX_SIZE+j];
            view.frame=CGRectMake(grapLeft+j*(sizeImage.width+lineGap), gapTop+i*(sizeImage.height+rowGap), sizeImage.width, sizeImage.height);
            [self.viewLock addSubview:view];
        }
    }
    
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _paths = [[NSMutableArray alloc] init];
}



- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self.viewLock];
    UIView *touched = [self.viewLock hitTest:pt withEvent:event];
    if (pt.x<=0||pt.x>=_viewLock.frame.size.width||pt.y<=0||pt.y>=_viewLock.frame.size.height)
    {
        return;
    }
    
    _labelAlert.hidden=YES;
    [self.viewLock drawLineFromLastDotTo:pt];
    
    if (touched!=self.viewLock)
    {
        //    NSLog(@"touched view tag: %ld ", touched.tag);
        
        BOOL found = NO;
        for (NSNumber *tag in _paths)
        {
            found = tag.integerValue==touched.tag;
            if (found)
                break;
        }
        
        if (found)
            return;
        
        [_paths addObject:[NSNumber numberWithInteger:touched.tag]];
        [self.viewLock addDotView:touched];
        
        UIImageView* iv = (UIImageView*)touched;
        iv.highlighted = YES;
    }
    
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // clear up hilite
    [self.viewLock clearDotViews];
    
    
    //恢复未选中状态
    for (UIView *view in self.viewLock.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [(UIImageView*)view setHighlighted:NO];
        }
    }
    
    [self.viewLock setNeedsDisplay];
    [self dealWithThePaths];
}


//获取当前绘制路径
-(NSString*)getKey
{
    NSMutableString *key;
    key = [NSMutableString string];
    
    // simple way to generate a key
    for (NSNumber *tag in _paths)
    {
        [key appendFormat:@"%02ld",(long) tag.integerValue];
    }
    
    return key;
}

//处理绘制路劲
-(void)dealWithThePaths
{
    NSString * key=[self getKey];
//    NSLog(@"aaaaaaaaaaa%@",key);
    if (key.length<8) {
        [self jitterAnimationWithInformation:@"至少链接4个点，请重新输入" textColor:[UIColor redColor] andIsAnimation:YES];
        return;
    }
    if (_lockType==LockViewTypeVerifyPasswords){
        
    }
    
    if (_lockType==LockViewTypeDeblocking)
    {
        //解锁
        if ([DYUser isRightForLockPasswords:key])
        {
            //正确解锁
            [self dismissLockViewController];
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
            NSString *isCancelLock=[NSString stringWithFormat:@"%@",[ud objectForKey:@"isCancelLock"]];
            if ([isCancelLock isEqualToString:@"1"]) {
                [DYUser cancelLockSecret];
                [ud setObject:@"0" forKey:@"isCancelLock"];
            }
        }
        else
        {
            //密码输入错误
            [self jitterAnimationWithInformation:@"密码错误" textColor:[UIColor redColor] andIsAnimation:YES];
        }
    }
    else if(_lockType==LockViewTypeSetPasswords)
    {
        //设置密码
        if (!_firstPasswords)
        {
            //还未设置第一次密码
            _firstPasswords=key;
            [self jitterAnimationWithInformation:@"再次输入密码" textColor:kMainColor andIsAnimation:NO];
        }
        else
        {
            if ([key isEqualToString:_firstPasswords]&&key.length>0)
            {
                //设置密码成功
                [DYUser setLockSecretPasswords:key];
                [MBProgressHUD checkHudWithView:nil label:@"设置成功" hidesAfter:1];
                //
//                                [self dismissLockViewController];
                [self.navigationController popViewControllerAnimated:YES];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                NSString *str = [NSString stringWithFormat:@"%@",[user objectForKey:@"UserName"]];
                [user setObject:@"nest" forKey:@"quxiao"];
                [user setObject:@"cheng" forKey:@"kai"];
//                DYMyAcountMainVC *VC = [[DYMyAcountMainVC alloc]initWithNibName:@"DYMyAcountMainVC" bundle:nil];
//                VC.hidesBottomBarWhenPushed = YES;
//                VC.phone=str;
//                [self.navigationController pushViewController:VC animated:YES];
                
            }
            else
            {
                //2次密码不一致。重新设置
                _firstPasswords=nil;
                [self jitterAnimationWithInformation:@"两次密码不一致,请重新输入" textColor:[UIColor redColor] andIsAnimation:YES];
                
            }
        }
    }
    else if (_lockType==LockViewTypeResetPasswords)
    {
        //重置密码
        if (!isCheckInitPassword)
        {
            isCheckInitPassword=[DYUser isRightForLockPasswords:key];
            
            if (isCheckInitPassword)
            {
                [self jitterAnimationWithInformation:@"请输入新密码" textColor:kMainColor andIsAnimation:NO];
            }
            else
            {
                [self jitterAnimationWithInformation:@"初始密码错误" textColor:[UIColor redColor] andIsAnimation:YES];
            }
        }
        else
        {
            
            //设置密码
            if (!_firstPasswords)
            {
                //还未设置第一次密码
                _firstPasswords=key;
                [self jitterAnimationWithInformation:@"再次输入新密码" textColor:kMainColor andIsAnimation:NO];
            }
            else
            {
                if ([key isEqualToString:_firstPasswords]&&key.length>0)
                {
                    //设置密码成功
                    [DYUser setLockSecretPasswords:key];
                    [MBProgressHUD checkHudWithView:nil label:@"设置成功" hidesAfter:1];
                    //                    [self dismissLockViewController];
                    
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    NSString *str = [NSString stringWithFormat:@"%@",[user objectForKey:@"UserName"]];
                    
                    DYMyAcountMainVC *VC = [[DYMyAcountMainVC alloc]initWithNibName:@"DYMyAcountMainVC" bundle:nil];
                    VC.hidesBottomBarWhenPushed = YES;
                    VC.phone=str;
                    [self.navigationController pushViewController:VC animated:YES];
                    
                }
                else
                {
                    //2次密码不一致。重新设置
                    _firstPasswords=nil;
                    [self jitterAnimationWithInformation:@"两次密码不一致,请重新输入" textColor:[UIColor redColor] andIsAnimation:YES];
                    
                }
            }
            
        }
        
    }
    
}


//显示提示信息
-(void)jitterAnimationWithInformation:(NSString*)information textColor:(UIColor*)textColor andIsAnimation:(BOOL)isAnimation
{
    _labelAlert.text=information;
    _labelAlert.textColor=textColor;
    _labelAlert.hidden=NO;
    
    if (isAnimation)
    {
        CAKeyframeAnimation * animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.autoreverses=YES;
        animation.repeatCount=2;
        animation.duration=0.06f;
        
        CGPoint point1=_labelAlert.center;
        CGPoint point2=_labelAlert.center;
        point2.x+=10;
        CGPoint point3=_labelAlert.center;
        point3.x-=10;
        
        NSArray * values=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:point1],[NSValue valueWithCGPoint:point2],[NSValue valueWithCGPoint:point1],[NSValue valueWithCGPoint:point3], nil];
        animation.values=values;
        
        [_labelAlert.layer addAnimation:animation forKey:nil];
    }
    
    
}

#pragma mark- alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==723&&buttonIndex==1)
    {
        [DYUser cancelLockSecret];
        [DYUser loginCancelRemenberPassword];
        [DYUser loginCancelLogin];
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        [ud setObject:@"shi" forKey:@"kai"];
    }
}


#pragma mark-

-(IBAction)forgetHeadPassword
{
    if (_lockType==LockViewTypeDeblocking)
    {
        //忘记密码
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"忘记手势密码,需重新登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag=723;
        [alert show];
    }
    else
    {
        //重制密码
        //        _firstPasswords=nil;
        //        _labelAlert.hidden=YES;
        //        [DYUser cancelLockSecret];
        //        [MBProgressHUD checkHudWithView:nil label:@"已关闭手势锁" hidesAfter:1];
        //        [self leftBarButtonAction:nil];
    }
}

@end
