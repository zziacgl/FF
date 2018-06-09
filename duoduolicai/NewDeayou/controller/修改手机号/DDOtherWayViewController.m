//
//  DDOtherWayViewController.m
//  NewDeayou
//
//  Created by 陈高磊 on 2017/2/9.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDOtherWayViewController.h"
#import "DDotherWayHeaderView.h"
#import "AFNetworking.h"
#import "DDMakeSurePhoneViewController.h"

#define kPhoneNumber         kefu_phone_title
#define CUSTOMER_SERVICE_PHONE [NSURL URLWithString:kefu_phone]


@interface DDOtherWayViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    DDotherWayHeaderView *headerView;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImage *firstImage;
@property (nonatomic, strong) UIImage *secondImage;
@property (nonatomic, strong) UIImage *thirdImage;

@end
static int count;
static BOOL first;
static BOOL second;
static BOOL third;
@implementation DDOtherWayViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号码";
    first = NO;
    second = NO;
    third = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    //导航右边的按钮
    UIButton * btnRightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRightItem.backgroundColor = [UIColor clearColor];
    btnRightItem.frame = CGRectMake(0, 0, 30, 30);
    btnRightItem.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [btnRightItem setTitle:@"提现记录" forState:UIControlStateNormal];
    [btnRightItem setImage:[UIImage imageNamed:@"shouji_"] forState:UIControlStateNormal];
    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRightItem addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnRightItem];
    

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth , kMainScreenHeight) style:UITableViewStylePlain];
//    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = false;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    headerView = [[NSBundle mainBundle]loadNibNamed:@"DDotherWayHeaderView" owner:nil options:nil].lastObject;
    headerView.height = 640;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseFirstPicture:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseFirstPicture:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseFirstPicture:)];
    headerView.firstImage.userInteractionEnabled = YES;
    headerView.secondImage.userInteractionEnabled = YES;
    headerView.thirdImage.userInteractionEnabled = YES;
    [headerView.nextBtn addTarget:self action:@selector(handleNext:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.firstImage addGestureRecognizer:tap1];
    [headerView.secondImage addGestureRecognizer:tap2];
    [headerView.thirdImage addGestureRecognizer:tap3];

    self.tableView.tableHeaderView = headerView;
    // Do any additional setup after loading the view from its nib.
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark -- 拨打电话
- (void)callPhone {
    if ( [[UIApplication sharedApplication]canOpenURL:CUSTOMER_SERVICE_PHONE])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"即将呼叫丰丰金融客服" message:kPhoneNumber delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        
        [alertView show];
    }
    else
    {
        [LeafNotification showInController:self withText:@"设备不支持打电话"];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication]openURL:CUSTOMER_SERVICE_PHONE];
    }
}


- (void)choseFirstPicture:(UITapGestureRecognizer *)sender {
//    NSLog(@"相册%ld", sender.view.tag);
    switch (sender.view.tag) {
        case 201:
            count = 1;
            break;
            
        case 202:
            count = 2;
            break;
        case 203:
            count = 3;
            break;
        default:
            break;
    }
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
//    UIImage *originImage=[self scaleFromImage:[info valueForKey:UIImagePickerControllerEditedImage] toSize:CGSizeMake(120.0f, 120.0f)];//将图片尺寸
    UIImage *originImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    NSData *imageData = UIImageJPEGRepresentation(originImage, 0.9f);
    switch (count) {
        case 1:
            headerView.firstImage.image = [UIImage imageWithData:imageData];
            self.firstImage = originImage;
            headerView.firstBtn.hidden = NO;
            [headerView.firstBtn addTarget:self action:@selector(handleFirst) forControlEvents:UIControlEventTouchUpInside];
            first = YES;
            break;
        case 2:
            headerView.secondImage.image = [UIImage imageWithData:imageData];
            self.secondImage = originImage;
            headerView.secondBtn.hidden = NO;
            [headerView.secondBtn addTarget:self action:@selector(handleSecond) forControlEvents:UIControlEventTouchUpInside];
            second = YES;
            break;
        case 3:
            
            headerView.thirdImage.image = [UIImage imageWithData:imageData];
            self.thirdImage = originImage;
            headerView.thirdBtn.hidden = NO;
            [headerView.thirdBtn addTarget:self action:@selector(handleThird) forControlEvents:UIControlEventTouchUpInside];
            third = YES;
            break;
        default:
            break;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
    
}
- (void)handleFirst {
    headerView.firstImage.image = [UIImage imageNamed:@"上传证件_03"];
    headerView.firstBtn.hidden = YES;
    first = NO;
}

- (void)handleSecond {
    headerView.secondImage.image = [UIImage imageNamed:@"上传证件_03"];
    headerView.secondBtn.hidden = YES;
    second = NO;
}
- (void)handleThird {
    headerView.thirdImage.image = [UIImage imageNamed:@"上传证件_03"];
    headerView.thirdBtn.hidden = YES;
    third = NO;
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
//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
- (void)handleNext:(UIButton *)sender {
    if (first && second && third) {
        [MBProgressHUD hudWithView:self.view label:@"正在上传，请稍后..."];
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        [securityPolicy setAllowInvalidCertificates:YES];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        [manager setSecurityPolicy:securityPolicy];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        sender.userInteractionEnabled = NO;
        NSString *url = [NSString stringWithFormat:@"%@/?action&m=users&q=up_phone", ffwebURL];
        [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSLog(@"你好%@", manager);
            NSData *fileData = [self.oldPhoneNumber dataUsingEncoding:NSUTF8StringEncoding];
            NSData *fileData1 = UIImageJPEGRepresentation(self.firstImage, 1.0);
            NSData *fileData2 = UIImageJPEGRepresentation(self.secondImage, 1.0);
            NSData *fileData3 = UIImageJPEGRepresentation(self.thirdImage, 1.0);
            [formData appendPartWithFormData:fileData name:@"phone"];
            [formData appendPartWithFileData:fileData1 name:@"positive" fileName:@"jepg" mimeType:@"image/png"];
            [formData appendPartWithFileData:fileData2 name:@"opposite" fileName:@"jepg" mimeType:@"image/png"];
            [formData appendPartWithFileData:fileData3 name:@"real" fileName:@"jepg" mimeType:@"image/png"];
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            BOOL isSuccess=[[dict objectForKey:@"result"]isEqualToString:@"success"]?YES:NO;
            NSString * errorMessage=[dict objectForKey:@"error_remark"];
//            NSLog(@"%@", dict);
            
            if (isSuccess) {
                 NSLog(@"成功%@", responseObject);
                DDMakeSurePhoneViewController * setNewPwd=[[DDMakeSurePhoneViewController alloc]initWithNibName:@"DDMakeSurePhoneViewController" bundle:nil];
                setNewPwd.hidesBottomBarWhenPushed=YES;
//                setNewPwd.massageStr = code;
                setNewPwd.messageId = [dict objectForKey:@"id"];
                setNewPwd.comeView = @"message";
                setNewPwd.oldPhoneStr = self.oldPhoneNumber;
                [self.navigationController pushViewController:setNewPwd animated:YES];
            }else {
            [LeafNotification showInController:self withText:errorMessage];
            }

             [MBProgressHUD hideHUDForView:self.view animated:YES];
           
            sender.userInteractionEnabled = YES;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"失败%@",error);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

       
    }else {
        [LeafNotification showInController:self withText:@"请上传三张照片"];
    }
    
    
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
