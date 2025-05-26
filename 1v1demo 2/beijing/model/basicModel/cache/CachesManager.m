//
//  CachesManager.m
//  beijing
//
//  Created by zhou last on 2018/9/15.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "CachesManager.h"

static CachesManager *_cachesManager = nil;

@implementation CachesManager
{
    NSString *_cachesDirPath;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *cachesPath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        _cachesDirPath = [cachesPath copy];
    }
    return self;
}
+ (CachesManager *)sharedManager {
    if (_cachesManager == nil) {
        @synchronized(self) {
            if (_cachesManager == nil) {
                _cachesManager = [[[self class] alloc] init];
            }
        }
    }
    return _cachesManager;
}

- (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (float)requestCachesFileSize {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:_cachesDirPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:_cachesDirPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [_cachesDirPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (NSString *)getAllTheCacheFileSize
{
    return [NSString stringWithFormat:@"%.2f MB",[self requestCachesFileSize]];
}

- (BOOL)clearCaches {
    if([self requestCachesFileSize] > 0) {
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:_cachesDirPath];
        for (NSString *file in files) {
            NSString *path = [_cachesDirPath stringByAppendingPathComponent:file];
            if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
        }
        return YES;
    } else {
        return NO;
    }
}

@end
