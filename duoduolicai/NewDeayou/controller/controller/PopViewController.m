//
//  PopViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/22.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableVIew;
    NSArray *_dataArray;
    NSArray *_arr1;
    NSArray *_arr2;
    
    
    
}

@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _arr1 = @[@"全部",@"热售中",@"还款中",@"已还完"];
//    _arr2 = @[@"right_menu_QR",@"right_menu_addFri",@"right_menu_multichat",@"right_menu_sendFile",@"right_menu_facetoface",@"right_menu_payMoney"];
    
    
    
    _tableVIew = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableVIew.delegate = self;
    _tableVIew.dataSource = self;
    _tableVIew.scrollEnabled = YES;
    _tableVIew.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableVIew];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr1.count;
    
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.textLabel.text = _arr1[indexPath.row];
    
//    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_arr2[indexPath.row]]];
    
    return cell;
    
    
}


//重置本控制器的大小
-(CGSize)preferredContentSize{
    
    if (self.popoverPresentationController != nil) {
        CGSize tempSize ;
        tempSize.height = self.view.frame.size.height;
        tempSize.width  = 160;
        CGSize size = [_tableVIew sizeThatFits:tempSize];  //返回一个完美适应tableView的大小的 size
        return size;
    }else{
        return [super preferredContentSize];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
