//
//  DYSortButtonItem.m
//  NewDeayou
//
//  Created by wayne on 14-6-24.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYSortButtonItem.h"

//改变状态的通知
#define kNotificationSortButtonState @"kNotificationSortButtonState"

@interface DYSortButtonItem ()
@property(nonatomic, retain)UIImageView * imageViewSort;//排序方向图标
@property(nonatomic, assign)SortButtonItemDirection directionSort;//排序方向
@property(nonatomic, assign)SortButtonItemType      typeSort;//排序类型
@property(nonatomic, assign)id<SortButtonItemDelegate> delegate; //响应事件的代理

@end

@implementation DYSortButtonItem


//单例取得记录的item
static DYSortButtonItem * markButtonItem;

+(DYSortButtonItem*)defaultMarkButtonItem
{
    return markButtonItem;
}

//设置单例item
+(void)setMarkButtonItem:(DYSortButtonItem*)item
{
    markButtonItem=item;
}


//创建方法
+(id)sortButtonItemWithFrame:(CGRect)frame andSortButtonItemType:(SortButtonItemType)type delegate:(id<SortButtonItemDelegate>)delegate
{
    DYSortButtonItem * button=[DYSortButtonItem buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    button.typeSort=type;
    button.delegate=delegate;
    
    float fontSize=16.0f;
    //设置标题
    NSArray * titles=@[@"默认",@"金额",@"利率",@"进度",@"期限"];
    [button setTitle:titles[type] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    
    CGSize imageSize=CGSizeMake(7, 4);
    //添加图片(方向指示)
    if (type!=SortButtonItemTypeDefult)
    {
        button.imageViewSort=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sort_direction_down_blue.png"] highlightedImage:[UIImage imageNamed:@"sort_direction_up_blue.png"]];
        button.imageViewSort.hidden=YES;
        button.imageViewSort.frame=CGRectMake(frame.size.width/2+fontSize, (frame.size.height-imageSize.height)/2.0f,imageSize.width, imageSize.height);
        [button addSubview:button.imageViewSort];
        button.directionSort=SortButtonItemDirectionDown;
    }
    
    
    //设置字体颜色
    [button setTitleColor:kCOLOR_R_G_B_A(51, 51, 51, 1) forState:UIControlStateNormal];
    [button setTitleColor:kMainColor forState:UIControlStateSelected];
    
    
    //添加事件
    [button addTarget:button action:@selector(prepareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (type==SortButtonItemTypeDefult)
    {
        [button prepareAction:button];
    }
    
    return button;
}

-(void)setDirectionSort:(SortButtonItemDirection)directionSort
{
    //设置排序方向
    _directionSort=directionSort;
    if (_directionSort==SortButtonItemDirectionDown)
    {
        _imageViewSort.highlighted=NO;
    }
    else if (_directionSort==SortButtonItemDirectionUp)
    {
        _imageViewSort.highlighted=YES;
    }
    
}

-(void)prepareAction:(DYSortButtonItem*)sortItem
{
    
    //记录上一个item
    DYSortButtonItem *markItem = [DYSortButtonItem defaultMarkButtonItem];
    if (self.typeSort==SortButtonItemTypeDefult&&sortItem==markItem)
    {
        return;
    }
    
    if (markItem&&markItem!=self)
    {
        if(markItem!=sortItem)
        {
            markItem.selected=NO;
            markItem.imageViewSort.hidden=YES;
        }
    }

    [DYSortButtonItem setMarkButtonItem:sortItem];
    sortItem.selected=YES;
    
    //设置方向（第三方）
    if(self.imageViewSort.hidden==YES)
    {
        self.imageViewSort.hidden=NO;
    }
    else
    {
        self.directionSort=self.directionSort==SortButtonItemDirectionDown?SortButtonItemDirectionUp:SortButtonItemDirectionDown;
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sortButtonItemWithType:andDirection:)])
    {
        [self.delegate sortButtonItemWithType:self.typeSort andDirection:self.directionSort];
    }
}

@end

