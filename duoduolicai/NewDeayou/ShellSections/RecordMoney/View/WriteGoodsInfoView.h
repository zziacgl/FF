//
//  WriteGoodsInfoView.h
//  NewDeayou
//
//  Created by zhoubiwen on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShellGoodsModel;

@interface WriteGoodsInfoView : UIView

+ (void)showWithView:(UIView *)view sureButtonAction:(void(^)(ShellGoodsModel *shellGoodsModel))sureButtonAction;


@end
