//
//  DYCustomBoxMoreVC.m
//  NewDeayou
//
//  Created by wayne on 14-6-20.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYCustomBoxMoreVC.h"
#import "DYUserCustomBox.h"

@interface DYCustomBoxMoreVC ()<CustomBoxDelegate>

@property (nonatomic,retain) NSMutableArray *aryBoxs; //boxs

@end

@implementation DYCustomBoxMoreVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"更多";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initBoxs];
}

-(void)initBoxs
{
    
    _aryBoxs=[NSMutableArray new];
    
    //先移除scrollView所现有的子视图
    for (UIView * view in self.view.subviews)
    {
        [view removeFromSuperview];
    }
    
    
    //创建box视图
    
    NSArray * aryBoxUsed=[DYUser customBoxNotUsedValues];
    NSUInteger total=aryBoxUsed.count;
    
    for (int x=0; x<total; x++)
    {
        DYUserCustomBox * box = [DYUserCustomBox customBoxWithFrame:CGRectZero boxType:[aryBoxUsed[x] intValue] edtingType:EdtingTypeAdd boxActionDelegate:self];
        
        [_aryBoxs addObject:box];
        [self.view addSubview:box];
    }
    [self layoutBoxsAnimatin:YES];
    
}

-(void)layoutBoxsAnimatin:(BOOL)animation
{
    //排布boxs
    NSUInteger total=_aryBoxs.count;
    int boxRowGap=kBoxRowGap(self.view.frame.size.width);
    
    for (int x=0; x<total; x++)
    {
        int hang=x/kNumberOfRow;
        int lie=x%kNumberOfRow;
        
        DYUserCustomBox * box=_aryBoxs[x];
        CGRect changeFrame=CGRectMake(kBoxLimitGap+lie*(kWidthBox+boxRowGap),hang*(kWidthBox+kBoxLineGap)+kBoxTopGap , kWidthBox, kWidthBox);
        [box changeLocationWithFrame:changeFrame animation:animation];
    }
    
}


-(void)customBoxActionWithBoxActionType:(BoxActionType)boxActionType andBoxType:(BoxType)boxType
{
    if (boxActionType==BoxActionTap)
    {
        //点击事件
    }
    else if(boxActionType==BoxActionRemove)
    {
        //移除事件
        for (DYUserCustomBox * box in _aryBoxs)
        {
            if (box.boxType==boxType)
            {
                //移除box然后再重新布局
                [UIView animateWithDuration:0.38 animations:^
                 {
                     [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                     CGAffineTransform transformScale=CGAffineTransformMakeScale(0.2, 0.2);
                     box.transform=transformScale;
                     
                 }
                completion:^(BOOL finished)
                 {
                     [box removeFromSuperview];
                     [_aryBoxs removeObject:box];
                     [self layoutBoxsAnimatin:YES];
                 }];
                
                break;
            }
        }
    }
    
}

@end
