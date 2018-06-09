//
//  DYUserCustomBox.m
//  NewDeayou
//
//  Created by wayne on 14-6-19.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYUserCustomBox.h"
#import "DYCustomBoxMoreVC.h"
#import "DDMyAccountViewController.h"
//#import "DYWithdrawalViewController.h"
#import "DDMyHomeViewController.h"
#import "DDDrawMoneyViewController.h"


#define kWidthImage              45.0f    //图片尺寸
#define kWidthBox                65.0f    //整体控件尺寸
#define kWidthEdtingImage       13.0f    //编辑图片尺寸
#define kWidthEdtingButton      2*kWidthEdtingImage //编辑按钮尺寸

#define kFontName  [UIFont systemFontOfSize:12.0f]    //字体大小



@interface DYUserCustomBox()<UIAlertViewDelegate>

@property(nonatomic,retain)UIImageView * imageViewDesign;   //图片
@property(nonatomic,retain)UILabel * labelName;             //名字
@property(nonatomic,retain)UIButton * buttonEdting;         //编辑按钮
@property(nonatomic,assign)DDMyHomeViewController<CustomBoxDelegate> *delegate;   //事件代理


@property(nonatomic,assign,getter=isEdting)BOOL edting;     //编辑状态
@property(nonatomic,assign)EdtingType edtingType;           //编辑类型


@property(nonatomic,retain)UILongPressGestureRecognizer * longGesture; //长按手势

@end

@implementation DYUserCustomBox

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame=CGRectMake(frame.origin.x, frame.origin.y, kWidthBox, kWidthBox);
        _edting=NO;
        
        //图片
        _imageViewDesign=[[UIImageView alloc]initWithFrame:CGRectMake((kWidthBox-kWidthImage)/2, 0, kWidthImage, kWidthImage)];
        [self addSubview:_imageViewDesign];
        
        
        //名字
        _labelName=[[UILabel alloc]initWithFrame:CGRectMake(0,kWidthImage, kWidthBox, kWidthBox-kWidthImage)];
        _labelName.backgroundColor=[UIColor clearColor];
        _labelName.font=kFontName;
        _labelName.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_labelName];
        
        //编辑按钮
        _buttonEdting=[UIButton buttonWithType:UIButtonTypeCustom];
        _buttonEdting.frame=CGRectMake(kWidthBox-kWidthEdtingButton, 0, kWidthEdtingButton, kWidthEdtingButton);
        _buttonEdting.hidden=YES;
        [_buttonEdting addTarget:self action:@selector(edtingAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buttonEdting];
        
        //编辑图片
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake((kWidthEdtingButton-kWidthEdtingImage)/2.0f, (kWidthEdtingButton-kWidthEdtingImage)/3.0f, kWidthEdtingImage, kWidthEdtingImage)];
        imageView.tag=345;
        [_buttonEdting addSubview:imageView];
        
        
        //长按手势
        _longGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        _longGesture.minimumPressDuration=0.7f;
        [self addGestureRecognizer:_longGesture];
        
        UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
        [self addGestureRecognizer:tapGesture];

    }
    return self;
}

#pragma mark- ---initMethod

+(DYUserCustomBox*)customBoxWithFrame:(CGRect)frame boxType:(BoxType)boxType edtingType:(EdtingType)edtingType boxActionDelegate:(UIViewController<CustomBoxDelegate>*)delegate
{
    DYUserCustomBox * box=[[DYUserCustomBox alloc]initWithFrame:frame];
    box.delegate=(DDMyHomeViewController<CustomBoxDelegate> *)delegate;
    box.edtingType=edtingType;
    box.boxType=boxType;
    [box initSubviewsWithBoxType:boxType];
    return box;
}

-(void)initSubviewsWithBoxType:(BoxType)boxType
{
    switch (boxType)
    {
        case BoxTypeInvest:
        {
            //投资
            self.imageViewDesign.image=[UIImage imageNamed:@"box_type_invest.png"];
            self.labelName.text=@"投资";
            
        }break;
        case BoxTypeBorrow:
        {
            //借款
            self.imageViewDesign.image=[UIImage imageNamed:@"box_type_borrow.png"];
            self.labelName.text=@"借款";
            
        }break;
        case BoxTypeRecharge:
        {
            //充值
            self.imageViewDesign.image=[UIImage imageNamed:@"box_type_recharge.png"];
            self.labelName.text=@"充值";
            
        }break;
        case BoxTypeWithdraw:
        {
            //提现
            self.imageViewDesign.image=[UIImage imageNamed:@"box_type_withdraw.png"];
            self.labelName.text=@"提现";
            
        }break;
        case BoxTypeCounter:
        {
            //计算器
            self.imageViewDesign.image=[UIImage imageNamed:@"box_type_counter.png"];
            self.labelName.text=@"计算器";
            
        }break;
        case BoxTypeApplyForAmount:
        {
            //额度申请
            self.imageViewDesign.image=[UIImage imageNamed:@"box_type_applyfor_amount.png"];
            self.labelName.text=@"额度申请";
            
        }break;
        case BoxTypeRealTimeFinance:
        {
            //实时财务
            self.imageViewDesign.image=[UIImage imageNamed:@"box_type_realtime_finance.png"];
            self.labelName.text=@"实时财务";
            
        }break;
        case BoxTypeMore:
        {
            //更多
            self.imageViewDesign.image=[UIImage imageNamed:@"box_type_more.png"];
            self.labelName.text=@"更多";
            [self removeGestureRecognizer:_longGesture];
            
        }break;
            
        default:
            break;
    }
}

#pragma mark- ---setter
-(void)setEdting:(BOOL)edting
{
    //设置编辑状态
    _edting=edting;
    [self changeStateWithEdting:_edting];
}

-(void)setEdtingType:(EdtingType)edtingType
{
    _edtingType=edtingType;
    if (_edtingType==EdtingTypeAdd)
    {
      //设置位添加图片
        UIImageView * imageViewEdting=(UIImageView*)[self.buttonEdting viewWithTag:345];
        [imageViewEdting setImage:[UIImage imageNamed:@"edting_add.png"]];
    }
    else
    {
      //设置为移除图片
        UIImageView * imageViewEdting=(UIImageView*)[self.buttonEdting viewWithTag:345];
        [imageViewEdting setImage:[UIImage imageNamed:@"edting_remove.png"]];
    }
}

#pragma mark- ---edting

-(void)changeStateWithEdting:(BOOL)isEdting
{
    //改变状态(正常/编辑)
    if (isEdting)
    {
        [self changeStateEdting];
    }
    else
    {
        [self changeStateNormal];
    }
}

-(void)changeStateEdting
{
    //编辑状态
    self.buttonEdting.hidden=NO;
    self.buttonEdting.layer.opacity=1;
    CAKeyframeAnimation * keyAniamation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    NSNumber * value1=[NSNumber numberWithFloat:0.8];
    NSNumber * value2=[NSNumber numberWithFloat:1.2];
    keyAniamation.autoreverses=NO;
    keyAniamation.values=@[value1,value2];
    
    keyAniamation.keyTimes=@[@0,@0.5,@1];
    keyAniamation.duration=0.5f;
    
    [self.buttonEdting.layer addAnimation:keyAniamation forKey:nil];

}

-(void)changeStateNormal
{
    //正常状态
    [UIView animateWithDuration:0.38f animations:^
     {
         self.buttonEdting.layer.opacity=0;
     }completion:^(BOOL finished) {
         self.buttonEdting.hidden=YES;
     }];
}

-(void)edtingAction
{
    //编辑事件
    
    if(self.edtingType==EdtingTypeAdd)
    {
        //添加
        [DYUser insertUsedBoxWithValue:[NSString stringWithFormat:@"%d",self.boxType]];
        [MBProgressHUD checkHudWithView:self.delegate.view label:[NSString stringWithFormat:@"已添加到[首页]"] hidesAfter:1.0];
        if ([self.delegate respondsToSelector:@selector(customBoxActionWithBoxActionType:andBoxType:)]&&self.delegate)
        {
            [self.delegate customBoxActionWithBoxActionType:BoxActionRemove andBoxType:self.boxType];
        }

    }
    else if(self.edtingType==EdtingTypeRemove)
    {
        //移除
        [DYUser removeUsedBoxWithValue:[NSString stringWithFormat:@"%d",self.boxType]];
        if ([self.delegate respondsToSelector:@selector(customBoxActionWithBoxActionType:andBoxType:)]&&self.delegate)
        {
            [self.delegate customBoxActionWithBoxActionType:BoxActionRemove andBoxType:self.boxType];
        }
    }
    else
    {
        
    }
}


#pragma mark- ---GestureAction

-(void)longPressGesture:(UIGestureRecognizer*)gesture
{
    //长按变成编辑状态
    if(gesture.state==UIGestureRecognizerStateBegan)
    {
        if (!self.isEdting)
        {
            self.edting=YES;
        }
    }
}

-(void)tapGesture
{
    //点击事件
    if (self.isEdting)
    {
        self.edting=NO;
        return;
    }
    if ([self.delegate respondsToSelector:@selector(customBoxActionWithBoxActionType:andBoxType:)]&&self.delegate)
    {
        [self.delegate customBoxActionWithBoxActionType:BoxActionTap andBoxType:self.boxType];
    }
    
    //wayne ---test
    UIViewController *vc;
    
    if (self.boxType==BoxTypeMore)
    {
        vc=[[DYCustomBoxMoreVC alloc]init];
        vc.view.backgroundColor=[UIColor whiteColor];
        vc.title=self.labelName.text;
    }
    else if (self.boxType==BoxTypeCounter)
    {
//        vc=[[DYCounterMainVC alloc]initWithNibName:@"DYCounterMainVC" bundle:nil];
    }
    else if (self.boxType==BoxTypeRealTimeFinance)
    {
        vc=[[DDMyAccountViewController alloc]init];
    }
    else if(self.boxType==BoxTypeApplyForAmount)
    {
        [self withLimitsApplyViewController];
        return;
    }
    else if (self.boxType==BoxTypeWithdraw)
    {
        [self withdrawalViewController];
        return;
    }
    else if (self.boxType==BoxTypeRecharge)
    {
//        vc=[[DYRechargeVC alloc]initWithNibName:@"DYRechargeVC" bundle:nil];
    }
    else
    {
        vc.view.backgroundColor=[UIColor whiteColor];
        vc.title=self.labelName.text;
    }
    
    vc.hidesBottomBarWhenPushed=YES;
   
    
    if (self.delegate && self.delegate.navigationController)
    {
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }
    else if (self.delegate)
    {
        [self.delegate presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        
    }
    
}

#pragma mark- ---changeLocation
-(void)changeLocationWithFrame:(CGRect)frame animation:(BOOL)animation
{
    //移动位置
    if (animation)
    {
        [UIView animateWithDuration:0.38 animations:^
        {
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.frame=frame;
        }];
    }
    else
    {
        self.frame=frame;
    }
    
}

-(void)withdrawalViewController
{
    
    [MBProgressHUD hudWithView:self.delegate.view label:nil];
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"account" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_users_bank_one" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:@"get_bank" forKey:@"fields" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    self.delegate.opration= [DYNetWork ChineseOperationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
     {
         
         [MBProgressHUD hideHUDForView:self.delegate.view animated:YES];
         
         NSString * account=[object DYObjectForKey:@"account"];
         if (account.length>1)
         {
             //已绑定银行卡
////             DYWithdrawalViewController * vc=[[DYWithdrawalViewController alloc]initWithNibName:@"DYWithdrawalViewController" bundle:nil];
//              DDDrawMoneyViewController * vc=[[DDDrawMoneyViewController alloc]initWithNibName:@"DDrawMoneyViewController" bundle:nil];
//             vc.hidesBottomBarWhenPushed=YES;
//             if (self.delegate && self.delegate.navigationController)
//             {
//                 [self.delegate.navigationController pushViewController:vc animated:YES];
//             }
//             else if (self.delegate)
//             {
//                 [self.delegate presentViewController:vc animated:YES completion:nil];
//             }

         }
         else
         {
             //未绑定银行卡
             UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您还未绑定银行卡,是否前往绑定？" delegate:self cancelButtonTitle:@"下次吧" otherButtonTitles:@"好的",nil];
             alertView.tag=809;
             [alertView show];
             
         }

         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideHUDForView:self.delegate.view animated:YES];
         
     }];
}
-(void)withLimitsApplyViewController
{
    
    [MBProgressHUD hudWithView:self.delegate.view label:nil];
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"dyp2p" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_users" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    self.delegate.opration= [DYNetWork ChineseOperationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
                             {
                                 
                                 [MBProgressHUD hideHUDForView:self.delegate.view animated:YES];
                                 if ([[object objectForKey:@"approve_result"]isKindOfClass:[NSDictionary class]]) {
                                     NSDictionary * dic_user=[object objectForKey:@"approve_result"];
                                     int realnameStatus=[[dic_user objectForKey:@"realname_status"]intValue];
                                     if (realnameStatus==1||realnameStatus==0)
                                     {
                                         //实名认证已通过
//                                         DYLimitsApplyVC * vc=[[DYLimitsApplyVC alloc]initWithNibName:@"DYLimitsApplyVC" bundle:nil];
//                                         vc.hidesBottomBarWhenPushed=YES;
//                                         if (self.delegate && self.delegate.navigationController)
//                                         {
//                                             [self.delegate.navigationController pushViewController:vc animated:YES];
//                                         }
//                                         else if (self.delegate)
//                                         {
//                                             [self.delegate presentViewController:vc animated:YES completion:nil];
//                                         }
                                         
                                     }
                                     else
                                     {
                                         //未绑定银行卡
                                         UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"您还未进行实名认证,是否前往绑定？" delegate:self cancelButtonTitle:@"下次吧" otherButtonTitles:@"好的",nil];
                                         alertView.tag=810;
                                         [alertView show];
                                     }
                                 }
                             } errorBlock:^(id error)
                             {
                                 [MBProgressHUD hideHUDForView:self.delegate.view animated:YES];
                                 [LeafNotification showInController:self.viewController withText:@"网络异常"];
                             }];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==809&&buttonIndex==1)
    {
//        DYBankViewController * bankVC=[[DYBankViewController alloc]initWithNibName:@"DYBankViewController" bundle:nil];
//        bankVC.hidesBottomBarWhenPushed=YES;
//        [self.delegate.navigationController pushViewController:bankVC animated:YES];
    }else if(alertView.tag==810&&buttonIndex==1)
    {
//        DYNameSystemCertificationViewController * nameVC=[[DYNameSystemCertificationViewController alloc]initWithNibName:@"DYNameSystemCertificationViewController" bundle:nil];
//        nameVC.hidesBottomBarWhenPushed=YES;
//        [self.delegate.navigationController pushViewController:nameVC animated:YES];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
