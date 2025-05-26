//
//  DYVideoView.m
//  beijing
//
//  Created by 黎 涛 on 2019/8/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DYVideoView.h"
#import "UIButton+LXMImagePosition.h"
#import "YLPushManager.h"
#import "ChatLiveManager.h"
#import "ZYGiftRedEnvep.h"
#import "ShareManager.h"
#import "YLBasicView.h"
#import "YLTapGesture.h"
#import "YLRechargeVipController.h"
#import "LXTAlertView.h"
#import "ToolManager.h"

@implementation DYVideoView

{
    UIImageView *coverImageView; //封面图
    UIButton *reportBtn; //举报按钮
    UIImageView *headImageView; //头像
    UIButton *followBtn; //关注
    UILabel *nameLabel; //昵称
    UIView *onlinePoint; //在线状态
    UILabel *onLineLabel; //在线状态
    UILabel *ageLabel;
    UIImageView *jtImageView;
    UIView *tapView; //用于添加点击事件
    UIImageView *playImageView;
}



#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blackColor;
        self.userInteractionEnabled = YES;
        self.isPlaying = YES;
        [self setSubViews];
        [self addGesture];
    }
    return self;
}

#pragma mark - setSubViews
- (void)setSubViews {
    coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    coverImageView.image = [UIImage imageNamed:@"loading"];
    coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    coverImageView.clipsToBounds = YES;
    [self addSubview:coverImageView];
    
//    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//    self.videoView.backgroundColor = UIColor.clearColor;
//    [self addSubview:self.videoView];
    
    tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    tapView.backgroundColor = UIColor.clearColor;
    [self addSubview:tapView];
    
    reportBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-50, SafeAreaTopHeight-44, 50, 50) text:@"" font:1 textColor:nil normalImg:@"nvideo_report" highImg:nil selectedImg:nil];
    [reportBtn addTarget:self action:@selector(reportButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reportBtn];
    
    CGFloat height = (SafeAreaBottomHeight-49)+140;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-height, App_Frame_Width, height)];
    [self addSubview:bgView];
    bgView.backgroundColor = UIColor.clearColor;
//    UIColor *color_1 = [UIColor clearColor];
//    UIColor *color_2 = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    [ToolManager mutableColor:color_1 end:color_2 isH:NO view:bgView];
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 42, 42)];
    headImageView.image = [UIImage imageNamed:@"default"];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 21;
    headImageView.layer.borderWidth = 2;
    headImageView.layer.borderColor = UIColor.whiteColor.CGColor;
    [bgView addSubview:headImageView];
    
    nameLabel = [UIManager initWithLabel:CGRectZero text:@"昵称" font:14 textColor:UIColor.whiteColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->headImageView.mas_top).offset(2);
        make.left.mas_equalTo(self->headImageView.mas_right).offset(8);
        make.width.mas_lessThanOrEqualTo(180);
        make.height.mas_equalTo(18);
    }];
    
    onlinePoint = [[UIView alloc] initWithFrame:CGRectZero];
    onlinePoint.backgroundColor = XZRGB(0xf5f5f5);
    onlinePoint.layer.masksToBounds = YES;
    onlinePoint.layer.cornerRadius = 3;
    [bgView addSubview:onlinePoint];
    [onlinePoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->nameLabel.mas_right).offset(8);
        make.centerY.mas_equalTo(self->nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
    
    onLineLabel = [UIManager initWithLabel:CGRectZero text:@"离线" font:12 textColor:UIColor.whiteColor];
    [bgView addSubview:onLineLabel];
    [onLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->nameLabel.mas_centerY);
        make.left.mas_equalTo(self->onlinePoint.mas_right).offset(3);
    }];
    
    ageLabel = [UIManager initWithLabel:CGRectZero text:@"18岁" font:10 textColor:UIColor.whiteColor];
    [bgView addSubview:ageLabel];
    [ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->nameLabel);
        make.bottom.mas_equalTo(self->headImageView.mas_bottom).offset(-3);
    }];
    
    jtImageView = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-35, 12, 19, 19)];
    jtImageView.image = [UIImage imageNamed:@"newvideo_btn_jt"];
    [bgView addSubview:jtImageView];
    
    NSArray *imgArr = @[@"newvideo_btn_chat", @"newvideo_btn_video", @"newvideo_btn_gift", @"newvideo_btn_follow"];
    NSArray *titleArr = @[@"私信", @"视频", @"礼物", @"关注"];
    CGFloat gap = (App_Frame_Width-30-200)/3;
    // 65 50 55
    for (int i = 0; i < imgArr.count; i ++) {
        UIButton *btn = [UIManager initWithButton:CGRectMake(15+(50+gap)*i, 65, 50, 55) text:titleArr[i] font:14 textColor:UIColor.whiteColor normalImg:imgArr[i] highImg:nil selectedImg:nil];
        if (i == 3) {
            followBtn = btn;
            followBtn.selected = NO;
            [followBtn setTitle:@"已关注" forState:UIControlStateSelected];
            [followBtn setImage:[UIImage imageNamed:@"newvideo_btn_follow_sel"] forState:UIControlStateSelected];
        }
        btn.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.15];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 6;
        btn.tag = 1234+i;
        [btn setImagePosition:2 spacing:8];
        [btn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
    }
    
    
    
    playImageView = [[UIImageView alloc] initWithFrame:CGRectMake((App_Frame_Width-60)/2, (APP_Frame_Height-60)/2, 60, 60)];
    playImageView.backgroundColor = UIColor.clearColor;
    playImageView.image = [UIImage imageNamed:@"AnthorDetail_dynamic_video"];
    playImageView.hidden = YES;
    [self addSubview:playImageView];
    
    UIButton *backBtn = [UIManager initWithButton:CGRectMake(0, SafeAreaTopHeight-44, 50, 50) text:@"" font:1 textColor:nil normalImg:@"AnthorDetail_back" highImg:nil selectedImg:nil];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    self.player = [PLPlayer playerWithURL:nil option:option];
    self.player.loopPlay = YES;
    self.player.delegate = self;
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.player.playerView];
    [self insertSubview:self.player.playerView atIndex:0];
    self.player.playerView.hidden = YES;
}

#pragma mark - func
- (void)back {
    UIViewController *curVC = [SLHelper getCurrentVC];
    [curVC.navigationController popViewControllerAnimated:YES];
}

- (void)bottomButtonClick:(UIButton *)sender {
    NSInteger index = sender.tag-1234;
    if (_handle.t_sex == [YLUserDefault userDefault].t_sex && index != 0) {
        [SVProgressHUD showInfoWithStatus:@"暂未开放同性用户交流"];
        return;
    }
    
    if (index != 3) {
        sender.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.enabled = YES;
        });
    }
    if (index == 0) {
        [self chatButtonClick];
    } else if (index == 1) {
        [self clickedVideo:_videoHandle.t_user_id];
    }else if (index == 2) {
        [self giftButtonClick];
    } else if (index == 3) {
        [self followButtonClick:sender];
    }
}

#pragma mark - 私聊
- (void)chatButtonClick {
    [YLPushManager pushChatViewController:_videoHandle.t_user_id otherSex:_handle.t_sex];
}

#pragma mark - set data
- (void)setupDefaultCoverImage {
    coverImageView.image = [UIImage imageNamed:@"loading"];
}

- (void)setVideoHandle:(videoListHandle *)videoHandle {
    _videoHandle = videoHandle;
    [coverImageView sd_setImageWithURL:[NSURL URLWithString:videoHandle.t_video_img] placeholderImage:[UIImage imageNamed:@"loading"]];
}

- (void)setVideoCoverUrl:(NSString *)videoCoverUrl {
    jtImageView.hidden = YES;
    [coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", videoCoverUrl]] placeholderImage:[UIImage imageNamed:@"loading"]];
}

- (void)setHandle:(videoPayHandle *)handle {
    
    _handle = handle;
    //头像
    if (![NSString isNullOrEmpty:handle.t_handImg]) {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:handle.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    }
    
    //昵称
    if (![NSString isNullOrEmpty:handle.t_nickName]) {
        nameLabel.text = handle.t_nickName;
    }else{
        nameLabel.text = @"";
    }
    
    if (handle.isFollow == 1) {
        followBtn.selected = YES;
    } else {
        followBtn.selected = NO;
    }
    [followBtn setImagePosition:2 spacing:8];
    
    //在线状态  0.在线1.在聊2.离线
    if (handle.t_onLine == 0){
        //在线
        onlinePoint.backgroundColor = XZRGB(0x31df9b);
        onLineLabel.text = @"在线";
    }else if (handle.t_onLine == 1){
        //在聊
        onlinePoint.backgroundColor = XZRGB(0xffeaed);
        onLineLabel.text = @"在聊";
    }else{
        //离线
        onlinePoint.backgroundColor = XZRGB(0xF5F5F5);
        onLineLabel.text = @"离线";
    }
}


- (void)setDefaultData {
    coverImageView.hidden = NO;
    nameLabel.text = @"";
    onLineLabel.text = @"离线";
    onlinePoint.backgroundColor = XZRGB(0xF5F5F5);
    headImageView.image = [UIImage imageNamed:@"default"];
    followBtn.selected = NO;
    [followBtn setImagePosition:2 spacing:8];
}

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    playImageView.hidden = isPlaying;
}

#pragma mark - Gesture
- (void)addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [tapView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDetail)];
    nameLabel.userInteractionEnabled = YES;
    [nameLabel addGestureRecognizer:nameTap];
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDetail)];
    headImageView.userInteractionEnabled = YES;
    [headImageView addGestureRecognizer:headTap];
}

- (void)tapGesture {
    if (self.playOrPause) {
        self.playOrPause(self.isPlaying);
    }
}

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    if (state == PLPlayerStatusPlaying) {
        self.player.playerView.hidden = NO;
        coverImageView.hidden = YES;
    }
}

#pragma mark - 举报
- (void)reportButtonClick {
    [YLPushManager pushReportWithId:_videoHandle.t_user_id];
}

#pragma mark - 用户详情
- (void)userDetail {
    [YLPushManager pushAnchorDetail:_videoHandle.t_user_id];
}

#pragma mark - 视频

- (void)clickedVideo:(int)otherId {
    [[ChatLiveManager shareInstance] getVideoChatAutographWithOtherId:otherId type:1 fail:nil];
}

#pragma mark - 礼物
- (void)giftButtonClick {
    [[MansionSendGiftView shareView] showWithUserId:_videoHandle.t_user_id isPlayGif:NO];
}

#pragma mark - 关注
- (void)followButtonClick:(UIButton *)sender {
    if (sender.selected == NO) {
        [YLNetworkInterface addAttention:[YLUserDefault userDefault].t_id
                       coverFollowUserId:(int)_videoHandle.t_user_id
                                   block:^(BOOL isSuccess)
         {
             if (isSuccess) {
                 sender.selected = !sender.selected;
                 [sender setImagePosition:2 spacing:8];
                 [SVProgressHUD showSuccessWithStatus:@"关注成功"];
             }
         }];
    } else {
        [YLNetworkInterface cancelAtttention:[YLUserDefault userDefault].t_id coverFollowUserId:(int)_videoHandle.t_user_id block:^(BOOL isSuccess) {
            if (isSuccess) {
                sender.selected = !sender.selected;
                [sender setImagePosition:2 spacing:8];
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            }
        }];
    }
}



@end
