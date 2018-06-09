//
//  DDActivityAreaTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 16/9/22.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDActivityAreaTableViewCell.h"

@interface DDActivityAreaTableViewCell ()


{
    NSTimeInterval timeUserValue;
    __block int timeout;
}
@end

@implementation DDActivityAreaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.typeLabel.layer.cornerRadius = 4;
    self.typeLabel.layer.masksToBounds = YES;
    self.backView.layer.borderWidth = 0.5;
    self.backView.layer.borderColor = kNormalColor.CGColor;
    self.coverView.layer.cornerRadius = 5;
    self.coverView.layer.masksToBounds = YES;
    self.activityIamge.layer.cornerRadius = 5;
    self.activityIamge.layer.masksToBounds = YES;
    
    
}
-(void)setAttributeWithDictionary:(NSDictionary*)dictionary{
    NSString *time = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"rest_time"]];
    double resttime = [time doubleValue];
    
    if (resttime > 0) {
        
        [self countDown:(int)resttime];
        self.predictLabel.alpha = 1;
        
    }else{
        self.predictLabel.alpha = 0;
        
    }
    
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
                self.predictLabel.alpha = 0;
                self.userInteractionEnabled = YES;
                self.typeLabel.text = @"热门";
                
            });
        }else{
           // int day = (timeout/3600)/24;
            int hour = timeout/3600;
            int minute = (timeout-hour*3600)/60;
            int second = (int)(timeout-hour*3600)%60;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                
                NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2d:%.2d:%.2d后开始",hour,minute, second]];
                
                [ self.predictLabel setAttributedText:noteStr] ;
                
                
                
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
