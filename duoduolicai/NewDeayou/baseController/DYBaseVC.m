//
//  DYBaseVC.m
//  NewDeayou
//
//  Created by wayne on 14/8/20.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYBaseVC.h"
#import "DYBaseNVC.h"

@interface DYBaseVC ()

@end

@implementation DYBaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tag = 1;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.navigationController isKindOfClass:[DYBaseNVC class]])
    {
        DYBaseNVC * nvc=(DYBaseNVC*) self.navigationController;
        nvc.mark=1;
    }

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tag = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
