//
//  DDVRPlayerViewController.h
//  NewDeayou
//
//  Created by 陈高磊 on 2016/10/26.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDOtherVideoModel;
@interface DDVRPlayerViewController : DYBaseVC
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *videoTitle;
@property (nonatomic, copy) NSString *videoID;
@property (nonatomic, copy) NSString *duomiStr;

@property (nonatomic, strong)DDOtherVideoModel *otherModel;

-(void)loadData;

@end
