//
//  AddGoodsViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "AddGoodsViewController.h"
#import "AddGoodsModel.h"
#import "AddGoosView.h"
@interface AddGoodsViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UIView *kbackView;
    
}
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, assign) BOOL searchActive;
@property (nonatomic, strong) AddGoosView *addView;
@property (nonatomic, strong) NSArray *myData;

@end

@implementation AddGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackColor;
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:_myData forKey:@""];
    [self setOutNavView];
    [self setUpTableView];
    self.rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame=CGRectMake(0, 0, 20, 20);
    self.rightButton.backgroundColor = [UIColor whiteColor];
    [self.rightButton setImage:[UIImage imageNamed:@"choseBtn"] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(handleAddGoods) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    // Do any additional setup after loading the view.
}

- (void)handleAddGoods {
    kbackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    kbackView.backgroundColor = [UIColor blackColor];
    kbackView.alpha = 0.5;

    [self.tabBarController.view addSubview:kbackView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.tabBarController.view addGestureRecognizer:tap1];
    
    self.addView = [[NSBundle mainBundle]loadNibNamed:@"AddGoosView" owner:nil options:nil].lastObject;
    self.addView.frame = CGRectMake(20, 150, kMainScreenWidth - 40, 150);
    self.addView.layer.cornerRadius = 8;
    self.addView.layer.masksToBounds = YES;
    [self.addView.CancelBtn addTarget:self action:@selector(handleCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.addView.SureBtn addTarget:self action:@selector(handleSure) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:self.addView];
    
}

- (void)handleCancel {
    self.addView.alpha = 0;
    [self.addView removeFromSuperview];
    kbackView.alpha = 0;
    [kbackView removeFromSuperview];
    
}
- (void)handleSure {
    self.dataAry = [NSMutableArray array];
    AddGoodsModel *model = [[AddGoodsModel alloc] init];
    if (self.addView.GoodsMoneyTF.text.length > 0 && self.addView.GoodsNameTF.text.length > 0) {
        model.goodsName = self.addView.GoodsNameTF.text;
        model.goodsMoney = self.addView.GoodsMoneyTF.text;
    }
    [self.dataAry addObject:model];
    [self.tableView reloadData];
    [self handleCancel];
    
}
- (void)setOutNavView {
    
     UIView*titleView = [[UIView alloc]initWithFrame:CGRectMake(0,0,kMainScreenWidth - 100,30)];
    self.navigationItem.titleView = titleView;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 100, 30)];
    self.searchBar.placeholder = @"输入要搜索的内容";
     self.searchBar.layer.cornerRadius = 15;
    self.searchBar.layer.masksToBounds = YES;
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.showsCancelButton=NO;
    self.searchBar.barStyle=UIBarStyleDefault;
    self.searchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    self.searchBar.delegate=self;
      self.searchBar.showsSearchResultsButton=NO;
    [titleView addSubview:self.searchBar];
    
   
}
- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:self.tableView];


}
#pragma mark -- tableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    AddGoodsModel *model = self.dataAry[indexPath.row];
    cell.textLabel.text = model.goodsName;
    return cell;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
    [self.addView.GoodsNameTF resignFirstResponder];
    [self.addView.GoodsMoneyTF resignFirstResponder];
}
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    
    [self.tabBarController.view endEditing:YES];
    
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
