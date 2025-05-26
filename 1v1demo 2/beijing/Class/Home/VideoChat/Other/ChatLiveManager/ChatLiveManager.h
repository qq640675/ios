//
//  ChatLiveManager.h
//  beijing
//
//  Created by yiliaogao on 2019/2/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnchorChatLivingViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface ChatLiveManager : NSObject

@property (nonatomic, copy)   NSString *rtcToken;

@property (nonatomic, assign) int  userId;

@property (nonatomic, assign) int  anchorId;

@property (nonatomic, assign) int  roomId;

@property (nonatomic, assign) BOOL isUser;

@property (nonatomic, copy) void (^callFailBlock)(void);


@property (nonatomic, assign) int videoType;

//实例
+ (id)shareInstance;

//获取视频签名
- (void)getVideoChatAutographWithOtherId:(int)otherId type:(int)videoType fail:(void (^ _Nullable)(void))fail;

@end

NS_ASSUME_NONNULL_END
