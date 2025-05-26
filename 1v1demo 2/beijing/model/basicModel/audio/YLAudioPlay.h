//
//  YLAudioPlay.h
//  wavDemo
//
//  Created by zhou last on 2018/7/27.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YLAudioPlay : NSObject

//实例
+ (id)shareInstance;

//发起通话或对方邀请通话
- (void)callPlay;

//结束播放
- (void)callEndPlay;

- (int)playTime;

//开始震动
- (void)startAlertSound;

//结束震动
-(void)stopDisplayLink;

- (void)callMSGPlay;

- (void)callMSGEndPlay;

- (void)anchorMatchingCallPlay;

- (void)callEndNoSoundsPaly;

- (void)startPlayNoVoiceMP3;

- (void)stopPlayNoVoiceMP3;

@end
