//
//  DYInvestDetailVC.h
//  NewDeayou
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYBaseVC.h"

@interface DYInvestDetailVC : DYBaseVC
@property (nonatomic, copy) NSString *borrowType;//判断标类型
//@property (nonatomic, copy) NSString *product;
@property(nonatomic,assign)ListType listType;
@property(nonatomic,copy)NSString * borrowId;
@property(nonatomic,assign)BOOL isFlow;
@property(nonatomic,copy)NSString *borrow_status_nid;
@property(nonatomic,copy)NSString *word;//是否新手标
@property(nonatomic)int isHome;//是否是首页立即购买进入的

@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@end
