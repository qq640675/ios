//
//  AgoraManager.h
//  beijing
//
//  Created by 黎 涛 on 2020/11/21.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AgoraManager : NSObject


@property (nonatomic, strong) AgoraRtcEngineKit *rtcEngineKit;
@property (nonatomic, strong) AgoraRtcVideoCanvas *localVideoCanvas;
@property (nonatomic, strong) AgoraRtcVideoCanvas *remoteVideoCanvas;

#pragma mark - shareManager
+ (AgoraManager *)shareManager;

#pragma mark - 1v1
/// 1v1  agora 进入房间
/// @param roomId 房间Id
/// @param delegateOb delegate对象
/// @param isVideo 是否是视频模式：NO，纯音频模式
/// @param success 进入房间成功回调
/// @param fail 获取签名失败回调
- (void)joinChannelWithRoomId:(int)roomId addDelegate:(id)delegateOb isVideo:(BOOL)isVideo success:(void (^)(NSString *token))success fail:(void (^)(void))fail;

#pragma mark - mansion
- (void)joinMansionChannelWithRoomId:(int)roomId addDelegate:(id)delegateOb chatType:(MansionChatType)chatType success:(void (^)(void))success fail:(void (^)(void))fail;

#pragma mark - local video  这里使用的相芯相机采集 不使用声网的本地视图
/// 设置本地视图
/// @param view 本地视图显示view
//- (void)setLocalView:(UIView *)view;
//
//- (void)startPreview;
//- (void)stopPreview;

#pragma mark - remote video
/// 设置远端视频呢
/// @param uid 远端uid
/// @param view 远端视图显示view
- (void)setRemoteViewWithId:(NSInteger)uid view:(UIView *)view;

#pragma mark - video & voice
//- (void)enableLocalVideo:(BOOL)enabled;
//- (void)switchCamera;
- (void)muteLocalVideoStream:(BOOL)mute;
- (void)muteLocalAudioStream:(BOOL)mute;
- (void)muteRemoteAudioStream:(NSUInteger)uid mute:(BOOL)mute;
- (void)setVideoEncoderMirrorMode:(AgoraVideoMirrorMode)mode;

#pragma mark - leaveChannel
/// 离开房间
- (void)leaveChannel;


@end

NS_ASSUME_NONNULL_END
