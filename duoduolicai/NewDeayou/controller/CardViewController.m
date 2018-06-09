//
//  CardViewController.m
//  CardModeDemo
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 wenSir. All rights reserved.
//

#import "CardViewController.h"
#import "CustomSlideView.h"
#import "DDCardModel.h"
#import "DYInvestDetailIntroduceVC.h"
#define adsViewWidth 293.0*(APPScreenBoundsWidth/320.0)
#define RatioValue  (APPScreenBoundsHeight-118)/450.0
#define APPScreenBoundsHeight [UIScreen mainScreen].bounds.size.height
#define APPScreenBoundsWidth [UIScreen mainScreen].bounds.size.width

@interface CardViewController ()<SlideCardViewDelegate>
{
    CustomSlideView *_slide;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *noDataLabel;
@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"公告";
    self.view.backgroundColor = kBackgroundColor;
    [self GetUserInfomation];
}

#pragma mark- 代理
-(void)slideCardViewDidEndScrollIndex:(NSInteger)index
{
    
}

-(void)slideCardViewDidSlectIndex:(NSInteger)index
{
    DYInvestDetailIntroduceVC * vc=[[DYInvestDetailIntroduceVC alloc]initWithNibName:@"DYInvestDetailIntroduceVC" bundle:nil];
    vc.hidesBottomBarWhenPushed=YES;
    DDCardModel *model = self.dataArray[index];
    vc.tfText = model.contents;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)slideCardViewDidScrollAllPage:(NSInteger)page AndIndex:(NSInteger)index
{
    
    
    //判断是否为第一页
//    if(page == index){
//        if (self.comeBackFirstMessageButton.frame.origin.y<APPScreenBoundsHeight) {
//            [UIView animateWithDuration:0.8 animations:^{
//                self.comeBackFirstMessageButton.center = CGPointMake(self.comeBackFirstMessageButton.center.x, self.comeBackFirstMessageButton.center.y+self.comeBackFirstMessageButton.frame.size.height);
//            }];
//        }
//    }else{
//        if (self.comeBackFirstMessageButton.frame.origin.y>=APPScreenBoundsHeight) {
//            [UIView animateWithDuration:0.8 animations:^{
//                self.comeBackFirstMessageButton.center = CGPointMake(self.comeBackFirstMessageButton.center.x, self.comeBackFirstMessageButton.center.y-self.comeBackFirstMessageButton.frame.size.height);
//            }];
//        }
//    }
    
    //提醒已是最后一条消息,由透明慢慢显现
//    if (_curPage == _totalPage && slideImageView.scrollView.contentOffset.y<0) {
//        self.lastMessageLabel.alpha = -(slideImageView.scrollView.contentOffset.y/50.0);
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取数据接口
-(void)GetUserInfomation
{
    
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"get_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"articles" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"94" forKey:@"type_id" atIndex:0];
    [diyouDic insertObject:@"order" forKey:@"order_asc" atIndex:0];
    [diyouDic insertObject:@"1" forKey:@"status" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
                 if (success==YES) {
             
             self.dataArray = [NSMutableArray new];
             self.dataArray = [DDCardModel mj_objectArrayWithKeyValuesArray:[object objectForKey:@"list"]];
             
                     
                     CGRect rect = {{lrintf((APPScreenBoundsWidth-adsViewWidth)/2.0),118-64},{lrintf(adsViewWidth) , APPScreenBoundsHeight-118}};
                     
                     _slide = [[CustomSlideView alloc]initWithFrame:rect AndzMarginValue:9/(RatioValue) AndxMarginValue:11/(RatioValue) AndalphaValue:1 AndangleValue:2000];
                     _slide.delegate = self;
                     [_slide addCardDataWithArray:self.dataArray];
                     _slide.backgroundColor = [UIColor clearColor];
                     [self.view addSubview:_slide];
        
                     
                     
             if (self.dataArray.count == 0) {
                 if (!_noDataLabel) {
                     self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kMainScreenHeight / 2 - 100, kMainScreenWidth, 30)];
                     self.noDataLabel.text = @"暂无公告";
                     _noDataLabel.textColor = [UIColor darkGrayColor];
                     _noDataLabel.textAlignment = NSTextAlignmentCenter;
                     [self.view addSubview:self.noDataLabel];
                 }
             }
             
         }
         else
         {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
}


@end
