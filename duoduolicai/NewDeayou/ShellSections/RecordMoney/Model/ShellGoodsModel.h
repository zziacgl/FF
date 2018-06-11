//
//  ShellGoodsModel.h
//  NewDeayou
//
//  Created by zhoubiwen on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShellGoodsModel : NSObject

@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSString *buyingPrice;
@property (nonatomic, strong) NSString *sellingPrice;
@property (nonatomic, strong) NSString *count;

- (NSDictionary *)convertDictionary;

@end
