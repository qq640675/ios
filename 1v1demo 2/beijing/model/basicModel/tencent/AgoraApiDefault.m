//
//  AgoraApiDefault.m
//  beijing
//
//  Created by wjx on 2024/12/21.
//  Copyright © 2024 zhou last. All rights reserved.
//

#import "AgoraApiDefault.h"

@implementation AgoraApiDefault
+ (AgoraApiDefault *)apiDefault
{
    AgoraApiDefault *apiDefault = [AgoraApiDefault new];
    return apiDefault;
}
- (NSString *)appid
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"appid"];
}
+ (void)saveTmpAppid:(NSString *)appid
{
    [[NSUserDefaults standardUserDefaults] setObject:appid forKey:@"appid"];
}
@end
