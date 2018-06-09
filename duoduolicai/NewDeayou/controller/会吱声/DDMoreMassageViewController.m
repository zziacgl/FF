//
//  DDMoreMassageViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/11/3.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMoreMassageViewController.h"
#import "DDMoreMassageHeaderView.h"
#import "DDMoreMassageTableViewCell.h"
#import "DDMoreMassageModel.h"
#import "DDReplyView.h"
@interface DDMoreMassageViewController ()<UITableViewDelegate, UITableViewDataSource>
{
     int _page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,strong)DDReplyView*reply;
@property(nonatomic,strong)UIView*clearView;
@property(nonatomic,copy)NSString*messageID;
@property(nonatomic,assign)BOOL isMessage;
@end
static NSString *identifier = @"DDMoreMassageTableViewCell";
@implementation DDMoreMassageViewController
- (DDReplyView*)reply{
    if (_reply==nil) {
        _reply = [[NSBundle mainBundle]loadNibNamed:@"DDReplyView" owner:nil options:nil].lastObject;
        _reply.frame = CGRectMake(0, kMainScreenHeight+40, kMainScreenWidth, 40);
        __weak typeof(self) wSelf = self;
        _reply.myBlock = ^(NSString*messageID){
            [wSelf getData];
            wSelf.messageID = messageID;
            _isMessage = YES;
        };
        
    }
    return _reply;
}
- (UIView*)clearView{
    if (_clearView == nil) {
        _clearView = [[UIView alloc]initWithFrame:self.tabBarController.view.bounds];
        _clearView.alpha = 0;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [_clearView addGestureRecognizer:tap];
        _clearView.backgroundColor = [UIColor clearColor];
        
    }
    return _clearView;
}
- (void)tap{
    [self.reply.textField resignFirstResponder];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, kMainScreenWidth, kMainScreenHeight-64-15) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
    [self.view addSubview:self.tableView];

    [self getData];
    [self MJ_refresh];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    

   
    // Do any additional setup after loading the view.
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.reply.transform = CGAffineTransformMakeTranslation(0, -height-self.reply.frame.size.height-40);
        
    }];
    
    
    
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    [UIView animateWithDuration:0.1
                     animations:^()
     {      self.clearView.alpha = 0;
         self.reply.transform = CGAffineTransformIdentity;
         [self.clearView removeFromSuperview];
         [self.reply removeFromSuperview];
         
     }];
    
}


- (void)MJ_refresh{
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [HeXColor colorWithHexString:@"#666666"];
    
    self.tableView.mj_footer = footer;
    
}

- (NSMutableArray*)dataArray{
    if (_dataArray==nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)getData {
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"video" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_all_reply" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
    
    [diyouDic1 insertObject:self.rootId forKey:@"root_id" atIndex:0];
    [diyouDic1 insertObject:@"1" forKey:@"page" atIndex:0];
    [diyouDic1 insertObject:@"10" forKey:@"epage" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess) {
            
            _page = 1;
            self.dataArray = [DDMessageModel mj_objectArrayWithKeyValuesArray:object[@"son_info"][@"list"]];
//            NSLog(@"%@", object);
            [self.tableView reloadData];
            
            
        }else{
            [LeafNotification showInController:self withText:errorMessage];
            
            
        }
        
        
        
    } fail:^{
        
        
    }];

}
- (void)loadMore {
    _page++;
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"video" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_all_reply" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
    
    [diyouDic1 insertObject:self.rootId forKey:@"root_id" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d", _page] forKey:@"page" atIndex:0];
    [diyouDic1 insertObject:@"10" forKey:@"epage" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess) {
            NSArray *ary = [DDMoreMassageModel mj_objectArrayWithKeyValuesArray:object[@"son_info"][@"list"]];
            
            [self.dataArray addObjectsFromArray:ary];
//            NSLog(@"%@", object);
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            
            
        }else{
            [LeafNotification showInController:self withText:errorMessage];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        
        
        
    } fail:^{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDMoreMassageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    DDMoreMassageModel *moreModel = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = moreModel;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 80;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        DDMoreMassageHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"DDMoreMassageHeaderView" owner:nil options:nil].lastObject;
        headerView.model = self.model;
        headerView.block = ^(){
        [self.tabBarController.view addSubview:self.clearView];
        [self.tabBarController.view addSubview:self.reply];
        self.clearView.alpha = 1;
        self.reply.type = ReplyTypeSection;
        self.reply.textField.placeholder = [NSString stringWithFormat:@"回复%@：",self.model.user];
//        NSLog(@"%@",[NSString stringWithFormat:@"回复%@：",self.model.user]);
        self.reply.model = self.model;
        [self.reply.textField becomeFirstResponder];
        

    };
    
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DDMessageModel*m = self.dataArray[indexPath.row];
    [self.tabBarController.view addSubview:self.clearView];
    [self.tabBarController.view addSubview:self.reply];
    self.clearView.alpha = 1;
    self.reply.textField.placeholder = [NSString stringWithFormat:@"回复%@：",m.user];
    self.reply.type = ReplyTypeCell;
    
    self.reply.model = m;
    [self.reply.textField becomeFirstResponder];

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
