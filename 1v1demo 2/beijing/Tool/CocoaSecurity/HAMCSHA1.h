//
//  HAMCSHA1.h
//  beijing
//
//  Created by 黎 涛 on 2020/3/16.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HAMCSHA1 : NSObject
+(NSString *)HmacSha1:(NSString *)key data:(NSString *)data;
+(NSString *)HmacSha1WithKey:(NSString *)key data:(NSString *)data;

@end

NS_ASSUME_NONNULL_END
