//
//  DYSafeViewController.h
//  NewDeayou
//
//  Created by apple on 15/10/21.
//  Copyright © 2015年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYSafeViewController : DYBaseVC
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic,strong)NSString *weburl;

@end
