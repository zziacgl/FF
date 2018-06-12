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
@property(nonatomic,strong)NSMutableArray *resultArray;
@property(nonatomic,strong)NSMutableArray *requltIndexData;



@end

@implementation AddGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackColor;

    [self setOutNavView];
    [self setUpTableView];
    self.rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame=CGRectMake(0, 0, 20, 20);
//    self.rightButton.backgroundColor = [UIColor whiteColor];
    [self.rightButton setImage:[UIImage imageNamed:@"addgoods"] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(handleAddGoods) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSArray *myArray = [[NSArray alloc] initWithArray:[userDefaultes arrayForKey:@"myArray"]];
    self.dataAry = [NSMutableArray array];
    self.dataAry = [myArray mutableCopy];
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"shellBack"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSMutableArray *)resultArray{
    
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}
- (void)handleAddGoods {
    kbackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    kbackView.backgroundColor = [UIColor blackColor];
    kbackView.alpha = 0.5;

    [self.tabBarController.view addSubview:kbackView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.tabBarController.view addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchviewTapped:)];
    tap.cancelsTouchesInView = NO;
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
    

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:self.addView.GoodsNameTF.text forKey:@"goodsName"];
    [dic setValue:self.addView.GoodsMoneyTF.text forKey:@"goodsMoney"];
    [self.dataAry insertObject:dic atIndex:0];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.dataAry forKey:@"myArray"];

    
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
    return _searchActive ? _resultArray.count : _dataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellAccessoryNone;
//    AddGoodsModel *model = self.dataAry[indexPath.row];
//    self.dataAry = [NSMutableArray arrayWithContentsOfFile:@"adddata"];
//    cell.textLabel.text = model.goodsName;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];

    NSArray *myArray = [[NSArray alloc] initWithArray:[userDefaultes arrayForKey:@"myArray"]];
    self.dataAry = [myArray mutableCopy];
    cell.textLabel.text = _searchActive ? [self.resultArray[indexPath.row] objectForKey:@"goodsName"]:[self.dataAry[indexPath.row] objectForKey:@"goodsName"];
    return cell;
}
#pragma mark -- searchDelegate
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        _searchActive = NO;
        [self.tableView reloadData];
        return;
    }
    _searchActive = YES;
    [self.resultArray removeAllObjects];
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        if (searchText!=nil && searchText.length>0) {
            
            for (NSDictionary *dic in self.dataAry) {
                
                NSString *tempStr = [dic objectForKey:@"goodsName"];
                
                NSString *pinyin = [self transformToPinyin:tempStr];
                NSLog(@"pinyin--%@",pinyin);
                
                if ([pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
                    [self.resultArray addObject:dic];
                    
                }
            }
        }else{
            self.resultArray = [NSMutableArray arrayWithArray:self.dataAry];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    
  
   
    
  
   
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
//    [self.addView.GoodsNameTF resignFirstResponder];
//    [self.addView.GoodsMoneyTF resignFirstResponder];
}
-(void)searchviewTapped:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    
    [self.tabBarController.view endEditing:YES];
    
}
- (NSString *)transformToPinyin:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++)
    {
        
        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];//区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
            
        }
        [allString appendString:@","];
        count ++;
        
    }
    
    NSMutableString *initialStr = [NSMutableString new];//拼音首字母
    
    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {
            
            [initialStr appendString:  [s substringToIndex:1]];
        }
    }
    
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",aString];
    
    return allString;
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
