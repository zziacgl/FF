//
//  DDMyHomeHeaderView.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/21.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMyHomeHeaderView.h"
#import "DYSafeViewController.h"
#import "ActicityViewController.h"
#import "DDBarnerModel.h"
#import "ActivityDetailViewController.h"
#import "DYADDetailContentVC.h"
#import "CircularProgressBar.h"
#import "DYInvestDetailVC.h"
#import <QuartzCore/CADisplayLink.h>
#import "DDHomeMessageViewController.h"
#import "DDServiceCenterViewController.h"
@interface DDMyHomeHeaderView()
{
    CADisplayLink*_timer;
    CircularProgressBar* lineProgressView;
}
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@end
@implementation DDMyHomeHeaderView
- (NSMutableArray*)aryUrls{
    if (_aryUrls == nil) {
        _aryUrls = [NSMutableArray array];
    }
    return _aryUrls;
}
- (NSMutableArray*)aryADImages{
    if (_aryADImages == nil) {
        _aryADImages = [NSMutableArray array];
    }
    return _aryADImages;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.cycleView.delegate = self;
    self.cycleView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    self.cycleView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    self.cycleView.placeholderImage = [UIImage imageNamed:@"ffbackImage"];
    
    self.lineProgress.backgroundColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
    
    self.barnerScrollView.backgroundColor = [UIColor grayColor];
       



}
- (void)layoutSubviews{
    [super layoutSubviews];
      self.lineProgress.layer.cornerRadius = self.lineProgress.width/2.0;
    
    lineProgressView = [[CircularProgressBar alloc] initWithFrame:self.lineProgress.bounds];
    [lineProgressView strokeChart];
    [self.lineProgress addSubview:lineProgressView];
    
   }
- (void)MyTask{
    lineProgressView.progress += 1.0/60.0;
    
}

- (IBAction)buy:(UIButton *)sender {
    
 //新手标详情页
    DYInvestDetailVC * detailVC=[[DYInvestDetailVC alloc]initWithNibName:@"DYInvestDetailVC" bundle:nil];
    detailVC.hidesBottomBarWhenPushed=YES;
    detailVC.borrowId=self.model.borrow_nid;
    detailVC.borrowType = self.model.borrow_type;

    NSString * bidType=@"";
    
    bidType = self.model.borrow_type;
    
    
    detailVC.isFlow=[bidType isEqualToString:@"roam"]?YES:NO;
    
    
    detailVC.borrow_status_nid = self.model.borrow_status_nid;
    int borrowId=[self.model.url intValue];
    
    if (borrowId>0) {
        detailVC.borrowId=[NSString stringWithFormat:@"%@",self.model.url];
    }
    detailVC.isHome=1;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)Safeguard:(UIButton *)sender {




    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/safe/index", ffwebURL];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"安全保障";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:adVC animated:YES];

    

}
- (void)setModel:(DDNewuserModel *)model{
    _model = model;
    self.investNameLabel.text = model.name;
        NSString *str = model.borrow_period_name;
//    NSUInteger len1 = [str length];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"投资期限  %@", str]];
//    NSLog(@"期限%@", str);
    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,6)];
    _timeLabel.attributedText=str3;
    
    NSString *str4 = model.tender_account_min;
//    NSUInteger len2 = [str length];
    NSMutableAttributedString *str5 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"起投金额  %@元", str4]];
    [str5 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,6)];
    _startMoenyLabel.attributedText=str5;
    
    float addInterest = [model.extra_borrow_apr floatValue];
    if (addInterest > 0) {
        NSString *str1 = [NSString stringWithFormat:@"%@%%+%@%%",model.borrow_apr, model.extra_borrow_apr];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:str1];
        if ([UIScreen mainScreen].bounds.size.height == 736) {
            [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50] range:NSMakeRange(0, model.borrow_apr.length)];
        }else if ([UIScreen mainScreen].bounds.size.height == 667){
            [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50] range:NSMakeRange(0, model.borrow_apr.length)];
        }else {
            [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(0, model.borrow_apr.length)];
        }
        self.percentLabel.attributedText = str2;
    }else {
        NSString *str1 = [NSString stringWithFormat:@"%@%%",model.borrow_apr];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:str1];
        if ([UIScreen mainScreen].bounds.size.height == 736) {
            [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50] range:NSMakeRange(0, model.borrow_apr.length)];
        }else if ([UIScreen mainScreen].bounds.size.height == 667){
            [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50] range:NSMakeRange(0, model.borrow_apr.length)];
        }else {
            [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(0, model.borrow_apr.length)];
        }
        self.percentLabel.attributedText = str2;
    }
    
   
    
    
    if ([model.borrow_type isEqualToString:@"standard"]) {
        self.homeInvestImage.image = [UIImage imageNamed:@"home_new"];
    }else {
        self.homeInvestImage.image = [UIImage imageNamed:@"home_recommend"];
    }
    
   
    
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(MyTask)];
    
    _timer.frameInterval = 1;
    
    [_timer addToRunLoop: [NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    



   
}
- (void)setAllDataAry:(NSMutableArray *)allDataAry{
    _allDataAry = allDataAry;
    NSLog(@"我的轮播%@",allDataAry);
//    [_allDataAry removeObjectAtIndex:0];
    
    for (DDBarnerModel*model in _allDataAry) {
        [self.aryADImages addObject:model.full_pic_url];
        [self.aryUrls addObject:model.url];
    }
    self.cycleView.imageURLStringsGroup = _aryADImages;
    
}
- (IBAction)activityArea:(UIButton *)sender {
    
    ActicityViewController *activityVC = [[ActicityViewController alloc] initWithNibName:@"ActicityViewController" bundle:nil];
    activityVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:activityVC animated:YES];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    
    DDBarnerModel*model = self.allDataAry[index];
    NSString *activityIdStr = model.activity_id;
    if (![activityIdStr isEqualToString:@"0"]) {
        if(![DYUser loginIsLogin]){
            [DYUser  loginShowLoginView];
        }else {
            //已经登录跳转活动详情界面
            [self activityData:activityIdStr];
        }
    }else {
        DYADDetailContentVC *vc=[[DYADDetailContentVC alloc]init];
        vc.webUrl=self.aryUrls[index];
        vc.model=model;
        vc.shareDic = model.share;
        vc.hidesBottomBarWhenPushed=YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    

}
- (IBAction)handleMessage:(UIButton *)sender {
    
    
    DDHomeMessageViewController*vc = [[DDHomeMessageViewController alloc]init];
//    if (self.redView.hidden) {
//        vc.alphaStr = @"0";
//    }else {
//        vc.alphaStr = @"1";
//    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];

    
}

#pragma mark -- 新手专区

- (IBAction)handleNewUser:(UIButton *)sender {
    if(![DYUser loginIsLogin]){
        [DYUser  loginShowLoginView];
        return;
    }
    NSString *loginKey = [DYUser GetLoginKey];

    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/novice/index&login_key=%@", ffwebURL, loginKey];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"新手专区";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:adVC animated:YES];
}

#pragma mark - 活动专区接口

- (void)activityData : (NSString *)acID{
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"get_activity" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"activity" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"100" forKey:@"epage" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess == YES) {
            
            NSArray *arrayData = [object objectForKey:@"list"];
            [arrayData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                NSString *str = [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"]];
                
                if ([str isEqualToString:acID]) {
                   
                    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
                    adVC.myUrls = arrayData[idx];
                    adVC.hidesBottomBarWhenPushed = YES;
                    [self.viewController.navigationController pushViewController:adVC animated:YES];
                    
                }
            }];
            
        }else {
            [LeafNotification showInController:self.viewController withText:errorMessage];
        }
        
        
    } fail:^{
        [LeafNotification showInController:self.viewController withText:@"网络异常"];
        
    }];
}
#pragma mark -- 关于我们
- (IBAction)aboutUS:(UIButton *)sender {
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/action/site/view?v=activity/about/index", ffwebURL];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"关于我们";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:adVC animated:YES];
    
}
#pragma mark -- 服务中心

- (IBAction)fengfengServe:(UIButton *)sender {
    DDServiceCenterViewController *serviceCenterVC = [[DDServiceCenterViewController alloc]init];
    serviceCenterVC.hidesBottomBarWhenPushed=YES;
    [self.viewController.navigationController pushViewController:serviceCenterVC animated:YES];
}


@end
