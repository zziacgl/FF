//
//  DYADDetailContentVC.h
//  NewDeayou
//
//  Created by wayne on 14/8/26.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBarnerModel.h"
@interface DYADDetailContentVC : DYBaseVC

@property(nonatomic,copy)NSString * webUrl;
@property (nonatomic, strong) NSDictionary *shareDic;
@property (nonatomic,strong)DDBarnerModel *model;
@end
