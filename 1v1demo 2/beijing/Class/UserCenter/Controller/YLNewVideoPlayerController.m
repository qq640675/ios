//
//  YLNewVideoPlayerController.m
//  beijing
//
//  Created by zhou last on 2018/10/31.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLNewVideoPlayerController.h"
#import "NSString+Util.h"
#import <AVFoundation/AVFoundation.h>
#import <SVProgressHUD.h>
#import "DefineConstants.h"

@interface YLNewVideoPlayerController ()

@property (weak, nonatomic) IBOutlet UIView *videoBgView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

//视频播放
@property (strong, nonatomic) AVPlayer *player;

@end

@implementation YLNewVideoPlayerController

- (void)viewWillAppear:(BOOL)animated
{
    self.player = nil;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    self.backButton.frame = CGRectMake(0, SafeAreaTopHeight-44, 44, 44);
    [self startVideoPlay:self.videoUrlPath];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    self.player = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark ---- 播放视频
- (void)startVideoPlay:(NSString *)videoPath
{
    NSURL *linkURL = nil;
    if (![NSString isNullOrEmpty:videoPath]) {
        linkURL = [NSURL URLWithString:videoPath];
    }
    
    if (linkURL != nil) {
        /**AVPlayer*/
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:linkURL];
        if (self.player == nil) {
            self.player = [AVPlayer playerWithPlayerItem:item];
            // 4.添加AVPlayerLayer
            AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            layer.frame = self.view.frame;
            [self.videoBgView.layer addSublayer:layer];
            [self.player play];
            // 监听播放结束通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        }
    }else{
        [SVProgressHUD showInfoWithStatus:@"视频地址有误!"];
    }
}

/**FIXME: - 处理重复播放*/
- (void)playerItemDidPlayToEnd:(NSNotification *)notification{
    // 重复播放, 从起点开始重播, 没有内存暴涨
    __weak typeof(self) weak_self = self;
    [self.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (!strong_self) return;
        [strong_self.player play];
    }];
}

#pragma mark ---- 返回
- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
