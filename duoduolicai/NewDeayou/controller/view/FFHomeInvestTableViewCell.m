//
//  FFHomeInvestTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/4/18.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "FFHomeInvestTableViewCell.h"
#import "DYInvestDetailVC.h"
@implementation FFHomeInvestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        self.btnWidth.constant = 60;
    }
    // Initialization code
}


-(void)setNewinvestModel:(DDNewuserModel *)newinvestModel {
    _newinvestModel = newinvestModel;
    [self.buyBtn addTarget:self action:@selector(handleBuyNewUser) forControlEvents:UIControlEventTouchDown];
    self.investTypeLabel.text = @"新手专享";
    if (newinvestModel) {
        self.nameLabel.text = newinvestModel.name;
        self.timeLimitLabel.text = newinvestModel.borrow_period_name;
        NSString *str1 = newinvestModel.tender_account_min;
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元起投", str1]];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,str1.length + 1)];
        self.startMoneyLabel.attributedText=str2;
        
        float addInterest = [newinvestModel.extra_borrow_apr floatValue];
        if (addInterest > 0) {
            NSString *str1 = [NSString stringWithFormat:@"%@%%+%@%%",newinvestModel.borrow_apr, newinvestModel.extra_borrow_apr];
            NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:str1];
            [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, newinvestModel.borrow_apr.length)];

            self.percentLabel.attributedText = str2;
        }else {
            NSString *str1 = [NSString stringWithFormat:@"%@%%",newinvestModel.borrow_apr];
            NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:str1];
            [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, newinvestModel.borrow_apr.length)];
            self.percentLabel.attributedText = str2;
        }
        
    }
    
}
- (void)setRecommendedModel:(DDNewuserModel *)recommendedModel{
    _recommendedModel = recommendedModel;
    [self.buyBtn addTarget:self action:@selector(handleBuyRecommended) forControlEvents:UIControlEventTouchDown];

    self.investTypeLabel.text = @"精选推荐";
    if (recommendedModel) {
        self.nameLabel.text = recommendedModel.name;
        self.timeLimitLabel.text = recommendedModel.borrow_period_name;
        NSString *str1 = recommendedModel.tender_account_min;
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元起投", str1]];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,str1.length + 1)];
        self.startMoneyLabel.attributedText=str2;
        
        float addInterest = [recommendedModel.extra_borrow_apr floatValue];
        if (addInterest > 0) {
            NSString *str1 = [NSString stringWithFormat:@"%@%%+%@%%",recommendedModel.borrow_apr, recommendedModel.extra_borrow_apr];
            NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:str1];
            [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, recommendedModel.borrow_apr.length)];
            
            self.percentLabel.attributedText = str2;
        }else {
            NSString *str1 = [NSString stringWithFormat:@"%@%%",recommendedModel.borrow_apr];
            NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:str1];
            [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, recommendedModel.borrow_apr.length)];
            self.percentLabel.attributedText = str2;
        }
        
    }
    
}

- (void)handleBuyNewUser {
    [MobClick event:@"Novice_enter"];
    DYInvestDetailVC * detailVC=[[DYInvestDetailVC alloc]initWithNibName:@"DYInvestDetailVC" bundle:nil];
    detailVC.hidesBottomBarWhenPushed=YES;
    detailVC.borrow_status_nid = self.newinvestModel.borrow_status_nid;
    NSString *borrow_type = self.newinvestModel.borrow_type;
    detailVC.borrowType = borrow_type;
    detailVC.borrowId = self.newinvestModel.borrow_nid;
    
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
    
    
}
- (void)handleBuyRecommended {
    DYInvestDetailVC * detailVC=[[DYInvestDetailVC alloc]initWithNibName:@"DYInvestDetailVC" bundle:nil];
    detailVC.hidesBottomBarWhenPushed=YES;
    detailVC.borrow_status_nid = self.recommendedModel.borrow_status_nid;
    NSString *borrow_type = self.recommendedModel.borrow_type;
    detailVC.borrowType = borrow_type;
    detailVC.borrowId = self.recommendedModel.borrow_nid;
    
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
