//
//  DDMessageDetailViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/12/23.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMessageDetailViewController.h"

@interface DDMessageDetailViewController ()
@property (nonatomic, strong) UILabel *tittleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;


@end

@implementation DDMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
//    self.view.backgroundColor = [HeXColor colorWithHexString:@"#cccccc"];
    [self configView];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)configView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 100)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    self.tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, kMainScreenWidth - 20, 20)];
    _tittleLabel.textColor = [UIColor darkGrayColor];
    _tittleLabel.font = [UIFont systemFontOfSize:15];
    _tittleLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"name"]];
    [self.view addSubview:self.tittleLabel];

    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tittleLabel.frame) + 5, kMainScreenWidth - 20, 20)];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[self.dataDic objectForKey:@"addtime"] doubleValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *startTime = [formatter stringFromDate:date];
    self.timeLabel.text = startTime;

    [self.view addSubview:self.timeLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.timeLabel.frame) + 5, kMainScreenWidth - 20, 20)];
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"contents"]];
    CGSize size = [_contentLabel sizeThatFits:CGSizeMake(_contentLabel.frame.size.width, MAXFLOAT)];
    _contentLabel.frame = CGRectMake(10, CGRectGetMaxY(self.timeLabel.frame) + 5, kMainScreenWidth - 20, size.height);
    [self.view addSubview:self.contentLabel];
    backView.frame = CGRectMake(0, 0, kMainScreenWidth, 70+size.height + 20);
    
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
