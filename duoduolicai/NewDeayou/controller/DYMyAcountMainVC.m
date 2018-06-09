//
//  DYMyAcountMainVC.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/8/20.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYMyAcountMainVC.h"
#import "DYAuthenticationTableViewCell.h"
#import "DYMoreFootView.h"
#import "DYBankInfoViewController.h"
#import "DYUpdateLoginPwdViewController.h"
#import "DYMainTabBarController.h"
//#import "DDPayPasswordViewController.h"
#import "DDMidTableViewCell.h"
#import "DDTopImageSetViewController.h"
#import "DDGenderViewController.h"
#import "DDNickNameSetViewController.h"
#import "PullingRefreshTableView.h"
#import "LeafNotification.h"
#import "DDChangePhoneViewController.h"
#import "QiniuSDK.h"
#import "QiniuPutPolicy.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SJAvatarBrowser.h"
//#import <CustomAlertView.h>
#import "ActivityDetailViewController.h"
#import "SCSecureHelper.h"
//#import <SVProgressHUD.h>
#import "SCGestureSetController.h"
#import "SZKCleanCache.h"
#import "DYSafeViewController.h"
#import "DDSecurityViewController.h"
#import "DDInformManageViewController.h"

#define kDocumentsPath                      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]
/**
 *  注册七牛获取
 */
static NSString *QiniuAccessKey        = @"dfxubn8QUaekhB4CYBeep4WtR6Wi-1I1uaQBuaLv";
static NSString *QiniuSecretKey        = @"RZOMP4J7M1a57a0MpKf02ZGwPfOvUiFW_-ux_JJz";
static NSString *QiniuBucketName       = @"";
static NSString *QiniuBaseURL          = @"";


@interface DYMyAcountMainVC ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UINib *nibHead;//复用cell的nib
    UINib *nibMidden;
    UINib *nibMidden2;
    UINib *nibMidden3;//更换头像
    UINib *nibBaic;
    
    NSArray *aryCellData;//标记cell的个数和高度
    BOOL isViewDidLoad;//标记第一次刷新
    
    
    int mark;
    int i;
    NSString *phoneStatus;//1认证，非1没有认证
    NSString *nameStatus;
    NSString *loginPwdStatus;
    
    NSString *phone;
    UIView *backView;
    UIView *tanView;
    UIButton *backBtn;
}

@property(nonatomic,strong) UITableView *tableView;     //tableview
@property(nonatomic,strong) NSArray     *imageArray;    //图标的数组
@property(nonatomic,strong) NSArray     *titleArray;    //标题的数组
@property(nonatomic,strong) NSArray     *typeArray;     //类型的数组
@property (weak, nonatomic) IBOutlet UIView *HeadView; //上部

@property(nonatomic, strong) UIImageView *img;
@property(nonatomic, strong) NSData *fileData;
@property (nonatomic, strong) NSDictionary *myDic;
@property (nonatomic, strong) NSString *qiniuToken;


@property (nonatomic, strong) UIImage *myimgage;
@property (nonatomic,strong) UIImageView *myimageView;
@property (nonatomic, strong) UIImage *bigImage;
@property (nonatomic, copy) NSString *myerror;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic) float cache;
@end
static int mycard;
@implementation DYMyAcountMainVC

#pragma mark - QINIU Method
- (NSString *)tokenWithScope:(NSString *)scope
{
    QiniuPutPolicy *policy = [QiniuPutPolicy new];
    policy.scope = scope;
    return [policy makeToken:QiniuAccessKey secretKey:QiniuSecretKey];
    
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"安全设置";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewDidAfterLoad];//视图在加载完之后出现
    self.view.backgroundColor = kBackColor;
}
-(void)loadView{
    [super loadView];
    i = 1;
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    
    _payPwdStatus=[NSString stringWithFormat:@"%@",[ud objectForKey:@"paypassword_status"]];
    phoneStatus=[NSString stringWithFormat:@"%@",[ud objectForKey:@"phone_status"]];
    nameStatus=[NSString stringWithFormat:@"%@",[ud objectForKey:@"realname_status"]];
    
    if ([phoneStatus isEqualToString:@"1"]) {
        phone=[NSString stringWithFormat:@"%@",[ud objectForKey:@"phone"]];
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    //        NSLog(@"%f", [UIScreen mainScreen].bounds.size.height);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=kBackColor;
    _tableView.showsVerticalScrollIndicator = false;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
  
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 70)];
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(0, 10, kMainScreenWidth, 50);
    exitBtn.backgroundColor = [UIColor whiteColor];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [exitBtn addTarget:self action:@selector(exit:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:exitBtn];
    self.tableView.tableFooterView = footView;
    
    
    
    [self.view addSubview:_tableView];
    
    //设置cell的个数和高度
    aryCellData=@[@"120",@"134",@"297"/*,@"44"*/,@"60"/*,@"44"*/];
    self.imageArray=@[@[@""],@[@""],@[@""]/*,@[@"我的账户-账户信息 (2).png"]*/,@[@"我的账户-银行卡信息 (2).png"]/*,@[@"我的账户-站内信息 (2).png"]*/];
    self.titleArray=@[@[@""],@[@""],@[@""]/*,@[@"账号信息"]*/,@[@"银行卡信息"]/*,@[@"站内信息"]*/];
    
    
    mycard = 0;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)exit:(id)sender
{
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"确定退出登录？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alertView.delegate = self;
    alertView.tag=404;
    [alertView show];
}

- (void)getdata {
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"get_qiniu_token" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"upload" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:@"avatar" forKey:@"token_type" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    //    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (success==YES) {
             
             NSLog(@"aaaaaaa%@",object);
             self.myDic = object;
             
             self.qiniuToken = [self.myDic objectForKey:@"token"];
             QiniuBaseURL = [self.myDic objectForKey:@"base_url"];
             QiniuBucketName = [self.myDic objectForKey:@"bucket"];
             
             i ++;
         }
         else
         {
             self.myerror = error;
             
             
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    mark = 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView datasource
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 470;//cell的高度
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *markReuse = @"markMidden";
    if (!nibMidden3) {
        nibMidden3 = [UINib nibWithNibName:@"DDMidTableViewCell" bundle:nil];
        [tableView registerNib:nibMidden3 forCellReuseIdentifier:markReuse];
    }
    DDMidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markReuse];
    cell.tag = 200;
    cell.model = self.model;
    NSLog(@"支付密码first%@", self.model.pay_password_status);

    [cell.TopImageSetBnt addTarget:self action:@selector(updateTopImage) forControlEvents:UIControlEventTouchDown];
    [cell.NickNameSetBnt addTarget:self action:@selector(updateNickName) forControlEvents:UIControlEventTouchDown];
   
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}
-(void)gotoSetting{
    DDInformManageViewController *informVC = [[DDInformManageViewController alloc] init];
    informVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:informVC animated:YES];
}

//风险评测
- (IBAction)handleRisk:(UIButton *)sender {
    //    DYSafeViewController *safeVC = [[DYSafeViewController alloc] init];
    //    safeVC.hidesBottomBarWhenPushed = YES;
    NSString *loginKey = [DYUser GetLoginKey];
    //    NSLog(@"login_key%@", loginKey);
    NSString *url = [NSString stringWithFormat:@"%@/activity/mobile/risk_assess/home.html?login_key=%@",pcURL,loginKey];
    //    NSLog(@"%@",url);
    //    safeVC.weburl = url;
    //    safeVC.title = @"风险评测";
    //    [self.navigationController pushViewController:safeVC animated:YES];
    
    
    ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
    adVC.myUrls = @{@"url":url};
    adVC.titleM =@"风险评测";
    adVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:adVC animated:YES];
}

#pragma mark - UIAlertViewDelegate
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==404){
        if (buttonIndex==1)
        {
           
            //注销登录
            [DYUser loginCancelLogin];
        }
        
    }else if(alertView.tag==110){
        if (buttonIndex==1) {
            
            NSString *url=[NSString stringWithFormat:@"%@?service_name=unbind_bankcard&login_key=%@",pcURL_XW,[DYUser GetLoginKey]];
            //        NSLog(@"%@",url);
            ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc] init];
            adVC.hidesBottomBarWhenPushed = YES;
            adVC.myUrls = @{@"url":url};
            adVC.titleM =@"解绑银行卡";
            [self.navigationController pushViewController:adVC animated:YES];
            
        }
        
    }
    
    
}
//查看头像
- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    [SJAvatarBrowser showImage:(UIImageView*)tap.view];
    
}

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)xiaoshi {
    [backView removeFromSuperview];
    [tanView removeFromSuperview];
    [backBtn removeFromSuperview];
    
    
    
}
-(void)updateGender{
    //修改性别
    if (!self.isBank) {
        DDGenderViewController * setGenderVC=[[DDGenderViewController alloc]initWithNibName:@"DDGenderViewController" bundle:nil];
        
        [self.navigationController pushViewController:setGenderVC animated:YES];
        
    }else {
        [LeafNotification showInController:self withText:@"已实名认证，无法修改性别"];
    }
    
}
-(void)updateNickName{
    //修改昵称
    DDNickNameSetViewController * setNickNameVC=[[DDNickNameSetViewController alloc]initWithNibName:@"DDNickNameSetViewController" bundle:nil];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *nickname=[NSString stringWithFormat:@"%@",[ud objectForKey:@"niname"]];
    if (![nickname isEqualToString:@""]) {
        setNickNameVC.niname=[NSString stringWithFormat:@"      %@",nickname];
    }
    
    [self.navigationController pushViewController:setNickNameVC animated:YES];
}
-(void)updateTopImage{
    [self getdata];
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"本地相簿",nil];
    [actionSheet showInView:self.view];
    
    
}
#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://照相机
        {
            if (self.myerror) {
                [LeafNotification showInController:self withText:self.myerror];
                return;
            }
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
            {
                NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-相机“选项中，允许%@访问你的手机相机",NSLocalizedString(@"丰丰金融",@"GMChatDemo")];
                [LeafNotification showInController:self withText:tips];
                //无权限  @"请在iPhone的”设置-隐私-相机“选项中，允许%@访问你的手机相机"
                return;
            }
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            //        case 1://默认头像
            //        {
            //            DDTopImageSetViewController * setTopImageVC=[[DDTopImageSetViewController alloc]initWithNibName:@"DDTopImageSetViewController" bundle:nil];
            //
            //            [self.navigationController pushViewController:setTopImageVC animated:YES];
            //
            //        }
            //            break;
        case 1://本地相簿
        {
            if (self.myerror) {
                [LeafNotification showInController:self withText:self.myerror];
                return;
            }
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
                //无权限
                NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-照片“选项中，允许%@访问你的手机照片",NSLocalizedString(@"丰丰金融",@"GMChatDemo")];
                [LeafNotification showInController:self withText:tips];
                return;
            }
            
            self.imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.delegate = self;
            _imagePicker.allowsEditing = YES;
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }
            break;
            //        case 3://本地视频
            //        {
            //            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            //            imagePicker.delegate = self;
            //            imagePicker.allowsEditing = YES;
            //            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //            //            [self presentModalViewController:imagePicker animated:YES];
            //            [self presentViewController:imagePicker animated:YES completion:nil];
            //        }
            //            break;
        default:
            break;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    
    if (navigationController == _imagePicker) {
        UIButton *cusbtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,30)];
        [cusbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cusbtn setTitle:@"Cancel" forState:(UIControlStateNormal)];
        
        //        cusbtn.backgroundColor = [UIColor redColor];
        
        [cusbtn addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchUpInside)];
        
//        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:cusbtn];
        
//        [viewController.navigationItem setRightBarButtonItem:btn animated:NO];
//        CGSize btnImageSize = CGSizeMake(22, 22);
//        UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
//
//        [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
//        [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
//        [btnLeft addTarget:self action:@selector(gobackimagePicker) forControlEvents:UIControlEventTouchUpInside];
//        viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
        
        
    }
    
    
}

//第二:实现click方法即可完成;self.imagePicker为弱引用


- (void)gobackimagePicker {
    [self imagePickerControllerDidCancel:self.imagePicker];
}
- (void)click {
    
    [self imagePickerControllerDidCancel:self.imagePicker];
    
}
#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *originImage = [info valueForKey:UIImagePickerControllerEditedImage];
    self.myimageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect: self.myimageView.bounds];
    UIBezierPath *clearPath = [[UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(self.myimageView.frame) + 2.0f, CGRectGetMinY(self.myimageView.frame) + 2.0f, CGRectGetWidth(self.myimageView.frame) - 2 * 2.0f, CGRectGetHeight(self.myimageView.frame) - 2 * 2.0f)] bezierPathByReversingPath];
    [path appendPath: clearPath];
    
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.myimageView.layer.mask;
    if(!shapeLayer) {
        shapeLayer = [CAShapeLayer layer];
        [self.myimageView.layer setMask: shapeLayer];
    }
    shapeLayer.path = path.CGPath;
    
    
    
    
    CGSize cropSize;
    cropSize.width = 88;
    cropSize.height = cropSize.width * originImage.size.height / originImage.size.width;
    
    //    NSDate *date = [NSDate date];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSData *imageData = UIImageJPEGRepresentation(originImage, 0.9f);
    
    //     NSString *uniqueName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:date]];
    NSString *uniqueName = [NSString stringWithFormat:@"%@",[self.myDic objectForKey:@"key"]];
    
    NSString *uniquePath = [kDocumentsPath stringByAppendingPathComponent:uniqueName];
    
    //    NSLog(@"uniquePath: %@",uniquePath);
    
    self.myimgage=[UIImage imageWithData:imageData];
    
    [imageData writeToFile:uniquePath atomically:NO];
    [MBProgressHUD hudWithView:self.view label:@"上传中"];

    [picker dismissViewControllerAnimated:YES completion:^{
        
        NSString *token = [self tokenWithScope:QiniuBucketName];
        NSLog(@"111111111%@", token);
        //        NSLog(@"22222222%@", self.qiniuToken);
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        NSData *data = [NSData dataWithContentsOfFile:uniquePath];
        
        NSString *key = [NSURL fileURLWithPath:uniquePath].lastPathComponent;
        
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                                                   progressHandler:^(NSString *key, float percent){
                                                       
                                                   }
                                                            params:@{ @"x:foo":@"fooval" }
                                                          checkCrc:YES
                                                cancellationSignal:nil];
        
        
        [upManager putData:data key:key token:_qiniuToken
         
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      if (!info.error) {
                          
                          
                          NSString *contentURL = [NSString stringWithFormat:@"http://%@/%@",QiniuBaseURL,key];
                          
                          NSLog(@"QN Upload Success URL= %@",contentURL);
                          
                          DDMidTableViewCell *cell = [self.view viewWithTag:200];
                          cell.topImageView.image = self.myimgage;
//                        [cell.topImageView sd_setImageWithURL:[NSURL URLWithString:contentURL]];
                          //     self.bigImage = self.myimgage;
                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                          [MBProgressHUD checkHudWithView:self.view label:@"上传成功" hidesAfter:1];

                      }
                      else {
                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                          [MBProgressHUD checkHudWithView:self.view label:@"上传成功" hidesAfter:1];

                          //                          NSLog(@"%@",info.error);
                      }
                  } option:opt];
    }];
    
    
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    //    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    //    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //    [userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    //    self.img.image = selfPhoto;
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

//修改手机号
- (void)handleChangePhone {
    DDChangePhoneViewController * changeVC=[[DDChangePhoneViewController alloc]initWithNibName:@"DDChangePhoneViewController" bundle:nil];
    changeVC.hidesBottomBarWhenPushed=YES;
    changeVC.phone=phone;
    
    [self.navigationController pushViewController:changeVC animated:YES];
    
}


-(void)gotoSecurityManager{
    //去密码管理
    
    DDSecurityViewController *SecurityManager = [[DDSecurityViewController alloc] init];
    SecurityManager.hidesBottomBarWhenPushed = YES;
    SecurityManager.isBank=self.isBank;
    [self.navigationController pushViewController:SecurityManager animated:YES];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
