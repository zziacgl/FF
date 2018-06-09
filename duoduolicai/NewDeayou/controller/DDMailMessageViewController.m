//
//  DDMailMessageViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/12/17.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMailMessageViewController.h"
#import "DDMailMessageTableViewCell.h"
#import "PullingRefreshTableView.h"
#import "WJPopoverViewController.h"
#import "DDMessageDetailViewController.h"

@interface DDMailMessageViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    UINib *nibContent;
    int page;
    BOOL canedit;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *changeImage;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic) CGSize size;

@property (nonatomic, strong) UIView *deleteView;

@property (nonatomic, strong) NSMutableDictionary *deleteDict; // 存放需要删除信的信息

@property (nonatomic, assign) BOOL allChoose; // 1 全选 , 0 取消全选
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *alert;
@property (nonatomic, strong) WJPopoverViewController *popView;
@property (nonatomic, strong) UIButton *editBtn;

@end

static int i = 1;


@implementation DDMailMessageViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"消息中心";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    //    self.rightButton = btnRightItem;
    self.rightButton.frame=CGRectMake(0, 0, 40, 20);
    [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:kBtnColor forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightButton addTarget:self action:@selector(handleScreen:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    
    
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editBtn.frame = CGRectMake(0, 0, 40, 20);
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_editBtn setTitleColor:kMainColor forState:UIControlStateNormal];
//    _editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    canedit = YES;
    
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    self.deleteDict = [NSMutableDictionary new];
    self.dataArray = [NSMutableArray new];
}


-(void)loadView{
    [super loadView];
    
    //设置下拉刷新tableview
    _tableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain topTextColor:kMainColor topBackgroundColor:nil bottomTextColor:kMainColor bottomBackgroundColor:nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullingDelegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    
}
- (void)handleScreen:(UIButton *)sender forEvent:(UIEvent *)event{
    [self creatPopViewWithEvent:event];
}
- (void)creatPopViewWithEvent:(UIEvent *)event{
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.frame = CGRectMake(0, 0, 90, 80);
        vc.view.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPopViewFromSuperView)];
        [vc.view addGestureRecognizer:tap];
        NSArray *ary = @[@"全部已读",@"编辑"];
        for (int i = 0; i < 2; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, i * 40, 90, 40);
            [btn setTitle:ary[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            btn.tag = 500 + i;
            [btn addTarget:self action:@selector(handleChose:) forControlEvents:UIControlEventTouchUpInside];
            [vc.view addSubview:btn];
    
        }
    
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 , 90, 1)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            lineView.alpha = 0.5;
            [vc.view addSubview:lineView];
    
    
    
        self.popView.borderWidth = 0;
        self.popView.offSet = -10;
        self.popView = [[WJPopoverViewController alloc] initWithViewController:vc];
        
        [self.popView showPopoverWithBarButtonItemTouch:event animation:YES];

}

#pragma mark --  筛选
- (void)handleChose:(UIButton *)sender {
    [self cancelPopViewFromSuperView];
    NSInteger index = sender.tag - 500;
    switch (index) {
        case 0:
            [self setAll];
            break;
        case 1:
            [self canEdit:self.editBtn];
             self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.editBtn];
            break;
            
        default:
            break;
    }
    
}
- (void)cancelPopViewFromSuperView {
    [WJPopoverViewController dissPopoverViewWithAnimation:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)setAll{
    //将未读标注成已读
    int num=0;
    NSString *ids=@"";
    for (NSDictionary *dic in self.dataArray) {
        int status=[[dic objectForKey:@"status"]intValue];
        if (status==0) {
            if (ids==nil||[ids length]==0) {
                ids=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                num++;
            }else{
                ids=[NSString stringWithFormat:@"%@,%@",ids,[dic objectForKey:@"id"]];
                num++;
            }
        }
    }
    //    NSLog(@"%@",ids);
    if ([ids length]>0) {
        DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
        [diyouDic1 insertObject:@"message" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"read_all" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (success==YES) {
                 
                 [LeafNotification showInController:self withText:@"已全部标注为已读"];
                 
                 NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                 NSString *badge=[NSString stringWithFormat:@"%@",[ud objectForKey:@"badge"]];
                 int ba=[badge intValue];
                 ba=ba-num;
                 
                 [ud setObject:[NSString stringWithFormat:@"%d",ba] forKey:@"badge"];
                 [_tableView launchRefreshing];
                 
                 [self GetBadge];
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }else{
        [LeafNotification showInController:self withText:@"全部都是已读"];
    }
}
-(void)GetBadge{
    
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"message" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_message_receive_list" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic1 insertObject:@"1" forKey:@"page" atIndex:0];
    [diyouDic1 insertObject:@"20" forKey:@"epage" atIndex:0];
    [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
     {
         if (success==YES) {
             //                          NSLog(@"%@",object);
             NSString *badge=[NSString stringWithFormat:@"%@",[object objectForKey:@"message_no"]];
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:badge forKey:@"badge"];
         }
         else
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_tableView launchRefreshing];
}

#pragma mark - deleteViewActions
- (void)allChooseBtnPressed:(UIButton *)btn {
    if (btn.tag == 500) {
        [btn setImage:[UIImage imageNamed:@"站内信_03"] forState:UIControlStateNormal];
        btn.tag = 501;
        self.allChoose = YES;
        for (int i = 0; i < self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            NSDictionary *dic=[self.dataArray objectAtIndex:indexPath.row];
            [self.deleteDict setObject:dic[@"id"] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
//        NSLog(@"当前您选中的站内信数量：%zd",self.deleteDict.count);
    }else if(btn.tag == 501) {
        [btn setImage:[UIImage imageNamed:@"站内信_03_03"] forState:UIControlStateNormal];
        btn.tag = 500;
        self.allChoose = NO;
        for (int i = 0; i < self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        [self.deleteDict removeAllObjects];
//        NSLog(@"当前您选中的站内信数量：%zd",self.deleteDict.count);
    }
}

- (void)deleteBtnPressed:(UIButton *)btn {
    if (!self.deleteDict.count) {
        return;
    }
    DYOrderedDictionary *diyouDic = [[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"message" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"delete_receive" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[self ids] forKey:@"ids" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    
    [DYNetWork operationWithDictionary:diyouDic
                         completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage)
     {
         if (isSuccess) {
//             NSLog(@"成功了");
             [self canEdit:self.rightButton];
             [self.tableView launchRefreshing];
             [self.deleteDict removeAllObjects];
         }else {
//             NSLog(@"失败了");
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }
         
//         NSLog(@"%@",object);
         
     } errorBlock:^(id error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [LeafNotification showInController:self withText:error];
         
     }];
}

- (NSString *)ids {
    __block NSString *string = @"";
    [self.deleteDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            if ([string isEqualToString:@""]) {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%@",obj]];
            }else {
                string = [string stringByAppendingString:[NSString stringWithFormat:@",%@",obj]];
            }
        }
    }];
    return string;
}

#pragma mark - tableView datasource
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
}

/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param textView 待计算的UITextView
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT + 5)];
    return sizeToFit.height;
}

#pragma mark -- tableView Editing
//配置tableView哪些行可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark  -- 编辑状态
- (void)canEdit:(UIButton *)sender {
    if (!self.tableView.editing) {
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        [sender addTarget:self action:@selector(handleCancal) forControlEvents:UIControlEventTouchUpInside];
        self.deleteView = [[UIView alloc] initWithFrame:CGRectMake(0,  kMainScreenHeight - ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height), kMainScreenWidth, 50)];
        _deleteView.backgroundColor = kCOLOR_R_G_B_A(241, 241, 241, 1);
        [self.view addSubview:self.deleteView];
        
        UIButton *allChoseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allChoseBtn.frame = CGRectMake(10, 15, 20, 20);
        allChoseBtn.tag = 500;
        [allChoseBtn setImage:[UIImage imageNamed:@"站内信_03_03"] forState:UIControlStateNormal];
        [allChoseBtn addTarget:self action:@selector(allChooseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteView addSubview:allChoseBtn];
        UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 40, 20)];
        allLabel.text = @"全选";
        allLabel.font = [UIFont systemFontOfSize:15];
        allLabel.textColor = kCOLOR_R_G_B_A(253, 83, 83, 1);
        [self.deleteView addSubview:allLabel];
        

        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(kMainScreenWidth - 60, 15, 40, 20);
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.deleteView addSubview:deleteBtn];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.deleteView.frame = CGRectMake(0, kMainScreenHeight - 50 - ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height), kMainScreenWidth, 50);
        } completion:^(BOOL finished) {
            
        }];
        
    }else {
        [self.deleteDict removeAllObjects];
        [UIView animateWithDuration:0.5 animations:^{
            self.deleteView.frame = CGRectMake(0, kMainScreenHeight - ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height), kMainScreenWidth, 50);
        } completion:^(BOOL finished) {
            [self.deleteView removeFromSuperview];
            
        }];
        
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
        [self.rightButton setImage:[UIImage imageNamed:@"选项-2"] forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(handleScreen:forEvent:) forControlEvents:UIControlEventTouchUpInside];

    }
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
}

- (void)handleCancal {
    [self.deleteDict removeAllObjects];
    [UIView animateWithDuration:0.5 animations:^{
        self.deleteView.frame = CGRectMake(0, kMainScreenHeight - 64, kMainScreenWidth, 50);
    } completion:^(BOOL finished) {
        [self.deleteView removeFromSuperview];
        
    }];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [self.rightButton setImage:[UIImage imageNamed:@"选项-2"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(handleScreen:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *markRuse=@"MailMessageinfo";
    if (!nibContent) {
        nibContent = [UINib nibWithNibName:@"DDMailMessageTableViewCell" bundle:nil];
        [tableView registerNib:nibContent forCellReuseIdentifier:markRuse];
    }
    DDMailMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markRuse];
    
    cell.tag = 200+indexPath.row;
    cell.changeView.tag=200+indexPath.row;
    //    NSLog(@"%ld",(long)cell.tag);
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.photoView.image = [UIImage imageNamed:@"200-200"];
    [cell.photoView.layer setMasksToBounds:YES];
    [cell.photoView.layer setCornerRadius:17.5];
    NSDictionary *dic=[self.dataArray objectAtIndex:indexPath.row];
    cell.Title.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    cell.AddTime.text=@"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    double addtime=0;
    if ([dic objectForKey:@"addtime"]!=nil&&[dic objectForKey:@"addtime"]!=[NSNull null]) {
        addtime=[[dic objectForKey:@"addtime"]doubleValue];
        cell.AddTime.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:addtime]]];
    }
//    cell.Descript.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"contents"]];
//    cell.Descript.lineBreakMode = NSLineBreakByWordWrapping;
//    self.size = [cell.Descript sizeThatFits:CGSizeMake(cell.Descript.frame.size.width, MAXFLOAT)];
//    cell.Descript.frame = CGRectMake(cell.Descript.frame.origin.x, cell.Descript.frame.origin.y, cell.Descript.frame.size.width, _size.height);
    
    self.tableView.rowHeight = 60 + _size.height;
    int status=[[dic objectForKey:@"status"]intValue];
    
    if (status==1) {
        cell.Stuts.alpha = 0;
    }
    if (tableView.editing) {
        if ([self.deleteDict.allKeys containsObject:[NSString stringWithFormat:@"%zd",indexPath.row]]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    DDMailMessageTableViewCell *cell = [self.view viewWithTag:200 + _indexPath.row];
    [self restoreCell:cell complete:^{
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        NSDictionary *dic=[self.dataArray objectAtIndex:indexPath.row];
        [self.deleteDict setObject:dic[@"id"] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//        NSLog(@"当前您选中的站内信数量：%zd",self.deleteDict.count);
    }else {
        DDMessageDetailViewController *detailVC = [[DDMessageDetailViewController alloc] initWithNibName:@"DDMessageDetailViewController" bundle:nil];
        detailVC.dataDic = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
        DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
        [diyouDic1 insertObject:@"message" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"update_view_status" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"id"]] forKey:@"ids" atIndex:0];
        [diyouDic1 insertObject:@"1" forKey:@"status" atIndex:0];
        [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (success==YES) {
//                 [self.tableView reloadData];
               
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        [self.deleteDict removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//        NSLog(@"当前您选中的站内信数量：%zd",self.deleteDict.count);
    }
}

-(void)tableView:(UITableView *)tableView didDeRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    
}

// cell 动画还原
- (void)restoreCell:(DDMailMessageTableViewCell *)cell complete:(void(^)())complete {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        cell.changeView.frame = CGRectMake(0, cell.changeView.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        [UIView animateWithDuration:0.5 animations:^{
            self.changeImage.frame = CGRectMake(-40, cell.frame.size.height / 2 - 20, 40, 40);
        } completion:^(BOOL finished) {
            
        }];
    } completion:^(BOOL finished) {
        
        self.indexPath = nil;
        if (complete) {
            complete();
        }
    }];
    
}

// 当前cell做动画
- (void)startCell:(DDMailMessageTableViewCell *)cell complete:(void(^)())complete {
    if (self.changeImage) [self.changeImage removeFromSuperview];
    
    self.changeImage = [[UIImageView alloc] initWithFrame:CGRectMake(-40, cell.frame.size.height / 2 - 20, 40, 40)];
    self.changeImage.image = [UIImage imageNamed:@"icon_dong_1"];
    self.changeImage.userInteractionEnabled = YES;
    [cell addSubview:self.changeImage];
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleChange) userInfo:nil repeats:YES];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        cell.changeView.frame = CGRectMake(40, cell.changeView.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        
        [UIView animateWithDuration:0.5 animations:^{
            self.changeImage.frame = CGRectMake(0, cell.frame.size.height / 2 - 20, 40, 40);
        } completion:^(BOOL finished) {
//            NSLog(@"完成动画的加载");
            
        }];
        
        UITapGestureRecognizer *movecell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
        
        self.changeImage.tag=cell.changeView.tag;
        [self.changeImage addGestureRecognizer:movecell];
        
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
    
}

- (void)handleChange {
    
    //    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    NSString *str = [NSString stringWithFormat:@"icon_dong_%d", i];
    self.changeImage.image = [UIImage imageNamed:str];
    i++;
    if (i>14) {
        
        i = 1;
    }
    
}

- (void)handleMove:(UITapGestureRecognizer *)tap {
    
    self.changeImage.userInteractionEnabled=NO;
    NSString *ids=@"";
    //    ids=[NSString stringWithFormat:@"%d",(int)tap.view.superview.tag ];
//    NSLog(@"%d", (int)tap.view.tag);
    for (int i = 0; i< self.dataArray.count; i ++ ) {
        if ((int)tap.view.tag == i + 200) {
            NSDictionary *dic=[self.dataArray objectAtIndex:i];
            int myId = [[dic objectForKey:@"id"] intValue];
            ids = [NSString stringWithFormat:@"%d", myId];
            
        }
    }
    
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"message" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"delete_receive" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%@",ids] forKey:@"ids" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         //
         if (success==YES) {
//             NSLog(@"1111%@",object);
             [UIView animateWithDuration:1 animations:^{
                 DDMailMessageTableViewCell *cell=[self.view viewWithTag:tap.view.tag];
                 cell.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
             } completion:^(BOOL finished) {
                 DDMailMessageTableViewCell *cell=[self.view viewWithTag:tap.view.tag];
                 [cell removeFromSuperview];
                 
                 [self.dataArray removeObjectAtIndex:tap.view.tag - 200];
                 [self.tableView reloadData];
//                 NSLog(@"%lu",(unsigned long)self.dataArray.count);
                 [self.changeImage removeFromSuperview];
                 self.indexPath = nil;
                 [self.timer invalidate];
                 self.timer = nil;
                 
             }];
             self.changeImage.userInteractionEnabled=YES;
         }
         else
         {
             self.changeImage.userInteractionEnabled=YES;
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         self.changeImage.userInteractionEnabled=YES;
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
    
    //    }
    
    
    
    
    
}

#pragma mark-－－－-scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.tableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
    
}
#pragma mark - pullingTableViewDelegate

-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    
    [self refreshTableView:@0];
    
}
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    
    [self refreshTableView:@1];
    
}
-(void)refreshTableView:(id)object
{
    [self GetUserInfomation:[object intValue]];
}
//获取数据接口
-(void)GetUserInfomation:(BOOL)isRefreshing
{
    
    //————————————————————————我的主页->实时财务->资金记录——————————————————————————
    
    
    if (isRefreshing)
    {
        page=1;
        DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
        [diyouDic1 insertObject:@"message" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"get_message_receive_list" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic1 insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.headerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             if (success==YES) {
//                 NSLog(@"站内信%@", object);
                 [self.dataArray removeAllObjects];
                 NSArray *arr = [object objectForKey:@"list"];
                 
                 //                 self.dataArray = [object objectForKey:@"list"];
                 if (arr) {
                     [self.dataArray addObjectsFromArray:arr];
                 }
                 if (self.dataArray.count==0) {
                     if (!self.alert) {
                         self.alert=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 44)];
                         _alert.text=@"无站内信";
                         _alert.textAlignment = NSTextAlignmentCenter;
                         [self.view addSubview:self.alert];
                         
                     }
                 }else{
                     [self.alert removeFromSuperview];
                     if (self.tableView.editing && self.allChoose) {
                         for (int i = 0; i< self.dataArray.count; i++) {
                             NSDictionary *dic=[self.dataArray objectAtIndex:i];
                             [self.deleteDict setObject:dic[@"id"] forKey:[NSString stringWithFormat:@"%d",i]];
                         }
                     }
                 }
                 [self.tableView reloadData];
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }else
    {
        page++;
        DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
        [diyouDic1 insertObject:@"message" forKey:@"module" atIndex:0];
        [diyouDic1 insertObject:@"get_message_receive_list" forKey:@"q" atIndex:0];
        [diyouDic1 insertObject:@"get" forKey:@"method" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
        [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
        [diyouDic1 insertObject:@"20" forKey:@"epage" atIndex:0];
        [diyouDic1 insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
        [DYNetWork operationWithDictionary:diyouDic1 completeBlock:^(id object,BOOL success,NSString*error)
         {
             if (_tableView.footerView.isLoading)
             {
                 [_tableView tableViewDidFinishedLoading];
             }
             
             if (success==YES) {
                 //             NSLog(@"%@",object);
                 NSArray * ary=[object objectForKey:@"list"];
                 if (ary.count>0) {
                     for (int i=0; i<ary.count;i++ )
                     {
                         [self.dataArray addObject:ary[i]];
                     }
                     
                     if (self.tableView.editing && self.allChoose) {
                         for (int i = 0; i< self.dataArray.count; i++) {
                             NSDictionary *dic=[self.dataArray objectAtIndex:i];
                             [self.deleteDict setObject:dic[@"id"] forKey:[NSString stringWithFormat:@"%d",i]];
                         }
                     }
                 }else
                 {
                     [LeafNotification showInController:self withText:@"数据加载完了"];
                 }
                 
                 //             NSLog(@"%@",self.dataArray);
                 [self.tableView reloadData];
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [LeafNotification showInController:self withText:error];
             }
             
         } errorBlock:^(id error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [LeafNotification showInController:self withText:@"网络异常"];
         }];
        
    }
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
