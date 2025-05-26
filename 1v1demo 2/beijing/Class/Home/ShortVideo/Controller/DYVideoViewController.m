//
//  DYVideoViewController.m
//  beijing
//
//  Created by 黎 涛 on 2019/8/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

// vc
#import "DYVideoViewController.h"
#import "YLRechargeVipController.h"
// view
#import "DYVideoView.h"
#import "insufficientView.h"
#import "YLBasicView.h"
#import "PrivacyCheckAlertView.h"
// other
#import "YLTapGesture.h"
#import "YLInsufficientManager.h"

#define videoWindow [UIApplication sharedApplication].keyWindow


@interface DYVideoViewController ()<UIScrollViewDelegate>
{
    UIScrollView *videoScroll;
    
    DYVideoView *lastView;
    DYVideoView *nowView;
    DYVideoView *nextView;
    
    videoListHandle *lastHandle;
    videoListHandle *nowHandle;
    videoListHandle *nextHandle;
    
    BOOL isUp; //是否向上滑动
    BOOL isTop; //是否到顶了
    BOOL isBottom; //是否到底了
    BOOL isCanLoadMore; //是否还能加载更多
    
    
    // 充值  vip
    videoListHandle *videoVipHandle; //视频model
    insufficientView *insuffiView;//余额不足弹框
    UIImageView *lastPayMethodImgView; //上一个支付方式 微信 支付宝
    UIImageView *lastRechargeImgView; //上一个充值按钮
    
    YLVideoRechargeType videoRechargeType;//充值列表
    YLVideoPayType videoPayType;//支付方式
    NSMutableArray *rechargeListArray; //充值列表
    UIButton *lastButton; //上一个按钮
}

@end

@implementation DYVideoViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    isCanLoadMore = YES;
    [self setScrollView];
    
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [self pauseNowVideo:YES];
}

#pragma mark - not
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAudioPlayer) name:@"enterBackgroundStopAudio" object:nil];
}

- (void)stopAudioPlayer {
    [nowView.player stop];
}

#pragma mark - setSubViews
- (void)setScrollView {
    videoScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    videoScroll.showsVerticalScrollIndicator = NO;
    videoScroll.contentSize = CGSizeMake(App_Frame_Width, APP_Frame_Height*3);
    videoScroll.contentOffset = CGPointMake(0, APP_Frame_Height);
    videoScroll.pagingEnabled = YES;
    videoScroll.delegate = self;
    videoScroll.scrollsToTop = NO;
    videoScroll.bounces = NO;
    [self.view addSubview:videoScroll];
    
    if (@available(iOS 11.0, *)) {
        [videoScroll setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToBack)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [videoScroll addGestureRecognizer:swipe];
    
    lastView = [[DYVideoView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    [videoScroll addSubview:lastView];
    
    nowView = [[DYVideoView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height, App_Frame_Width, APP_Frame_Height)];
    WEAKSELF
    nowView.playOrPause = ^(BOOL isPlaying) {
        [weakSelf pauseNowVideo:isPlaying];
    };

    [videoScroll addSubview:nowView];
    
    nextView = [[DYVideoView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height*2, App_Frame_Width, APP_Frame_Height)];
    [videoScroll addSubview:nextView];
    
    [self scrollDefaultSet];
}

- (void)scrollDefaultSet {
    if (self.videoArray.count > self.videoIndex-1) {
        lastHandle = self.videoArray[self.videoIndex-1];
        lastView.videoHandle = lastHandle;
    }
    if (self.videoIndex == 0) {
        [lastView setupDefaultCoverImage];
    }
    if (self.videoArray.count > self.videoIndex) {
        nowHandle = self.videoArray[self.videoIndex];
        nowView.videoHandle = nowHandle;
        nowView.isloadedVideo = NO;
        [nowView setDefaultData];
        [self loadHandle];
    }
    if (self.videoArray.count > self.videoIndex+1) {
        nextHandle = self.videoArray[self.videoIndex+1];
        nextView.videoHandle = nextHandle;
    }
    
    if (self.videoArray.count == self.videoIndex+1) {
        [nextView setupDefaultCoverImage];
    }
    
    [nowView.player stop];
    [nowView.player.playerView setHidden:YES];
    [self playNowVideo];
}


#pragma mark - func
- (void)loadHandle {
    [YLNetworkInterface getAnchorPlayPage:[YLUserDefault userDefault].t_id albumId:nowHandle.t_id coverConsumeUserId:nowHandle.t_user_id queryType:self.queryType block:^(videoPayHandle *handle) {
        self->nowView.handle = handle;
    }];
}

#pragma mark - play
- (void)playNowVideo {
    nowView.isPlaying = YES;
    if ([nowHandle.t_is_private intValue] == 1) {
        //私密
        if (nowHandle.is_see == 1) {
            //看过
            [self payingVideo];
        }else{
            if (![YLUserDefault userDefault].t_is_vip) {
                //vip
                [self payingVideo];
            } else {
                nowView.isPlaying = NO;
                [self vipGradeSet:nowHandle];
            }
        }
    }else{
        //公开
        [self payingVideo];
    }
}

- (void)payingVideo {
    nowView.isPlaying = YES;
    nowView.isloadedVideo = YES;
    [nowView.player playWithURL:[NSURL URLWithString:nowHandle.t_addres_url] sameSource:NO];
}

- (void)pauseNowVideo:(BOOL)isPlaying {
    nowView.isPlaying = !isPlaying;
    if (isPlaying == YES) {
        [nowView.player pause];
    } else {
        if (nowView.isloadedVideo == YES) {
            // 加载过 就继续播放
            [nowView.player resume];
        } else {
            // 没加载过 就开始播放
            [self playNowVideo];
        }
    }
}


#pragma mark ----- 弹出vip升级框
- (void)vipGradeSet:(videoListHandle *)handle
{
    videoVipHandle = handle;
    WEAKSELF;
    PrivacyCheckAlertView *alertView = [[PrivacyCheckAlertView alloc] initWithType:@"视频" coin:[handle.t_money intValue]];
    alertView.sureButtonClickBlock = ^{
        [weakSelf cosumeOkBtnBeClicked];
    };
    
}

#pragma mark ---- 确定消费
- (void)cosumeOkBtnBeClicked {
    [YLNetworkInterface seeVideoConsumeUserId:[YLUserDefault userDefault].t_id coverConsumeUserId:videoVipHandle.t_user_id videoId:videoVipHandle.t_id block:^(int code) {
        if (code == 1) {
            [self refreshConsumeStatus];
            [self payingVideo];
        }else if (code == -1){
            //余额不足
            [[YLInsufficientManager shareInstance] insufficientShow];
        }
    }];
}

#pragma mari --- 更改消费过后的遮罩展示效果
- (void)refreshConsumeStatus
{
    videoListHandle *handle = self.videoArray[self.videoIndex];
    handle.is_see = 1;
}

#pragma mark - UIScrollViewDelegate
// scrollView 位置发生改变是调用  多次调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.videoIndex <= 0 && scrollView.contentOffset.y < APP_Frame_Height) {
        [SVProgressHUD showInfoWithStatus:@"已经到顶了哦~"];
//        videoScroll.contentOffset = CGPointMake(0, APP_Frame_Height);
        isTop = YES;
        return;
    } else if (self.videoIndex >= self.videoArray.count - 1 && scrollView.contentOffset.y > APP_Frame_Height) {
        [SVProgressHUD showInfoWithStatus:@"已经到底了哦~"];
//        videoScroll.contentOffset = CGPointMake(0, APP_Frame_Height);
        isBottom = YES;
        return;
    } else if (scrollView.contentOffset.y < APP_Frame_Height) {
        // 这里是向下滑  获取上一个内容
        isUp = NO;
    } else if (scrollView.contentOffset.y > APP_Frame_Height) {
        // 这里是向上滑 获取下一个内容
        isUp = YES;
    }
    
}

// 开始滚动时执行 一次有效滑动调用一次
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    isTop = NO;
    isBottom = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self scrollingDataChanged];
    }
}

// 停止滑动时候调用 一次有效滑动调用一次
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollingDataChanged];
}

#pragma mark - 滑动时的数据变化处理
- (void)scrollingDataChanged {
    if(APP_Frame_Height == videoScroll.contentOffset.y) {
        return;
    }
    if (isTop == YES || isBottom == YES) {
        videoScroll.contentOffset = CGPointMake(0, APP_Frame_Height);
        return;
    }
    //滑动停止
    if (isUp == YES) {
        self.videoIndex ++;
        if (self.videoIndex >= self.videoArray.count-2) {
            // 还剩两个的时候就需要加载更多
            [self loadMore];
        }
    } else {
        self.videoIndex --;
    }
    
    videoScroll.contentOffset = CGPointMake(0, APP_Frame_Height);
    [self scrollDefaultSet];
}

#pragma mark - load more
- (void)loadMore {
    if (self.videoArray.count < 10 || isCanLoadMore == NO) {
        return;
    }
    self.page ++;
    [YLNetworkInterface getVideoListUserId:[YLUserDefault userDefault].t_id page:self.page queryType:self.videoType block:^(NSMutableArray *listArray) {
        if (listArray.count < 10 || listArray == nil) {
            self->isCanLoadMore = NO;
        }
        for (videoListHandle *handle in listArray) {
            [self->_videoArray addObject:handle];
        }
    }];
}

#pragma mark - func
- (void)swipeToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    nowView.player = nil;
}

@end
