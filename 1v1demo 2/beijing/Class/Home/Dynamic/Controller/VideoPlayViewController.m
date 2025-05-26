//
//  VideoPlayViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/5/26.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "DYVideoView.h"
#import "videoListHandle.h"

@interface VideoPlayViewController ()
{
    DYVideoView *nowView;
}

@end

@implementation VideoPlayViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setSubView];
    [self requestVideoData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (nowView.isloadedVideo == YES) {
        [self playingVideo];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self pauseNowVideo];
}

#pragma mark - net
- (void)requestVideoData {
    [SVProgressHUD show];
    [YLNetworkInterface getAnchorPlayPage:[YLUserDefault userDefault].t_id albumId:self.videoId coverConsumeUserId:self.godId queryType:self.queryType block:^(videoPayHandle *handle) {
        self->nowView.handle = handle;
    }];
}

#pragma mark - subViews
- (void)setSubView {
    nowView = [[DYVideoView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    [nowView setDefaultData];
    nowView.isloadedVideo = NO;
    nowView.videoCoverUrl = self.coverImageUrl;
    videoListHandle *videoHandle = [[videoListHandle alloc] init];
    videoHandle.t_user_id = self.godId;
    nowView.videoHandle = videoHandle;
    [self.view addSubview:nowView];
    [self playingVideo];
}

#pragma mark - play
- (void)playingVideo {
    if (nowView.isloadedVideo == YES) {
        // 加载过 就继续播放
        [nowView.player resume];
    } else {
        // 没加载过 就开始播放
        nowView.isloadedVideo = YES;
        [nowView.player playWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.videoUrl]] sameSource:NO];
    }
}

- (void)pauseNowVideo {
    [nowView.player pause];
}



@end
