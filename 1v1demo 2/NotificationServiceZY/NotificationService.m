//
//  NotificationService.m
//  NotificationServiceZY
//
//  Created by zhou last on 2018/11/27.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "NotificationService.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

@interface NotificationService ()
{
    dispatch_source_t timer;
    AVAudioPlayer *audioPlay;
}

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    
    NSLog(@"___________didReceiveNotificationRequest:%@ self.bestAttemptContent:%@",contentHandler,self.bestAttemptContent);

    [self startSystemSound];

    self.contentHandler(self.bestAttemptContent);
}

- (void)startSystemSound{
//    dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
//    // 创建一个 timer 类型定时器 （ DISPATCH_SOURCE_TYPE_TIMER）
//
//    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//
//    //设置定时器的各种属性（何时开始，间隔多久执行）
//    // GCD 的时间参数一般为纳秒 （1 秒 = 10 的 9 次方 纳秒）
//    // 指定定时器开始的时间和间隔的时间
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC, 0);
//    // 任务回调
//    dispatch_source_set_event_handler(timer, ^{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    });
//    // 开始定时器任务（定时器默认开始是暂停的，需要复位开启）
//    dispatch_resume(timer);
}


- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
