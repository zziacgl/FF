//
//  DYRegistNextViewController.h
//  NewDeayou
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    RegistTypePhone   =1,
    RegistTypeEmail     ,
    
}RegistType;
@class DYLoginVC;

@interface DYRegistNextViewController : UIViewController

@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *isUpdate;

@property (nonatomic,assign) DYLoginVC * loginVC;

@property (nonatomic, strong) NSString *checkUserInfo;
@end
