//
//  DYMyInvestmentRecordTableViewCell.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/18.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYMyInvestmentRecordTableViewCell.h"
#import "DYSafeViewController.h"
#import "RepaymentViewController.h"
@implementation DYMyInvestmentRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.xieyi.layer.borderWidth = .5;
    self.xieyi.layer.borderColor = kBtnColor.CGColor;
    self.xieyi.layer.cornerRadius = 4;
    self.jihua.layer.borderWidth = .5;
    self.jihua.layer.borderColor = kBtnColor.CGColor;
    self.jihua.layer.cornerRadius = 4;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = kBackColor;
    
}
- (void)setIsMonth:(BOOL)isMonth{
    _isMonth = isMonth;
    if (isMonth == YES) {
        self.jihua.hidden = false;
    }else if(isMonth == false){
        self.jihua.hidden = YES;

    }
}
- (IBAction)xieyiAction:(id)sender {

    
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":_webURL};
    adVC.titleM =@"借款协议";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:adVC animated:YES];

    
//    DYOrderedDictionary *diyouDic = [[DYOrderedDictionary alloc] init];
//    [diyouDic insertObject:@"esign" forKey:@"module" atIndex:0];
//    [diyouDic insertObject:@"esign" forKey:@"q" atIndex:0];
//    [diyouDic insertObject:@"server_survive" forKey:@"type" atIndex:0];
//    [diyouDic insertObject:[NSString stringWithFormat:@"%d", [DYUser GetUserID]] forKey:@"user_id" atIndex:0];
////    [diyouDic insertObject:[DYUser GetLoginKey] forKey:@"login_key" atIndex:0];
//    [diyouDic insertObject:self.borrowNid forKey:@"borrow_nid" atIndex:0];
//    [diyouDic insertObject:self.TouID forKey:@"tender_id" atIndex:0];
//    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
//       
//        if (isSuccess) {
//            NSLog(@"aa%@",object);
//        }else {
//            NSLog(@"bb%@", errorMessage);
//        }
//        
//    } fail:^{
//        
//    }];
    
}
- (IBAction)jihuaAction:(id)sender {
    RepaymentViewController *safeVC = [[RepaymentViewController alloc] init];
    safeVC.TouID = _TouID;
    [self.viewController.navigationController pushViewController:safeVC animated:YES];
}



@end
