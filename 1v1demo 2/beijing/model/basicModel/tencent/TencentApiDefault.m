//
//  TencentApiDefault.m
//  beijing
//
//  Created by zhengzw on 2024/12/7.
//  Copyright © 2024 zhou last. All rights reserved.
//

#import "TencentApiDefault.h"

@implementation TencentApiDefault

+ (TencentApiDefault *)apiDefault
{
    TencentApiDefault *apiDefault = [TencentApiDefault new];
    return apiDefault;
}

+ (void)saveTmpSecretId:(NSString *)tmpSecretId
{
    [[NSUserDefaults standardUserDefaults] setObject:tmpSecretId forKey:@"TX_tmpSecretId"];
}

- (NSString *)tmpSecretId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"TX_tmpSecretId"];
}

+ (void)saveTmpSecretKey:(NSString *)tmpSecretKey
{
    [[NSUserDefaults standardUserDefaults] setObject:tmpSecretKey forKey:@"TX_tmpSecretKey"];
}
- (NSString *)tmpSecretKey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"TX_tmpSecretKey"];
}

+ (void)saveTmpSessionToken:(NSString *)sessionToken
{
    [[NSUserDefaults standardUserDefaults] setObject:sessionToken forKey:@"TX_sessionToken"];
}
- (NSString *)sessionToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"TX_sessionToken"];
}

+ (void)saveTmpRegion:(NSString *)region
{
    [[NSUserDefaults standardUserDefaults] setObject:region forKey:@"TX_region"];
}
- (NSString *)region
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"TX_region"];
}

+ (void)saveTmpAppid:(NSString *)appid
{
    [[NSUserDefaults standardUserDefaults] setObject:appid forKey:@"TX_appid"];
}



- (NSString *)appid
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"TX_appid"];
}

+ (void)saveTmpBucket:(NSString *)bucket
{
    [[NSUserDefaults standardUserDefaults] setObject:bucket forKey:@"TX_bucket"];
}
- (NSString *)bucket
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"TX_bucket"];
}
@end
