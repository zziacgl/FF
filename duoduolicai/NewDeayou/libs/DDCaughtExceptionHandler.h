//
//  DDCaughtExceptionHandler.h
//  NewDeayou
//
//  Created by 郭嘉 on 2017/6/14.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DDCaughtExceptionHandler : NSObject

/*!
 *  异常的处理方法
 *
 *  @param install   是否开启捕获异常
 *  @param showAlert 是否在发生异常时弹出alertView
 */
+ (void)installUncaughtExceptionHandler:(BOOL)install showAlert:(BOOL)showAlert;
@end