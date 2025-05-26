//
//  NSDictionary+SafeObject.m
//  iBIMiPhone
//
//  Created by yuebin on 2018/11/20.
//  Copyright © 2018年 ysg. All rights reserved.
//

#import "NSDictionary+SafeObject.h"

@implementation NSDictionary (SafeObject)

- (BOOL)objIsNull {
    return (self == nil || [self isEqual:[NSNull null]]) ? YES : NO;
}

+ (BOOL)objIsNull:(id)obj {
    return (obj == nil || [obj isEqual:[NSNull null]]) ? YES : NO;
}

- (NSInteger)safeIntForKey:(NSString *)key {
    
    if ([self objIsNull] || ![self isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return -1;
    }
    
    if ([NSDictionary objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"(字典）key非法");
        return -1;
    }
    
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return ((NSString *)value).intValue;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)value).integerValue;
    }
    if ([value isKindOfClass:NSNull.class]) {
        return 0;
    }
    return -1;
}

- (NSString *)safeStringForKey:(NSString *)key {
    
    if ([self objIsNull] || ![self isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return @"";
    }
    
    if ([NSDictionary objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"（string）key非法");
        return @"";
    }
    
    NSString *value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)value).stringValue;
    }
    
    if ([value isKindOfClass:[NSString class]] && (value != nil) ) {
        return value;
    }
    return @"";
}

- (NSDictionary *)safeDictionaryForKey:(NSString *)key {
    
    if ([self objIsNull] || ![self isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return @{};
    }
    
    if ([NSDictionary objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"（字典）key非法");
        return @{};
    }
    
    NSDictionary *value = [self objectForKey:key];
    if ([value isKindOfClass:[NSDictionary class]] && (value != nil)) {
        return value;
    }
    return @{};
}

- (BOOL)safeBoolForKey:(NSString *)key {
    
    if ([self objIsNull] || ![self isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return NO;
    }
    
    if ([NSDictionary objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"（bool）key非法");
        return NO;
    }
    
    NSString *value = [self objectForKey:key];
    if ((value != nil) || [value isKindOfClass:[NSString class]]) {
        return value.boolValue;
    }
    return NO;
}

- (float)safeFloatForKey:(NSString *)key {
    if ([self objIsNull] || ![self isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return -1.0f;
    }
    
    if ([NSDictionary objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"(float）key非法");
        return -1.0f;
    }
    
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return ((NSString *)value).floatValue;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)value).floatValue;
    }
    return -1.0f;
}

- (NSURL *)safeUrlForKey:(NSString *)key {
    if ([self objIsNull] || ![self isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return [NSURL URLWithString:@""];
    }
    
    if ([NSDictionary objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"（url）key非法");
        return [NSURL URLWithString:@""];
    }
    
    NSString *value = [self objectForKey:key];
    if ((value != nil) && [value isKindOfClass:[NSString class]]) {
        NSString *url = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return [NSURL URLWithString:url];
    }
    return [NSURL URLWithString:@""];
}

- (NSArray *)safeArrayForKey:(NSString *)key {
    if ([self objIsNull] || ![self isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return @[];
    }
    
    if ([NSDictionary objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"（array）key非法");
        return @[];
    }
    
    NSArray *value = [self objectForKey:key];
    if ((value != nil) && [value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return @[];
}


@end
