//
//  DYSortButtonItem.h
//  NewDeayou
//
//  Created by wayne on 14-6-24.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>


//筛选的类型(默认,金额,利率,进度,期限) 枚举类型
typedef enum
{
    SortButtonItemTypeDefult = 0,
    SortButtonItemTypeAmount   ,
    SortButtonItemTypeInterestRate,
    SortButtonItemTypeSchedule,
    SortButtonItemTypeDeadline,
    
}SortButtonItemType;

typedef enum
{
    SortButtonItemDirectionDown = 0 ,
    SortButtonItemDirectionUp
    
}SortButtonItemDirection;//排序方向


//点击事件代理（自定义代理）
@protocol SortButtonItemDelegate <NSObject>

-(void)sortButtonItemWithType:(SortButtonItemType)type andDirection:(SortButtonItemDirection)direction;

@end




@interface DYSortButtonItem : UIButton

//初始化方法
+(id)sortButtonItemWithFrame:(CGRect)frame andSortButtonItemType:(SortButtonItemType)type delegate:(id<SortButtonItemDelegate>)delegate;

@end
