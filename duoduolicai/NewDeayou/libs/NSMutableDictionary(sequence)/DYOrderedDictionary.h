//
//  DYOrderedDictionary.h
//  NewDeayou
//
//  Created by diyou on 14-7-25.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYOrderedDictionary : NSMutableDictionary
{
    NSMutableDictionary *dictionary;
    NSMutableArray *array;
}

//插入一个位置
- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex;

//取得某个位置的obj
- (id)keyAtIndex:(NSUInteger)anIndex;

//逆序
- (NSEnumerator *)reverseKeyEnumerator;

//顺序
- (NSEnumerator *)keyEnumerator;

//过滤中文等字符
-(void)filtrateChinese;


@end
