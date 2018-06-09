//
//  DDCollectionReusableView.h
//  NewDeayou
//
//  Created by Tony on 2016/10/28.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMessageModel.h"
typedef void (^myBlock)(void);
@interface DDCollectionReusableView : UICollectionReusableView
@property (nonatomic,strong)  UILabel *comment;
@property (nonatomic,strong)  UILabel *nickName;
@property (nonatomic,strong)  UIImageView *icon;
@property (nonatomic,strong)DDMessageModel*model;
@property (nonatomic,copy)NSString*modelText;
@property(nonatomic,strong)UIView*bgView;
@property(nonatomic,copy)myBlock block;

@end
