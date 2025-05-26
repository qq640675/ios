//
//  KJJPushHelper.h
//  beijing
//
//  Created by zhou last on 2018/8/7.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KJJPushHelper : NSObject

// 在应用启动的时候调用
+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction
  advertisingIdentifier:(NSString *)advertisingId;

// 在appdelegate注册设备处调用
+ (void)registerDeviceToken:(NSData *)deviceToken;

// ios7以后，才有completion，否则传nil
+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion;

// 显示本地通知在最前面
+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification;

//设置别名
+ (void)setAlias:(int)userId;

//删除别名
+ (void)deleteAlias;

@end
