//
//  CardView.m
//  CardModeDemo
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 wenSir. All rights reserved.
//

#import "CardView.h"

@implementation CardView
- (IBAction)delete:(UIButton *)sender {
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
//    self.layer.borderColor = [UIColor grayColor].CGColor;
//    self.layer.borderWidth = 0.5;
    self.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    self.layer.shadowRadius = 3;//阴影半径，默认3
   }
-(void)loadCardViewWithDictionary:(NSDictionary *)dictionary
{
//    self.backgroundColor = RGBCOLOR([[dictionary objectForKey:@"red"] floatValue], [[dictionary objectForKey:@"green"] floatValue], [[dictionary objectForKey:@"blue"] floatValue]);

}
- (void)setModel:(DDCardModel *)model{
    _model = model;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    double time=[model.addtime doubleValue];
    if (time>0) {
       self.time.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
    }
    self.typeName.text = model.typeName;
    self.content.text = model.name;

}
@end
