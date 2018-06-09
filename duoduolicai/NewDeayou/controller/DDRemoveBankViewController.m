//
//  DDRemoveBankViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/10.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDRemoveBankViewController.h"

@interface DDRemoveBankViewController ()

@end

@implementation DDRemoveBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"解除绑定";
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kMainScreenHeight / 4, kMainScreenWidth, 30)];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    NSString *str = @"";
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 设置图片大小
    
    attch.bounds = CGRectMake(0, -5, 22, 22);
    attch.image = [UIImage imageNamed:@"对勾"];
    NSMutableAttributedString*aString =  [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ ",str]];
    NSAttributedString *iconString = [NSAttributedString attributedStringWithAttachment:attch];
    [aString appendAttributedString:iconString];
    [aString appendAttributedString:[[NSAttributedString alloc] initWithString:@"  申请提交成功！"]];
    firstLabel.attributedText = aString;
    [self.view addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(firstLabel.frame) + 40, kMainScreenWidth - 60, 60)];
    secondLabel.text = @"客服将在1-2个工作日内进行审核确认，请保持手机畅通。";
    secondLabel.numberOfLines = 0;
    secondLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:secondLabel];
    
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
