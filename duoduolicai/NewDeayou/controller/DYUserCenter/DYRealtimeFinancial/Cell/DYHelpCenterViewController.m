//
//  DYHelpCenterViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/10/19.
//  Copyright © 2015年 wayne. All rights reserved.
//

#import "DYHelpCenterViewController.h"

@interface DYHelpCenterViewController ()

@end

@implementation DYHelpCenterViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"规则介绍";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [[NSURL alloc]initWithString:@"http://www.51duoduo.com/ddjs/3jjljst.html"];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
