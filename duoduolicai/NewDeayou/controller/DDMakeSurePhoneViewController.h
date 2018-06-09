//
//  DDMakeSurePhoneViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/23.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMakeSurePhoneViewController : DYBaseVC
@property (nonatomic, copy) NSString *massageStr;
@property (nonatomic, copy) NSString *oldPhoneStr;
@property (nonatomic, copy) NSString *messageId;//提交资料成功id

@property (nonatomic, copy) NSString *comeView;//从哪个页面进来
@end
