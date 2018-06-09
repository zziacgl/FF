
//
//  DYOrderedDictionary.m
//  NewDeayou
//
//  Created by diyou on 14-7-25.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "DYOrderedDictionary.h"

NSString *DescriptionForObject(NSObject *object, id locale, NSUInteger indent)
{
    NSString *objectString;
    if ([object isKindOfClass:[NSString class]])
    {
        objectString = (NSString *)[[object retain] autorelease];
    }
    else if ([object respondsToSelector:@selector(descriptionWithLocale:indent:)])
    {
        objectString = [(NSDictionary *)object descriptionWithLocale:locale indent:indent];
    }
    else if ([object respondsToSelector:@selector(descriptionWithLocale:)])
    {
        objectString = [(NSSet *)object descriptionWithLocale:locale];
    }
    else
    {
        objectString = [object description];
    }
    return objectString;
}

@implementation DYOrderedDictionary
//初始化方法
- (id)init
{
    [super init];
    return [self initWithCapacity:0];
}

//初始化方法
- (id)initWithCapacity:(NSUInteger)capacity
{
    self = [super init];
    if (self != nil)
    {
        dictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
        array = [[NSMutableArray alloc] initWithCapacity:capacity];
    }
    return self;
}

//析构方法
- (void)dealloc
{
    [dictionary release];
    [array release];
    [super dealloc];
}

//copy方法
- (id)copy
{
    return [self mutableCopy];
}

//复写方法
- (void)setObject:(id)anObject forKey:(id)aKey
{
    if (![dictionary objectForKey:aKey])
    {
        [array addObject:aKey];
    }
    [dictionary setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey
{
    [dictionary removeObjectForKey:aKey];
    [array removeObject:aKey];
}

- (NSUInteger)count
{
    return [dictionary count];
}

- (id)objectForKey:(id)aKey
{
    return [dictionary objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator
{
    return [array objectEnumerator];
}

- (NSEnumerator *)reverseKeyEnumerator
{
    return [array reverseObjectEnumerator];
}

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex
{
    if ([dictionary objectForKey:aKey])
    {
        [self removeObjectForKey:aKey];
    }
    [array insertObject:aKey atIndex:anIndex];
    [dictionary setObject:anObject forKey:aKey];
}

- (id)keyAtIndex:(NSUInteger)anIndex
{
    return [array objectAtIndex:anIndex];
}

//返回一个字符串对象,该对象代表了字典的内容,格式的属性列表。
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *indentString = [NSMutableString string];
    NSUInteger i, count = level;
    for (i = 0; i < count; i++)
    {
        [indentString appendFormat:@"    "];
    }
    
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"%@{\n", indentString];
    for (NSObject *key in self)
    {
        [description appendFormat:@"%@    %@ = %@;\n",
         indentString,
         DescriptionForObject(key, locale, level),
         DescriptionForObject([self objectForKey:key], locale, level)];
    }
    [description appendFormat:@"%@}\n", indentString];
    return description;
}

//过滤中文等字符
-(void)filtrateChinese
{
    for (id key in self.allKeys)
    {
        id object=[self objectForKey:key];
        
//        if ([object isKindOfClass:[NSString class]])
//        {
//            if ([object rangeOfString:@"验证码"].length>0)
//            {
//                [self setObject:object forKey:key];
//                continue;
//            }
//        }
//        
        
        
        if ([object isKindOfClass:[NSString class]])
        {
            
            
            [self setObject:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                      (CFStringRef)object,
                                                                                                      NULL,
                                                                                                      NULL,
                                                                                                      kCFStringEncodingUTF8)) forKey:key];
        }
    }
}

@end
