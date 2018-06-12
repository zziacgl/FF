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

#define kCachePath(str) [[self cachePath] stringByAppendingPathComponent:str]

@implementation ShellModelTool

+ (NSArray *)getRecord:(RecordType)recordType {
    NSArray *totalArr = [self totalArray];
    
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSString *path in totalArr) {
        NSArray *dayArr = [NSArray arrayWithContentsOfFile:kCachePath(path)];
        NSMutableArray *array = [NSMutableArray new];
        for (NSString *subPath in dayArr) {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:kCachePath(subPath)];
            ShellRecordModel *model = [ShellRecordModel new];
            [model setValuesForKeysWithDictionary:dict];
            if (recordType == model.recordType) {
                [array addObject:model];
            }
        }
        [modelArr addObject:array];
    }
    
    return modelArr;
}

+ (void)saveRecordModel:(ShellRecordModel *)recordModel {
    if (!recordModel.recordId) {
        recordModel.recordId = [self recordId];
    }
    
    if (!recordModel.createDate) {
        recordModel.createDate = [[NSDate date] stringWithFormat:@"YYYY-MM-dd"];
    }
    if (!recordModel.createTime) {
        recordModel.createTime = [[NSDate date] stringWithFormat:@"YYYY-MM-dd HH:mm:ss"];
    }

    // 保存当前记录的id，便于查询
    [self storeTodayDataArray:recordModel.recordId];
    NSDictionary *dict = [recordModel convertDictionary];
    
    [dict writeToFile:kCachePath(recordModel.recordId) atomically:YES];
}

+ (void)modifyRecordModel:(ShellRecordModel *)recordModel {
    if (!recordModel.recordId) {
        NSLog(@"%s %d\n修改的记录id不存在",__func__,__LINE__);
        return;
    }
    NSDictionary *dict = [recordModel convertDictionary];
    [dict writeToFile:kCachePath(recordModel.recordId) atomically:YES];
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
        [self storeTodayArray:dateStr];
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

+ (NSString *)recordId {
    NSString *key = @"record_id_index";
    NSInteger recordid = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    recordid++;
    [[NSUserDefaults standardUserDefaults] setInteger:recordid forKey:key];
    return [NSString stringWithFormat:@"%ld",recordid];
}

@end
