//
//  DDCaughtExceptionHandler.m
//  NewDeayou
//
//  Created by 郭嘉 on 2017/6/14.
//  Copyright © 2017年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDCaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

static BOOL showAlertView = nil;

void HandleException(NSException *exception);
void SignalHandler(int signal);
NSString* getAppInfo();

@interface DDCaughtExceptionHandler()
@property (assign,nonatomic)BOOL dismissed;
@property (nonatomic,strong)NSString *exceptionInfo;
@property (nonatomic,strong)UIImage *exceptionImage;
@end

@implementation DDCaughtExceptionHandler

+(void) installUncaughtExceptionHandler:(BOOL)install showAlert:(BOOL)showAlert{
    
    if (install && showAlert) {
        [[self alloc] alertView:showAlert];
    }
    
    NSSetUncaughtExceptionHandler(install ? HandleException : NULL);
    signal(SIGABRT, install ? SignalHandler : SIG_DFL);
    signal(SIGILL, install ? SignalHandler : SIG_DFL);
    signal(SIGSEGV, install ? SignalHandler : SIG_DFL);
    signal(SIGFPE, install ? SignalHandler : SIG_DFL);
    signal(SIGBUS, install ? SignalHandler : SIG_DFL);
    signal(SIGPIPE, install ? SignalHandler : SIG_DFL);
    
}
-(void)alertView:(BOOL)show{
    
    showAlertView = show;
}

//获取调用堆栈
+(NSArray *)backtrace{
    
    //指针列表
    void* callstack[128];
    //backtrace用来获取当前线程的调用堆栈，获取的信息存放在这里的callstack中
    //128用来指定当前的buffer中可以保存多少个void*元素
    //返回值是实际获取的指针个数
    int frames = backtrace(callstack, 128);
    //backtrace_symbols将backtrace函数获取的信息转化为一个字符串数组
    //返回一个指向字符串数组的指针
    //每个字符串包含了一个相对于callstack中对应元素的可打印信息，包括函数名，偏移地址，实际返回地址
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < frames; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex {
#pragma clang diagnostic pop
    
    if(anIndex==1){
        
        NSData *imageData = UIImagePNGRepresentation(self.exceptionImage);
        NSString *base64Encoded = [imageData base64EncodedStringWithOptions:0];
        NSString *syserror = [NSString stringWithFormat:@"mailto://1439125361@qq.com?subject=bug报告&body=感谢您的配合!<br><br><br>"
                              "Error Detail:%@<br><img src='data:image/jpg;base64,%@'>",
                              self.exceptionInfo,base64Encoded];
//        NSLog(@"图片%@", base64Encoded);
        NSURL *url = [NSURL URLWithString:[syserror stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
        
    }else{
//        self.dismissed = YES;

    }
    
}

//处理报错信息
-(void)validateAndSaveCriticalApplicationData:(NSException *)exception{
    
    UIViewController *VC=[self getCurrentVC];//获取当前页面的viewController
    
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"\n--------Log Exception---------\nappInfo             :\n%@\n\nexception viewcontroller    :%@,%@\nexception name      :%@\nexception reason    :%@\nexception userInfo  :%@\ncallStackSymbols    :%@\n\n--------End Log Exception-----", getAppInfo(),VC.title,VC.tabBarItem.title,exception.name, exception.reason, exception.userInfo ? : @"no user info", [exception callStackSymbols]];
    
//    NSLog(@"%@", exceptionInfo);
    //	[exceptionInfo writeToFile:[NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    self.exceptionInfo=exceptionInfo;
    
    NSArray *arrContent=[exceptionInfo componentsSeparatedByString:@"\n"];
    UIFont *font = [UIFont systemFontOfSize:15];
    
    NSMutableArray *arrHeight = [[NSMutableArray alloc] initWithCapacity:arrContent.count];
    
    
    
    CGFloat fHeight = 0.0f;
    
    for (NSString *sContent in arrContent) {
        
        CGSize stringSize = [sContent sizeWithFont:font constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 10000) lineBreakMode:UILineBreakModeWordWrap];
        
        [arrHeight addObject:[NSNumber numberWithFloat:stringSize.height]];
        
        fHeight += stringSize.height;
        
    }
    
    
    
    CGSize newSize = CGSizeMake([UIScreen mainScreen].bounds.size.width+20, fHeight+50);
    
    
    
    UIGraphicsBeginImageContextWithOptions(newSize,NO,0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetCharacterSpacing(ctx, 10);
    
    CGContextSetTextDrawingMode (ctx, kCGTextFillStroke);
    
    CGContextSetRGBFillColor (ctx, 0.1, 0.2, 0.3, 1); // 6
    
    CGContextSetRGBStrokeColor (ctx, 0, 0, 0, 1);
    
    
    
    int nIndex = 0;
    
    CGFloat fPosY = 20.0f;
    
    for (NSString *sContent in arrContent) {
        
        NSNumber *numHeight = [arrHeight objectAtIndex:nIndex];
        
        CGRect rect = CGRectMake(10, fPosY, [UIScreen mainScreen].bounds.size.width , [numHeight floatValue]);
        
        [sContent drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
        
        
        
        fPosY += [numHeight floatValue];
        
        nIndex++;
        
    }
    
    // transfer image
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    //截屏
    CGRect screenRect = CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height);
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx2 = UIGraphicsGetCurrentContext();
    
    [VC.view.layer renderInContext:ctx2];
    
    UIImage * image2 = UIGraphicsGetImageFromCurrentImageContext();
    self.exceptionImage=image2;
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image2, nil, nil, nil);
}
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}
-(void)handleException:(NSException *)exception{
    
    [self validateAndSaveCriticalApplicationData:exception];
    
    if (!showAlertView) {
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:@"出错啦"
     message:@"为了更好解决bug请点击下方的 发送反馈邮件 按钮，感谢你们的支持，我们会变得越来越好\n"
     delegate:self
     cancelButtonTitle:@"退出"
     otherButtonTitles:@"发送反馈邮件", nil];
    [alert show];
#pragma clang diagnostic pop
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!self.dismissed) {
        //点击发送反馈邮件
        for (NSString *mode in (__bridge NSArray *)allModes) {
            //快速切换Mode
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
        
    }
    
    //点击退出
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey]intValue]);
    }else{
        [exception raise];
    }
}


@end
void HandleException(NSException *exception) {
    
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    // 如果太多不用处理
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    
    //获取调用堆栈
    NSArray *callStack = [exception callStackSymbols];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
    //在主线程中，执行制定的方法, withObject是执行方法传入的参数
    [[[DDCaughtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException exceptionWithName:[exception name]
                             reason:[exception reason]
                           userInfo:userInfo]
     waitUntilDone:YES];
}

//处理signal报错
void SignalHandler(int signal) {
    
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    // 如果太多不用处理
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    
    NSString* description = nil;
    switch (signal) {
        case SIGABRT:
            description = [NSString stringWithFormat:@"Signal SIGABRT was raised!\n"];
            break;
        case SIGILL:
            description = [NSString stringWithFormat:@"Signal SIGILL was raised!\n"];
            break;
        case SIGSEGV:
            description = [NSString stringWithFormat:@"Signal SIGSEGV was raised!\n"];
            break;
        case SIGFPE:
            description = [NSString stringWithFormat:@"Signal SIGFPE was raised!\n"];
            break;
        case SIGBUS:
            description = [NSString stringWithFormat:@"Signal SIGBUS was raised!\n"];
            break;
        case SIGPIPE:
            description = [NSString stringWithFormat:@"Signal SIGPIPE was raised!\n"];
            break;
        default:
            description = [NSString stringWithFormat:@"Signal %d was raised!",signal];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSArray *callStack = [DDCaughtExceptionHandler backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [userInfo setObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    
    //在主线程中，执行指定的方法, withObject是执行方法传入的参数
    [[[DDCaughtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                             reason: description
                           userInfo: userInfo]
     waitUntilDone:YES];
}

NSString* getAppInfo() {
    
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion];
    return appInfo;
}



