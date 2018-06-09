//
//  DDAssignTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/8/12.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDAssignTableViewCell.h"
#import "DYInvestDetailIntroduceVC.h"
#import "DYSafeViewController.h"
#import "DYTransactionRecordsViewController_new.h"
#import "RepaymentPlanViewController.h"
#import "DDSmallWalletHelperViewController.h"
@implementation DDAssignTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [MobClick event:@"product_Choice_ZR"];
    UIImage *image = [DYUtils gradientImageWithBounds:self.topImage.bounds andColors:@[kShallowColor,kDeepColor] andGradientType:1];
    self.topImage.image = image;
    self.topView.backgroundColor = kMainColor;
    CALayer *layer = [self.coverView layer];
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOpacity = 0.3;
    // Initialization code
}

-(void)setAttributeWithDictionary:(NSDictionary*)dic viewController:(DYInvestDetailVC*)vc isFlow:(BOOL)isFlow{
    self.isFlow = isFlow;
    if (dic.allKeys.count < 1) {
        return;
    }
    NSLog(@"vcDelegate%@", dic);
    _dicData = dic;
    self.vcDelegate = vc;
    self.typeLabel.text = [dic DYObjectForKey:@"name"];
    NSString *strr = [NSString stringWithFormat:@"%@元", [dic DYObjectForKey:@"account"]];
    
    NSString *str1 = [NSString stringWithFormat:@"%@元", [dic DYObjectForKey:@"borrow_account_wait"]];

    self.surplusLabel.text = str1;
    self.residueLabel.text = strr;
    self.limitMinMoneyLabel.text = [NSString stringWithFormat:@"%@元", [dic DYObjectForKey:@"tender_account_min"]];//起投金额
    
    self.oldaprLabel.text = [NSString stringWithFormat:@"%@%%", [dic DYObjectForKey:@"old_borrow_apr"]];
    self.incomeLabel.text = [NSString stringWithFormat:@"%@%%",[dic DYObjectForKey:@"borrow_apr"]];//年化收益
    self.deadlineLabel.text = [NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"borrow_period_name"]];
    
    
       
//    self.detailUrl = [NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"borrow_contents_url"]];
     self.detailUrl=[NSString stringWithFormat:@"http://www.51duoduo.com/?action&m=borrow&q=get_contents&borrow_nid=%@",[dic DYObjectForKey:@"borrow_nid"]];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    double starttime=[[NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"addtime"]]doubleValue];
    
    double endTime = [[NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"recover_time"]] doubleValue];
    self.startTimeLabel.text=[NSString stringWithFormat:@"%@-%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:starttime]],[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endTime]]];//开始时间
    self.projectStateLabel.text = [NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"status_type_name"]];//状态名称
    self.refundWayLabel.text=[NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"style_name"]];//还款方式
    double resttime = [[NSString stringWithFormat:@"%@", [dic DYObjectForKey:@"_borrow_end_time"]] doubleValue];
//    NSLog(@"endtime%f",resttime);
    NSString *markType = [dic DYObjectForKey:@"borrow_status_nid"];
    if ([markType isEqualToString:@"loan"]) {
        if (resttime > 0) {
            
            [self setCountDownTime:resttime];
            [self startTimer];
        }else {
            _valueDateLabel.text = @"--:--:--";
        }
        
    }else {
         _valueDateLabel.text = @"--:--:--";
    }
    
    self.detailUrl=[NSString stringWithFormat:@"%@/?action&m=borrow&q=get_contents&borrow_nid=%@",ffwebURL,[dic DYObjectForKey:@"borrow_nid"]];
    self.fullstatus = [NSString stringWithFormat:@"%@",[dic DYObjectForKey:@"borrow_full_status"]];

   
}

-(void)setCountDownTime:(NSTimeInterval)time{
//    NSLog(@"timetimetime%f",time);
    timeUserValue = time;
}
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)startTimer {
    if (!_timer) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleCountDown) userInfo:nil repeats:YES];
    }
    
}
- (void)handleCountDown {
    NSString *hourStr = @"";
    NSString *minuteStr = @"";
    NSString *secondStr = @"";
    int hour = (int)(timeUserValue/3600);
    if (hour < 10) {
        hourStr = [NSString stringWithFormat:@"0%d", hour];
    }else {
        hourStr = [NSString stringWithFormat:@"%d", hour];
    }
    int minute = (int)(timeUserValue - hour*3600)/60;
    if (minute < 10) {
        minuteStr = [NSString stringWithFormat:@"0%d", minute];
    }else {
        minuteStr = [NSString stringWithFormat:@"%d", minute];
    }
    
    int second = timeUserValue - hour*3600 - minute*60;
    if (second < 10) {
        secondStr = [NSString stringWithFormat:@"0%d", second];
    }else {
        secondStr = [NSString stringWithFormat:@"%d", second];
    }
    
    NSString *dural = [NSString stringWithFormat:@"%@:%@:%@", hourStr, minuteStr,secondStr];
    _valueDateLabel.text = dural;
    timeUserValue--;
    if (timeUserValue <= 0) {
        [self.vcDelegate.navigationController popViewControllerAnimated:YES];
        [self stopTimer];
    }
    
}


- (IBAction)projectDetail:(UIButton *)sender {
//    DYInvestDetailIntroduceVC * vc=[[DYInvestDetailIntroduceVC alloc]initWithNibName:@"DYInvestDetailIntroduceVC" bundle:nil];
//    vc.hidesBottomBarWhenPushed=YES;
//    vc.tfText=[self introducation];
//    [self.vcDelegate.navigationController pushViewController:vc animated:YES];
//    DYSafeViewController *safeVC = [[DYSafeViewController alloc] initWithNibName:@"DYSafeViewController" bundle:nil];
//    safeVC.weburl = self.detailUrl;
//    NSLog(@"detailUrl%@",self.detailUrl);
//    safeVC.title = @"项目详情";
//    [self.vcDelegate.navigationController pushViewController:safeVC animated:YES];
    
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":self.detailUrl};
    adVC.titleM =@"项目详情";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.vcDelegate.navigationController pushViewController:adVC animated:YES];

}
- (IBAction)safeProtect:(UIButton *)sender {
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/safe/index", ffwebURL];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"安全保障";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.vcDelegate.navigationController pushViewController:adVC animated:YES];

}
- (IBAction)repaymentPlan:(UIButton *)sender {
    if ([self.fullstatus isEqualToString:@"1"]) {
        RepaymentPlanViewController *repayVC = [[RepaymentPlanViewController alloc] initWithNibName:@"RepaymentPlanViewController" bundle:nil];
        repayVC.hidesBottomBarWhenPushed=YES;
        repayVC.borrowId=self.borrowId;
        [self.vcDelegate.navigationController pushViewController:repayVC animated:YES];
    }else {
        [LeafNotification showInController:self.viewController withText:@"本条投资未进入还款期,无还款记录"];

        
    }
    

}
//风险提示
- (IBAction)safeShow:(id)sender {
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/safe/risk", ffwebURL];
    adVC.myUrls = @{@"url":url};    adVC.titleM =@"风险提示";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.vcDelegate.navigationController pushViewController:adVC animated:YES];

}
- (IBAction)record:(UIButton *)sender {
    //投资人列表显示
    DYTransactionRecordsViewController_new * vc=[[DYTransactionRecordsViewController_new alloc]initWithNibName:@"DYTransactionRecordsViewController_new" bundle:nil];
    vc.hidesBottomBarWhenPushed=YES;
    vc.borrow_nid=[_dicData DYObjectForKey:@"borrow_nid"];
    [self.vcDelegate.navigationController pushViewController:vc animated:YES];

}
- (IBAction)massageDetail:(UIButton *)sender {
  
    
}


- (NSString*)introducation
{
    NSMutableString * text=[[NSMutableString alloc]init];
    if(self.isFlow)
    {
        [text insertString:@"<B>借款方商业描述:</B></br>" atIndex:0];
        [text insertString:[_dicData DYObjectForKey:@"borrow_contents"] atIndex:text.length];
    }
    else
    {
        [text insertString:@"<B>借款标介绍:</B></br>" atIndex:0];
        //        NSLog(@"%@",[_dicData DYObjectForKey:@"borrow_contents"]);
        NSMutableString *contents=[NSMutableString stringWithFormat:@"%@",[_dicData DYObjectForKey:@"borrow_contents"]];
        int width=[UIScreen mainScreen].bounds.size.width-15;
        NSString *img=[NSString stringWithFormat:@"<img width=\"%dpx\" src=\"https://www.51duoduo.com",width];
        [contents replaceOccurrencesOfString:@"<img src=\"" withString:img options:NSLiteralSearch range:NSMakeRange(0,[contents length])];
        
        [text insertString:contents atIndex:text.length];
        return text;
    }
    
    if ([[_dicData DYObjectForKey:@"borrow_account"]length]>0)
    {
        [text insertString:@"</br></br><B>借款方资产状况:</B></br>" atIndex:text.length];
        [text insertString:[_dicData DYObjectForKey:@"borrow_account"] atIndex:text.length];
    }
    
    if ([[_dicData DYObjectForKey:@"borrow_account_use"]length]>0)
    {
        [text insertString:@"</br></br><B>借款方资金用途</B>:</br>" atIndex:text.length];
        [text insertString:[_dicData DYObjectForKey:@"borrow_account_use"] atIndex:text.length];
    }
    
    if ([[_dicData DYObjectForKey:@"risk"]length]>0)
    {
        [text insertString:@"</br></br><B>风险控制措施</B>:</br>" atIndex:text.length];
        [text insertString:[_dicData DYObjectForKey:@"risk"] atIndex:text.length];
    }
    
    return text;
}




@end
