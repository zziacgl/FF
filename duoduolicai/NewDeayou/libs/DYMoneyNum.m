//
//  DYMoneyNum.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/10/9.
//  Copyright © 2015年 wayne. All rights reserved.
//

#import "DYMoneyNum.h"

@implementation DYMoneyNum

+(NSString *)tranformMoneyNum:(int)money{
    NSString *MoneyNum=@"";
    int m = money;
    NSMutableArray *number=[[NSMutableArray alloc]init];
    int i=0;
    while (m > 1000) {
        int a = fmod(m, 1000);
        m=m/1000;
        if (a<10) {
            NSString *num=[NSString stringWithFormat:@"%d00",a];
            [number insertObject:num atIndex:i];
        }else if(a < 100){
            NSString *num=[NSString stringWithFormat:@"%d0",a];
            [number insertObject:num atIndex:i];
        }else{
            NSString *num=[NSString stringWithFormat:@"%d",a];
            [number insertObject:num atIndex:i];
        }
        i++;
    }
    switch (number.count) {
        case 1:
        {
            MoneyNum = [NSString stringWithFormat:@"%d,%@.00",m,[number objectAtIndex:0]];
        }
            break;
        case 2:
        {
            MoneyNum = [NSString stringWithFormat:@"%d,%@,%@.00",m,[number objectAtIndex:1],[number objectAtIndex:0]];
        }
            break;
        case 3:
        {
            MoneyNum = [NSString stringWithFormat:@"%d,%@,%@,%@.00",m,[number objectAtIndex:2],[number objectAtIndex:1],[number objectAtIndex:0]];
        }
            break;
        default:
        {
            MoneyNum = [NSString stringWithFormat:@"%d.00",m];
        }
            break;
    }
    return MoneyNum;
}
@end
