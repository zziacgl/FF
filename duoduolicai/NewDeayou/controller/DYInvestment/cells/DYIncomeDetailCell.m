//
//  DYIncomeDetailCell.m
//  NewDeayou
//
//  Created by wayne on 14/8/14.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYIncomeDetailCell.h"

@interface DYIncomeDetailCell()

@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UILabel *labelType;
@property (strong, nonatomic) IBOutlet UILabel *labelAccount;

@end

@implementation DYIncomeDetailCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setAttributeWithDictionary:(NSDictionary*)dic
{
    _labelTime.text=[dic objectForKey:@"date_time"];
    _labelTime.font=[UIFont systemFontOfSize:15];
    if ([[dic objectForKey:@"type"]isEqualToString:@"lixi"])
    {
        _labelType.text=@"利息";
    }
    else
    {
        _labelType.text=@"奖励";
        
    }
    _labelAccount.text=[NSString stringWithFormat:@"￥%.2f",[[dic objectForKey:@"account"]floatValue]];
    
}


@end
