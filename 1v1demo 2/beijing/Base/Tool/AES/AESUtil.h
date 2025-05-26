//
//  AESUtil.h
//  beijing
//
//  Created by wjx on 2024/12/21.
//  Copyright © 2024 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AESUtil : NSObject
// AES 加密
+ (NSString *)encrypt:(NSString *)content withKey:(NSString *)key;

// AES 解密
+ (NSString *)decrypt:(NSString *)content withKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
