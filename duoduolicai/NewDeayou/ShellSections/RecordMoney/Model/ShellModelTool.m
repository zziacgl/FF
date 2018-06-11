//
//  ShellModelTool.m
//  NewDeayou
//
//  Created by zhoubiwen on 2018/6/11.
//  Copyright © 2018年 丰丰金融. All rights reserved.
//

#import "ShellModelTool.h"
#import "ShellRecordModel.h"

#import "YYKit.h"

@implementation ShellModelTool

+ (NSArray *)getRecord:(RecordType)recordType {
    NSArray *totalArr = [self totalArray];
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSString *path in totalArr) {
        NSArray *dayArr = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *array = [NSMutableArray new];
        for (NSString *subPath in dayArr) {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:subPath];
            ShellRecordModel *model = [ShellRecordModel new];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
        }
        [modelArr addObject:array];
    }
    return modelArr;
}

+ (void)saveRecordModel:(ShellRecordModel *)recordModel {
    // 保存当前记录的id，便于查询
    [self storeTodayDataArray:recordModel.recordId];
    NSDictionary *dict = [recordModel convertDictionary];
    
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    cachePath = [cachePath stringByAppendingPathComponent:@""];
    [dict writeToFile:cachePath atomically:YES];
}

+ (void)modifyRecordModel:(ShellRecordModel *)recordModel {
    
}

+ (void)deleteRecordModel:(ShellRecordModel *)recordModel {
    
}

#pragma mark - private
+ (NSArray *)totalArray {
    return [NSArray arrayWithContentsOfFile:[self totalArrayPath]];
}

+ (void)storeTodayArray:(NSString *)path {
   NSArray *arr = [self totalArray];
    NSMutableArray *totalArr = [NSMutableArray new];
    if (arr) {
        [totalArr addObjectsFromArray:arr];
    }
    [totalArr addObject:path];
    [totalArr writeToFile:[self totalArrayPath] atomically:YES];
}

+ (void)storeTodayDataArray:(NSString *)recordId {
    
    NSDate *date = [NSDate date];
    NSString *dateStr = [date stringWithFormat:@"YYYY-MM-dd"];
    NSString *path = [[self cachePath] stringByAppendingPathComponent:dateStr];
    NSArray *todayArr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *arr = [NSMutableArray new];
    
    if (todayArr){
        [arr addObjectsFromArray:todayArr];
    }else {
        [self storeTodayArray:path];
    }
    [arr addObject:recordId];
    [arr writeToFile:path atomically:YES];
}

+ (NSString *)cachePath {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)totalArrayPath {
    return [[self cachePath] stringByAppendingPathComponent:@"TotalArray"];
}

@end
