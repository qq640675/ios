//
//  UserInfoVideoView.m
//  beijing
//
//  Created by 黎 涛 on 2019/9/21.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "UserInfoVideoView.h"
#import "LXTAlertView.h"
#import "ChatLiveManager.h"
#import "ZYGiftRedEnvep.h"
#import "ToolManager.h"

@implementation UserInfoVideoView
{
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *ageLabel;
    UIView *onlinePoint;
    UILabel *onLineLabel;
    UILabel *fansLabel;
    UIButton *followBtn;
}

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = UIColor.blackColor;
        [self setSubViews];
    }
    return self;
}

#pragma mark - setData
- (void)setVideoHandle:(videoPayHandle *)videoHandle {
    _videoHandle = videoHandle;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", videoHandle.t_handImg]] placeholderImage:[UIImage imageNamed:@"default"]];
    nameLabel.text = videoHandle.t_nickName;
    ageLabel.text = [NSString stringWithFormat:@"%@岁",videoHandle.t_age];
    if (videoHandle.t_age.length == 0 || [videoHandle.t_age containsString:@"null"]) {
        ageLabel.hidden = YES;
    }
    if (videoHandle.t_onLine == 0){
        //在线
        onlinePoint.backgroundColor = XZRGB(0x31df9b);
        onLineLabel.text = @"在线";
    }else if (videoHandle.t_onLine == 1){
        //在聊
        onlinePoint.backgroundColor = XZRGB(0xffeaed);
        onLineLabel.text = @"在聊";
    }else{
        //离线
        onlinePoint.backgroundColor = XZRGB(0xF5F5F5);
        onLineLabel.text = @"离线";
    }
    
    if (videoHandle.isFollow == 1) {
        followBtn.selected = YES;
    } else {
        followBtn.selected = NO;
    }
    [followBtn setImagePosition:2 spacing:8];
}

#pragma mark - PLPlayerDelegate
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    if (state == PLPlayerStatusPlaying) {
        self.player.playerView.hidden = NO;
    }
}

#pragma mark - func
- (void)back {
    UIViewController *curVC = [SLHelper getCurrentVC];
    [curVC.navigationController popViewControllerAnimated:YES];
}

- (void)reportButtonClick {
    [YLPushManager pushReportWithId:self.anchorId];
}

- (void)bottomButtonClick:(UIButton *)sender {
    NSInteger index = sender.tag-1234;
    if (_videoHandle.t_sex == [YLUserDefault userDefault].t_sex && index != 0) {
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
        [self clickedVideo:(int)self.anchorId];
    }
    else if (index == 2) {
        [self giftButtonClick];
    } else if (index == 3) {
        [self followButtonClick:sender];
    }
}

#pragma mark - 视频
- (void)clickedVideo:(int)otherId {
    [[ChatLiveManager shareInstance] getVideoChatAutographWithOtherId:otherId type:1 fail:nil];
}

#pragma mark - 礼物
- (void)giftButtonClick {
    [[MansionSendGiftView shareView] showWithUserId:self.anchorId isPlayGif:NO];
}

#pragma mark - 私聊
- (void)chatButtonClick {
    [YLPushManager pushChatViewController:self.anchorId otherSex:_videoHandle.t_sex];
}

#pragma mark - 关注
- (void)followButtonClick:(UIButton *)sender {
    if (sender.selected == NO) {
        [YLNetworkInterface addAttention:[YLUserDefault userDefault].t_id
                       coverFollowUserId:(int)self.anchorId
                                   block:^(BOOL isSuccess)
         {
             if (isSuccess) {
                 sender.selected = !sender.selected;
                 [self->followBtn setImagePosition:2 spacing:8];
                 [SVProgressHUD showSuccessWithStatus:@"关注成功"];
             }
         }];
    } else {
        [YLNetworkInterface cancelAtttention:[YLUserDefault userDefault].t_id coverFollowUserId:(int)self.anchorId block:^(BOOL isSuccess) {
            if (isSuccess) {
                sender.selected = !sender.selected;
                [self->followBtn setImagePosition:2 spacing:8];
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            }
        }];
    }
}

#pragma mark - setSubViews
- (void)setSubViews {
    UIButton *backBtn = [UIManager initWithButton:CGRectMake(0, SafeAreaTopHeight-44, 50, 50) text:@"" font:1 textColor:nil normalImg:@"AnthorDetail_back" highImg:nil selectedImg:nil];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    UIButton *reportBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-50, SafeAreaTopHeight-44, 50, 50) text:@"" font:1 textColor:nil normalImg:@"nvideo_report" highImg:nil selectedImg:nil];
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
    
    UIImageView *jtImageView = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-35, 12, 19, 19)];
    jtImageView.image = [UIImage imageNamed:@"newvideo_btn_jt"];
    [bgView addSubview:jtImageView];
    
//    NSArray *imgArr = @[@"newvideo_btn_chat", @"newvideo_btn_video", @"newvideo_btn_voice", @"newvideo_btn_gift", @"newvideo_btn_follow"];
//    NSArray *titleArr = @[@"私信", @"视频", @"语音", @"礼物", @"关注"];
    NSArray *imgArr = @[@"newvideo_btn_chat", @"newvideo_btn_video", @"newvideo_btn_gift", @"newvideo_btn_follow"];
    NSArray *titleArr = @[@"私信", @"视频", @"礼物", @"关注"];
    CGFloat gap = (App_Frame_Width-30-(50*imgArr.count))/(imgArr.count-1);
    // 65 50 55
    for (int i = 0; i < imgArr.count; i ++) {
        UIButton *btn = [UIManager initWithButton:CGRectMake(15+(50+gap)*i, 65, 50, 55) text:titleArr[i] font:14 textColor:UIColor.whiteColor normalImg:imgArr[i] highImg:nil selectedImg:nil];
        if (i == imgArr.count-1) {
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





@end
