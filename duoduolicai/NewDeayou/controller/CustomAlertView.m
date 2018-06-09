//
//  CustomAlertView.m
//  CustomAlertView
//
//  Created by huadao on 15/11/13.
//  Copyright © 2015年 KUKER. All rights reserved.
//

#import "CustomAlertView.h"
#import "DDWalletTurnInViewController.h"
@implementation CustomAlertView
//{
//    UITableView * _tableView;
//}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"aa%ld", (long)self.number);
        self.backgroundColor = [UIColor whiteColor];
        UILabel * labela_A = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                      10,
                                                                      self.frame.size.width,
                                                                      20)];
        labela_A.text = @"选择转入方式";
        labela_A.font = [UIFont systemFontOfSize:18.0];
        labela_A.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labela_A];
        
        UILabel * labela_B = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                      labela_A.frame.origin.y+labela_A.frame.size.height+18,
                                                                      190,
                                                                      20)];
        labela_B.center=CGPointMake(self.frame.size.width/2+8, labela_A.frame.origin.y+labela_A.frame.size.height+18);
        labela_B.text = @"账户资金安全由人保PICC保障";
        labela_B.font = [UIFont systemFontOfSize:14.0];
        labela_B.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labela_B];
        
        UIImageView *imageDun=[[UIImageView alloc] initWithFrame:CGRectMake(labela_B.frame.origin.x-17, labela_B.frame.origin.y+2, 15, 15)];
        imageDun.image=[UIImage imageNamed:@"dun.png"];
        [self addSubview:imageDun];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(labela_B.frame) + 18, self.frame.size.width - 10, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.alpha = 0.5;
        [self addSubview:lineView];
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-30.0
                                                                   ,
                                                                   10,
                                                                   20,
                                                                   20)];
//        btn.backgroundColor = [UIColor blueColor];
        [btn addTarget:self action:@selector(dismissalertview) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"零钱宝(2).png"] forState:UIControlStateNormal];
        [self addSubview:btn];
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(lineView.frame),
                                                                  self.frame.size.width,
                                                                  180)];
        self.tableView.layer.cornerRadius = 10;
        NSLog(@"%ld", (long)self.number);
        _tableView.delegate = self;
        _tableView.dataSource = self;
         _tableView.scrollEnabled =NO;
        [self addSubview:_tableView];

        
        
    }
    return self;
}
-(void)dismissalertview{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(makeDismiss)]) {
        [self.delegate makeDismiss];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"银行卡转入";
        if([self.str3 length]>0){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.str3];
        }
        
       cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"体验金转入";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"体验金剩余%@",self.str2];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    } else {
        cell.textLabel.text = @"账户余额转入";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"剩余%@", self.str1];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(gotoAction:)]) {
        [self.delegate gotoAction:(int)indexPath.row];
    
    }
   
}

@end
