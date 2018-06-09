//
//  DYInvestListCell.m
//  NewDeayou
//
//  Created by wayne on 14-6-24.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYInvestListCell.h"
#import "MZTimerLabel.h"

#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

#define kFontNumsBig  [UIFont systemFontOfSize:25.0f] //大字体
#define kFontNumsSmall  [UIFont systemFontOfSize:15.0f] //小字体

@interface DYInvestListCell()
{
    NSTimeInterval timeUserValue;
    MZTimerLabel *timerExample3;
    __block int timeout;
}
//borrow_account_wait剩余金额   style_name还款方式
//标的属性(类型,名称,奖励,金额,利率,期限,进度)

@property (weak, nonatomic) IBOutlet UILabel *percentLabel;

@property (strong, nonatomic) IBOutlet UILabel *labelBidName;//标名
@property (strong, nonatomic) IBOutlet UILabel *labelBidRate;//预期年化
@property (strong, nonatomic) IBOutlet UILabel *labelBidDeadline;//持有时间
@property (nonatomic,strong) UIProgressView *pro ;
@property (nonatomic, strong) UILabel *tittleLabel;
@property (nonatomic, strong) UILabel *tittleStyleLabel;

@property (nonatomic,assign) InvestBidType bidType;
@property (nonatomic,assign) float bidAward;
@property (nonatomic,assign) float bidTotal;
@property (nonatomic,assign) float bidRate;
@property (nonatomic,assign) float bidDeadline;
@property (nonatomic,assign) float bidProgress;

@property (nonatomic,assign) BOOL isRevert;

@end

static UIProgressView *progressView;

@implementation DYInvestListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=kBackColor;
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        self.buyLabel.font = [UIFont systemFontOfSize:12];
        self.buyLabelHeight.constant = 70;
    }
    UIProgressView *pro=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    pro.frame=CGRectMake(10, 4, kMainScreenWidth- 26 - 50, 2);
    
    pro.trackTintColor = LZColorFromHex(0xedf0ef);
    pro.progressTintColor = LZColorFromHex(0x55bbfc);
    [self.progressBackView addSubview:pro];
    self.pro =pro;
    
   
    
//    self.pieChartView = [[HKPieChartView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
//    _pieChartView.alpha = 0;
//    [self.progressBackView addSubview:self.pieChartView];
    
//    self.investType.layer.cornerRadius = 28;
//    self.investType.layer.masksToBounds = YES;
//    self.investType.layer.borderColor = [HeXColor colorWithHexString:@"#cccccc"].CGColor;
//    self.investType.layer.borderWidth = 2;
    
    self.tittleLabel = [[UILabel alloc] initWithFrame:self.labelBidName.frame];
    _tittleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.labelBidName addSubview:self.tittleLabel];
    self.tittleStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tittleLabel.frame), 10, 80, 30)];
    _tittleStyleLabel.backgroundColor = [UIColor clearColor];
    _tittleStyleLabel.textColor = kMainColor;
    _tittleStyleLabel.layer.cornerRadius = 5;
    _tittleStyleLabel.layer.masksToBounds = YES;
    _tittleStyleLabel.layer.borderColor = kMainColor.CGColor;
    _tittleStyleLabel.layer.borderWidth = 1;
    _tittleStyleLabel.font = [UIFont systemFontOfSize:12];
    _tittleStyleLabel.textAlignment = NSTextAlignmentCenter;
    [self.labelBidName addSubview:self.tittleStyleLabel];
   
//    self.countTimeLabel.layer.masksToBounds = YES;
//    self.countTimeLabel.layer.cornerRadius = 28;
//    self.countTimeLabel.layer.borderColor = kBtnColor.CGColor;
//    self.countTimeLabel.layer.borderWidth = 2;
    
}


-(void)setAttributeWithDictionary:(NSDictionary*)dictionary type:(int)tfty product:(NSString *)product
{
    
    
//    NSLog(@"setAttributeWithDictionary%@", dictionary);
    
    
    NSString *percent = [NSString stringWithFormat:@"%@", [dictionary DYObjectForKey:@"borrow_account_scale"]];
    float mypar =  [percent floatValue];
      [self.pro setProgress:mypar / 100 animated:YES];
    self.percentLabel.text = [NSString stringWithFormat:@"%.f%%", mypar];
//    [_pieChartView updatePercent:mypar animation:YES];
    
    NSString *borrow_status_nid=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"borrow_status_nid"]];
//    NSLog(@"进度%f",mypar);
    //first:初审中 ， over:流标 ，false:初审失败，roam_now:马上认购 , roam_no:回购中 ,roam_yes:回购完 ,repay_advance:提前还款
    //repay_yes:已还完 repay:还款中 full_false:复审失败 cancel:用户撤标 late:已过期 full:满标待审 loan：马上投标
    
    if([borrow_status_nid isEqualToString:@"repay_yes"]){
        //已还完
        self.buyLabel.text = @"已还完";
        self.buyLabel.backgroundColor = LZColorFromHex(0xcfcfcf);

    }else if([borrow_status_nid isEqualToString:@"repay"]){
        //还款中
        self.buyLabel.text = @"还款中";
        self.buyLabel.backgroundColor = LZColorFromHex(0xcfcfcf);

        
    }else if([borrow_status_nid isEqualToString:@"late"]){
        //已过期
        self.buyLabel.text = @"已过期";
        self.buyLabel.backgroundColor = LZColorFromHex(0xcfcfcf);

    }else if([borrow_status_nid isEqualToString:@"full"]){
        //满标待审
         self.buyLabel.text = @"满标待审";
        self.buyLabel.backgroundColor = LZColorFromHex(0xcfcfcf);

    }else if([borrow_status_nid isEqualToString:@"over"]){
        //流标
        self.buyLabel.text = @"流标";
        self.buyLabel.backgroundColor = LZColorFromHex(0xcfcfcf);


    }else if([borrow_status_nid isEqualToString:@"count_down"]) {

    }else{
         self.buyLabel.text = @"立即购买";
        self.buyLabel.backgroundColor = LZColorFromHex(0x11a0f7);

    }
   
    
//    //预计标
//    double resttime = [[NSString stringWithFormat:@"%@", [dictionary DYObjectForKey:@"count_down_time"]] doubleValue];
//    if (resttime > 0) {
//        [self countDown:(int)resttime];
//        self.countTimeLabel.alpha = 1;
//        self.investType.alpha = 0;
//        self.userInteractionEnabled = NO;
//
//    }else{
//        self.countTimeLabel.alpha = 0;
//        self.userInteractionEnabled = YES;
//
//    }

    
    
    
    self.tittleLabel.text=[dictionary objectForKey:@"name"];
    [self.tittleLabel sizeToFit];
     NSString *word = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"invest_word"]];
    if (![word isEqualToString:@"(null)"] && ![word isEqualToString:@""] && word) {
        self.tittleStyleLabel.frame = CGRectMake(CGRectGetMaxX(self.tittleLabel.frame) + 5, 10, 60, 20);
        self.tittleStyleLabel.text = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"invest_word"]];
        
    }else {
        self.tittleStyleLabel.frame = CGRectMake(0, 0, 0, 0);
    }
    
//    NSString * bidType=[dictionary objectForKey:@"borrow_type"];
    
    
//    if ([bidType isEqualToString:@"credit"])
//    {
//        self.bidType=InvestBidTypeCredit;
//    }
//    else if ([bidType isEqualToString:@"vouch"])
//    {
//        self.bidType=InvestBidTypeAssure;
//    }
//    else if ([bidType isEqualToString:@"day"])
//    {
//        self.bidType=InvestBidTypeGod;
//    }
//    else if ([bidType isEqualToString:@"pawn"])
//    {
//        self.bidType=InvestBidTypePledge;
//    }
//    else if ([bidType isEqualToString:@"roam"])
//    {
//        self.bidType=InvestBidTypeFlow;
//    }
//    else if ([bidType isEqualToString:@"second"])
//    {
//        self.bidType=InvestBidTypeSecond;
//    }
//    else if ([bidType isEqualToString:@"worth"])
//    {
//        self.bidType=InvestBidTypeNetWorth;
//    }
//    else
//    {
//        self.bidType=0;
//    }
    
    self.bidProgress=[[dictionary DYObjectForKey:@"borrow_account_scale"] floatValue];
    self.bidTotal=[[dictionary DYObjectForKey:@"account"] floatValue];
    
    self.bidRate=[[dictionary DYObjectForKey:@"borrow_apr"] floatValue];
    
    //设置属性化字体(利率)
    NSString * rate=[NSString stringWithFormat:@"%.2f",_bidRate];
     NSString *borrowApr = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"extra_borrow_apr"]];
    float borApr = [borrowApr floatValue];
    
    NSUInteger len = [rate length];
    if (borApr > 0) {
        NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%+%@%%", rate,borrowApr]];
        [str4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:27] range:NSMakeRange(0,len)];
        _labelBidRate.attributedText = str4;
    }else {
        NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%", rate]];
        [str4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:27] range:NSMakeRange(0,len)];
        _labelBidRate.attributedText = str4;
    }
    
   

    
    NSString *bidStr = [NSString stringWithFormat:@"%@", [dictionary DYObjectForKey:@"borrow_period_name"]];
    _labelBidDeadline.text = bidStr;
    
    self.refundStyleLabel.text = [NSString stringWithFormat:@"%@", [dictionary DYObjectForKey:@"style_name"]];
//    float remainmoney = [[NSString stringWithFormat:@"%@", [dictionary DYObjectForKey:@"borrow_account_wait"]] floatValue];
    NSString *remainStr = [NSString stringWithFormat:@"%@", [dictionary DYObjectForKey:@"borrow_account_wait"]];
    NSUInteger remainLen = [remainStr length];
    NSMutableAttributedString *remainMoney = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余金额:%@元", remainStr]];
    [remainMoney addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(5, remainLen)];
    self.remainMoneyLabel.attributedText = remainMoney;
    

//        self.huankLabel.hidden=YES;
//        self.huankTitle.hidden=YES;
//        self.progressBackView.hidden=NO;

    
}



- (void)countDown:(int)timeInterval{
    if (timeout>0) {
        return;
    }
    timeout=timeInterval; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_time,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_time, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_time);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                self.countTimeLabel.alpha = 0;
//                self.pieChartView.alpha = 1;
                self.userInteractionEnabled = YES;
            });
        }else{
            // int day = (timeout/3600)/24;
            int hour = timeout/3600;
            int minute = (timeout-hour*3600)/60;
            int second = (int)(timeout-hour*3600)%60;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2d:%.2d:%.2d",hour,minute, second]];
                
//                [ self.countTimeLabel setAttributedText:noteStr] ;
                
                
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_time);
    
}

-(void)setCountDownTime:(NSTimeInterval)time{
//    NSLog(@"timetimetime%f",time);
    timeUserValue = time;
}





-(void)setBidTotal:(float)bidTotal
{
    //设置标金额
    _bidTotal=bidTotal;
    
    NSString * stringBidTotal;
    float wan=_bidTotal/10000.0f;
    if (wan>1.0)
    {
        stringBidTotal=[NSString stringWithFormat:@"￥%.2f万",wan];
    }
    else
    {
        stringBidTotal=[NSString stringWithFormat:@"￥%.2f",_bidTotal];
    }
}



-(void)setBidRate:(float)bidRate
{
    _bidRate=bidRate;
    
    
    
}










@end
