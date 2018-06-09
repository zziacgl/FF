//
//  DYRealtimeFianacailContentTableViewCell.h
//  NewDeayou
//
//  Created by diyou on 14-7-10.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYRealtimeFianacailContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *button2;//持有资产

@property (weak, nonatomic) IBOutlet UIButton *moneyImage;//金币图片
@property (weak, nonatomic) IBOutlet UIButton *baoImage;//零钱包图片

@property (weak, nonatomic) IBOutlet UILabel *totalM;//累计收益
//@property (weak, nonatomic) IBOutlet UIButton *totalD;//总资产
@property (weak, nonatomic) IBOutlet UILabel *totalMain;//总资产

@property (weak, nonatomic) IBOutlet UILabel *totalL; // 可用余额
@property (weak, nonatomic) IBOutlet UIButton *ContentD;//持有资产
@property (weak, nonatomic) IBOutlet UIButton *Blance;//账户余额

@property (weak, nonatomic) IBOutlet UIButton *InvestRecordBtn;//我的投资

@property (weak, nonatomic) IBOutlet UILabel *MyAcountLabel;

@property (weak, nonatomic) IBOutlet UIButton *TuijianAward;
@property (weak, nonatomic) IBOutlet UIButton *RecordView;

@property (weak, nonatomic) IBOutlet UILabel *TiYanJianLabel;//体验金
@property (weak, nonatomic) IBOutlet UILabel *LingQianBaoLabel;//零钱包
@property (weak, nonatomic) IBOutlet UIButton *LingqianBaoBnt;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *myImage;
@property (nonatomic, strong) UIImageView *lingqinImage;
@property (nonatomic, strong) UIImageView *downImage;
@property (nonatomic ,strong) UIButton *myBtn;
@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic, strong) NSTimer *timer3;
@property (nonatomic, strong) NSMutableArray *arrry;
@property (weak, nonatomic) IBOutlet UIButton *tiyanjinBnt;//体验金记录
@property (nonatomic, strong) UIImageView *doudongImage;
@property (weak, nonatomic) IBOutlet UILabel *myTiyanjin;
@property (weak, nonatomic) IBOutlet UIButton *workBtn;//加班费按钮

@property (nonatomic)CGPoint Imagepoint;

- (void)startTimer;

- (void)closeTimer;

@property (nonatomic,strong) NSTimer *timer_number3;
@property (nonatomic) float start3;
@property (nonatomic) float end3;

@property (nonatomic,strong) NSTimer *timer_number2;
@property (nonatomic) float start2;
@property (nonatomic) float end2;
@property (nonatomic) float content2;

@property (weak, nonatomic) IBOutlet UIButton *DuoMIBnt;


@property (weak, nonatomic) IBOutlet UIButton *seeBnt;//加班费查看
@property (weak, nonatomic) IBOutlet UIButton *seeBnt2;

@end
