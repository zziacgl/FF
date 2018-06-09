//
//  FFHomeBannerTableViewCell.h
//  NewDeayou
//
//  Created by 陈高磊 on 2018/4/18.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPagedFlowView.h"
#import "DDBarnerModel.h"
@interface FFHomeBannerTableViewCell : UITableViewCell
@property (nonatomic, strong) NewPagedFlowView *bannerView;

@property (nonatomic, strong) NSMutableArray *aryADImages;
@property (nonatomic, strong) NSMutableArray *aryUrls;
@property (nonatomic, strong) UIImageView * backImage;
@property (nonatomic, strong) NSMutableArray *bannerAry;

@end
