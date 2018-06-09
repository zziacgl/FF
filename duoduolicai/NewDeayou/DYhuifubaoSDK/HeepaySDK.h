//
//  HeePayApp1_2.h
//  HeePayApp1.2
//
//  Created by Jiangrx on 4/25/14.
//  Copyright (c) 2014 Jiangrx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class HeepaySDK;

/*  此处新添加一个回调值status,表示用户启动APP后，是否进行了支付，及支付结果状态
 *  1: 支付成功
 *  0: 支付处理中
 * -1: 支付失败或处理失败
 * -2: 用户没有进行支付，直接返回了商户APP。
 */

typedef void (^HeepaySDKBlocks)(NSString *status);

@interface HeepaySDK : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic,copy) HeepaySDKBlocks blocks;

//调用sdk
- (void)invokeSDKWithTokenId:(NSString *)tokenId agentBillId:(NSString *)agentBillId agentId:(NSString *)agentId rootController:(UIViewController *)rootController;

@end
