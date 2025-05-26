//
//  AgoraManager.m
//  beijing
//
//  Created by 黎 涛 on 2020/11/21.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "AgoraManager.h"

@implementation AgoraManager

#pragma mark - shareManagerz
+ (AgoraManager *)shareManager {
    static dispatch_once_t onceToken;
    static AgoraManager *manager = nil;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[AgoraManager alloc] init];
        }
    });
    return manager;
}

#pragma mark - 1v1
- (void)joinChannelWithRoomId:(int)roomId addDelegate:(id)delegateOb isVideo:(BOOL)isVideo success:(nonnull void (^)(NSString * _Nonnull))success fail:(nonnull void (^)(void))fail{
    [YLNetworkInterface getAgoraRoomSignWithRoomId:roomId Success:^(NSString *rtcToken) {
        self.rtcEngineKit = [AgoraRtcEngineKit sharedEngineWithAppId:basicAgoraAppId delegate:delegateOb];
        [self.rtcEngineKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];//场景
        [self.rtcEngineKit setClientRole:AgoraClientRoleBroadcaster];
        if (isVideo) {
            [self.rtcEngineKit setExternalVideoSource:YES useTexture:YES pushMode:YES];
            [self.rtcEngineKit enableVideo];
        } else {
            [self.rtcEngineKit disableVideo];
        }
        
        [self.rtcEngineKit joinChannelByToken:rtcToken channelId:[NSString stringWithFormat:@"%d", roomId] info:nil uid:[YLUserDefault userDefault].t_id joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
            NSLog(@"___AGORA join room channel:%@ id:%ld elapsed:%ld", channel, uid, elapsed);
            if (success) {
                success(rtcToken);
            }
        }];
    } fail:^{
        if (fail) {
            fail();
        }
    }];
}

#pragma mark - mansion
- (void)joinMansionChannelWithRoomId:(int)roomId addDelegate:(id)delegateOb chatType:(MansionChatType)chatType success:(void (^)(void))success fail:(void (^)(void))fail {
    [YLNetworkInterface getAgoraRoomSignWithRoomId:roomId Success:^(NSString *rtcToken) {
        self.rtcEngineKit = [AgoraRtcEngineKit sharedEngineWithAppId:basicAgoraAppId delegate:delegateOb];
        [self.rtcEngineKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];//场景
        [self.rtcEngineKit setClientRole:AgoraClientRoleBroadcaster];
        if (chatType == MansionChatTypeVideo) {
            [self.rtcEngineKit setExternalVideoSource:YES useTexture:YES pushMode:YES];
            [self.rtcEngineKit enableVideo];
        } else {
            [self.rtcEngineKit disableVideo];
        }
        
        [self.rtcEngineKit joinChannelByToken:rtcToken channelId:[NSString stringWithFormat:@"%d", roomId] info:nil uid:[YLUserDefault userDefault].t_id joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
            NSLog(@"___AGORA join room channel:%@ id:%ld elapsed:%ld", channel, uid, elapsed);
            if (success) {
                success();
            }
        }];
    } fail:^{
        if (fail) {
            fail();
        }
    }];
}

#pragma mark - local video
//- (void)setLocalView:(UIView *)view {
//    if (!self.localVideoCanvas) {
//        self.localVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
//        self.localVideoCanvas.uid = [YLUserDefault userDefault].t_id;
//        self.localVideoCanvas.renderMode = AgoraVideoRenderModeHidden;
//    }
//    self.localVideoCanvas.view = nil;
//    self.localVideoCanvas.view = view;
//    [self.rtcEngineKit setupLocalVideo:self.localVideoCanvas];
//}
//
//- (void)startPreview {
//    [self.rtcEngineKit startPreview];
//}
//
//- (void)stopPreview {
//    [self.rtcEngineKit stopPreview];
//}

#pragma mark - remote video
- (void)setRemoteViewWithId:(NSInteger)uid view:(UIView *)view {
    if (!self.remoteVideoCanvas) {
        self.remoteVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        self.remoteVideoCanvas.renderMode = AgoraVideoRenderModeHidden;
    }
    self.remoteVideoCanvas.uid = uid;
    self.remoteVideoCanvas.view = nil;
    self.remoteVideoCanvas.view = view;
    [self.rtcEngineKit setupRemoteVideo:self.remoteVideoCanvas];
}

#pragma mark - video & voice
//- (void)enableLocalVideo:(BOOL)enabled {
//    [self.rtcEngineKit enableLocalVideo:enabled];
//}

//- (void)switchCamera {
//    [self.rtcEngineKit switchCamera];
//}

- (void)muteLocalVideoStream:(BOOL)mute {
    [self.rtcEngineKit muteLocalVideoStream:mute];
}

- (void)muteLocalAudioStream:(BOOL)mute {
    [self.rtcEngineKit muteLocalAudioStream:mute];
}

- (void)muteRemoteAudioStream:(NSUInteger)uid mute:(BOOL)mute {
    [self.rtcEngineKit muteRemoteAudioStream:uid mute:mute];
}

- (void)setVideoEncoderMirrorMode:(AgoraVideoMirrorMode)mode {
    AgoraVideoEncoderConfiguration *config = [[AgoraVideoEncoderConfiguration alloc] init];
    config.mirrorMode = mode;
    [self.rtcEngineKit setVideoEncoderConfiguration:config];
}

#pragma mark - leaveChannel
- (void)leaveChannel {
    [self.rtcEngineKit muteLocalAudioStream:NO];
    [self.rtcEngineKit setDefaultAudioRouteToSpeakerphone:YES];
    [self.rtcEngineKit setEnableSpeakerphone:YES];
    [self.rtcEngineKit stopPreview];
    [self.rtcEngineKit stopAudioMixing];
    [self.rtcEngineKit stopAudioRecording];
    [self.rtcEngineKit setVideoSource:nil];
    [self.rtcEngineKit leaveChannel:nil];
    self.rtcEngineKit.delegate = nil;
    [AgoraRtcEngineKit destroy];
}



@end
