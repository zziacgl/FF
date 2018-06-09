//
//  FFHomeThirdTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/4/18.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "FFHomeThirdTableViewCell.h"

@implementation FFHomeThirdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if(![DYUser loginIsLogin]){
        self.myImageView.image = [UIImage imageNamed:@"new"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"新人专享大礼包"];
        [str addAttribute:NSForegroundColorAttributeName value:kMainColor range:NSMakeRange(4,3)];
        self.tittleLabel.attributedText=str;
        self.detailLabel.text = @"注册即得1888元理财大礼包";
        [self.coverBtn addTarget:self action:@selector(handleNewUser) forControlEvents:UIControlEventTouchDown];
    }else {
        self.myImageView.image = [UIImage imageNamed:@"homeinvite"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"邀请好友得现金"];
        [str addAttribute:NSForegroundColorAttributeName value:kMainColor range:NSMakeRange(4,3)];
        self.tittleLabel.attributedText=str;
        self.detailLabel.text = @"好友投资最高可得70元现金";
        [self.coverBtn addTarget:self action:@selector(handlerecommended) forControlEvents:UIControlEventTouchDown];
    }
    
    // Initialization code
}
- (void)handleNewUser {
    NSString *loginKey = [DYUser GetLoginKey];
    
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/novice/index&login_key=%@", ffwebURL, loginKey];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"新手专区";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:adVC animated:YES];
    
}
- (void)handlerecommended {
    NSString *loginKey = [DYUser GetLoginKey];

    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/invitation/index&login_key=%@", ffwebURL, loginKey];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"推荐专区";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:adVC animated:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
