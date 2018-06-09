//
//  GiftTalkSheetView.m
//  SystemSheetView
//
//  Created by FreeGeek on 14-11-13.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import "GiftTalkSheetView.h"
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface GiftTalkSheetView ()<UIScrollViewDelegate>
@property (assign , nonatomic) id<GiftTalkSheetDelegate>delegate;
@property (strong , nonatomic) UIView * SheetView;
@property (strong , nonatomic) UIView * BlackView;
@property (strong , nonatomic) UIButton * CancelButton;
@property (strong , nonatomic) UIScrollView * ScrollView;
@property (strong , nonatomic) UIButton * ShareButton;
@property (strong , nonatomic) UILabel * ShareLabel;
@property (strong , nonatomic) UIPageControl * page;
@property (strong , nonatomic) UILabel * PointDetailsLabel;
@property (assign , nonatomic) float SheetViewHeight;    //Sheet高度
@property (assign , nonatomic) float CancelButtonHeightInterval;  //取消按钮的上下间隔
@property (assign , nonatomic) float CancelButtonWidthInterval;   //取消按钮左右间隔
@property (assign , nonatomic) float CancelHeight;       //取消按钮高度
@property (assign , nonatomic) float CancelWidth;        //取消按钮宽度
@property (assign , nonatomic) float ScrollViewHeight;   //滑动页面高度
@property (assign , nonatomic) float ShareButtonHeight;  //分享按钮高度
@property (assign , nonatomic) float BottomViewHeight;
@end
@implementation GiftTalkSheetView
@synthesize PointDetailsLabel;
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(id)initWithTitleArray:(NSArray *)titleArray ImageArray:(NSArray *)imageArray PointArray:(NSArray *)PointArray ActivityName:(NSString *)activityName Delegate:(id<GiftTalkSheetDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        if (delegate)
        {
            self.delegate = delegate;
        }
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _BlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _BlackView.backgroundColor = [UIColor colorWithRed:106/255.00f green:106/255.00f blue:106/255.00f alpha:0.4];
        [self addSubview:_BlackView];
        UITapGestureRecognizer * Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapCancelAction)];
        [_BlackView addGestureRecognizer:Tap];
        
        _SheetView  = [[UIView alloc]initWithFrame:CGRectMake(0,ScreenHeight,ScreenWidth, _SheetViewHeight)];
        [self addSubview:_SheetView];
        _CancelHeight = 45;
        _CancelButtonWidthInterval = 10;
        _CancelButtonHeightInterval = 5;
        if (imageArray.count > 4)
        {
            _BottomViewHeight = ScreenWidth / 5 * 2 + _CancelHeight + 4 * _CancelButtonHeightInterval;
            if (imageArray.count > 8)
            {
                _BottomViewHeight = ScreenWidth / 5 * 2 + _CancelHeight + 4 * _CancelButtonHeightInterval + 20;
            }
        }
        else
        {
                _BottomViewHeight = self.bounds.size.width / 3.6 + 10;
        }
        
        _SheetViewHeight = _BottomViewHeight + _CancelHeight + _CancelButtonHeightInterval * 2;
        
        _CancelWidth = ScreenWidth - _CancelButtonWidthInterval * 2;
        
        _CancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _CancelButton.frame = CGRectMake(_CancelButtonWidthInterval,_SheetViewHeight - _CancelHeight - _CancelButtonHeightInterval,_CancelWidth,_CancelHeight);
        _CancelButton.backgroundColor = [UIColor whiteColor];
        _CancelButton.layer.cornerRadius = 5;
        if (![activityName isEqualToString:@"false"] && ![activityName isEqualToString:@""] && ![activityName isEqual:[NSNull null]] && ![activityName isKindOfClass:[NSNull class]] && activityName != nil)
        {
            [_CancelButton setTitle:activityName forState:UIControlStateNormal];
            [_CancelButton addTarget:self action:@selector(GoToPointStore) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [_CancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [_CancelButton addTarget:self action:@selector(TapCancelAction) forControlEvents:UIControlEventTouchUpInside];
        }
        [_CancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _CancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_CancelButton setTitleColor:[UIColor colorWithRed:0.259f green:0.580f blue:0.698f alpha:1.00f] forState:UIControlStateNormal];
        [_SheetView addSubview:_CancelButton];
        
        _ScrollViewHeight = _BottomViewHeight - 10;
        
        UIView * BottomView = [[UIView alloc]initWithFrame:CGRectMake(_CancelButtonWidthInterval, 0, _CancelWidth, _BottomViewHeight)];
        BottomView.backgroundColor = [UIColor whiteColor];
        BottomView.layer.cornerRadius = 5;
        
        [_SheetView addSubview:BottomView];
        _ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,5, _CancelWidth, _ScrollViewHeight)];
        _ScrollView.bounces = NO;
        _ScrollView.pagingEnabled = YES;
        _ScrollView.contentSize = CGSizeMake((imageArray.count / 9 + 1) * _CancelWidth, _ScrollViewHeight);
        _ScrollView.showsHorizontalScrollIndicator = NO;
        _ScrollView.showsVerticalScrollIndicator = NO;
        _ScrollView.delegate = self;
        [BottomView addSubview:_ScrollView];
        UIView * FirstScrollView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _CancelWidth, _ScrollViewHeight)];
        FirstScrollView.layer.cornerRadius = 5;
        FirstScrollView.backgroundColor = [UIColor whiteColor];
        UIView * SecondScrollView = [[UIView alloc]initWithFrame:CGRectMake(_CancelWidth, 0, _CancelWidth, _ScrollViewHeight)];
        SecondScrollView.layer.cornerRadius = 5;
        SecondScrollView.backgroundColor = [UIColor whiteColor];
        [_ScrollView addSubview:FirstScrollView];
        [_ScrollView addSubview:SecondScrollView];
        _ShareButtonHeight = _CancelWidth / 5.5;
        float SharebuttonInterval = (_CancelWidth - _ShareButtonHeight * 4) / 5;
        for (int i = 0; i < [imageArray count]; i++)
        {
            _ShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_ShareButton setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
            _ShareButton.tag = i;
            
            _ShareLabel = [[UILabel alloc]init];
            _ShareLabel.text = [titleArray objectAtIndex:i];
            _ShareLabel.font = [UIFont boldSystemFontOfSize:10];
            _ShareLabel.textColor = [UIColor colorWithRed:53/255.00f green:53/255.00f blue:53/255.00f alpha:1];
            _ShareLabel.textAlignment = NSTextAlignmentCenter;
            
            if (PointArray.count != 0)
            {

                PointDetailsLabel = [[UILabel alloc]init];
                if ([[PointArray objectAtIndex:i] intValue] != 0)
                {
                    PointDetailsLabel.text = [NSString stringWithFormat:@"分享+%@积分",[PointArray objectAtIndex:i]];
                    PointDetailsLabel.font = [UIFont systemFontOfSize:8];
                    PointDetailsLabel.textColor = [UIColor orangeColor];
                    PointDetailsLabel.textAlignment = NSTextAlignmentCenter;
                }
            }
            if (i < 8)
            {
                _ShareButton.frame = CGRectMake(SharebuttonInterval * (i % 4 + 1) + _ShareButtonHeight * (i % 4), _CancelButtonWidthInterval + (_ShareButtonHeight + _ShareButtonHeight * 2 / 3) * (i / 4), _ShareButtonHeight, _ShareButtonHeight);
                
                _ShareLabel.frame = CGRectMake(SharebuttonInterval * (i % 4 + 1) + _ShareButtonHeight * (i % 4), _ShareButton.frame.origin.y + _ShareButtonHeight,_ShareButtonHeight, 20);
                
                PointDetailsLabel.frame = CGRectMake(SharebuttonInterval * (i % 4 + 1) + _ShareButtonHeight * (i % 4), _ShareButton.frame.origin.y + _ShareButtonHeight + 15, _ShareButtonHeight, 10);
                
                [FirstScrollView addSubview:PointDetailsLabel];
                [FirstScrollView addSubview:_ShareLabel];
                [FirstScrollView addSubview:_ShareButton];
            }
            if (i > 7)
            {
                int k = i - 8;
                _ShareButton.frame = CGRectMake(SharebuttonInterval * (k % 4 + 1) + (imageArray.count / 9 - 1) * _CancelWidth + _ShareButtonHeight * (k % 4),_CancelButtonWidthInterval + (_ShareButtonHeight + _ShareButtonHeight * 2 / 3) * (k / 4) , _ShareButtonHeight, _ShareButtonHeight);
                
                _ShareLabel.frame = CGRectMake(SharebuttonInterval * (k % 4 + 1) + (imageArray.count / 9 - 1) * _CancelWidth + _ShareButtonHeight * (k % 4),_ShareButton.frame.origin.y + _ShareButtonHeight, _ShareButtonHeight, 20);
                
                PointDetailsLabel.frame = CGRectMake(SharebuttonInterval * (k % 4 + 1) + (imageArray.count / 9 - 1) * _CancelWidth + _ShareButtonHeight * (k % 4), _ShareButton.frame.origin.y + _ShareButtonHeight + 15, _ShareButtonHeight, 10);
                
                [SecondScrollView addSubview:PointDetailsLabel];
                [SecondScrollView addSubview:_ShareButton];
                [SecondScrollView addSubview:_ShareLabel];
            }
            _ShareButton.layer.cornerRadius = CGRectGetHeight([_ShareButton bounds]) / 2;
            _ShareButton.layer.masksToBounds = YES;
            [_ShareButton addTarget:self action:@selector(SeaYeungShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (imageArray.count > 8)
        {
            _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0,BottomView.bounds.size.height - 20, _CancelWidth, 10)];
            _page.numberOfPages = imageArray.count / 9 + 1;
            _page.layer.cornerRadius = 5;
            _page.currentPage = 0;
            _page.pageIndicatorTintColor = [UIColor colorWithRed:0.812f green:0.812f blue:0.812f alpha:1.00f];
            _page.currentPageIndicatorTintColor = [UIColor colorWithRed:0.547f green:0.547f blue:0.547f alpha:1.00f];
            [BottomView addSubview:_page];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _SheetView.frame = CGRectMake(0, ScreenHeight - _SheetViewHeight - 20, ScreenWidth, _SheetViewHeight);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                _SheetView.frame = CGRectMake(0,ScreenHeight - _SheetViewHeight,ScreenWidth, _SheetViewHeight);
            } completion:^(BOOL finished) {

            }];
        }];
    }
         return self;
}

-(void)SeaYeungShareButtonAction:(UIButton *)button
{
    [self.delegate GiftTalkShareButtonAction:(NSInteger *)button.tag];
    [self TapCancelAction];
}

-(void)TapCancelAction
{
    [UIView animateWithDuration:0.2 animations:^
    {
        _SheetView.frame = CGRectMake(_SheetView.frame.origin.x, _SheetView.frame.origin.y - 20, _SheetView.bounds.size.width, _SheetView.bounds.size.height);
    } completion:^(BOOL finished)
    {
        [UIView animateWithDuration:0.25 animations:^
         {
             _SheetView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 300);
         } completion:^(BOOL finished)
         {
             [_SheetView removeFromSuperview];
             [_BlackView removeFromSuperview];
             [self removeFromSuperview];
         }];
    }];
}

-(void)GoToPointStore
{
    [self.delegate GiftTalkGoToPointStore];
}

-(void)ShowInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = _ScrollView.contentOffset;
    _page.currentPage = lroundf(point.x / ScreenWidth);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
