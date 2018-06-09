//
//  DYRegistComfirmViewController.h
//  NewDeayou
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYLoginVC.h"
//typedef enum
//{
//    RegistTypePhone   =1,
//    RegistTypeEmail     ,
//    
//}RegistType;

@interface DYRegistComfirmViewController : DYBaseVC

@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *phone_code;

//@property (nonatomic,assign) DYLoginVC * loginVC;

@property (nonatomic, strong) NSString *checkUserInfo;
@property (nonatomic, assign) DYLoginVC * loginVC;

@end
