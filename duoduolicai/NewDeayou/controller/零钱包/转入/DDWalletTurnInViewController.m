//
//  DDWalletTurnInViewController.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/11/17.
//  Copyright © 2015年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDWalletTurnInViewController.h"
#import "LeafNotification.h"
@interface DDWalletTurnInViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleYuJi;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic)BOOL isAuto;//true 滑动，false 手动
@end

@implementation DDWalletTurnInViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navigationController.navigationBarHidden = NO;
    if (self.type==1) {
        self.title=@"账户余额转入";
    }else{
        self.title=@"体验金转入";
        self.titleYuJi.text=@"7天预计收益(元)";
    }
    self.isAuto=true;//滑动
    
    float m2=[self.balance floatValue];
    float a2=[self.annual floatValue];
    float n2=m2*a2/365*30/100;
    if (self.type!=1) {
        n2=m2*a2/365*7/100;
    }
    self.Alert.text=[NSString stringWithFormat:@"%.2f",n2];
    
    self.HeadView.backgroundColor=kCOLOR_R_G_B_A(253, 83, 83, 1);
    //转入（元）
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.HeadView.frame) + 20, kMainScreenWidth, 40)];
    label1.font=[UIFont systemFontOfSize:14];
    label1.textColor=[UIColor grayColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text=@"转入(元)";
    label1.tag=12;
    [self.view addSubview:label1];
    
    //建议转入100元以上
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 240, kMainScreenWidth, 40)];
    label2.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, 240);
    label2.font=[UIFont systemFontOfSize:14];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor=[UIColor grayColor];
    label2.text=@"建议转入100元以上";
    label2.tag=13;
    [self.view addSubview:label2];
    
    
    //滑块设置
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(25, 200, [UIScreen mainScreen].bounds.size.width - 50, 20)];
    _slider.minimumValue = 1;
    _slider.maximumValue = 100;
    _slider.value = 100;
    _slider.minimumTrackTintColor = [UIColor clearColor];
    _slider.maximumTrackTintColor = [UIColor clearColor];
    
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 205, [UIScreen mainScreen].bounds.size.width - 50, 10)];
    UIImage *img = [UIImage imageNamed:@"零钱宝-账户余额转出-滑动输入_03"];
    imageView.image = img;
    imageView.tag=14;
    UIImage *thumbImage = [UIImage imageNamed:@"充值页面2_05"];
    //添加点击手势和滑块滑动事件响应
    [_slider addTarget:self
                action:@selector(valueChanged:)
      forControlEvents:UIControlEventValueChanged];
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [_slider setThumbImage:thumbImage forState:UIControlStateNormal];
    [_slider addGestureRecognizer:tap];
    
    [self.view addSubview:imageView];
    [self.view addSubview:_slider];
    
    //转入的金额
    NSString *m=[NSString stringWithFormat:@"%@",self.balance];
//    NSLog(@"%lu",(unsigned long)m.length);
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, m.length*8, 40)];
    label3.center=CGPointMake(_slider.maximumValue/_slider.maximumValue*([UIScreen mainScreen].bounds.size.width-35), CGRectGetMinY(_slider.frame)-20);
    label3.font=[UIFont systemFontOfSize:14];
    label3.textColor=[UIColor grayColor];
    label3.textAlignment=NSTextAlignmentCenter;
    
    label3.text=[NSString stringWithFormat:@"%@",self.balance];
    label3.tag=20;
    [self.view addSubview:label3];
    
    UIButton *bin2=[[UIButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44-64, 103, 36)];
    //    [bin2 setBackgroundImage:[UIImage imageNamed:@"投资详情_02.png"] forState:UIControlStateNormal];
    bin2.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, 280);
    //    [bin2 setTitle:@"手动输入金额" forState:UIControlStateNormal];
    [bin2 setBackgroundImage:[UIImage imageNamed:@"零钱宝-账户余额转入_10.png"] forState:UIControlStateNormal];
    [bin2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    bin2.tag=11;
    [bin2 addTarget:self action:@selector(Turform2) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:bin2];
    
    
    
    //底部按钮
    UIButton *bin=[[UIButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44-64, [UIScreen mainScreen].bounds.size.width, 44)];
    [bin setBackgroundImage:[UIImage imageNamed:@"投资详情_02.png"] forState:UIControlStateNormal];
    [bin setTitle:@"确认转入" forState:UIControlStateNormal];
    bin.tag=10;
    [bin addTarget:self action:@selector(turnIn) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:bin];
    
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)turnIn{
   
    [MBProgressHUD hudWithView:self.view label:@"数据请求中"];
    NSString *investMoney=@"";
    if (_isAuto) {
        //滑动
        UILabel *m=[self.view viewWithTag:20];
        investMoney=m.text;
    }else{
        UITextField *TxtMoney=[self.view viewWithTag:15];
        investMoney=TxtMoney.text;
    }
    
    NSMutableDictionary *p=[NSMutableDictionary dictionary];
    p[@"转入金额"]=investMoney;

//    NSLog(@"%@",investMoney);
    DYOrderedDictionary * diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"lqb" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"info_lqb" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"post" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",[DYUser GetUserID]] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:investMoney forKey:@"amount" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",self.type] forKey:@"type" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    [DYNetWork operationWithDictionary:diyouDic completeBlock:^(id object,BOOL success,NSString*error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (success==YES) {
             //可用信用额度数据填充
             [self.navigationController popViewControllerAnimated:YES];//回到上一页
             NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
             [ud setObject:[NSString stringWithFormat:@"%d",self.type] forKey:@"LingqianBaoDone"];
             [ud setObject:investMoney forKey:@"LingqianBaoEnd"];
             [ud setObject:[NSString stringWithFormat:@"%d",self.type] forKey:@"LingqianBaoType"];
//             NSLog(@"%d",self.type);
         }
         else
         {
             [LeafNotification showInController:self withText:error];
         }
         
     } errorBlock:^(id error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [LeafNotification showInController:self withText:@"网络异常"];
     }];
    
}
- (void)valueChanged:(UISlider *)sender
{

    [sender setValue:sender.value];
    UILabel *m=[self.view viewWithTag:20];
    m.text=[NSString stringWithFormat:@"%.2f",sender.value/_slider.maximumValue*[self.balance floatValue]];
    
    m.center=CGPointMake(sender.value/_slider.maximumValue*([UIScreen mainScreen].bounds.size.width-35), CGRectGetMinY(_slider.frame)-20);
//    NSLog(@"bbb%f",sender.value);
    if (sender.value<10) {
        m.center=CGPointMake(sender.value/_slider.maximumValue*([UIScreen mainScreen].bounds.size.width-30)+4*(10-sender.value), CGRectGetMinY(_slider.frame)-20);
    }
    float m2=[m.text floatValue];
    float a2=[self.annual floatValue];
    float n2=m2*a2/365*30/100;
    if (self.type!=1) {
        n2=m2*a2/365*7/100;
    }
    self.Alert.text=[NSString stringWithFormat:@"%.2f",n2];
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    
    //取得点击点
    CGPoint p = [sender locationInView:_slider];
//    NSLog(@"aaa%f",p.x);
    if (p.x > 15) {
        _slider.value=p.x/[UIScreen mainScreen].bounds.size.width*_slider.maximumValue;
        UILabel *m=[self.view viewWithTag:20];
        m.text=[NSString stringWithFormat:@"%.2f",(p.x-15)/([UIScreen mainScreen].bounds.size.width-30)*[self.balance floatValue]];
        m.center=CGPointMake(p.x, CGRectGetMinY(_slider.frame)-20);
        
        float m2=[m.text floatValue];
        float a2=[self.annual floatValue];
        float n2=m2*a2/365*30/100;
        if (self.type!=1) {
            n2=m2*a2/365*7/100;
        }
        self.Alert.text=[NSString stringWithFormat:@"%.2f",n2];
        
    }
    
}

/**
 *  四舍五入
 *
 *  @param num 待转换数字
 *
 *  @return 转换后的数字
 */
- (NSString *)numberFormat:(float)num
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0"];
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    UIButton *btn=[self.view viewWithTag:10];
    btn.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-22-64-height);
    
}

-(void)Turform2{
    if(self.isAuto){
        //从滑动到手动
        self.Alert.text=@"0.00";
        UILabel *label1=(UILabel *)[self.view viewWithTag:12];
        UILabel *label2=(UILabel *)[self.view viewWithTag:13];
        UILabel *label5=(UILabel *)[self.view viewWithTag:20];
        UIButton *bnt=[self.view viewWithTag:11];
        UIImageView *imageview=[self.view viewWithTag:14];
        
        
        [label1 removeFromSuperview];
        [label2 removeFromSuperview];
        [label5 removeFromSuperview];
        //        [self.slider removeFromSuperview];
        self.slider.hidden = YES;
        [imageview removeFromSuperview];
        
        self.isAuto=false;//手动
        
        UIButton *bnt3=[self.view viewWithTag:10];
        bnt3.enabled=NO;
        
        //        [bnt setTitle:@"滑动输入金额" forState:UIControlStateNormal];
        [bnt setBackgroundImage:[UIImage imageNamed:@"零钱宝-账户余额转出_11@2x.png"] forState:UIControlStateNormal];
        
        UITextField *TxtMoney=[[UITextField alloc]initWithFrame:CGRectMake(14, 138, [UIScreen mainScreen].bounds.size.width-14-70, 44)];
        TxtMoney.tag=15;
        TxtMoney.placeholder=@"  请输入金额";
        TxtMoney.delegate=self;
        TxtMoney.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"充值页面_15@2x.png"]];
        TxtMoney.leftViewMode=UITextFieldViewModeAlways;
        TxtMoney.keyboardType=UIKeyboardTypeDecimalPad;
        [self.view addSubview:TxtMoney];
        
        UIButton *bnt2=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-14-70+5, 130, 60, 44)];
        [bnt2 setBackgroundColor:kCOLOR_R_G_B_A(253, 83, 83, 1)];
        [bnt2 setTitle:@"全投" forState:UIControlStateNormal];
        [bnt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        bnt2.tag=16;
        [bnt2.layer setMasksToBounds:YES];
        [bnt2.layer setCornerRadius:5.0];
        [bnt2 addTarget:self action:@selector(allIn) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:bnt2];
        
        UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(14, 180, 100, 44)];
        label3.text=@"可用余额(元):";
        label3.font=[UIFont systemFontOfSize:14];
        label3.tag=17;
        [self.view addSubview:label3];
        
        UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(114, 180, 200, 44)];
        label4.text=self.balance;
        label4.font=[UIFont systemFontOfSize:14];
        label4.tag=18;
        [self.view addSubview:label4];
        
        
        
        
    }else{
        //从手动到滑动
        
        UITextField *TxtMoney=[self.view viewWithTag:15];
        [TxtMoney removeFromSuperview];
        
        UIButton *bnt2=[self.view viewWithTag:16];
        [bnt2 removeFromSuperview];
        
        UILabel *label3=[self.view viewWithTag:17];
        [label3 removeFromSuperview];
        
        UILabel *label4=[self.view viewWithTag:18];
        [label4 removeFromSuperview];
        float m2=[self.balance floatValue];
        float a2=[self.annual floatValue];
        float n2=m2*a2/365*30/100;
        if (self.type!=1) {
            n2=m2*a2/365*7/100;
        }
        self.Alert.text=[NSString stringWithFormat:@"%.2f",n2];
        UIButton *bnt=[self.view viewWithTag:11];
        [bnt setBackgroundImage:[UIImage imageNamed:@"零钱宝-账户余额转入_10"] forState:UIControlStateNormal];
        
        self.isAuto=true;//滑动
        UIButton *bnt3=[self.view viewWithTag:10];
        bnt3.enabled=YES;
        
        //转入（元）
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        label1.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, 160);
        label1.font=[UIFont systemFontOfSize:14];
        label1.textColor=[UIColor grayColor];
        label1.text=@"转入(元)";
        label1.tag=12;
        [self.view addSubview:label1];
        
        //建议转入100元以上
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
        label2.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, 240);
        label2.font=[UIFont systemFontOfSize:14];
        label2.textColor=[UIColor grayColor];
        label2.text=@"建议转入100元以上";
        label2.tag=13;
        [self.view addSubview:label2];
        
        //滑块设置
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(15, 200, [UIScreen mainScreen].bounds.size.width - 30, 20)];
        _slider.minimumValue = 1;
        _slider.maximumValue = 100;
        _slider.value = 100;
        _slider.minimumTrackTintColor = [UIColor clearColor];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        
        //背景图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 205, [UIScreen mainScreen].bounds.size.width - 30, 10)];
        UIImage *img = [UIImage imageNamed:@"零钱宝-账户余额转出-滑动输入_03"];
        imageView.image = img;
        imageView.tag=14;
        
        
        //添加点击手势和滑块滑动事件响应
        [_slider addTarget:self
                    action:@selector(valueChanged:)
          forControlEvents:UIControlEventValueChanged];
        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_slider setThumbImage:[UIImage imageNamed:@"充值页面2_05@2x.png"] forState:UIControlStateNormal];
        [_slider addGestureRecognizer:tap];
        
        [self.view addSubview:imageView];
        [self.view addSubview:_slider];
        
        //转入的金额
        NSString *m=[NSString stringWithFormat:@"%@",self.balance];
//        NSLog(@"%lu",(unsigned long)m.length);
        UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, m.length*8, 40)];
        label5.center=CGPointMake(_slider.maximumValue/_slider.maximumValue*([UIScreen mainScreen].bounds.size.width-30), CGRectGetMinY(_slider.frame)-20);
        label5.font=[UIFont systemFontOfSize:14];
        label5.textColor=[UIColor grayColor];
        label5.textAlignment=NSTextAlignmentCenter;
        //    label3.backgroundColor=[UIColor redColor];
        label5.text=[NSString stringWithFormat:@"%@",self.balance];
        label5.tag=20;
        [self.view addSubview:label5];
        
    }
    
}
-(void)allIn{
    //全投
    UITextField *TxtMoney=[self.view viewWithTag:15];
    TxtMoney.text=[NSString stringWithFormat:@" %@",self.balance];
    float m=[self.balance floatValue];
    float a=[self.annual floatValue];
    float n=m*a/365*30/100;
    if (self.type!=1) {
        n=m*a/365*7/100;
    }
    self.Alert.text=[NSString stringWithFormat:@"%.2f",n];
    UIButton *btn=[self.view viewWithTag:10];
    btn.enabled=YES;
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    UIButton *btn=[self.view viewWithTag:10];
    btn.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-22-64);
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UITextField *TxtMoney=[self.view viewWithTag:15];
    if ([TxtMoney.text isEqualToString:@""]) {
        TxtMoney.text=[NSString stringWithFormat:@"    "];
    }
    //输入框开始输入时
    return true;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    UITextField *TxtMoney=[self.view viewWithTag:15];
    NSString *s=@"";
    float m=0;
    if (range.length==1) {
        m=[[TxtMoney.text substringToIndex:TxtMoney.text.length-1] floatValue];
        s=[TxtMoney.text substringToIndex:TxtMoney.text.length-1];
    }else{
        m=[[NSString stringWithFormat:@"%@%@",TxtMoney.text,string] floatValue];
        s=[NSString stringWithFormat:@"%@%@",TxtMoney.text,string];
        
    }
    float a=[self.annual floatValue];
    float n=m*a/365*30/100;
    if (self.type!=1) {
        n=m*a/365*7/100;
    }
    self.Alert.text=[NSString stringWithFormat:@"%.2f",n];
    UIButton *btn=[self.view viewWithTag:10];
    if ([self.balance floatValue]>=m&&[self.balance floatValue]>0&&m>0) {
        btn.enabled=YES;
    }else{
        btn.enabled=NO;
    }
    float b=[self.balance floatValue];
    if(m>b){
        m=b;
        TxtMoney.text=[NSString stringWithFormat:@"    %.2f",b];
        float a=[self.annual floatValue];
        float n=m*a/365*30/100;
        if (self.type!=1) {
            n=m*a/365*7/100;
        }
        self.Alert.text=[NSString stringWithFormat:@"%.2f",n];

        return NO;
    }
    NSArray *array=[s componentsSeparatedByString:@"."];
    if (array.count==2) {
        NSString *s2=[NSString stringWithFormat:@"%@",array[1]];
        if (s2.length>2) {
            TxtMoney.text=[NSString stringWithFormat:@"    %.2f",m];
            return NO;
        }
    }
    
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [[self.view viewWithTag:15] resignFirstResponder];
    
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
