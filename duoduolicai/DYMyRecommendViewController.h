//
//  DYMyRecommendViewController.h
//  NewDeayou
//
//  Created by 郭嘉 on 15/10/7.
//  Copyright © 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"
#import "UMSocialShakeService.h"

#define kAcountBackgroundColor kCOLOR_R_G_B_A(246, 246, 246, 1)

@interface DYMyRecommendViewController : UIViewController<UMSocialUIDelegate>
{
    NSArray * titleArray;
    NSArray * imageArray;
    NSArray * pointArray;
    NSString * activityName;
    NSUserDefaults * defaults;
    UIWebView * PointStoreWebview;
    UIButton * deleteViewButton;
    

}
@property (nonatomic,strong)NSDictionary * dic;

@end
