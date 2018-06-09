//
//  PullingRefreshTableView.m
//  PullingTableView
//
//  Created by luo danal on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PullingRefreshTableView.h"
#import <QuartzCore/QuartzCore.h>

#define kPROffsetY 60.f
#define kPRMargin 25.f
#define kPRLabelHeight 20.f
#define kPRLabelWidth 100.f
#define kPRArrowWidth 20.f  
#define kPRArrowHeight 40.f

#define kTextColor [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define kPRBGColor [UIColor clearColor]
#define kPRAnimationDuration .18f

@interface LooadingView ()
@property(nonatomic,retain)UIColor * textColor;
@property(nonatomic,retain)UIColor * prbgColor;
- (void)updateRefreshDate :(NSDate *)date;
- (void)layouts;
@end

@implementation LooadingView
@synthesize atTop = _atTop;
@synthesize state = _state;
@synthesize loading = _loading;
#pragma mark ------customMethod
- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top andTextColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor=textColor;
        self.prbgColor=backgroundColor;
        if (!self.prbgColor) {
            self.prbgColor=kPRBGColor;
        }
        if (!self.textColor) {
            self.textColor=kTextColor;
        }
        self.atTop = top;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = self.prbgColor;
        //        self.backgroundColor = [UIColor clearColor];
        UIFont *ft = [UIFont systemFontOfSize:12.f];
        _stateLabel = [[UILabel alloc] init ];
        _stateLabel.font = ft;
        _stateLabel.textColor = self.textColor;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.backgroundColor = self.prbgColor;
        _stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _stateLabel.text = NSLocalizedString(@"下拉刷新", @"");
        [self addSubview:_stateLabel];
        
        _dateLabel = [[UILabel alloc] init ];
        _dateLabel.font = ft;
        _dateLabel.textColor = self.textColor;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.backgroundColor = self.prbgColor;
        _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //        _dateLabel.text = NSLocalizedString(@"最后更新", @"");
        if (top)
        {
            [self addSubview:_dateLabel];
        }
        
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _stateLabel.frame.origin.x-30, 20) ];
        
        _arrow = [CALayer layer];
        _arrow.frame = CGRectMake(0, 0, _stateLabel.frame.origin.x-30, 20);
        _arrow.contentsGravity = kCAGravityResizeAspect;
        
        _arrow.contents = (id)[UIImage imageWithCGImage:[UIImage imageNamed:@"释放金币"].CGImage scale:1 orientation:UIImageOrientationDown].CGImage;
        
        [self.layer addSublayer:_arrow];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityView];
        
        [self layouts];
        
    }
    return self;
}
 //Default is at top
- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top {
    self = [super initWithFrame:frame];
    if (self) {
        
        if (!self.prbgColor) {
            self.prbgColor=kPRBGColor;
        }
        if (!self.textColor) {
            self.textColor=kTextColor;
        }
        self.atTop = top;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = self.prbgColor;
//        self.backgroundColor = [UIColor clearColor];
        UIFont *ft = [UIFont systemFontOfSize:12.f];
        _stateLabel = [[UILabel alloc] init ];
        _stateLabel.font = ft;
        _stateLabel.textColor = kMainColor;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.backgroundColor = self.prbgColor;
        _stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _stateLabel.text = NSLocalizedString(@"下拉刷新", @"");
        [self addSubview:_stateLabel];

        _dateLabel = [[UILabel alloc] init ];
        _dateLabel.font = ft;
        _dateLabel.textColor = kMainColor;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.backgroundColor = self.prbgColor;
        _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        _dateLabel.text = NSLocalizedString(@"最后更新", @"");
        if (top)
        {
            [self addSubview:_dateLabel];
        }
        
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _stateLabel.frame.origin.x-30, 20) ];

        _arrow = [CALayer layer];
        _arrow.frame = CGRectMake(0, 0, _stateLabel.frame.origin.x-30, 20);
        _arrow.contentsGravity = kCAGravityResizeAspect;
      
        _arrow.contents = (id)[UIImage imageWithCGImage:[UIImage imageNamed:@"释放金币"].CGImage scale:1 orientation:UIImageOrientationDown].CGImage;

        [self.layer addSublayer:_arrow];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityView];
        
        [self layouts];
        
    }
    return self;
}

- (void)layouts {
    
    CGSize size = self.frame.size;
    CGRect stateFrame,dateFrame,arrowFrame;

    float x = 0,y,margin;
//    x = 0;
    margin = (kPROffsetY - 2*kPRLabelHeight)/2;
    if (self.isAtTop) {
        y = size.height - margin - kPRLabelHeight;
        dateFrame = CGRectMake(0,y,size.width,kPRLabelHeight);
        
        y = y - kPRLabelHeight;
        stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
        
        
        x = kPRMargin;
        float width=[UIScreen mainScreen].bounds.size.width;
        if (width==375) {
            //iphone6
            x=kPRMargin+10.f;
        }
        if (width==414) {
            //iphone6plus
            x=kPRMargin+15.f;
        }
//        NSLog(@"%f",width);
        y = size.height - margin - kPRArrowHeight-10;
        arrowFrame = CGRectMake(4*x, y, kPRArrowWidth, kPRArrowHeight);
        
        UIImage *arrow = [UIImage imageNamed:@"释放金币"];
        _arrow.contents = (id)arrow.CGImage;
        
    } else {    //at bottom
        y = margin;
        stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight );
        
        y = y + kPRLabelHeight;
        dateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
        
        x = kPRMargin-5.f;
        float width=[UIScreen mainScreen].bounds.size.width;
        if (width==375) {
            //iphone6
            x=kPRMargin;
        }
        if (width==414) {
            //iphone6plus
            x=kPRMargin+6.f;
        }

        y = margin-10;
        arrowFrame = CGRectMake(4*x, y, kPRArrowWidth, kPRArrowHeight);
        
        UIImage *arrow = [UIImage imageNamed:@"释放金币"];
        _arrow.contents = (id)arrow.CGImage;
//        _stateLabel.text = NSLocalizedString(@"上拉加载", @"");
        _stateLabel.text = NSLocalizedString(@"以上显示的是已加载数据", @"");
    }
    
    _stateLabel.frame = stateFrame;
    _dateLabel.frame = dateFrame;
    _arrowView.frame = arrowFrame;
    _activityView.center = _arrowView.center;
    _arrow.frame = arrowFrame;
    _arrow.transform = CATransform3DIdentity;
}

- (void)setState:(PRState)state {
    [self setState:state animated:YES];
}

- (void)setState:(PRState)state animated:(BOOL)animated{
    float duration = animated ? kPRAnimationDuration : 0.f;
    if (_state != state) {
        _state = state;
        if (_state == kPRStateLoading) {    //Loading
            
            _arrow.hidden = YES;
            _activityView.hidden = NO;
            [_activityView startAnimating];
            
            _loading = YES;
            if (self.isAtTop) {
                _stateLabel.text = NSLocalizedString(@"正在赚钱", @"");
            } else {
                _stateLabel.text = NSLocalizedString(@"正在加载", @"");
            }
            
        } else if (_state == kPRStatePulling && !_loading) {    //Scrolling
            
            _arrow.hidden = NO;
            _activityView.hidden = YES;
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            _arrow.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            [CATransaction commit];
            
            if (self.isAtTop) {
                _stateLabel.text = NSLocalizedString(@"释放赚钱", @"");
            } else {
                _stateLabel.text = NSLocalizedString(@"释放加载更多", @"");
            }
            
        } else if (_state == kPRStateNormal && !_loading){    //Reset
            
            _arrow.hidden = NO;
            _activityView.hidden = YES;
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            _arrow.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            if (self.isAtTop) {
                _stateLabel.text = NSLocalizedString(@"下拉赚钱", @"");
            } else {
                _stateLabel.text = NSLocalizedString(@"上拉加载更多", @"");
            }
        } else if (_state == kPRStateHitTheEnd) {
            if (!self.isAtTop) {    //footer
                _arrow.hidden = YES;
                _stateLabel.text = NSLocalizedString(@"已全部加载", @"");
            }
        }
    }
}

- (void)setLoading:(BOOL)loading {
//    if (_loading == YES && loading == NO) {
//        [self updateRefreshDate:[NSDate date]];
//    }
    _loading = loading;
}

- (void)updateRefreshDate :(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateString = [df stringFromDate:date];
    NSString *title = NSLocalizedString(@"今天", nil);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:date toDate:[NSDate date] options:0];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    if (year == 0 && month == 0 && day < 3)
    {
        if (day == 0)
        {
            title = NSLocalizedString(@"今天",nil);
        } else if (day == 1)
        {
            title = NSLocalizedString(@"昨天",nil);
        } else if (day == 2)
        {
            title = NSLocalizedString(@"前天",nil);
        }
        df.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
        dateString = [df stringFromDate:date];
        
    } 
    _dateLabel.text = [NSString stringWithFormat:@"%@: %@",
                       NSLocalizedString(@"最后更新", @""),
                       dateString];
    [df release];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface PullingRefreshTableView ()
- (void)scrollToNextPage;
@end

@implementation PullingRefreshTableView
@synthesize pullingDelegate = _pullingDelegate;
@synthesize autoScrollToNextPage;
@synthesize reachedTheEnd = _reachedTheEnd;
@synthesize headerOnly = _headerOnly;
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentSize"];
    [_headerView release];
    [_footerView release];
    [super dealloc];
}
#pragma mark ------customMethod
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style topTextColor:(UIColor*)topTextColor topBackgroundColor:(UIColor*)topBackgroundColor bottomTextColor:(UIColor*)bottomTextColor bottomBackgroundColor:(UIColor*)bottomBackgroundColor
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        
        CGRect rect = CGRectMake(0, 0 - frame.size.height, frame.size.width, frame.size.height);
        _headerView = [[LooadingView alloc] initWithFrame:rect atTop:YES andTextColor:topTextColor backgroundColor:topBackgroundColor];
        _headerView.backgroundColor=kCOLOR_R_G_B_A(239, 239, 239, 1);
        _headerView.atTop = YES;
        [self addSubview:_headerView];
        
        rect = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
        _footerView = [[LooadingView alloc] initWithFrame:rect atTop:NO andTextColor:bottomTextColor backgroundColor:bottomBackgroundColor];
        _footerView.atTop = NO;
        _footerView.backgroundColor=kCOLOR_R_G_B_A(239, 239, 239, 1);
        [self addSubview:_footerView];
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        
        CGRect rect = CGRectMake(0, 0 - frame.size.height, frame.size.width, frame.size.height);
        _headerView = [[LooadingView alloc] initWithFrame:rect atTop:YES];
        _headerView.backgroundColor=kCOLOR_R_G_B_A(239, 239, 239, 1);
        _headerView.atTop = YES;
        [self addSubview:_headerView];
        
        rect = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
        _footerView = [[LooadingView alloc] initWithFrame:rect atTop:NO];
        _footerView.atTop = NO;
        _footerView.backgroundColor=kCOLOR_R_G_B_A(239, 239, 239, 1);
        [self addSubview:_footerView];
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

        CGRect rect = CGRectMake(0, 0 - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        _headerView = [[LooadingView alloc] initWithFrame:rect atTop:YES];
        _headerView.atTop = YES;
        [self addSubview:_headerView];

        rect = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        _footerView = [[LooadingView alloc] initWithFrame:rect atTop:NO];
        _footerView.atTop = NO;
        [self addSubview:_footerView];

        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<PullingRefreshTableViewDelegate>)aPullingDelegate {
    self = [self initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.pullingDelegate = aPullingDelegate;
    }
    return self;
}

- (void)setReachedTheEnd:(BOOL)reachedTheEnd{
    _reachedTheEnd = reachedTheEnd;
    if (_reachedTheEnd){
        _footerView.state = kPRStateHitTheEnd;
    } else {
        _footerView.state = kPRStateNormal;
    }
}

- (void)setHeaderOnly:(BOOL)headerOnly{
    _headerOnly = headerOnly;
    _footerView.hidden = _headerOnly;
}

#pragma mark - Scroll methods

- (void)scrollToNextPage {
    float h = self.frame.size.height;
    float y = self.contentOffset.y + h;
    y = y > self.contentSize.height ? self.contentSize.height : y;
    
//    [UIView animateWithDuration:.4 animations:^{
//        self.contentOffset = CGPointMake(0, y);
//    }];
//    NSIndexPath *ip = [NSIndexPath indexPathForRow:_bottomRow inSection:0];
//    [self scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    
    [UIView animateWithDuration:.7f 
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut 
                     animations:^{
                        self.contentOffset = CGPointMake(0, y);  
                     }
                     completion:^(BOOL bl){
                     }];
}

- (void)tableViewDidScroll:(UIScrollView *)scrollView {

    if (_headerView.state == kPRStateLoading || _footerView.state == kPRStateLoading) {
        return;
    }

    CGPoint offset = scrollView.contentOffset;
    CGSize size = scrollView.frame.size;
    CGSize contentSize = scrollView.contentSize;
 
    if (contentSize.height<=size.height) {
        contentSize.height=size.height;
    }
    float yMargin = offset.y + size.height - contentSize.height;
    if (offset.y < -kPROffsetY)
    {   //header totally appeard
         _headerView.state = kPRStatePulling;
    } else if (offset.y > -kPROffsetY && offset.y < 0)
    { //header part appeared
        _headerView.state = kPRStateNormal;
        
    } else if ( yMargin > kPROffsetY)
    {  //footer totally appeared
        if (_footerView.state != kPRStateHitTheEnd)
        {
            _footerView.state = kPRStatePulling;
        }
    } else if ( yMargin < kPROffsetY && yMargin > 0)
    {//footer part appeared
        if (_footerView.state != kPRStateHitTheEnd)
        {
            _footerView.state = kPRStateNormal;
        }
    }
    else if(yMargin<0)
    {
        if (_footerView.state != kPRStateHitTheEnd)
        {
            _footerView.state = kPRStateNormal;
        }
    }
    
    
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView
{
    
//    CGPoint offset = scrollView.contentOffset;
//    CGSize size = scrollView.frame.size;
//    CGSize contentSize = scrollView.contentSize;
    
    if (_headerView.state == kPRStateLoading || _footerView.state == kPRStateLoading)
    {
        return;
    }
    if (_headerView.state == kPRStatePulling)
    {
//    if (offset.y < -kPROffsetY) {
        _isFooterInAction = NO;
//        _headerView.state = kPRStateLoading;
        
        [UIView animateWithDuration:1.2 animations:^{
            _headerView.state = kPRStateLoading;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.18 animations:^{
                self.contentInset = UIEdgeInsetsMake(kPROffsetY, 0, 0, 0);
            }];
        }];
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartRefreshing:)]) {
            [_pullingDelegate pullingTableViewDidStartRefreshing:self];
        }
    } else if (_footerView.state == kPRStatePulling)
    {
//    } else  if (offset.y + size.height - contentSize.height > kPROffsetY){
        if (self.reachedTheEnd || self.headerOnly) {
            return;
        }
        _isFooterInAction = YES;
        _footerView.state = kPRStateLoading;
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, kPROffsetY, 0);
        }];
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartLoading:)]) {
            [_pullingDelegate pullingTableViewDidStartLoading:self];
        }
    }
}
#pragma mark ------customMethod
- (void)tableViewDidFinishedLoadingHeaderView:(UIImageView*)imageView andFrame:(CGRect)frame
{
    if (_headerView.loading)
    {
        _headerView.loading = NO;
        [_headerView setState:kPRStateNormal animated:NO];
        NSDate *date = [NSDate date];
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewRefreshingFinishedDate)])
        {
            date = [_pullingDelegate pullingTableViewRefreshingFinishedDate];
        }
        [_headerView updateRefreshDate:date];
        [UIView animateWithDuration:kPRAnimationDuration*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
        {
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            imageView.frame=frame;
        }
        completion:^(BOOL bl)
        {
        }];
    }

}
- (void)tableViewDidFinishedLoading {
    [self tableViewDidFinishedLoadingWithMessage:nil];  
}

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg{

    //    if (_headerView.state == kPRStateLoading) {
    if (_headerView.loading)
    {
        _headerView.loading = NO;
        [_headerView setState:kPRStateNormal animated:NO];
        NSDate *date = [NSDate date];
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewRefreshingFinishedDate)]) {
            date = [_pullingDelegate pullingTableViewRefreshingFinishedDate];
        }
        [_headerView updateRefreshDate:date];
        [UIView animateWithDuration:kPRAnimationDuration*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL bl){
            if (msg != nil && ![msg isEqualToString:@""]) {
                [self flashMessage:msg];
            }
        }];
    }
    //    if (_footerView.state == kPRStateLoading) {
    else if (_footerView.loading)
    {
        _footerView.loading = NO;
        [_footerView setState:kPRStateNormal animated:NO];
        NSDate *date = [NSDate date];
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewLoadingFinishedDate)]) {
            date = [_pullingDelegate pullingTableViewRefreshingFinishedDate];
        }
        [_footerView updateRefreshDate:date];
        
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL bl){
            if (msg != nil && ![msg isEqualToString:@""]) {
                [self flashMessage:msg];
            }
        }];
    }
}

- (void)flashMessage:(NSString *)msg{
    //Show message
    __block CGRect rect = CGRectMake(0, self.contentOffset.y - 20, self.bounds.size.width, 20);
    
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.frame = rect;
        _msgLabel.font = [UIFont systemFontOfSize:14.f];
        _msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _msgLabel.backgroundColor = [UIColor orangeColor];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_msgLabel];    
    }
    _msgLabel.text = msg;
    
    rect.origin.y += 20;
    [UIView animateWithDuration:.4f animations:^{
        _msgLabel.frame = rect;
    } completion:^(BOOL finished){
        rect.origin.y -= 20;
        [UIView animateWithDuration:.4f delay:1.2f options:UIViewAnimationOptionCurveLinear animations:^{
            _msgLabel.frame = rect;
        } completion:^(BOOL finished){
            [_msgLabel removeFromSuperview];
            _msgLabel = nil;            
        }];
    }];
}

- (void)launchRefreshing
{
    [self setContentOffset:CGPointMake(0,0) animated:NO];
    [UIView animateWithDuration:kPRAnimationDuration animations:^{
        self.contentOffset = CGPointMake(0, -kPROffsetY-1);
    } completion:^(BOOL bl){
        [self tableViewDidEndDragging:self];
    }];
}
- (void)launchRefreshingNoAnimated
{
 
    [_pullingDelegate pullingTableViewDidStartLoading:self];
}
- (void)launchRefreshing:(LaunchRefreshingFinished)finished
{
    [self setContentOffset:CGPointMake(0,0) animated:NO];
    [UIView animateWithDuration:kPRAnimationDuration animations:^{
        self.contentOffset = CGPointMake(0, -kPROffsetY-1);
    } completion:^(BOOL bl){
        [self tableViewDidEndDragging:self];
        finished();
    }];
}

#pragma mark - 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGRect frame = _footerView.frame;
    CGSize contentSize = self.contentSize;
    frame.origin.y = contentSize.height < self.frame.size.height ? self.frame.size.height : contentSize.height;
    _footerView.frame = frame;
    if (self.autoScrollToNextPage && _isFooterInAction) {
        [self scrollToNextPage];
        _isFooterInAction = NO;
    } else if (_isFooterInAction) {
        CGPoint offset = self.contentOffset;
       // offset.y += 44.f;
        self.contentOffset = offset;
    }

    
}

@end
