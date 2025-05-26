//
//  DYVideoView.h
//  beijing
//
//  Created by 黎 涛 on 2019/8/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
// model
#import "videoListHandle.h"
#import "videoPayHandle.h"
#import <PLPlayerKit/PLPlayerKit.h>

@interface DYVideoView : BaseView
<
PLPlayerDelegate
>

@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) videoListHandle *videoHandle;
@property (nonatomic, strong) videoPayHandle *handle;

@property (nonatomic, strong) PLPlayer  *player;

@property (nonatomic, assign) BOOL isloadedVideo; //是否已经加载过视频地址
@property (nonatomic, assign) BOOL isPlaying; //是否正在播放
@property (nonatomic, copy) NSString *videoCoverUrl;
@property (nonatomic, copy) void (^playOrPause)(BOOL isPlaying); //播放暂定点击

- (void)setDefaultData;

- (void)setupDefaultCoverImage;

@end

