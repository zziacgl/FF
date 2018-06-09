//
//  DDNetWoringTool.m
//  NewDeayou
//
//  Created by Tony on 16/10/9.
//  Copyright © 2016年 浙江多多投资管理有限公司. All rights reserved.
//

#import "DDNetWoringTool.h"
#import "JSON.h"
//#import "Base64.h"
#import "DDBase.h"
#import "AFNetworking.h"
@implementation DDNetWoringTool
//帝友进行base64后再进行urlencode
+ (NSString*)DiYouBase64Urlencode
{
    
    NSMutableDictionary * dic=[DYNetWork DiYouDictionary];
    //将字典转换成data类型
    NSData * data=[[dic JSONFragment] dataUsingEncoding:NSUTF8StringEncoding];
    //将data进行64位编码
    NSString * rrrrrr=[data base64EncodedString];
    //对diyou进行urlencode编码
    NSString *diyou = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                           (CFStringRef)rrrrrr, nil,
                                                                                           (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return diyou;
    
}

#pragma mark - JSON方式post提交数据
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(DYOrderedDictionary *)parameters success:(DDCompleteBlock)success fail:(void (^)())fail
{
    
    
    //过滤中文
    [parameters insertObject:[DYNetWork DiYouDictionary] forKey:@"diyou" atIndex:0];
    //[parmas filtrateChinese];
    
    NSString * jsonS=[parameters JSONRepresentation];
    while ([jsonS rangeOfString:@"\\\\"].length>0)
    {
        jsonS= [jsonS stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    }
    //    NSLog(@"jsonS%@",jsonS);
    //字典转化成json格式后再转化为data类型
    NSData * data_diyou=[jsonS dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    
    //256加密
    NSData * data_aes128_diyou=[data_diyou AES256EncryptWithKey:kDiyou_key];
    //urlenconde
    
    NSString *result1 = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                             (CFStringRef)[data_aes128_diyou base64EncodedString], nil,
                                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    /*   NSString * result1=(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
     (CFStringRef)[data_aes128_diyou base64EncodedString],
     NULL,
     NULL,
     kCFStringEncodingUTF8));
     */
    /*  －－－－－－－－   反解密   --------
     
     //urldecode;
     NSString*mmmm=[[result1 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     //aes256 decode
     NSData * data_aes256_decode=[data_aes128_diyou AES256DecryptWithKey:kDiyou_key];
     NSLog(@"%@",[data_aes256_decode JSONValue]);
     
     －－－－－－－  */
    
//        NSString * url=[NSString stringWithFormat:@"%@diyou=%@&sign=%@",kHostName,[DDNetWoringTool DiYouBase64Urlencode],result1];
//    
//    
//    
//    
//         NSLog(@"url%@",url);
    
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    
    manager.requestSerializer.timeoutInterval = 600;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //解码
    NSString *str1 = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)[DDNetWoringTool DiYouBase64Urlencode], CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSString *str2 = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)result1, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    [parameters insertObject:str1 forKey:@"diyou" atIndex:0];
    [parameters insertObject:str2 forKey:@"sign" atIndex:0];
    
    NSLog(@"打印url%@",parameters);
    [manager POST:kHostName parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
//        NSLog(@"打印%@",dict);
        BOOL isSuccess=[[dict objectForKey:@"result"]isEqualToString:@"success"]?YES:NO;
        NSString * errorMessage=[dict objectForKey:@"error_remark"];
        
        
        if (success) {
            success(dict,isSuccess,errorMessage);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
        if (fail) {
            fail(error);
        }
    }];
    
}

+ (void)getJSONWithUrl:(NSString *)urlStr parameters:(DYOrderedDictionary *)parameters success:(DDCompleteBlock)success fail:(void (^)())fail{
    
    
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    //过滤中文
    [parameters insertObject:[DYNetWork DiYouDictionary] forKey:@"diyou" atIndex:0];
    //[parmas filtrateChinese];
    
    NSString * jsonS=[parameters JSONRepresentation];
    while ([jsonS rangeOfString:@"\\\\"].length>0)
    {
        jsonS= [jsonS stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    }
    //    NSLog(@"jsonS%@",jsonS);
    //字典转化成json格式后再转化为data类型
    NSData * data_diyou=[jsonS dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    
    //256加密
    NSData * data_aes128_diyou=[data_diyou AES256EncryptWithKey:kDiyou_key];
    //urlenconde
    NSString *result1 = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                             (CFStringRef)[data_aes128_diyou base64EncodedString], nil,
                                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    /*   NSString * result1=(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
     (CFStringRef)[data_aes128_diyou base64EncodedString],
     NULL,
     NULL,
     kCFStringEncodingUTF8));
     */
    /*  －－－－－－－－   反解密   --------
     
     //urldecode;
     NSString*mmmm=[[result1 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     //aes256 decode
     NSData * data_aes256_decode=[data_aes128_diyou AES256DecryptWithKey:kDiyou_key];
     NSLog(@"%@",[data_aes256_decode JSONValue]);
     
     －－－－－－－  */
    
    NSString * url=[NSString stringWithFormat:@"%@?diyou=%@&sign=%@",kHostName,[DDNetWoringTool DiYouBase64Urlencode],result1];
    
    //     NSLog(@"url%@",url);
    
    
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        BOOL isSuccess=[[dict objectForKey:@"result"]isEqualToString:@"success"]?YES:NO;
        NSString * errorMessage=[dict objectForKey:@"error_remark"];
        
        
        if (success) {
            success(dict,isSuccess,errorMessage);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
        if (fail) {
            fail(error);
        }
    }];
    
    
}


//生成帝友字典
+ (NSMutableDictionary*)DiYouDictionary
{
    
    DYOrderedDictionary * dicDiyou=[[DYOrderedDictionary alloc]init];
    [dicDiyou insertObject:kDiyou_http forKey:@"diyou_http" atIndex:0];
    [dicDiyou insertObject:kDiyou_project forKey:@"diyou_project" atIndex:0];
    [dicDiyou insertObject:/*@"b0360ccc4b92b65891bda549ced18c6b"*/@"ae5e2760ad0f57210765203202e3baa4" forKey:@"diyou_auth" atIndex:0];
    [dicDiyou insertObject:kDiyou_key forKey:@"diyou_key" atIndex:0];
    [dicDiyou insertObject:@"iphone" forKey:@"diyou_name" atIndex:0];
    [dicDiyou insertObject:@"soap" forKey:@"diyou_os" atIndex:0];
    
    return dicDiyou;
    
}


@end
