//
//  DYFeedbackViewController.m
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/13.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYFeedbackViewController.h"
#import "DYPlaceholderTextView.h"
#import "DDServiceCenterViewController.h"



@interface DYFeedbackViewController ()
@property (nonatomic,strong) DYPlaceholderTextView *textView;
@property (nonatomic,strong) UIButton              *sendButton;

@end

@implementation DYFeedbackViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"意见反馈";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewDidAfterLoad];
    CGSize btnImageSize = CGSizeMake(22, 22);
    UIButton * btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_bar_normal"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0, 0, btnImageSize.width, btnImageSize.height);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView = [[DYPlaceholderTextView alloc]initWithFrame:CGRectMake(10, 10, kScreenSize.width-20, 100)];

    self.textView.placeholder = @"丰丰金融听您的!                                                                                              一旦您的建议被采纳，丰丰金融就送你精美礼品一份";
    [self.view addSubview:self.textView];
    
    
    self.sendButton = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.textView.frame)+10,kScreenSize.width-20, 40)];
    self.sendButton.layer.cornerRadius = 5;
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchDown];
    self.sendButton.backgroundColor = kBtnColor;
    self.sendButton.layer.masksToBounds = YES;
    [self.view addSubview:self.sendButton];
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)sendAction:(id)sender
{
    if(![DYUser loginIsLogin]){
        
        [DYUser  loginShowLoginView];
        return;
    }else {
        if (self.textView.text == nil) {
            [LeafNotification showInController:self withText:@"内容不能为空"];
            return;
        }else{
            DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
            
            [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
            
            [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
            [diyouDic insertObject:self.textView.text forKey:@"content" atIndex:0];
            [diyouDic insertObject:@"users" forKey:@"module" atIndex:0];
            [diyouDic insertObject:@"opinion" forKey:@"q" atIndex:0];
            [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object, BOOL isSuccess, NSString *errorMessage) {
                if (isSuccess) {
                    
                    [self.textView resignFirstResponder];
                    [MBProgressHUD  checkHudWithView:nil label:@"发送成功！" hidesAfter:1];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [self.textView resignFirstResponder];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [LeafNotification showInController:self withText:errorMessage];
                }
            } errorBlock:^(id error) {
                [self.textView resignFirstResponder];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [LeafNotification showInController:self withText:@"网络异常"];
            }];
        }
    
    
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
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
