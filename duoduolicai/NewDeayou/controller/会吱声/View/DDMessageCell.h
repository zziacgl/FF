//
//  DDMessageCell.h
//  NewDeayou
//
//  Created by Tony on 2016/10/28.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMessageModel.h"
typedef void (^myBlock)(void);

@interface DDMessageCell : UICollectionViewCell
@property(nonatomic,copy)myBlock block;

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *reply;
@property(nonatomic,strong)DDMessageModel*model;
@end
