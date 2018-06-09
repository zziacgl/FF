//
//  DYPush.m
//  NewDeayou
//
//  Created by 郭嘉 on 15/9/22.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYPush.h"
#import "JSON.h"
//#import "Base64.h"
#import "DDBase.h"

@implementation DYPush

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

+ (MKNetworkOperation*)operationWithDictionary:(DYOrderedDictionary*)parmas completeBlock:(DYCompleteBlock)completeBlock errorBlock:(DYErrorBlock)errorBlock
{
    //过滤中文
    [parmas insertObject:[DYNetWork DiYouDictionary] forKey:@"diyou" atIndex:0];
    //[parmas filtrateChinese];
    
    NSString * jsonS=[parmas JSONRepresentation];
    while ([jsonS rangeOfString:@"\\\\"].length>0)
    {
        jsonS= [jsonS stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    }
    
    
    NSString * url=[NSString stringWithFormat:@"https://www.51duoduo.com/llpay/bank_query.php?card_no=%@",[parmas objectForKey:@"CertNo"]];

//    NSLog(@"%@",url);
    
    MKNetworkEngine * engine=[[MKNetworkEngine alloc]init];
    MKNetworkOperation * operation=[engine operationWithURLString:url];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSData *data = [completedOperation responseData];
         NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//         NSLog(@"%@",dic);
         BOOL isSuccess=[[dic objectForKey:@"result"]isEqualToString:@"success"]?YES:NO;
         NSString * errorMessage=[dic objectForKey:@"error_remark"];
         completeBlock(dic,isSuccess,errorMessage);
         
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         if (errorBlock)
             errorBlock(error);
     }];
    [engine enqueueOperation:operation];
    return operation;
}
+(MKNetworkOperation*)ChineseOperationWithDictionary:(DYOrderedDictionary*)parmas completeBlock:(DYCompleteBlock)completeBlock errorBlock:(DYErrorBlock)errorBlock
{
    //过滤中文
    [parmas insertObject:[DYNetWork DiYouDictionary] forKey:@"diyou" atIndex:0];
    //字典转化成json格式后再转化为data类型
    
    NSString * url=[NSString stringWithFormat:@"https://www.51duoduo.com/simplepush/simplepush.php?diyou=%@&deviceToken=%@&badge=%@&message=%@",[DYPush DiYouBase64Urlencode],[parmas objectForKey:@"deviceToken"],[parmas objectForKey:@"badge"],[parmas objectForKey:@"message"]];
    
    MKNetworkEngine * engine=[[MKNetworkEngine alloc]init];
    MKNetworkOperation * operation=[engine operationWithURLString:url];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSData *data = [completedOperation responseData];
         NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         BOOL isSuccess=[[dic objectForKey:@"result"]isEqualToString:@"success"]?YES:NO;
         NSString * errorMessage=[dic objectForKey:@"error_remark"];
         completeBlock(dic,isSuccess,errorMessage);
         
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         if (errorBlock)
             errorBlock(error);
     }];
    [engine enqueueOperation:operation];
    return operation;
}


@end
