//
//  DYMoreCell.h
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/13.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMoreSeparateColor kCOLOR_R_G_B_A(234, 234, 234, 1)

@interface DYMoreCell : UITableViewCell

//第一行不隐藏，其余的都隐藏
- (void)hideTopImageView:(BOOL)hide;

@end
