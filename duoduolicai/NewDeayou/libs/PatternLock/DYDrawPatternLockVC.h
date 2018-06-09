//
//  DYDrawPatternLockVC.h
//  NewDeayou
//
//  Created by wayne on 14-7-17.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LockViewTypeDeblocking =1  , //解锁屏幕
    LockViewTypeSetPasswords   , //设置密码
    LockViewTypeResetPasswords  ,//重置密码
    LockViewTypeVerifyPasswords, //验证手势密码
}LockViewType;//手势锁屏类型

@interface DYDrawPatternLockVC : UIViewController

@property (nonatomic) int Lock_Type;//0:指纹，1：指纹

-(id)initWithLockType:(LockViewType)lockType;

@end
