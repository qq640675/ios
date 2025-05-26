//
//  CachesManager.h
//  beijing
//
//  Created by zhou last on 2018/9/15.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CachesManager : NSObject

+ (CachesManager *)sharedManager;

- (BOOL)clearCaches;
- (NSString *)getAllTheCacheFileSize;

- (float)requestCachesFileSize;

@end
