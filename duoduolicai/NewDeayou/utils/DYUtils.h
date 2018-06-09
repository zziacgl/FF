//
//  DYUtils.h
//  NewDeayou
//
//  Created by wayne on 14-6-18.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface DYUtils : NSObject
+ (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(int)gradientType;
+ (NSDictionary *)stringConvertWithStr:(NSString *)string;

//过滤中文
+(NSString*)filtrateChinese:(NSString*)url;

//大于一万
+(NSString*)withMoreTenThousand:(NSString*)money;

//大于一万元
+(NSString*)withMoreTenThousandYUAN:(NSString*)money;

//将时间戳 转换为北京时间
+(NSString*)dataUnixTime:(NSString*)time;

//将时间戳 转换为北京时间
+(NSString*)dataUnixTimeYYYYMMDD:(NSString*)time;
+(NSString *)datazerotime;
+(NSString *)datatotimestamp:(NSString *)time;
//将时间戳 转换为北京时间
+(NSString*)dataUnixTimeYYYYMMDDHHmm:(NSString*)time;
//unicode转换为中文
+(NSString *)replaceUnicode:(NSString *)unicodeStr;
//中文转换为unicode
+(NSString *) stringToUnicode:(NSString *)string;
+(NSString*)datachangeTimeYYYYMMDD:(NSString*)time;

//倒计时

+(NSString *)countDowentime:(NSTimeInterval)time;





@end

@interface NSString (MDdd5)

- (NSString *)MD5String;

@end


@interface UIImage(custom)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end


@interface NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密
- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密
- (NSString *)newStringInBase64FromData;            //追加64编码
+ (NSString*)base64encode:(NSString*)str;           //同上64编码
@end


@interface UIViewController(AfterLoad)

- (void)viewDidAfterLoad;

@end


@interface NSDictionary(DYObjectForKey)

-(id)DYObjectForKey:(id)key;

@end

@interface  UIButton (CustomeBackgroundColor)

-(void)customBackgroundMainColorAndCornerRadius3;

@end



