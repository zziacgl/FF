//
//  DDChangePhoneLastViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2017/2/9.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDChangePhoneLastViewController.h"

@interface DDChangePhoneLastViewController ()

@end

@implementation DDChangePhoneLastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    self.title = @"修改手机号码";
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    

    
    self.view.backgroundColor = [HeXColor colorWithHexString:@"#F2F6F9"];
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kMainScreenWidth, 30)];
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
    secondLabel.textColor = [UIColor darkGrayColor];
    secondLabel.text = @"材料审核需要1-2个工作日，审核通过将以短信方式通知到您，审核失败将在个人消息中心进行通知。";
    secondLabel.numberOfLines = 0;
    secondLabel.font = [UIFont systemFontOfSize:14];
//    secondLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:secondLabel];
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(secondLabel.frame) + 20, kMainScreenWidth - 60, 60)];
    thirdLabel.text = @"修改手机号成功后，您后期登录的账号默认为修改后的新手机号码";
    thirdLabel.textColor = kMainColor2;
    thirdLabel.numberOfLines = 0;
    thirdLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:thirdLabel];
    
    UILabel *forthLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(thirdLabel.frame) + 60, kMainScreenWidth - 60, 40)];
    forthLabel.textColor = [UIColor darkGrayColor];
    
    forthLabel.text= [NSString stringWithFormat:@"如有疑问请拨打客服热线：%@",kefu_phone_title];
    forthLabel.numberOfLines = 0;
    forthLabel.font = [UIFont systemFontOfSize:14];
    forthLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:forthLabel];
    
    
    
    // Do any additional setup after loading the view.
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
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
