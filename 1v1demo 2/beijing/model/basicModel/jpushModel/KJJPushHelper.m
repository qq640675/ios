//
//  KJJPushHelper.m
//  beijing
//
//  Created by zhou last on 2018/8/7.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "KJJPushHelper.h"
#import <JPUSHService.h>
#import <SVProgressHUD.h>
#import "YLAudioPlay.h"

@implementation KJJPushHelper

+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction
  advertisingIdentifier:(NSString *)advertisingId{
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    // ios8之后可以自定义category
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        // ios8之前 categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
#endif
    }
#else
    // categories 必须为nil
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
#endif
    // Required
    [JPUSHService setupWithOption:launchingOption appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:advertisingId];
    
    return;
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    return;
}

#pragma mark ---- 设置别名
+ (void)setAlias:(int)userId
{
    [JPUSHService setAlias:[NSString stringWithFormat:@"%d",userId] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
        if (iResCode == 0) {
            NSLog(@"添加别名成功");
        }
    } seq:1];
}


#pragma mark ---- 删除别名
+ (void)deleteAlias
{
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode == 0) {
            NSLog(@"删除别名成功");
        }
    } seq:1];
}


+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion {
    [JPUSHService handleRemoteNotification:userInfo];
    
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    NSString *badge = [apsInfo objectForKey:@"badge"];

    
    NSLog(@"_____Jpush->badge:%@ completion:%@ apsInfo:%@",badge,completion,apsInfo);
    
    if (completion) {
        completion(UIBackgroundFetchResultNewData);
    }
    return;
}

+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification {
    NSLog(@"_____________notif:%@",notification);
    
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    return;
}

@end
