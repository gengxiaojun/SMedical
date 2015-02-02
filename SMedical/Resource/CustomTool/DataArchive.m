//
//  DataArchive.m
//  SMedical
//
//  Created by _SS on 14/12/18.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "DataArchive.h"

@implementation DataArchive

+ (instancetype)sharedShower{
    static DataArchive *shower = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shower = [[DataArchive alloc] init];
    });
    return shower;
}

//  归档数据存储的路径
- (NSString *)filePathOfArchive{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filePath = [cachesPath stringByAppendingPathComponent:@"archive"];
    return filePath;
}
#pragma mark - 
#pragma mark - 详情页面cell移动数据归档
- (void)archiveDetalsShowWithDic:(NSDictionary *)dic{
    NSString *filePath = [self filePathOfArchive];
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    for (NSString *key in [dic allKeys]) {
        [archiver encodeObject:[dic objectForKey:key] forKey:key];
    }
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}

- (id)unArchiveDetalsShowWithKey:(NSString *)key{
    NSString *filePath = [self filePathOfArchive];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id object = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    return object;
}
//  删除归档数据
- (void)deleteData{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager changeCurrentDirectoryPath:cachesPath];
    [fileManager removeItemAtPath:@"archiveData" error:nil];
}

@end
