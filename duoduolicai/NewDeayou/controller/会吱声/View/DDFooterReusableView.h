//
//  DDFooterReusableView.h
//  NewDeayou
//
//  Created by Tony on 2016/10/31.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^myBlock)(void);
@interface DDFooterReusableView : UICollectionReusableView

@property(nonatomic, strong) UIButton *button;

@property(nonatomic,copy)myBlock block;
@end
