//
//  VideoPlayViewController.m
//  CQTNews
//
//  Created by Base on 2017/3/9.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "MyVideoPlayViewController.h"
//#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "DefineConstants.h"

@interface MyVideoPlayViewController ()

@property (strong, nonatomic) AVPlayer *player;
@property (copy, nonatomic) id clickBlock;
@end

@implementation MyVideoPlayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KBLACKCOLOR;
    
    NSURL *linkURL = [NSURL URLWithString:self.linkURL];
    
    /**AVPlayer*/
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:linkURL];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    self.player = player;
    // 4.添加AVPlayerLayer
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = self.view.frame;
    [self.view.layer addSublayer:layer];
    [player play];
    // 监听播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromParentViewController];
    [self resetOldStatus];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self resetOldStatus];
    void(^clickBlock)(id info) = self.clickBlock;
    if (clickBlock) {
        clickBlock(nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private

- (void)resetOldStatus{
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark - Public

- (void)clickSelfViewBlock:(void(^)(id info))clickBlock{
    if (clickBlock) {
        self.clickBlock = clickBlock;
    }
}

@end
