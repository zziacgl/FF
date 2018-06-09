//
//  FFRedPacketTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/1/18.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "FFRedPacketTableViewCell.h"

@implementation FFRedPacketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(FFRedPacketmodel *)model {
    if (model) {
        
        if ([model.status isEqualToString:@"1"]) {
//            self.coverImage.alpha = 1;
//            self.coverImage.image = [UIImage imageNamed:@"ic_used_coupon"];
            self.typeLabel.backgroundColor = [UIColor lightGrayColor];
            self.typeLabel.text = @"已使用";
            if ([model.type isEqualToString:@"ticket"]) {//返现红包
                self.leftImaeView.image = [UIImage imageNamed:@"usedRedPacket"];
                NSString *money = model.award;
                NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", money]];
                [moneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 1)];
                self.awardLabel.attributedText = moneyStr;
                
            }else {
                self.leftImaeView.image = [UIImage imageNamed:@"usedRedPacket"];
                NSString *money = model.award;
                NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%", money]];
                [moneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(money.length, 1)];
                self.awardLabel.attributedText = moneyStr;
                
            }
        }else{
            NSString *leftStatus = model.lifetstatus;
            if ([leftStatus isEqualToString:@"1"]) {//过期卡券
//                self.coverImage.alpha = 1;
//                self.coverImage.image = [UIImage imageNamed:@"ic_dead_coupon"];
                self.typeLabel.backgroundColor = [UIColor lightGrayColor];
                self.typeLabel.text = @"已过期";
                if ([model.type isEqualToString:@"ticket"]) {//返现红包
                    self.leftImaeView.image = [UIImage imageNamed:@"usedRedPacket"];
                    NSString *money = model.award;
                    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", money]];
                    [moneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 1)];
                    self.awardLabel.attributedText = moneyStr;
                    
                }else {
                    self.leftImaeView.image = [UIImage imageNamed:@"usedRedPacket"];
                    NSString *money = model.award;
                    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%", money]];
                    [moneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(money.length, 1)];
                    self.awardLabel.attributedText = moneyStr;
                    
                }
                
            }else {
//                  self.coverImage.alpha = 0;
                self.typeLabel.backgroundColor = LZColorFromHex(0x4bb3ee);
                self.typeLabel.text = @"未使用";
                if ([model.type isEqualToString:@"ticket"]) {//返现红包
                    self.leftImaeView.image = [UIImage imageNamed:@"moneyRedPacket"];
                    NSString *money = model.award;
                    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", money]];
                    [moneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 1)];
                    self.awardLabel.attributedText = moneyStr;
                    
                }else {
                    self.leftImaeView.image = [UIImage imageNamed:@"addRedPacket"];
                    NSString *money = model.award;
                    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%", money]];
                    [moneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(money.length, 1)];
                    self.awardLabel.attributedText = moneyStr;
                    
                }
            }
            
           
        }
        
        
        self.reComeLabel.text = model.recom_name;
        
        if ([model.time_unit isEqualToString:@"1"]) {//天
            self.firstLabel.text = [NSString stringWithFormat:@"限投资%@天以上标", model.period];

        }else {
            self.firstLabel.text = [NSString stringWithFormat:@"限投资%@月以上标", model.period];

        }
        
        
        
        self.secondLabel.text = [NSString stringWithFormat:@"最低投资%@元可使用", model.invest_account];
        self.thirdLabel.text = [NSString stringWithFormat:@"有效期：%@-%@", [DYUtils datachangeTimeYYYYMMDD:model.addtime], [DYUtils datachangeTimeYYYYMMDD:model.deadline]];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
