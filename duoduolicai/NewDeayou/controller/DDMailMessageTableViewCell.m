//
//  DDMailMessageTableViewCell.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/12/17.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMailMessageTableViewCell.h"
#define TagVale  1000

@interface DDMailMessageTableViewCell ()
@property (nonatomic, strong) UIImageView *imageV;
@end

@implementation DDMailMessageTableViewCell
static int i = 1;
- (void)awakeFromNib {
    [super awakeFromNib];
    self.myImage.userInteractionEnabled = YES;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.editing)//仅仅在编辑状态的时候需要自己处理选中效果
    {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
                for (UIView *subV in view.subviews) {
                    if ([subV isKindOfClass:[UIImageView class]]) {
                        UIImageView *imgV = (UIImageView *)subV;
                        imgV.image = nil;
                    }
                }
            }
        }
        if (selected){
            UIView* editDotView1 = [self viewWithTag:TagVale];
            [editDotView1 removeFromSuperview];
            //选中时的效果
            UIImage* img = [UIImage imageNamed:@"站内信_03"];
            UIImageView* editDotView = [[UIImageView alloc] initWithImage:img];
            editDotView.tag = TagVale;
            editDotView.frame = CGRectMake(12,CGRectGetHeight(self.frame) / 2 - 11,22,22);
            [self addSubview:editDotView];
            editDotView.image = img;
        }
        else {
            //非选中时的效果
            UIView* editDotView1 = [self viewWithTag:TagVale];
            [editDotView1 removeFromSuperview];
            UIImage* img = [UIImage imageNamed:@"站内信_03_03"];
            UIImageView* editDotView = [[UIImageView alloc] initWithImage:img];
            editDotView.tag = TagVale;
            editDotView.frame = CGRectMake(12,CGRectGetHeight(self.frame) / 2 - 11,22,22);
            [self addSubview:editDotView];
            editDotView.image = img;
            [self bringSubviewToFront:self.imageV];
        }
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing)//编辑状态
    {
        if (self.editingStyle == (UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete)){ //编辑多选状态
            if (![self viewWithTag:TagVale])  //编辑多选状态下添加一个自定义的图片来替代原来系统默认的圆圈，注意这个图片在选中与非选中的时候注意切换图片以模拟系统的那种效果
            {
                UIImage* img = [UIImage imageNamed:@"站内信_03_03"];
                UIImageView* editDotView = [[UIImageView alloc] initWithImage:img];
                editDotView.tag = TagVale;
                editDotView.frame = CGRectMake(12,CGRectGetHeight(self.frame) / 2 - 11,22,22);
                [self addSubview:editDotView];
            }
        }
    }
    else {
        //非编辑模式下检查是否有dot图片，有的话删除
        UIView* editDotView = [self viewWithTag:TagVale];
        if (editDotView)
        {
            [editDotView removeFromSuperview];
        }
        if (self.imageV) {
            [self.imageV removeFromSuperview];
        }
    }
}

- (void)changeImage {
    NSString *str = [NSString stringWithFormat:@"icon_dong_%d", i];
//    NSLog(@"%@", str);
    self.moveImage.image = [UIImage imageNamed:str];
    i++;
    if (i>14) {
        i = 1;
    }
}



@end
