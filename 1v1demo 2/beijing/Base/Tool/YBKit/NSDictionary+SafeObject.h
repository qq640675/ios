//
//  NSDictionary+SafeObject.h
//  iBIMiPhone
//
//  Created by yuebin on 2018/11/20.
//  Copyright © 2018年 ysg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (SafeObject)

- (NSInteger)safeIntForKey:(NSString *)key;

- (NSString *)safeStringForKey:(NSString *)key;

- (NSDictionary *)safeDictionaryForKey:(NSString *)key;

- (BOOL)safeBoolForKey:(NSString *)key;

- (float)safeFloatForKey:(NSString *)key;

- (NSURL *)safeUrlForKey:(NSString *)key;

- (NSArray *)safeArrayForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
