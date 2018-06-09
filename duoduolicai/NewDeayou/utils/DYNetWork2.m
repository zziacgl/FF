//
//  DYNetWork2.m
//  NewDeayou
//
//  Created by diyou on 14-7-31.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYNetWork2.h"
#import "JSON.h"
//#import "Base64.h"
#import "DDBase.h"
#import "DYOrderedDictionary.h"




@implementation DYNetWork2

//帝友进行base64后再进行urlencode
+(NSString*)DiYouBase64Urlencode
{
    
    NSMutableDictionary * dic=[DYNetWork2 DiYouDictionary];
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
+(NSMutableDictionary*)DiYouDictionary
{
    
    DYOrderedDictionary * dicDiyou=[[DYOrderedDictionary alloc]init];
    [dicDiyou insertObject:kDiyou_http forKey:@"diyou_http" atIndex:0];
    [dicDiyou insertObject:kDiyou_project forKey:@"diyou_project" atIndex:0];
    [dicDiyou insertObject:@"b0360ccc4b92b65891bda549ced18c6b" forKey:@"diyou_auth" atIndex:0];
    [dicDiyou insertObject:kDiyou_key forKey:@"diyou_key" atIndex:0];
    [dicDiyou insertObject:@"iphone" forKey:@"diyou_name" atIndex:0];
    [dicDiyou insertObject:@"soap" forKey:@"diyou_os" atIndex:0];
    return dicDiyou;
    
}

#pragma mark--用户额度申请记录

+(MKNetworkOperation*)DYBorrowLimitApplicationRecordUsedID:(int)userID page:(int)page completeBlock:(DYCompleteBlock2)completeBlock errorBlock:(DYErrorBlock)errorBlock
{
    DYOrderedDictionary *diyouDic=[[DYOrderedDictionary alloc]init];
    [diyouDic insertObject:@"borrow" forKey:@"module" atIndex:0];
    [diyouDic insertObject:@"get_amount_apply_list" forKey:@"q" atIndex:0];
    [diyouDic insertObject:@"get" forKey:@"method" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",userID] forKey:@"user_id" atIndex:0];
    [diyouDic insertObject:[NSString stringWithFormat:@"%d",page] forKey:@"page" atIndex:0];
    [diyouDic insertObject:[DYNetWork2 DiYouDictionary] forKey:@"diyou" atIndex:0];
    
    
    NSData * data_diyou=[[diyouDic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];   
    NSData * data_aes256_diyou=[data_diyou AES256EncryptWithKey:kDiyou_key];
    NSString *result1 = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                             (CFStringRef)[data_aes256_diyou base64EncodedString], nil,
                                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString * url=[NSString stringWithFormat:@"%@diyou=%@&sign=%@",kHostName,[DYNetWork2 DiYouBase64Urlencode],result1];
    MKNetworkEngine * engine=[[MKNetworkEngine alloc]init];
    MKNetworkOperation * operation=[engine operationWithURLString:url];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSData *data = [completedOperation responseData];
         NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         NSString * error=nil;
         if ([[dic objectForKey:@"result"] isEqual:@"success"]==YES) {
             
             
             id list=[dic objectForKey:@"list"];
             if (completeBlock&&[list isKindOfClass:[NSArray class]])
             {
                 completeBlock(list,error);
             }
         }
         else
         {
             
             error=[dic objectForKey:@"error_remark"];
             
             if (completeBlock) {
                 
                 completeBlock([NSNull null],error);
                 
             }
         }
     }
     errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         if (errorBlock)
             errorBlock(error);
     }];
    [engine enqueueOperation:operation];
    return operation;

    
    
}
//网络接口
+(MKNetworkOperation*)operationWithDictionary:(DYOrderedDictionary*)parmas completeBlock:(DYCompleteBlock)completeBlock errorBlock:(DYErrorBlock)errorBlock
{
    //过滤中文
    //[parmas filtrateChinese];
    NSString * jsonS=[parmas JSONRepresentation];
    while ([jsonS rangeOfString:@"\\\\"].length>0)
    {
        jsonS= [jsonS stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    }
     //字典转化成json格式后再转化为data类型
    NSData * data_diyou=[jsonS dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    
    //256加密
    NSData * data_aes128_diyou=[data_diyou AES256EncryptWithKey:kDiyou_key];
    //urlenconde
    NSString *result1 = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                             (CFStringRef)[data_aes128_diyou base64EncodedString], nil,
                                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
//    NSLog(@"%@",result1);
    /*  －－－－－－－－   反解密   --------
     
     //urldecode;
     NSString*mmmm=[[result1 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     //aes256 decode
     NSData * data_aes256_decode=[data_aes128_diyou AES256DecryptWithKey:kDiyou_key];
     NSLog(@"%@",[data_aes256_decode JSONValue]);
     
     －－－－－－－  */
    
    NSString * url=[NSString stringWithFormat:@"%@diyou=%@&sign=%@",kHostName,[DYNetWork2 DiYouBase64Urlencode],result1];
//    NSLog(@"%@",url);
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
