//
//  MansionCallMeViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/11.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionCallMeViewController.h"
#import "YLAudioPlay.h"

@interface MansionCallMeViewController ()

@property (nonatomic, strong) UIButton      *endBtn;
@property (nonatomic, strong) UIButton      *chatBtn;
@property (nonatomic, strong) UIImageView   *iconImageView;
@property (nonatomic, strong) UILabel       *nickNameLb;
@property (nonatomic, strong) UILabel       *tipLabel;
@property (nonatomic, assign) BOOL isHandle; //是否操作了接通或者挂断 操作之后取消延迟函数
@property (nonatomic, strong) UILabel *bigTipLabel;

@end

@implementation MansionCallMeViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    [self setSubViews];
    [self getUserData];
    
    // 30s自动挂断
    _isHandle = NO;
    [self performSelector:@selector(autoHangUp) withObject:nil afterDelay:29.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - net
- (void)getUserData {
    
    //lsl update start
    [YLNetworkInterface getUserInfoByIdUser:_userId block:^(personalCenterHandle *handle) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", handle.handImg]]];
        self.nickNameLb.text = handle.nickName;
        self.bigTipLabel.text = [NSString stringWithFormat:@"%@%@", handle.nickName, self.bigTipLabel.text];
        
    }];
    //lsl update end
}

#pragma mark - setSubViews
- (void)setSubViews {
    [self.view addSubview:self.iconImageView];
    
    [self.view addSubview:self.nickNameLb];
    
    NSString *type = @"视频";
    if (_chatType == MansionChatTypeVoice) {
        type = @"语音";
        self.iconImageView.frame = CGRectMake((App_Frame_Width-100)/2, 100, 100, 100);
        self.iconImageView.layer.cornerRadius = 50;
        
        self.nickNameLb.frame = CGRectMake(50, CGRectGetMaxY(self.iconImageView.frame), App_Frame_Width-100, 30);
        self.nickNameLb.textAlignment = NSTextAlignmentCenter;
    }
//    self.tipLabel = [UIManager initWithLabel:CGRectMake(self.nickNameLb.x, CGRectGetMaxY(self.nickNameLb.frame), self.nickNameLb.width, 25) text:[NSString stringWithFormat:@"邀请你加入府邸%@房间", type] font:14 textColor:UIColor.whiteColor];
//    self.tipLabel.textAlignment = NSTextAlignmentRight;
//    [self.view addSubview:self.tipLabel];
    
    self.bigTipLabel = [UIManager initWithLabel:CGRectMake(40, (APP_Frame_Height-60)/2, App_Frame_Width-80, 60) text:[NSString stringWithFormat:@"邀请你加入他的一对二%@聊天房间", type] font:17 textColor:UIColor.whiteColor];
    self.bigTipLabel.numberOfLines = 0;
    [self.view addSubview:self.bigTipLabel];
    

    
    [self.view addSubview:self.endBtn];
    UILabel *endLb = [UIManager initWithLabel:CGRectMake(30, APP_Frame_Height-35, 60, 20) text:@"挂断" font:12.0f textColor:[UIColor whiteColor]];
    [self.view addSubview:endLb];
    
    [self.view addSubview:self.chatBtn];
    UILabel *chatLb = [UIManager initWithLabel:CGRectMake(App_Frame_Width-90, APP_Frame_Height-35, 60, 20) text:@"接听" font:12.0f textColor:[UIColor whiteColor]];
    [self.view addSubview:chatLb];
}

#pragma mark - func
- (void)endButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    _isHandle = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoHangUp) object:nil];
    [self closeVoice];
    [self hangup];
}

- (void)autoHangUp {
    // 30s自动挂断
    if (_isHandle == YES) {
        // 虽操作后已取消延迟函数  还是return掉 以防意外
        return;
    }
    [self closeVoice];
    [self hangup];
}

- (void)hangup {
    [YLNetworkInterface breakMansionLinkWithMansionRoomId:_mansionRoomId roomId:_roomId breakUserId:[YLUserDefault userDefault].t_id result:^{
        if (self.answerNewComing) {
            self.answerNewComing(YES);
        }
    }];
}

- (void)chatButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    _isHandle = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoHangUp) object:nil];
    [self closeVoice];
    [YLNetworkInterface videoMansionChatBeginTimingWithMansionRoomId:_mansionRoomId roomId:_roomId chatType:1 success:^{
        if (self.answerNewComing) {
            self.answerNewComing(NO);
        }
    } fail:^{
        [self hangup];
    }];
}

- (void)closeVoice {
    //关闭提示音和震动
    [[YLAudioPlay shareInstance] callEndNoSoundsPaly];
    [[YLAudioPlay shareInstance] stopDisplayLink];
}

#pragma mark - lazy loading
- (UIButton *)endBtn {
    if (!_endBtn) {
        _endBtn = [UIManager initWithButton:CGRectMake(30, APP_Frame_Height-105, 60, 60) text:nil font:12.0f textColor:[UIColor clearColor] normalImg:@"Matching_end" highImg:nil selectedImg:nil];
        [_endBtn addTarget:self action:@selector(endButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endBtn;
}

- (UIButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-90, APP_Frame_Height-105, 60, 60) text:nil font:12.0f textColor:[UIColor clearColor] normalImg:@"isOn" highImg:nil selectedImg:nil];
        [_chatBtn addTarget:self action:@selector(chatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-56, SafeAreaTopHeight-44+16, 50, 50)];
        _iconImageView.layer.cornerRadius = 4;
        _iconImageView.clipsToBounds      = YES;
        _iconImageView.backgroundColor    = [UIColor lightGrayColor];
    }
    return _iconImageView;
}

- (UILabel *)nickNameLb {
    if (!_nickNameLb) {
        _nickNameLb = [UIManager initWithLabel:CGRectMake(App_Frame_Width-66-180, SafeAreaTopHeight-44+16, 180, 50) text:@"昵称" font:20 textColor:[UIColor whiteColor]];
        _nickNameLb.font = [UIFont boldSystemFontOfSize:20];
        _nickNameLb.textAlignment = NSTextAlignmentRight;
    }
    return _nickNameLb;
}


@end
