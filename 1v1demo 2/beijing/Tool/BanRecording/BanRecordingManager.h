//
//  BanRecordingManager.h
//  beijing
//
//  Created by 黎 涛 on 2020/5/22.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BanRecordingManager : NSObject

/*
 ** 3.0 新增截屏录屏限制
 ** 使用说明
 ** 如果需要全局限制  在AppDelegate 添加通知即可
 ** 如果是单独某个VC限制 则在该控制器的viewWillAppear方法里添加通知，并且需要在viewWillDisappear方法里移除通知
 */
+ (instancetype)shareManager;
- (void)addBanScreenRecordingNotification;
- (void)removeBanScreenRecordingNotification;

@end

NS_ASSUME_NONNULL_END
