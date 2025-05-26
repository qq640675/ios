//
//  LiveRoomViewController.h
//  Demo03_创建直播间
//
//  Created by jameskhdeng(邓凯辉) on 2018/3/30.
//  Copyright © 2018年 Tencent. All rights reserved.
//  房间页

#import <UIKit/UIKit.h>
#import <ILiveSDK/ILiveCoreHeader.h>

typedef enum : NSUInteger {
    YLRoomTypeCreateRoom = 0,
    YLRoomTypeJoinRoom,
} YLRoomType;

@interface LiveRoomViewController : UIViewController <ILiveMemStatusListener, ILiveRoomDisconnectListener>

@property (nonatomic ,assign) YLRoomType roomType;
@property (nonatomic ,assign) int godId; //主播id
@end
