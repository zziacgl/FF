//
//  DDSmallWalletTableViewCell.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/11.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DDSmallWalletTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UILabel *yearLabel;//年化收益
@property (nonatomic, strong) UILabel *detaiLabel;
@property (weak, nonatomic) IBOutlet UIView *HeadView;//头部


@property (nonatomic, strong) UIButton *TranIn;//转入

@property (weak, nonatomic) IBOutlet UILabel *YesterdayEarnings;//昨日收益
@property (weak, nonatomic) IBOutlet UILabel *TotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *TotalTiYanJInLabel;
@property (weak, nonatomic) IBOutlet UILabel *Totalincome;
@property (weak, nonatomic) IBOutlet UILabel *ContinuousDays;
@property (weak, nonatomic) IBOutlet UILabel *Line1;
@property (weak, nonatomic) IBOutlet UILabel *Line2;
@property (weak, nonatomic) IBOutlet UILabel *Line3;

@property (weak, nonatomic) IBOutlet UIButton *RecordBnt;//按钮
@property (weak, nonatomic) IBOutlet UIButton *TiYanJinRecordBnt;

@end
