//
//  DDMassageViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2016/10/27.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDMassageViewController.h"
#import "DDMessageCell.h"
#import "DDCollectionReusableView.h"
#import "DDFooterReusableView.h"
#import "DDFlowLayout.h"
#import "DDReplyView.h"
#import "DDVRPlayerViewController.h"
#import "DDMoreMassageViewController.h"

@interface DDMassageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    int _page;
}
@property(nonatomic,strong)UICollectionView*collectionView;
@property(nonatomic,strong)NSArray*replyArray;
@property(nonatomic,strong)DDReplyView*reply;
@property(nonatomic,strong)UIView*clearView;
@property(nonatomic,copy)NSString*messageID;
@property(nonatomic,assign)BOOL isMessage;

@end
static NSString*cellID = @"DDMessageCell";
static NSString*headID = @"DDCollectionReusableView";
static NSString*footID = @"DDFooterReusableView";

@implementation DDMassageViewController
- (NSMutableArray*)dataArray{
    if (_dataArray==nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSArray*)replyArray{
    if (_replyArray==nil) {
        _replyArray = [NSArray array];
    }
    return _replyArray;
}
- (DDReplyView*)reply{
    if (_reply==nil) {
        _reply = [[NSBundle mainBundle]loadNibNamed:@"DDReplyView" owner:nil options:nil].lastObject;
        _reply.frame = CGRectMake(0, kMainScreenHeight+40, kMainScreenWidth, 40);
        __weak typeof(self) wSelf = self;
        _reply.myBlock = ^(NSString*messageID){
            [wSelf loadData];
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
- (void)setVideoID:(NSString *)videoID{
    _videoID = videoID;
    [self loadData];
}
- (void)loadMore{
    _page++;
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"video" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_video_reward" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic1 insertObject:self.videoID forKey:@"id" atIndex:0];
    [diyouDic1 insertObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page" atIndex:0];    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        if (isSuccess) {
            NSArray *array  = [DDMessageModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            
            [self.dataArray addObjectsFromArray:array];
            [self.collectionView reloadData];
            [self.collectionView.mj_footer endRefreshing];

        }else{
            [LeafNotification showInController:self withText:errorMessage];
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } fail:^{
         [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];

}
- (void)loadData{
    DYOrderedDictionary * diyouDic1=[[DYOrderedDictionary alloc]init];
    [diyouDic1 insertObject:@"video" forKey:@"module" atIndex:0];
    [diyouDic1 insertObject:@"get_video_reward" forKey:@"q" atIndex:0];
    [diyouDic1 insertObject:@"post" forKey:@"method" atIndex:0];
    
   
    [diyouDic1 insertObject:self.videoID forKey:@"id" atIndex:0];
    [diyouDic1 insertObject:@"1" forKey:@"page" atIndex:0];
    [DDNetWoringTool postJSONWithUrl:nil parameters:diyouDic1 success:^(id object, BOOL isSuccess, NSString *errorMessage) {
        
        if (isSuccess) {
//            NSLog(@"DDMessageModel%@", object);
            _page = 1;
            self.dataArray  = [DDMessageModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
            [self.collectionView reloadData];
            if (_isMessage&&self.dataArray.count>0&&self.messageID) {
                [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    DDMessageModel*m = (DDMessageModel*)obj;
                    if (m.messageID == self.messageID) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
                        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:false];
                    }

                    
                }];
                
            }
            _isMessage = NO;
        }else{
            [LeafNotification showInController:self withText:errorMessage];
        }
    } fail:^{
        
    }];
    

}

- (void)MJ_refresh{
  
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [HeXColor colorWithHexString:@"#666666"];
    
    self.collectionView.mj_footer = footer;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kCOLOR_R_G_B_A(239, 239, 244, 1);
    [self setupCollectionView];
    
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

    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.1
                     animations:^()
     {      self.clearView.alpha = 0;
         self.reply.transform = CGAffineTransformIdentity;
         [self.clearView removeFromSuperview];
         [self.reply removeFromSuperview];
         
     }];

}

- (void)setupCollectionView{
    DDFlowLayout *flowLayout = [[DDFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(kMainScreenWidth, 60);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.footerReferenceSize = CGSizeMake(kMainScreenWidth, 30);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth,
                                                                            kMainScreenHeight / 3 * 2 - 141) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    UINib *cellnib = [UINib nibWithNibName:cellID bundle:nil];
    [self.collectionView registerNib:cellnib forCellWithReuseIdentifier:cellID];
   
    [self.collectionView registerClass:[DDFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footID];
    [self.collectionView registerClass:[DDCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headID];
    
    [self.view addSubview:self.collectionView];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDMessageCell*cell = (DDMessageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    DDMessageModel * mModel = self.dataArray[indexPath.section];
    cell.model = mModel.son_info[indexPath.row];
    
    
    
    if (indexPath.row==0) {
        cell.line.hidden = YES;
    }else{
          cell.line.hidden = false;
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DDMessageModel * mModel = self.dataArray[indexPath.section];
    DDMessageModel*m = mModel.son_info[indexPath.row];
    [self.tabBarController.view addSubview:self.clearView];
    [self.tabBarController.view addSubview:self.reply];
    self.clearView.alpha = 1;
    self.reply.textField.placeholder = [NSString stringWithFormat:@"回复%@：",m.user];
    self.reply.type = ReplyTypeCell;

    self.reply.model = m;
    [self.reply.textField becomeFirstResponder];
}
- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        DDCollectionReusableView * resable = (DDCollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headID forIndexPath:indexPath];
        
        resable.model = self.dataArray[indexPath.section];
        __weak typeof(resable) wResable = resable;
        resable.block = ^(){
            [self.tabBarController.view addSubview:self.clearView];
            [self.tabBarController.view addSubview:self.reply];
            self.clearView.alpha = 1;
            self.reply.type = ReplyTypeSection;
            self.reply.textField.placeholder = [NSString stringWithFormat:@"回复%@：",wResable.model.user];
            self.reply.model = wResable.model;
            [self.reply.textField becomeFirstResponder];
            

            
            
            
            
            
        };
        view = resable;
    }else if(kind == UICollectionElementKindSectionFooter){
        DDFooterReusableView * foot = (DDFooterReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footID forIndexPath:indexPath];
        DDMessageModel *model = self.dataArray[indexPath.section];;
        
        foot.block = ^(){
            DDMoreMassageViewController *moreVC = [[DDMoreMassageViewController alloc] init];
            moreVC.rootId = model.messageID;
            moreVC.model = model;
            [self.navigationController pushViewController:moreVC animated:YES];
        };
        view = foot;
    }
    return view;
    
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    DDMessageModel *sectionModel = self.dataArray[section];
    
    return sectionModel.son_info.count>2?2:sectionModel.son_info.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDMessageModel *model = self.dataArray[indexPath.section];
    DDMessageModel*mm = model.son_info[indexPath.row];
    CGSize sizeForFirstLabel = [mm.message boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-34-53, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    return CGSizeMake(kMainScreenWidth, sizeForFirstLabel.height+16+17+10);
    
    
    
    return  UICollectionViewFlowLayoutAutomaticSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    DDMessageModel *sectionModel = self.dataArray[section];
    if  (sectionModel.son_info.count>2){
        return CGSizeMake(kMainScreenWidth, 30);
    }
    return CGSizeZero;
    

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    DDMessageModel *model = self.dataArray[section];
     CGSize sizeForFirstLabel = [model.message boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-34-35-8-10, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    return CGSizeMake(kMainScreenWidth, sizeForFirstLabel.height+10+21+8+10);
}

@end
