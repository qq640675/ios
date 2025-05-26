//
//  CacheManager.h
//  beijing
//
//  Created by 黎 涛 on 2019/6/29.
//  Copyright © 2019 zhou last. All rights reserved.
//

// 录音缓存文件地址
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheManager : NSObject

+ (NSString *)recorderPathWithFileName:(NSString *)fileName;

+ (NSString *)recorderMP3PathWithFileName:(NSString *)fileName;

+ (void)recorderDeleteFileWithName:(NSString *)fileName;

//录音文件转码 pcm->mp3
+ (void)recorderPCMtoMP3WithFileName:(NSString *)fileName success:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
