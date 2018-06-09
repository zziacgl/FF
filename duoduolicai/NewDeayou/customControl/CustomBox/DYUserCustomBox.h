//
//  DYUserCustomBox.h
//  NewDeayou
//
//  Created by wayne on 14-6-19.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNumberOfRow     3     //每行的列数
#define kBoxLineGap      10     //每行的间隙
#define kWidthBox       65.0f  //box控件尺寸

#define kBoxLimitGap        20.0f //box与左右边界的间隙
#define kBoxTopGap          16.0f //box与上边界的间隙

#define kBoxRowGap(width) (width-2*kBoxLimitGap-kNumberOfRow*kWidthBox)/(kNumberOfRow-1) //box的列间隙

typedef enum
{
    BoxActionTap =0, //点击事件代理
    BoxActionRemove  //移除事件代理
    
}BoxActionType;

typedef enum
{
    EdtingTypeAdd =0, //添加自定义功能
    EdtingTypeRemove  //移除自定义功能
    
}EdtingType;


typedef enum
{
    BoxTypeInvest =0,           //投资
    BoxTypeBorrow,              //借款
    BoxTypeRecharge,            //充值
    BoxTypeWithdraw,            //提现
    BoxTypeCounter,             //计算器
    BoxTypeApplyForAmount,      //额度申请
    BoxTypeRealTimeFinance,     //实时财务
    BoxTypeMore =999,                //更多
    
}BoxType;



@protocol CustomBoxDelegate <NSObject>

-(void)customBoxActionWithBoxActionType:(BoxActionType)boxActionType andBoxType:(BoxType)boxType;

@end



@interface DYUserCustomBox : UIView

@property(nonatomic,assign)BoxType      boxType;            //box类型


+(DYUserCustomBox*)customBoxWithFrame:(CGRect)frame boxType:(BoxType)boxType edtingType:(EdtingType)edtingType boxActionDelegate:(UIViewController<CustomBoxDelegate>*)delegate;

-(void)changeLocationWithFrame:(CGRect)frame animation:(BOOL)animation;

@end



