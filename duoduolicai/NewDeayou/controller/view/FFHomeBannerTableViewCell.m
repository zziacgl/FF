//
//  FFHomeBannerTableViewCell.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/4/18.
//  Copyright © 2018年 浙江多多投资管理有限公司. All rights reserved.
//

#import "FFHomeBannerTableViewCell.h"
#import "DYADDetailContentVC.h"
@interface FFHomeBannerTableViewCell ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>


@end
@implementation FFHomeBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewController.automaticallyAdjustsScrollViewInsets = NO;

    self.bannerView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth / 30 * 13)];
    self.bannerView.delegate = self;
    self.bannerView.layer.cornerRadius = 8;
    if (@available(iOS 11.0, *)) {
        self.bannerView.layer.maskedCorners = YES;
    } else {
        // Fallback on earlier versions
    }
    self.bannerView.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    self.bannerView.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.bannerView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    self.bannerView.layer.shadowRadius = 3;//阴影半径，默认3
    
  
    
  
    self.bannerView.dataSource = self;
    self.bannerView.minimumPageAlpha = 0.1;
    self.bannerView.orientation = NewPagedFlowViewOrientationHorizontal;
    self.bannerView.isOpenAutoScroll = YES;
   

    [self.contentView addSubview:self.bannerView];
    
}
- (NSMutableArray*)aryUrls{
    if (_aryUrls == nil) {
        _aryUrls = [NSMutableArray array];
    }
    return _aryUrls;
}
- (NSMutableArray*)aryADImages{
    if (!_aryADImages) {
        _aryADImages = [NSMutableArray array];
    }
    return _aryADImages;
}

- (void)setBannerAry:(NSMutableArray *)bannerAry {
    _bannerAry = bannerAry;
    if (bannerAry.count == 0) {
        if (!_backImage) {
            
            self.backImage = [[UIImageView alloc] initWithFrame:self.frame];
            self.backImage.image = [UIImage imageNamed:@"lunbo_default"];
            [self addSubview:self.backImage];
        }
    }else {
        NSLog(@"轮播%@", bannerAry);
        [self.backImage removeFromSuperview];
        [self.aryADImages removeAllObjects];
        [self.aryUrls removeAllObjects];
        for (DDBarnerModel *model in self.bannerAry) {
            
            [self.aryADImages addObject:model.full_pic_url];
            [self.aryUrls addObject:model.url];
        }
        NSLog(@"我的%@", self.aryADImages);
         [self.bannerView reloadData];
        
    }
}
#pragma mark --NewPagedFlowView Delegate

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(kMainScreenWidth - 80, (kMainScreenWidth - 50) * 13 / 30);
}
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    DDBarnerModel*model = self.bannerAry[subIndex];

    NSLog(@"点击了第%ld张图",(long)subIndex);
    DYADDetailContentVC *vc=[[DYADDetailContentVC alloc]init];
    vc.webUrl=self.aryUrls[subIndex ];
    vc.model=model;
    vc.shareDic = model.share;
    vc.hidesBottomBarWhenPushed=YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}


#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.aryADImages.count;
    
}
- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.aryADImages[index]]] placeholderImage:[UIImage imageNamed:@"backImage"]];

//    bannerView.mainImageView.image = self.aryADImages[index];
    
    return bannerView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
