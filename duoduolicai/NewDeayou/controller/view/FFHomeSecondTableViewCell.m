//
//  FFHomeSecondTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/4/18.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "FFHomeSecondTableViewCell.h"

@implementation FFHomeSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)handleSafe:(UIButton *)sender {
    [MobClick event:@"homeAQBZ"];
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/safe/index", ffwebURL];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"安全保障";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:adVC animated:YES];
    
    

}

- (IBAction)handleCompliance:(UIButton *)sender {
   
    
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/activity/mobile/compliance/compliance.html", ffwebURL];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"合规进程";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:adVC animated:YES];
}

- (IBAction)handleAbout:(UIButton *)sender {
    [MobClick event:@"homeGYWM"];

    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/about/index", ffwebURL];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"关于我们";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:adVC animated:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
