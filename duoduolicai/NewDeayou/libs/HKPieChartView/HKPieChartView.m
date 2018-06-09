//
//  HKPieChartView.m
//  PieChart
//
//  Created by hukaiyin on 16/6/20.
//  Copyright © 2016年 HKY. All rights reserved.
//

#import "HKPieChartView.h"

@interface HKPieChartView()

@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, assign) UIColor *trackColor;
@property (nonatomic, assign) UIColor *progressColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) CGFloat percent; //饼状图显示的百分比，最大为100
@property (nonatomic, assign) CGFloat animationDuration;//动画持续时长
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, assign) CGFloat pathWidth;
@property (nonatomic, assign) CGFloat sumSteps;
@property (nonatomic, strong) UILabel *progressLabel;
@end

@implementation HKPieChartView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self updateUI];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self updateUI];
}

- (void)updateUI {
    self.trackColor = [UIColor lightGrayColor];
    self.progressColor = [UIColor whiteColor];
    self.animationDuration = 3;
    self.pathWidth = self.bounds.size.width / 1.15;
    [self shadowImageView];
    [self trackLayer];
    [self gradientLayer];
}

#pragma mark - Load

- (void)loadLayer:(CAShapeLayer *)layer WithColor:(UIColor *)color {
    
    CGFloat layerWidth = self.pathWidth;
    CGFloat layerX = (self.bounds.size.width - layerWidth)/2;
    layer.frame = CGRectMake(layerX, layerX, layerWidth, layerWidth);
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    
    layer.lineCap = kCALineCapButt;
    layer.lineWidth = self.lineWidth;
    layer.path = self.path.CGPath;
}

#pragma mark - Animation

- (void)updatePercent:(CGFloat)percent animation:(BOOL)animationed {
    self.percent = percent;
   
    
//    NSLog(@"%f", self.percent);
    [self.progressLayer removeAllAnimations];
    
    if (!animationed) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [CATransaction setAnimationDuration:1];
        
        self.progressLayer.strokeEnd = self.percent / 100.00;
        
        [CATransaction commit];
    } else {
        CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0.0);
        animation.toValue = @(self.percent / 100.00);
        animation.duration = self.animationDuration * self.percent / 100.00;
        animation.removedOnCompletion = YES;
        animation.delegate = self;
        animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

        self.progressLayer.strokeEnd = self.percent / 100.00;
        [self.progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    if (!self.timer) {
        self.timer = [NSTimer timerWithTimeInterval:1/60.f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//        NSLog(@"%s,%d",__FUNCTION__,__LINE__);
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self invalidateTimer];
        self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", self.percent];
//        NSLog(@"aaprogressLabel%@", self.progressLabel.text);
//        NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    }
}

- (void)timerAction {
    id strokeEnd = [[_progressLayer presentationLayer] valueForKey:@"strokeEnd"];
    if (![strokeEnd isKindOfClass:[NSNumber class]]) {
        return;
    }
    CGFloat progress = [strokeEnd floatValue];
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",floorf(progress * 100.00)];
    
    
    
}

- (void)invalidateTimer {
//    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    if (!self.timer) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Getters & Setters

- (CAShapeLayer *)trackLayer {
    if (!_trackLayer) {
        _trackLayer = [CAShapeLayer layer];
        [self loadLayer:_trackLayer WithColor:[HeXColor colorWithHexString:@"#cccccc"]];
        [self.layer addSublayer:_trackLayer];
    }
    return _trackLayer;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _shadowImageView.image = [UIImage imageNamed:@"shadow"];
        [self addSubview:_shadowImageView];
    }
    return _shadowImageView;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        [self loadLayer:_progressLayer WithColor:self.progressColor];
        _progressLayer.strokeEnd = 0;
    }
    return _progressLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
//        _gradientLayer.colors = @[(id)[UIColor cyanColor].CGColor,
//                                 (id)[UIColor colorWithRed:253/255 green:83/255 blue:83/255 alpha:1.000].CGColor];
//        [_gradientLayer setStartPoint:CGPointMake(0.5, 1.0)];
//        [_gradientLayer setEndPoint:CGPointMake(0.5, 0.0)];
        _gradientLayer.backgroundColor = kBtnColor.CGColor;
        [_gradientLayer setMask:self.progressLayer];
        [self.layer addSublayer:_gradientLayer];
        
    }
    return _gradientLayer;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _progressLabel.textColor = kBtnColor;
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:10];

        [self addSubview:_progressLabel];
    }
    return _progressLabel;
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    _percent = _percent > 100 ? 100 : _percent;
    _percent = _percent < 0 ? 0 : _percent;
}

- (UIBezierPath *)path {
    if (!_path) {
        
        CGFloat halfWidth = self.pathWidth / 2;
        _path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfWidth, halfWidth)
                                               radius:(self.pathWidth - self.lineWidth)/2
                                           startAngle:-M_PI/2*3
                                             endAngle:M_PI/2
                                            clockwise:YES];
    }
    return _path;
}

- (CGFloat)lineWidth {
    if (_lineWidth == 0) {
        _lineWidth = 2;
    }
    return _lineWidth;
}

@end
