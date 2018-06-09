//
//  DDMailMessageTableViewCell.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/12/17.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMailMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *AddTime;
//@property (weak, nonatomic) IBOutlet UITextView *Descript;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *Descript;
@property (nonatomic, strong) UIImageView *moveImage;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;

@property (weak, nonatomic) IBOutlet UIView *changeView;

@property (weak, nonatomic) IBOutlet UIView *Stuts;


@end
