//
//  SLDefaultsHelper.m
//  JFQ
//
//  Created by lunubao on 2018/6/28.
//  Copyright © 2018年 LSL. All rights reserved.
//

#import "SLDefaultsHelper.h"

@implementation SLDefaultsHelper

+ (NSObject *)getSLDefaults:(NSString *)strKey {
    if (strKey.length <= 0) {
        return nil;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSObject *obj = [user valueForKey:strKey];
    return obj;
}

+ (void)saveSLDefaults:(NSObject* )obj key:(NSString *)strKey {
    if (obj == nil || strKey.length <= 0) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:obj forKey:strKey];
    [user synchronize];
}

+ (void)deleteSLDefaulte:(NSString *)strKey {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:strKey];
    [user synchronize];
}

@end
