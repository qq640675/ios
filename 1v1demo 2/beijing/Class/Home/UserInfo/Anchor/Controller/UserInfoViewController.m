//
//  UserInfoViewController.m
//  beijing
//
//  Created by 黎 涛 on 2019/9/21.
//  Copyright © 2019 zhou last. All rights reserved.
//

// vc
#import "UserInfoViewController.h"
#import "DetailViewController.h"
// view
#import "UserInfoVideoView.h"

@interface UserInfoViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UserInfoVideoView *videoView;
@property (nonatomic, strong) videoPayHandle *videoHandle;
@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, strong) DetailViewController *detailVC;

@end

@implementation UserInfoViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    _lastOffsetY = 0;
    [self setSubViews];
    [self nvideoPlayQuest];
    
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (_videoHandle) {
        if (_mainScrollView.contentOffset.y == 0) {
            [self playVideo];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self pauseVideo];
}

#pragma mark - not
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAudioPlayer) name:@"enterBackgroundStopAudio" object:nil];
}

- (void)stopAudioPlayer {
    [self.videoView.player stop];
}

#pragma mark - net
- (void)nvideoPlayQuest {
    [SVProgressHUD show];
    [YLNetworkInterface getAnchorPlayPage:[YLUserDefault userDefault].t_id albumId:0 coverConsumeUserId:(int)self.anthorId queryType:0 block:^(videoPayHandle *handle) {
        [SVProgressHUD dismiss];
        self.videoHandle = handle;
        self.videoView.videoHandle = handle;
        [self playVideo];
    }];
}

#pragma mark - video set
- (void)playVideo {
    if (_videoView.player.status == PLPlayerStatusPaused) {
        [_videoView.player resume];
    } else {
        [_videoView.player playWithURL:[NSURL URLWithString:_videoHandle.t_addres_url] sameSource:NO];
    }
}

- (void)pauseVideo {
    if (_videoView.player.isPlaying) {
        [_videoView.player pause];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self pauseVideo];
    if (scrollView.isTracking || scrollView.isDecelerating) {
        if (_detailVC.detailTableView.contentOffset.y > 0) {
            scrollView.contentOffset = CGPointMake(0, APP_Frame_Height);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate == NO){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_lastOffsetY == scrollView.contentOffset.y) {
        return;
    }
    _lastOffsetY = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y == 0) {
        [self playVideo];
    } else {
        [self pauseVideo];
    }
}

#pragma mark - subView
- (void)setSubViews {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    _mainScrollView.backgroundColor = UIColor.whiteColor;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.contentSize = CGSizeMake(App_Frame_Width, APP_Frame_Height*2);
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    if (@available(iOS 11.0, *)) {
        _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _videoView = [[UserInfoVideoView alloc] init];
    _videoView.anchorId = self.anthorId;
    [_mainScrollView addSubview:_videoView];

    
    _detailVC = [[DetailViewController alloc] init];
    _detailVC.anthorId = self.anthorId;
    _detailVC.view.frame = CGRectMake(0, APP_Frame_Height, App_Frame_Width, APP_Frame_Height);
    [_mainScrollView addSubview:_detailVC.view];
    [self addChildViewController:_detailVC];
}

#pragma mark - dealloc
- (void)dealloc {
    [self.videoView.player stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
