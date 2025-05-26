//
//  MansionVideoViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

// vc
#import "MansionVideoViewController.h"
#import "MansionCallMeViewController.h"

// view
#import "MansionVideoShowView.h"
#import "MansionMessageView.h"
#import "MansionInputView.h"
#import "MansionInviteAlertView.h"
#import "TUIFaceCell.h"
#import "MansionSendGiftView.h"

// other
#import "YLJsonExtension.h"
#import <MJExtension.h>
#import "TUIKit.h"
#import "SensitiveWordTools.h"
#import "SVGAParser.h"
#import "SVGAPlayer.h"

#import "FUCameraManager.h"

#import "PulpShadeView.h"
#import "VideoWarningAlertView.h"

@interface MansionVideoViewController ()<TFaceViewDelegate, SVGAPlayerDelegate, AgoraRtcEngineDelegate>

@property (nonatomic, strong) UIView *showBgView;

@property (nonatomic, strong) MansionVideoShowView *ownerVideoView; //房主的视图
@property (nonatomic, strong) MansionVideoShowView *firstAnchorVideoView; //第一个主播视图
@property (nonatomic, strong) MansionVideoShowView *secondAnchorVideoView; //第二个主播视图
@property (nonatomic, strong) MansionVideoShowView *thirdAnchorVideoView; //第三个主播视图
@property (nonatomic, strong) MansionVideoShowView *fourthAnchorVideoView; //第四个主播视图

@property (nonatomic, strong) AgoraRtcVideoCanvas *ownerVideoCanvas;
@property (nonatomic, strong) AgoraRtcVideoCanvas *firstAnchorVideoCanvas;
@property (nonatomic, strong) AgoraRtcVideoCanvas *secondAnchorVideoCanvas;
@property (nonatomic, strong) AgoraRtcVideoCanvas *thirdAnchorVideoCanvas;
@property (nonatomic, strong) AgoraRtcVideoCanvas *fourthAnchorVideoCanvas;

@property (nonatomic, strong) MansionMessageView *messageView; //消息视图
@property (nonatomic, strong) MansionInputView *inputView; //输入框视图
@property (nonatomic, strong) TIMConversation *grpConversation; //聊天室会话
@property (nonatomic, strong) TUIFaceView *emojiView;

@property (nonatomic, strong) MansionVideoShowView *selfVideoView; //自己的视图

@property (nonatomic, strong) MansionCallMeViewController *comingVC;
@property (nonatomic, strong) UIButton *micBtn;

@property (nonatomic, strong) NSMutableArray *anchors; //房间内的主播信息数组
@property (nonatomic, strong) NSDictionary *mansionRoomInfo; //房间信息
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;

//礼物特效
@property (nonatomic, strong) SVGAParser    *parser;
@property (nonatomic, strong) SVGAPlayer    *player;

@property (nonatomic, strong) dispatch_source_t matchTimer;
@property (nonatomic, strong) UILabel *ownerNameLabel;
@property (nonatomic, strong) UILabel *firstNameLabel;
@property (nonatomic, strong) UILabel *secondNameLabel;
@property (nonatomic, strong) UILabel *thirdNameLabel;
@property (nonatomic, strong) UILabel *fourthNameLabel;

// 计时以及显示
@property (nonatomic, strong) UILabel *firstTimeLabel;
@property (nonatomic, strong) UILabel *secondTimeLabel;
@property (nonatomic, strong) UILabel *thirdTimeLabel;
@property (nonatomic, strong) UILabel *fourthTimeLabel;
@property (nonatomic, assign) NSInteger firstCount;
@property (nonatomic, assign) NSInteger secondCount;
@property (nonatomic, assign) NSInteger thirdCount;
@property (nonatomic, assign) NSInteger fourthCount;

//截图鉴黄
@property (nonatomic, assign) BOOL t_screenshot_user_switch;
@property (nonatomic, assign) BOOL t_screenshot_anchor_switch;
@property (nonatomic, strong) NSMutableArray *t_screenshot_time_list;
@property (nonatomic, assign) NSInteger totleCount;
@property (nonatomic, strong) UILabel *yellowTipLabel;
@property (nonatomic, assign) NSInteger animationCount;
@property (nonatomic, copy) NSString *tipContent;
@property (nonatomic, strong) VideoWarningAlertView *alertView;
@property (nonatomic, strong) PulpShadeView *selfShade;
@property (nonatomic, strong) PulpShadeView *firstShade;
@property (nonatomic, strong) PulpShadeView *secondShade;

@property (nonatomic, strong) FUCameraManager *cameraManager;

@end

@implementation MansionVideoViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.firstCount = 0;
    self.secondCount = 0;
    self.thirdCount = 0;
    self.fourthCount = 0;
    [self checkNewComing];
    [self requestScreenShotStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 开启屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 关闭屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[TIMGroupManager sharedInstance] getGroupList:nil fail:nil];
} 

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self hideEmojiView];
}

#pragma mark - check newcoming
- (void)checkNewComing {
    if (self.isNewComing == YES) {
        [self setNewComingView];
    } else {
        [self setVideoView];
    }
}

- (void)setNewComingView {
    _comingVC = [[MansionCallMeViewController alloc] init];
    _comingVC.mansionRoomId = _mansionRoomId;
    _comingVC.userId = _ownerId;
    _comingVC.roomId = _roomId;
    _comingVC.chatType = _chatType;
    [self.view addSubview:_comingVC.view];
    [self addChildViewController:_comingVC];
    WEAKSELF;
    _comingVC.answerNewComing = ^(BOOL isHangUp) {
        if (isHangUp == YES) {
            [weakSelf dismissViewController:@""];
        } else {
            [weakSelf setVideoView];
        }
    };
}

- (void)setVideoView {
    [self setSubViews];
    [self joinRoom];
//    if (_chatType == MansionChatTypeVideo) {
//        [self initWithTiLive];//美颜
//    }
    [self addNot];
    [self setGiftPlay];
}

#pragma mark - not
- (void)addNot {
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //收到新消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"receive_msg_notification" object:nil];
    
    //收到挂断通知 只有主播才会收到挂断通知
    if (self.isHouseOwner == NO) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveHangUpNot) name:@"MASIONVIDEOHANGUP" object:nil];
    }
    if (_chatType == MansionChatTypeVoice) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveHangUpNot) name:@"MASIONVOICEHANGUP" object:nil];
    }
    //余额不足 挂断  针对房主;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noMoneyAutoHangup) name:@"liveInsuffiveNoti" object:nil];
    
    //被封号挂断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountCancle) name:@"videoIsOnHangupNoti" object:nil];
    
    //视频警告
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(warningAlert:) name:@"RECIEVEVIDEOWARNING" object:nil];
}

- (void)warningAlert:(NSNotification *)not {
    NSString *content = (NSString *)not.object;
    VideoWarningAlertView *alert = [[VideoWarningAlertView alloc] init];
    [alert showWithContent:content];
}

- (void)keyboardShow:(NSNotification *)note {
    _emojiView.hidden = YES;
    _emojiView.y = APP_Frame_Height;
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.inputView.y = APP_Frame_Height-50-deltaY;
        self.inputView.whiteView.alpha = 1;
    }];
}

- (void)keyboardHide:(NSNotification *)note {
    CGFloat height = 55+(SafeAreaBottomHeight-49);
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.inputView.y = APP_Frame_Height-height;
        self.inputView.whiteView.alpha = 0;
    }];
}

- (void)receiveHangUpNot {
    [[AgoraManager shareManager] leaveChannel];
    [self.cameraManager stopCapture];
    [self dismissViewController:@"已挂断"];
}

- (void)noMoneyAutoHangup {
    [[AgoraManager shareManager] leaveChannel];
    [self.cameraManager stopCapture];
    [self deleteChatGroup];
    [self hangupMansionRoom];
}

- (void)accountCancle {
    if (self.isHouseOwner == YES) {
        [[AgoraManager shareManager] leaveChannel];
        [self.cameraManager stopCapture];
        [self deleteChatGroup];
        [self hangupMansionRoom];
    } else {
        [[AgoraManager shareManager] leaveChannel];
        [self.cameraManager stopCapture];
        [self deleteChatGroup];
        [self hangupRoom:@"涉黄被封号"];
    }
}

#pragma mark - net
- (void)requestMansionRoomInfo {
    // 获取大房间里面的具体人详情
    [YLNetworkInterface getMansionHouseVideoInfoWithMansionRoomId:_mansionRoomId success:^(NSDictionary *roomInfo) {
        self.mansionRoomInfo = roomInfo;
        if ([roomInfo[@"anochorInfo"] isKindOfClass:[NSArray class]]) {
            self.anchors = [NSMutableArray arrayWithArray:roomInfo[@"anochorInfo"]];
        }
        if (self.isHouseOwner == NO) {
            self.titleLabel.text = roomInfo[@"mansionRoomName"];
        }
        
        if ([roomInfo[@"userInfo"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userInfo = roomInfo[@"userInfo"];
            NSString *t_handImg = [NSString stringWithFormat:@"%@", userInfo[@"t_handImg"]];
            if (t_handImg.length > 0 && ![t_handImg containsString:@"null"]) {
                if (self.chatType == MansionChatTypeVideo) {
                    [self.ownerVideoView.headImageView sd_setImageWithURL:[NSURL URLWithString:t_handImg]];
                } else {
                    [self.ownerVideoView.videoImageV sd_setImageWithURL:[NSURL URLWithString:t_handImg]];
                }
            }
            NSString *t_nickName = [NSString stringWithFormat:@"%@", userInfo[@"t_nickName"]];
            if (t_nickName.length > 0 && ![t_nickName containsString:@"null"]) {
                if (self.chatType == MansionChatTypeVideo) {
                    self.ownerVideoView.nameLabel.text = t_nickName;
                } else {
                    self.ownerNameLabel.text = t_nickName;
                }
            }
        }
        for (int i = 0; i < self.anchors.count; i ++) {
            NSDictionary *dic = self.anchors[i];
            int t_id = [[NSString stringWithFormat:@"%@", dic[@"t_id"]] intValue];
            NSString *t_handImg = [NSString stringWithFormat:@"%@", dic[@"t_handImg"]];
            if (t_id > 0 && t_handImg.length > 0 && ![t_handImg containsString:@"null"]) {
                if (t_id == self.firstAnchorVideoView.userId) {
                    if (self.chatType == MansionChatTypeVideo) {
                        [self.firstAnchorVideoView.headImageView sd_setImageWithURL:[NSURL URLWithString:t_handImg]];
                    } else {
                        [self.firstAnchorVideoView.videoImageV sd_setImageWithURL:[NSURL URLWithString:t_handImg]];
                    }
                }
                if (t_id == self.secondAnchorVideoView.userId) {
                    if (self.chatType == MansionChatTypeVideo) {
                        [self.secondAnchorVideoView.headImageView sd_setImageWithURL:[NSURL URLWithString:t_handImg]];
                    } else {
                        [self.secondAnchorVideoView.videoImageV sd_setImageWithURL:[NSURL URLWithString:t_handImg]];
                    }
                }
                if (t_id == self.thirdAnchorVideoView.userId) {
                    if (self.chatType == MansionChatTypeVideo) {
                        [self.thirdAnchorVideoView.headImageView sd_setImageWithURL:[NSURL URLWithString:t_handImg]];
                    } else {
                        [self.thirdAnchorVideoView.videoImageV sd_setImageWithURL:[NSURL URLWithString:t_handImg]];
                    }
                }
                if (t_id == self.fourthAnchorVideoView.userId) {
                    if (self.chatType == MansionChatTypeVideo) {
                        [self.fourthAnchorVideoView.headImageView sd_setImageWithURL:[NSURL URLWithString:t_handImg]];
                    } else {
                        [self.fourthAnchorVideoView.videoImageV sd_setImageWithURL:[NSURL URLWithString:t_handImg]];
                    }
                }
            }
            NSString *t_nickName = [NSString stringWithFormat:@"%@", dic[@"t_nickName"]];
            if (t_nickName.length > 0 && ![t_nickName containsString:@"null"]) {
                if (t_id == self.firstAnchorVideoView.userId) {
                    if (self.chatType == MansionChatTypeVideo) {
                        self.firstAnchorVideoView.nameLabel.text = t_nickName;
                    } else {
                        self.firstNameLabel.text = t_nickName;
                    }
                }
                if (t_id == self.secondAnchorVideoView.userId) {
                    if (self.chatType == MansionChatTypeVideo) {
                        self.secondAnchorVideoView.nameLabel.text = t_nickName;
                    } else {
                        self.secondNameLabel.text = t_nickName;
                    }
                }
                if (t_id == self.thirdAnchorVideoView.userId) {
                    if (self.chatType == MansionChatTypeVideo) {
                        self.thirdAnchorVideoView.nameLabel.text = t_nickName;
                    } else {
                        self.thirdNameLabel.text = t_nickName;
                    }
                }
                if (t_id == self.fourthAnchorVideoView.userId) {
                    if (self.chatType == MansionChatTypeVideo) {
                        self.fourthAnchorVideoView.nameLabel.text = t_nickName;
                    } else {
                        self.fourthNameLabel.text = t_nickName;
                    }
                }
            }
        }    }];
}

#pragma mark - setSubViews
- (void)setSubViews {
    [self addTiTleView];
    [self addVideoShowView];
    [self addMessageView];
    [self addInputView];
}

- (void)addTiTleView {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    bgImageView.image = [UIImage imageNamed:@"mansion_room_bg"];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    
    _titleLabel = [UIManager initWithLabel:CGRectMake(15, SafeAreaTopHeight-44, App_Frame_Width-100, 44) text:self.titleStr font:16 textColor:UIColor.whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    
    _closeBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-44, SafeAreaTopHeight-44, 44, 44) text:@"" font:1 textColor:nil normalImg:@"mansion_room_out" highImg:nil selectedImg:nil];
    [_closeBtn addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
}

- (void)addVideoShowView {
    CGFloat width = 172;
    CGFloat height = 220;
    _showBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 400+SafeAreaTopHeight)];
    _showBgView.backgroundColor = [XZRGB(0x5a2bc7) colorWithAlphaComponent:0.2];
    [self.view addSubview:_showBgView];
    
    WEAKSELF;
    _ownerVideoView = [[MansionVideoShowView alloc] initWithFrame:CGRectMake((App_Frame_Width-width)/2, SafeAreaTopHeight, 140, 140) isHouseOwner:self.isHouseOwner isOwnerView:YES tag:1019 type:self.chatType];
    _ownerVideoView.voiceButtonClickBlock = ^(UIButton * _Nonnull sender) {
        [weakSelf voiceButtonClick:sender index:1019];
    };
    _ownerVideoView.cameraButtonClickBlock = ^{
        [weakSelf cameraButtonClick];
    };
    
    UIView *videoBG = [[UIView alloc] initWithFrame:CGRectMake((App_Frame_Width-width*2)/2, CGRectGetMaxY(_ownerVideoView.frame)+5, width*2, height)];
    [_showBgView addSubview:videoBG];
    
    _firstAnchorVideoView = [[MansionVideoShowView alloc] initWithFrame:CGRectMake(0, 0, width, height) isHouseOwner:self.isHouseOwner isOwnerView:NO tag:1234 type:self.chatType];
    _firstAnchorVideoView.deleteButtonClickBlock = ^{
        [weakSelf deleteButtonClick:1234];
    };
    _firstAnchorVideoView.addButtonClickBlock = ^{
        [weakSelf inviteAnchorJoin];
    };
    _firstAnchorVideoView.voiceButtonClickBlock = ^(UIButton * _Nonnull sender) {
        [weakSelf voiceButtonClick:sender index:1234];
    };
    _firstAnchorVideoView.cameraButtonClickBlock = ^{
        [weakSelf cameraButtonClick];
    };
    [videoBG addSubview:_firstAnchorVideoView];
    
    _secondAnchorVideoView = [[MansionVideoShowView alloc] initWithFrame:CGRectMake(width, 0, width, height) isHouseOwner:self.isHouseOwner isOwnerView:NO tag:1333 type:self.chatType];
    _secondAnchorVideoView.deleteButtonClickBlock = ^{
        [weakSelf deleteButtonClick:1333];
    };
    _secondAnchorVideoView.addButtonClickBlock = ^{
        [weakSelf inviteAnchorJoin];
    };
    _secondAnchorVideoView.voiceButtonClickBlock = ^(UIButton * _Nonnull sender) {
        [weakSelf voiceButtonClick:sender index:1333];
    };
    _secondAnchorVideoView.cameraButtonClickBlock = ^{
        [weakSelf cameraButtonClick];
    };
    [videoBG addSubview:_secondAnchorVideoView];
    
    
    
    _thirdAnchorVideoView = [[MansionVideoShowView alloc] initWithFrame:CGRectMake(0, height+10, width, height) isHouseOwner:self.isHouseOwner isOwnerView:NO tag:1244 type:self.chatType];
    _thirdAnchorVideoView.deleteButtonClickBlock = ^{
        [weakSelf deleteButtonClick:1244];
    };
    _thirdAnchorVideoView.addButtonClickBlock = ^{
        [weakSelf inviteAnchorJoin];
    };
    _thirdAnchorVideoView.voiceButtonClickBlock = ^(UIButton * _Nonnull sender) {
        [weakSelf voiceButtonClick:sender index:1244];
    };
    _thirdAnchorVideoView.cameraButtonClickBlock = ^{
        [weakSelf cameraButtonClick];
    };
    [videoBG addSubview:_thirdAnchorVideoView];
    
    _fourthAnchorVideoView = [[MansionVideoShowView alloc] initWithFrame:CGRectMake(width, height+10, width, height) isHouseOwner:self.isHouseOwner isOwnerView:NO tag:1343 type:self.chatType];
    _fourthAnchorVideoView.deleteButtonClickBlock = ^{
        [weakSelf deleteButtonClick:1343];
    };
    _fourthAnchorVideoView.addButtonClickBlock = ^{
        [weakSelf inviteAnchorJoin];
    };
    _fourthAnchorVideoView.voiceButtonClickBlock = ^(UIButton * _Nonnull sender) {
        [weakSelf voiceButtonClick:sender index:1343];
    };
    _fourthAnchorVideoView.cameraButtonClickBlock = ^{
        [weakSelf cameraButtonClick];
    };
    [videoBG addSubview:_fourthAnchorVideoView];
    
    
    _firstTimeLabel = [UIManager initWithLabel:CGRectZero text:@"" font:13 textColor:UIColor.whiteColor];
    _firstTimeLabel.font = [UIFont systemFontOfSize:13];
    
    _secondTimeLabel = [UIManager initWithLabel:CGRectZero text:@"" font:13 textColor:UIColor.whiteColor];
    _secondTimeLabel.font = [UIFont systemFontOfSize:13];
    
    _thirdTimeLabel = [UIManager initWithLabel:CGRectZero text:@"" font:13 textColor:UIColor.whiteColor];
    _thirdTimeLabel.font = [UIFont systemFontOfSize:13];
    
    _fourthTimeLabel = [UIManager initWithLabel:CGRectZero text:@"" font:13 textColor:UIColor.whiteColor];
    _fourthTimeLabel.font = [UIFont systemFontOfSize:13];
    
    if (_chatType == MansionChatTypeVoice) {
        _showBgView.height = App_Frame_Width;
        videoBG.frame = CGRectMake(0, 0, App_Frame_Width, App_Frame_Width);
        videoBG.backgroundColor = UIColor.clearColor;
        
        CGFloat width = (App_Frame_Width-60)/3;
        CGFloat height = 140;
        _firstAnchorVideoView.layer.cornerRadius = 8;
        _secondAnchorVideoView.layer.cornerRadius = 8;
        _thirdAnchorVideoView.layer.cornerRadius = 8;
        _fourthAnchorVideoView.layer.cornerRadius = 8;
        [_ownerVideoView resetFrame:CGRectMake(23, SafeAreaTopHeight+5, width, height)];
        [_firstAnchorVideoView resetFrame:CGRectMake(30+width, SafeAreaTopHeight+5, width, height)];
        [_secondAnchorVideoView resetFrame:CGRectMake(37+2*width, SafeAreaTopHeight+5, width, height)];
        [_thirdAnchorVideoView resetFrame:CGRectMake(30+width, SafeAreaTopHeight+5+height+10, width, height)];
        [_fourthAnchorVideoView resetFrame:CGRectMake(37+2*width, SafeAreaTopHeight+5+height+10, width, height)];
        [videoBG addSubview:_ownerVideoView];
        
        [self setVoiceSubViewWithSuperView:videoBG];
        
        [videoBG addSubview:_firstTimeLabel];
        [videoBG addSubview:_secondTimeLabel];
        [videoBG addSubview:_thirdTimeLabel];
        [videoBG addSubview:_fourthTimeLabel];
        _firstTimeLabel.frame = CGRectMake(_firstNameLabel.x, CGRectGetMaxY(_firstNameLabel.frame), _firstNameLabel.width, 20);
        _secondTimeLabel.frame = CGRectMake(_secondNameLabel.x, CGRectGetMaxY(_secondNameLabel.frame), _secondNameLabel.width, 20);
        _thirdTimeLabel.frame = CGRectMake(_thirdNameLabel.x, CGRectGetMaxY(_thirdNameLabel.frame), _thirdNameLabel.width, 20);
        _fourthTimeLabel.frame = CGRectMake(_fourthNameLabel.x, CGRectGetMaxY(_fourthNameLabel.frame), _fourthNameLabel.width, 20);
    } else {
        videoBG.backgroundColor = XZRGB(0x5f30ca);
        videoBG.layer.masksToBounds = YES;
        videoBG.layer.cornerRadius = 8;
        
        [self.view addSubview:_ownerVideoView];
        
        [_showBgView addSubview:_firstTimeLabel];
        [_showBgView addSubview:_secondTimeLabel];
        [_showBgView addSubview:_thirdTimeLabel];
        [_showBgView addSubview:_fourthTimeLabel];
        _firstTimeLabel.frame = CGRectMake(videoBG.x, CGRectGetMaxY(videoBG.frame), videoBG.width/2, 25);
        _secondTimeLabel.frame = CGRectMake(CGRectGetMaxX(_firstTimeLabel.frame), CGRectGetMinY(_firstTimeLabel.frame), _firstTimeLabel.width, 25);
        _thirdTimeLabel.frame = CGRectMake(videoBG.x, _firstTimeLabel.frame.origin.y + _firstTimeLabel.frame.size.height + 10, videoBG.width/2, 25);
        _fourthTimeLabel.frame = CGRectMake(CGRectGetMaxX(_thirdTimeLabel.frame), CGRectGetMinY(_thirdTimeLabel.frame), _thirdTimeLabel.width, 25);
    }
    
    [self.view bringSubviewToFront:_closeBtn];
}

- (void)setVoiceSubViewWithSuperView:(UIView *)superView {
    CGFloat gap = (App_Frame_Width-200)/2;
    _micBtn = [UIManager initWithButton:CGRectMake(gap, superView.height-100, 100, 100) text:@"" font:1 textColor:nil normalImg:@"mansion_micbtn" highImg:nil selectedImg:@"mansion_micbtn_close"];
    [_micBtn addTarget:self action:@selector(micButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:_micBtn];
    
    UIButton *voiceBtn = [UIManager initWithButton:CGRectMake(gap+100, superView.height-100, 100, 100) text:@"" font:1 textColor:nil normalImg:@"mansion_voicebtn" highImg:nil selectedImg:@"mansion_voicebtn_close"];
    [voiceBtn addTarget:self action:@selector(voiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:voiceBtn];
    
    _ownerNameLabel = [UIManager initWithLabel:CGRectMake(_ownerVideoView.x, CGRectGetMaxY(_ownerVideoView.frame), _ownerVideoView.width, 22) text:@"" font:14 textColor:UIColor.whiteColor];
    [superView addSubview:_ownerNameLabel];
    
    _firstNameLabel = [UIManager initWithLabel:CGRectMake(_firstAnchorVideoView.x, CGRectGetMaxY(_firstAnchorVideoView.frame), _firstAnchorVideoView.width, 22) text:@"" font:14 textColor:UIColor.whiteColor];
    [superView addSubview:_firstNameLabel];
    
    _secondNameLabel = [UIManager initWithLabel:CGRectMake(_secondAnchorVideoView.x, CGRectGetMaxY(_secondAnchorVideoView.frame), _secondAnchorVideoView.width, 22) text:@"" font:14 textColor:UIColor.whiteColor];
    [superView addSubview:_secondNameLabel];
    
    
    _thirdNameLabel = [UIManager initWithLabel:CGRectMake(_thirdAnchorVideoView.x, CGRectGetMaxY(_thirdAnchorVideoView.frame), _thirdAnchorVideoView.width, 22) text:@"" font:14 textColor:UIColor.whiteColor];
    [superView addSubview:_thirdNameLabel];
    
    _fourthNameLabel = [UIManager initWithLabel:CGRectMake(_fourthAnchorVideoView.x, CGRectGetMaxY(_fourthAnchorVideoView.frame), _fourthAnchorVideoView.width, 22) text:@"" font:14 textColor:UIColor.whiteColor];
    [superView addSubview:_fourthNameLabel];
    
    
}

- (void)addMessageView {
    CGFloat top = _showBgView.height+10;
    CGFloat bottomHeight = 55+(SafeAreaBottomHeight-49);
    _messageView = [[MansionMessageView alloc] initWithFrame:CGRectMake(15, top, App_Frame_Width-30, APP_Frame_Height-top-bottomHeight)];
    [self.view addSubview:_messageView];
}

- (void)addInputView {
    _inputView = [[MansionInputView alloc] init];
    [self.view addSubview:_inputView];
    WEAKSELF;
    _inputView.sendTextBlock = ^(NSString * _Nonnull text) {
        [weakSelf sendIMText:text];
    };
    _inputView.emojiButtonClickBlock = ^{
        [weakSelf chatEmoji];
    };
    _inputView.sendGiftButtonClickBlock = ^{
        [weakSelf sendGiftButtonClick];
    };
}

#pragma mark - gift play
- (void)setGiftPlay {
    // 大礼物特效
    self.player = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    _player.delegate = self;
    _player.loops = 1;
    _player.clearsAfterStop = YES;
    _player.userInteractionEnabled = NO;
    [self.view addSubview:_player];
    
    self.parser = [[SVGAParser alloc] init];
}

- (void)playGiftAnimation:(NSString *)gifUrl {
    if (gifUrl.length == 0) return;
    [self.parser parseWithURL:[NSURL URLWithString:gifUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        if (videoItem != nil) {
            self.player.videoItem = videoItem;
            [self.player startAnimation];
        }
    } failureBlock:nil];
}

#pragma mark - func
- (void)closeButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    [LXTAlertView alertViewWithTitle:@"" message:@"你确定退出聊天吗？" cancleTitle:@"狠心挂断" sureTitle:@"再聊一会" sureHandle:^{
        
    } cancleHandle:^{
        [[AgoraManager shareManager] leaveChannel];
        [self.cameraManager stopCapture];
        
        if (self.isHouseOwner) {
            [self deleteChatGroup]; //解散聊天室
            [self hangupMansionRoom];
        } else {
            [self sendleavedMessage]; //发送离开房间IM消息
            [self hangupRoom:@""];
        }
    }];
}

- (void)inviteAnchorJoin {
    [self.view endEditing:YES];
    [self hideEmojiView];
    MansionInviteAlertView *alertView = [[MansionInviteAlertView alloc] initWithType:InvitiAlertTypeJoinRoom mansionRoomId:_mansionRoomId chatType:1];
    [alertView show];
}

- (void)sendGiftButtonClick {
    [self.view endEditing:YES];
    [self hideEmojiView];
    NSMutableArray *userArray = [NSMutableArray array];
    if (self.isHouseOwner == YES) {
        for (NSDictionary *dic in _anchors) {
            [userArray addObject:dic];
        }
    } else {
        NSDictionary *onwerInfo = _mansionRoomInfo[@"userInfo"];
        [userArray addObject:onwerInfo];
        for (NSDictionary *dic in _anchors) {
            NSString *t_id = [NSString stringWithFormat:@"%@", dic[@"t_id"]];
            if ([t_id intValue] != [YLUserDefault userDefault].t_id) {
                [userArray addObject:dic];
            }
        }
    }
    WEAKSELF;
    [[MansionSendGiftView shareView] showWithUserArray:userArray isShowHead:YES conversasion:self.grpConversation];
    [MansionSendGiftView shareView].sendGiftIMMessageSeccess = ^(NSDictionary * _Nonnull param) {
        [weakSelf playGiftAnimation:param[@"gift_gif_url"]];
        [weakSelf refreshMessageWithParam:param];
    };
}

- (void)voiceButtonClick:(UIButton *)sender index:(NSInteger)tag {
    sender.selected = !sender.selected;
    NSInteger userId;
    if (tag == 1019) {
        if (self.isHouseOwner) {
            _micBtn.selected = sender.selected;
            [[AgoraManager shareManager] muteLocalAudioStream:sender.selected];
        } else {
            userId = self.ownerId;
            [[AgoraManager shareManager] muteRemoteAudioStream:self.ownerId mute:sender.selected];
        }
    } else if (tag == 1234) {
        if (self.selfVideoView == self.firstAnchorVideoView) {
            _micBtn.selected = sender.selected;
            [[AgoraManager shareManager] muteLocalAudioStream:sender.selected];
        } else {
            [[AgoraManager shareManager] muteRemoteAudioStream:self.firstAnchorVideoView.userId mute:sender.selected];
        }
    } else if (tag == 1333) {
        if (self.selfVideoView == self.secondAnchorVideoView) {
            _micBtn.selected = sender.selected;
            [[AgoraManager shareManager] muteLocalAudioStream:sender.selected];
        } else {
            [[AgoraManager shareManager] muteRemoteAudioStream:self.secondAnchorVideoView.userId mute:sender.selected];
        }
    } else if (tag == 1244) {
        if (self.selfVideoView == self.thirdAnchorVideoView) {
            _micBtn.selected = sender.selected;
            [[AgoraManager shareManager] muteLocalAudioStream:sender.selected];
        } else {
            [[AgoraManager shareManager] muteRemoteAudioStream:self.thirdAnchorVideoView.userId mute:sender.selected];
        }
    } else if (tag == 1343) {
        if (self.selfVideoView == self.fourthAnchorVideoView) {
            _micBtn.selected = sender.selected;
            [[AgoraManager shareManager] muteLocalAudioStream:sender.selected];
        } else {
            [[AgoraManager shareManager] muteRemoteAudioStream:self.fourthAnchorVideoView.userId mute:sender.selected];
        }
    }
}

- (void)micButtonClick:(UIButton *)sender {
    // 静音
    sender.selected = !sender.selected;
    [[AgoraManager shareManager] muteLocalAudioStream:sender.selected];
    self.selfVideoView.voiceBtn.selected = sender.selected;
}

- (void)voiceButtonClick:(UIButton *)sender {
    // 扩音
    sender.selected = !sender.selected;
    [[AgoraManager shareManager].rtcEngineKit setEnableSpeakerphone:sender.selected];
}

- (void)cameraButtonClick {
    //相机翻转
    [self.cameraManager switchCamera];
}

#pragma mark - hangup
- (void)hangupMansionRoom {
    // 挂断府邸房间  房主调用
    [YLNetworkInterface closeMansionLinkWithMansionRoomId:_mansionRoomId];
    [self dismissViewController:@""];
}

- (void)hangupRoom:(NSString *)message {
    // 挂断小房间  主播调用
    [YLNetworkInterface breakMansionLinkWithMansionRoomId:_mansionRoomId roomId:_roomId breakUserId:[YLUserDefault userDefault].t_id result:nil];
    [self dismissViewController:message];
}

- (void)onwerHangupAnchorWithAnchor:(int)anchorid {
    // 房主挂断主播
    if (self.anchors.count == 0) return;
    int roomid = 0;
    for (NSDictionary *dic in self.anchors) {
        int t_id = [[NSString stringWithFormat:@"%@", dic[@"t_id"]] intValue];
        if (t_id == anchorid) {
            roomid = [[NSString stringWithFormat:@"%@", dic[@"roomId"]] intValue];
        }
    }
    if (roomid == 0) return;

    [YLNetworkInterface breakMansionLinkWithMansionRoomId:_mansionRoomId roomId:roomid breakUserId:[YLUserDefault userDefault].t_id result:nil];
}

- (void)dismissViewController:(NSString *)message {
    [LXTAlertView dismiss:^{
        if (self.matchTimer) {
            dispatch_source_cancel(self.matchTimer);
            self.matchTimer = nil;
        }
        [YLUserDefault saveConnet:NO];
        [YLUserDefault saveAppOnBack:NO roomId:0 socketOnLine:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self dismissViewControllerAnimated:YES completion:^{
            if (message.length > 0) {
                [SVProgressHUD showInfoWithStatus:message];
            }
        }];
    }];
}

#pragma mark - kickChannelUser
- (void)deleteButtonClick:(int)index {
    [self.view endEditing:YES];
    [self hideEmojiView];
    [LXTAlertView alertViewDefaultWithTitle:@"温馨提示" message:@"确定将这个主播踢出聊天房间？" sureHandle:^{
        if (index == 1234) {
            // 踢掉第一个位置的主播
            [self onwerHangupAnchorWithAnchor:(int)self.firstAnchorVideoView.userId];
            [self sendkickUserMessageWithAnchorId:(int)self.firstAnchorVideoView.userId];
        } else if (index == 1333) {
            // 踢掉第二个位置的主播
            [self onwerHangupAnchorWithAnchor:(int)self.secondAnchorVideoView.userId];
            [self sendkickUserMessageWithAnchorId:(int)self.secondAnchorVideoView.userId];
        } else if (index == 1244) {
            // 踢掉第三个位置的主播
            [self onwerHangupAnchorWithAnchor:(int)self.thirdAnchorVideoView.userId];
            [self sendkickUserMessageWithAnchorId:(int)self.thirdAnchorVideoView.userId];
        } else if (index == 1343) {
            // 踢掉第四个位置的主播
            [self onwerHangupAnchorWithAnchor:(int)self.fourthAnchorVideoView.userId];
            [self sendkickUserMessageWithAnchorId:(int)self.fourthAnchorVideoView.userId];
        }
    }];
}

#pragma mark - emoji
- (void)chatEmoji {
    [self.view endEditing:YES];
    self.emojiView.hidden = NO;
    CGFloat height = 55+(SafeAreaBottomHeight-49);
    [UIView animateWithDuration:0.25 animations:^{
        self.inputView.y = APP_Frame_Height-height-180;
        self.inputView.whiteView.alpha = 1;
        self.emojiView.y = self.inputView.y+55;
    }];
}

- (void)hideEmojiView {
    if (_emojiView.hidden == NO) {
        CGFloat height = 55+(SafeAreaBottomHeight-49);
        [UIView animateWithDuration:0.25 animations:^{
            self.inputView.y = APP_Frame_Height-height;
            self.inputView.whiteView.alpha = 0;
            self.emojiView.y = APP_Frame_Height;
        }];
        _emojiView.hidden = YES;
    }
}

- (void)sendEmojiMessage {
    [self sendIMText:self.inputView.inputTextField.text];
}

#pragma mark - TUIFaceView Delegate
- (void)faceView:(TUIFaceView *)faceView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TFaceGroup *group = [TUIKit sharedInstance].config.faceGroups[indexPath.section];
    TFaceCellData *face = group.faces[indexPath.row];
    [self.inputView.inputTextField setText:[self.inputView.inputTextField.text stringByAppendingString:face.name]];
}

- (void)faceViewDidBackDelete:(TUIFaceView *)faceView {
    if (self.inputView.inputTextField.text.length != 0) {
        UITextPosition *position = [self.inputView.inputTextField endOfDocument];
        self.inputView.inputTextField.selectedTextRange = [self.inputView.inputTextField textRangeFromPosition:position toPosition:position];
        [self.inputView.inputTextField deleteBackward];
    }
}

- (void)faceViewDidSendMsg:(TUIFaceView *)faceView {
    if (self.inputView.inputTextField.text.length > 0) {
        [self sendEmojiMessage];
    }
}

#pragma mark - IM - newMessage
- (void)receiveMessage:(NSNotification *)notification {
    NSMutableArray *array = [[notification userInfo] objectForKey:@"receive_msg_info_key"];
    TIMMessage *msg = array.firstObject;
    TIMConversation *conv = [msg getConversation];
    if (conv.getType != TIM_GROUP) {
        // 不是群聊  return
        return;
    }
    int groupId = [[conv getReceiver] intValue];
    if (groupId != self.mansionRoomId) {
        // 不是这个聊天室 退出
        return;
    }
    
    TIMUserProfile *user = [[TIMFriendshipManager sharedInstance] queryUserProfile:msg.sender];
    if (user) {
        [self addNewMessage:msg nickName:user.nickname];
    } else {
        //获取用户信息
        [[TIMFriendshipManager sharedInstance] getUsersProfile:@[msg.sender] forceUpdate:YES succ:^(NSArray<TIMUserProfile *> *profiles) {
            TIMUserProfile *file = [profiles firstObject];
            [self addNewMessage:msg nickName:file.nickname];
        } fail:^(int code, NSString *msg) {
            NSLog(@"___mansion 获取IM用户资料异常:%@", msg);
        }];
    }
}

- (void)addNewMessage:(TIMMessage*)msg nickName:(NSString *)name {
    TIMConversation *conv = [msg getConversation];
    if ([conv getType] == TIM_C2C) return; //单聊消息直接return
    
    NSInteger msgUserId = [msg.sender integerValue]-10000;
    TIMElem *elem = [msg getElem:0];
    if ([elem isKindOfClass:[TIMTextElem class]]) {
        TIMTextElem *textElem = (TIMTextElem *)elem;
        // 文本消息
        NSDictionary *param = @{@"messageType":@(MansionMessageTypeText),
                                @"t_id":@(msgUserId),
                                @"nickName":[NSString stringWithFormat:@"%@", name],
                                @"contentText":[NSString stringWithFormat:@"%@", textElem.text]};
        [self refreshMessageWithParam:param];
    } else if ([elem isKindOfClass:[TIMCustomElem class]]) {
        // 自定义消息
        TIMCustomElem *customElem = (TIMCustomElem *)elem;
        NSString *jsonStr  = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
        if ([jsonStr hasPrefix:@"serverSend&&"]) {
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"serverSend&&" withString:@"{"];
        }
        NSDictionary *dic = [YLJsonExtension dictionaryWithJsonString:jsonStr];
        NSString *type = dic[@"type"];
        if ([type isEqualToString:@"0"] || [type isEqualToString:@"1"]) {
            // 礼物
            NSDictionary *param = @{@"messageType":@(MansionMessageTypeGift),
                                    @"t_id":@(msgUserId),
                                    @"nickName":[NSString stringWithFormat:@"%@", name],
                                    @"gift_name":[NSString stringWithFormat:@"%@", dic[@"gift_name"]],
                                    @"gift_still_url":[NSString stringWithFormat:@"%@", dic[@"gift_still_url"]],
                                    @"gift_gif_url":[NSString stringWithFormat:@"%@", dic[@"gift_gif_url"]],
                                    @"otherName":[NSString stringWithFormat:@"%@", dic[@"otherName"]],
                                    @"otherId":[NSString stringWithFormat:@"%@", dic[@"otherId"]]};
            [self playGiftAnimation:param[@"gift_gif_url"]];
            [self refreshMessageWithParam:param];
        } else if ([type isEqualToString:@"kickUser"]) {
            // 踢人
            NSDictionary *param = @{@"messageType":@(MansionMessageTypeKickUser),
                                    @"t_id":@(msgUserId),
                                    @"nickName":[NSString stringWithFormat:@"%@", name],
                                    @"otherName" : [NSString stringWithFormat:@"%@", dic[@"otherName"]],
                                    @"otherId":[NSString stringWithFormat:@"%@", dic[@"otherId"]]};
            [self refreshMessageWithParam:param];
            int uid = [[NSString stringWithFormat:@"%@", dic[@"otherId"]] intValue];
            if (uid == [YLUserDefault userDefault].t_id) {
                //自己被踢掉
                [[AgoraManager shareManager] leaveChannel];
                [self.cameraManager stopCapture];
                [self sendleavedMessage];
                [self hangupRoom:@"你已被房主踢出房间"];
            } else {
                [self otherAnchorDidOfflineOfUid:uid];
            }
        } else if ([type isEqualToString:@"joined"]) {
            NSDictionary *param = @{@"messageType":@(MansionMessageTypeUserJoined),
                                    @"t_id":@(msgUserId),
                                    @"nickName":[NSString stringWithFormat:@"%@", name]};
            [self refreshMessageWithParam:param];
        } else if ([type isEqualToString:@"leaved"]) {
            NSDictionary *param = @{@"messageType":@(MansionMessageTypeUserLeaved),
                                    @"t_id":@(msgUserId),
                                    @"nickName":[NSString stringWithFormat:@"%@", name]};
            [self refreshMessageWithParam:param];
        }  else if ([type isEqualToString:@"pulp"]) {
            [self addOtherPulpShadeViewWithId:(int)msgUserId];
        }
    }
}

#pragma mark - IM
- (void)createChatGroup {
    // 创建聊天室  由房主创建聊天室  以府邸房间号作为聊天室的groupid
    TIMCreateGroupInfo *groupInfo = [[TIMCreateGroupInfo alloc] init];
    groupInfo.group = [NSString stringWithFormat:@"%d", self.mansionRoomId];
    groupInfo.groupName = self.titleStr;
    groupInfo.groupType = @"ChatRoom";
    [[TIMGroupManager sharedInstance] createGroup:groupInfo succ:^(NSString *groupId) {
        NSLog(@"groupid:%@",groupId);
        self.grpConversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:groupId];
        [self sendJoinedMessage];
    } fail:^(int code, NSString *msg) {
        if (code == 6014) {
            // IM sdk not login
            
        }
        NSLog(@"%@",msg);
    }];
}

- (void)deleteChatGroup {
    // 解散聊天室 由房主解散
    NSString *group = [NSString stringWithFormat:@"%d", self.mansionRoomId];
    [[TIMGroupManager sharedInstance] deleteGroup:group succ:^{
        NSLog(@"__mansion chat group delete success");
    } fail:^(int code, NSString *msg) {
        NSLog(@"__mansion chat group delete error:%@", msg);
    }];
}

- (void)joinChatGroup {
    // 加入聊天室  由主播加入
    NSString *group = [NSString stringWithFormat:@"%d", self.mansionRoomId];
    [[TIMGroupManager sharedInstance] joinGroup:group msg:nil succ:^{
        self.grpConversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:group];
        [self sendJoinedMessage];
    } fail:^(int code, NSString *msg) {
        if (code == 10013) {
            self.grpConversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:group];
            [self sendJoinedMessage];
        }
        NSLog(@"___mandion join IM room error:%@",msg);
    }];
}

// 进入房间消息
- (void)sendJoinedMessage {
    NSDictionary *param = @{@"messageType":@(MansionMessageTypeUserJoined),
                            @"t_id":@([YLUserDefault userDefault].t_id),
                            @"nickName":[NSString stringWithFormat:@"%@", [YLUserDefault userDefault].t_nickName],
                            @"type":@"joined"};
    NSString *jsonStr = [YLJsonExtension jsonStrWitNSDictonary:param];
    NSData *data =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];

    TIMCustomElem *customElem = [[TIMCustomElem alloc] init];
    [customElem setData:data];

    [self sendMessage:customElem param:param];
}

//离开房间消息
- (void)sendleavedMessage {
    NSDictionary *param = @{@"messageType":@(MansionMessageTypeUserLeaved),
                            @"t_id":@([YLUserDefault userDefault].t_id),
                            @"nickName":[NSString stringWithFormat:@"%@", [YLUserDefault userDefault].t_nickName],
                            @"type":@"leaved"};
    NSString *jsonStr = [YLJsonExtension jsonStrWitNSDictonary:param];
    NSData *data =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];

    TIMCustomElem *customElem = [[TIMCustomElem alloc] init];
    [customElem setData:data];

    [self sendMessage:customElem param:param];
}

// 文本消息
- (void)sendIMText:(NSString *)text {
    NSString *sendText = text;
    //判断输入的内容是否含有敏感词
    BOOL hasSensitive = [[SensitiveWordTools sharedInstance] hasSensitiveWord:text];
    if (hasSensitive) {
        sendText = [[SensitiveWordTools sharedInstance] filter:text];
    }
    NSDictionary *param = @{@"messageType":@(MansionMessageTypeText),
                            @"t_id":@([YLUserDefault userDefault].t_id),
                            @"nickName":[NSString stringWithFormat:@"%@", [YLUserDefault userDefault].t_nickName],
                            @"contentText" : [NSString stringWithFormat:@"%@", sendText]};
    
    TIMTextElem *textElem = [[TIMTextElem alloc] init];
    [textElem setText:sendText];
    
    [self sendMessage:textElem param:param];
}

- (void)sendkickUserMessageWithAnchorId:(int)anchorId {
    // 发送踢人IM 由房主发送
    [[TIMFriendshipManager sharedInstance] getUsersProfile:@[[NSString stringWithFormat:@"%d", anchorId+10000]] forceUpdate:YES succ:^(NSArray<TIMUserProfile *> *profiles) {
        TIMUserProfile *file = [profiles firstObject];
        NSString *otherName = file.nickname;
        
        NSDictionary *param = @{@"messageType":@(MansionMessageTypeKickUser),
                                @"t_id":@([YLUserDefault userDefault].t_id),
                                @"nickName":[NSString stringWithFormat:@"%@", [YLUserDefault userDefault].t_nickName],
                                @"otherName" : [NSString stringWithFormat:@"%@", otherName],
                                @"type":@"kickUser",
                                @"otherId":[NSString stringWithFormat:@"%d", anchorId]
        };
        
        NSString *jsonStr = [YLJsonExtension jsonStrWitNSDictonary:param];
        NSData *data =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        TIMCustomElem *customElem = [[TIMCustomElem alloc] init];
        [customElem setData:data];

        [self sendMessage:customElem param:param];
        
        [self otherAnchorDidOfflineOfUid:anchorId];
    } fail:^(int code, NSString *msg) {
        NSLog(@"___mansion 获取IM用户资料异常:%@", msg);
    }];
}

- (void)sendMessage:(TIMElem *)elem param:(NSDictionary *)param {
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    [self.grpConversation sendMessage:msg succ:^(){
        [self.view endEditing:YES];
        [self hideEmojiView];
        self.inputView.inputTextField.text = @"";
        [self refreshMessageWithParam:param];
    }fail:^(int code, NSString * err) {
        NSString *error = [NSString stringWithFormat:@"出错了->code:%d,msg:%@",code,err];
        NSLog(@"____im error:%@", error);
        [LXTAlertView  alertViewDefaultOnlySureWithTitle:@"温馨提示" message:error];
    }];
}

- (void)refreshMessageWithParam:(NSDictionary *)param {
    MansionMessageModel *model = [MansionMessageModel mj_objectWithKeyValues:param];
    [self.messageView.messageData addObject:model];
    [self.messageView reloadAndscrollToBottom];
}

#pragma mark - timer
- (void)startTimer {
    if (_matchTimer) return;
    __block NSInteger timeCount = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.matchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_matchTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_matchTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            timeCount++;
            if (self.isHouseOwner) {
                if (self.firstAnchorVideoView.videoBG.hidden == NO) {
                    self.firstCount ++;
                    self.firstTimeLabel.text = [SLHelper getHHMMSSFromSS:[NSString stringWithFormat:@"%ld", (long)self.firstCount]];
                }
                if (self.secondAnchorVideoView.videoBG.hidden == NO) {
                    self.secondCount ++;
                    self.secondTimeLabel.text = [SLHelper getHHMMSSFromSS:[NSString stringWithFormat:@"%ld", (long)self.secondCount]];
                }
                if (self.thirdAnchorVideoView.videoBG.hidden == NO) {
                    self.thirdCount ++;
                    self.thirdTimeLabel.text = [SLHelper getHHMMSSFromSS:[NSString stringWithFormat:@"%ld", (long)self.thirdCount]];
                }
                if (self.fourthAnchorVideoView.videoBG.hidden == NO) {
                    self.fourthCount ++;
                    self.fourthTimeLabel.text = [SLHelper getHHMMSSFromSS:[NSString stringWithFormat:@"%ld", (long)self.fourthCount]];
                }
            } else {
                if (self.selfVideoView == self.firstAnchorVideoView) {
                    self.firstCount ++;
                    self.firstTimeLabel.text = [SLHelper getHHMMSSFromSS:[NSString stringWithFormat:@"%ld", (long)self.firstCount]];
                } else if (self.selfVideoView == self.secondAnchorVideoView) {
                    self.secondCount ++;
                    self.secondTimeLabel.text = [SLHelper getHHMMSSFromSS:[NSString stringWithFormat:@"%ld", (long)self.secondCount]];
                } else if (self.selfVideoView == self.thirdAnchorVideoView) {
                    self.thirdCount ++;
                    self.thirdTimeLabel.text = [SLHelper getHHMMSSFromSS:[NSString stringWithFormat:@"%ld", (long)self.thirdCount]];
                } else if (self.selfVideoView == self.fourthAnchorVideoView) {
                    self.fourthCount ++;
                    self.fourthTimeLabel.text = [SLHelper getHHMMSSFromSS:[NSString stringWithFormat:@"%ld", (long)self.fourthCount]];
                }
                
                //轮询
                if (timeCount > 1 && timeCount%30 == 0) {
                    [self requestVideoState];
                }
            }
            
            
            
            //鉴黄
            if ((self.isHouseOwner == YES && self.t_screenshot_user_switch == 1) || (self.isHouseOwner == NO && self.t_screenshot_anchor_switch == 1)) {
                
                [self pulpTimeCountDown];
                
                if (self.t_screenshot_time_list.count > 0 && timeCount > 0 && self.chatType == MansionChatTypeVideo) {
                    //只有开关是1并且填写了截图时间间隔的才需要截图鉴黄
                    if (self.totleCount == 1) {
                        NSInteger listTime = [self.t_screenshot_time_list[0] integerValue];
                        if (timeCount == listTime-10) {
                            [self showTipAnimationWithCount:timeCount];
                        }
                        if (timeCount%listTime == 0) {
                            [self screenShot];
                        }
                    } else {
                        NSString *arrCountStr = self.t_screenshot_time_list[0];
                        NSInteger arrCount = [arrCountStr integerValue];
                        if (timeCount == arrCount-10) {
                            [self showTipAnimationWithCount:timeCount];
                        }
                        if (arrCount == timeCount && time > 0) {
                            [self screenShot];
                            if ([self.t_screenshot_time_list containsObject:arrCountStr]) {
                                [self.t_screenshot_time_list removeObject:arrCountStr];
                            }
                        }
                    }
                }
            }
            if (timeCount == self.animationCount+15) {
                [self removeTipAnimation];
            }
        });
    });
    dispatch_resume(_matchTimer);
}

- (void)requestVideoState {
    [YLNetworkInterface getVideoStatusWithUserId:(int)self.ownerId anchorId:[YLUserDefault userDefault].t_id roomId:self.roomId result:^(bool isSuccess) {
        if (!isSuccess) {
            //挂断
            [self hangupRoom:@"已挂断"];
        }
    }];
}

#pragma mark - agora
- (void)joinRoom {
    // 加入房间
    [[AgoraManager shareManager] joinMansionChannelWithRoomId:self.mansionRoomId addDelegate:self chatType:_chatType success:^{
        if (self.chatType == MansionChatTypeVideo) {
            [self initTTTRoomSelfVideoCanvas];
        } else {
            [self initVoiceVideoView];
        }
        if (self.isHouseOwner) {
            [self createChatGroup];
        } else {
            [self joinChatGroup];
        }
        } fail:^{
            [self dismissViewController:@"登录房间失败"];
        }];
}

- (void)initTTTRoomSelfVideoCanvas {
    // 设置自己的视频流
    if (self.isHouseOwner == YES) {
        self.selfVideoView = self.ownerVideoView;
    } else {
        if (self.anchors.count == 0) {
            self.firstAnchorVideoView.videoBG.hidden = NO;
            self.selfVideoView = self.firstAnchorVideoView;
        } else if (self.anchors.count == 1) {
            self.secondAnchorVideoView.videoBG.hidden = NO;
            self.selfVideoView = self.secondAnchorVideoView;
        } else if (self.anchors.count == 2) {
            self.thirdAnchorVideoView.videoBG.hidden = NO;
            self.selfVideoView = self.thirdAnchorVideoView;
        } else if (self.anchors.count == 3) {
            self.fourthAnchorVideoView.videoBG.hidden = NO;
            self.selfVideoView = self.fourthAnchorVideoView;
        }
        [self startTimer];
    }
    self.selfVideoView.cameraBtn.hidden = NO;
    self.selfVideoView.headImageView.image = [YLUserDefault userDefault].headImage;
    self.selfVideoView.nameLabel.text = [YLUserDefault userDefault].t_nickName;
    [self.selfVideoView.voiceBtn setImage:[UIImage imageNamed:@"mansion_room_mic"] forState:0];
    [self.selfVideoView.voiceBtn setImage:[UIImage imageNamed:@"mansion_room_mic_close"] forState:UIControlStateSelected];

    [self.cameraManager startCapture];
}

- (void)initVoiceVideoView {
    if (self.isHouseOwner == YES) {
        self.selfVideoView = self.ownerVideoView;
    } else {
        if (self.anchors.count == 0) {
            self.firstAnchorVideoView.videoBG.hidden = NO;
            self.selfVideoView = self.firstAnchorVideoView;
        } else if (self.anchors.count == 1) {
            self.secondAnchorVideoView.videoBG.hidden = NO;
            self.selfVideoView = self.secondAnchorVideoView;
        } else if (self.anchors.count == 2) {
            self.thirdAnchorVideoView.videoBG.hidden = NO;
            self.selfVideoView = self.thirdAnchorVideoView;
        } else if (self.anchors.count == 3) {
            self.fourthAnchorVideoView.videoBG.hidden = NO;
            self.selfVideoView = self.fourthAnchorVideoView;
        }
        [self startTimer];
    }
    [self.selfVideoView.voiceBtn setImage:[UIImage imageNamed:@"mansion_room_mic"] forState:0];
    [self.selfVideoView.voiceBtn setImage:[UIImage imageNamed:@"mansion_room_mic_close"] forState:UIControlStateSelected];
    self.selfVideoView.videoImageV.contentMode = UIViewContentModeScaleAspectFill;
    if ([YLUserDefault userDefault].headImage) {
        self.selfVideoView.videoImageV.image = [YLUserDefault userDefault].headImage;
    }
}

- (void)initTTTRoomOtherVideoCanvasWithId:(int)userId {
    if (userId == self.ownerId) {
        // 设置房主的远端视频流
        self.ownerVideoCanvas.uid = _ownerId;
        _ownerVideoCanvas.view = nil;
        _ownerVideoCanvas.view = self.ownerVideoView.videoImageV;
        [[AgoraManager shareManager].rtcEngineKit setupRemoteVideo:self.ownerVideoCanvas];
        return;
    }
    // 设置主播的远端视频流
    if (self.firstAnchorVideoView.videoBG.hidden == YES) {
        self.firstAnchorVideoView.videoBG.hidden = NO;
        self.firstAnchorVideoView.userId = userId;
        self.firstAnchorVideoCanvas.uid = userId;
        _firstAnchorVideoCanvas.view = nil;
        _firstAnchorVideoCanvas.view = self.firstAnchorVideoView.videoImageV;
        [[AgoraManager shareManager].rtcEngineKit setupRemoteVideo:self.firstAnchorVideoCanvas];
        [self startTimer];
    } else if (self.secondAnchorVideoView.videoBG.hidden == YES) {
        self.secondAnchorVideoView.videoBG.hidden = NO;
        self.secondAnchorVideoView.userId = userId;
        self.secondAnchorVideoCanvas.uid = userId;
        _secondAnchorVideoCanvas.view = nil;
        _secondAnchorVideoCanvas.view = self.secondAnchorVideoView.videoImageV;
        [[AgoraManager shareManager].rtcEngineKit setupRemoteVideo:self.secondAnchorVideoCanvas];
    } else if (self.thirdAnchorVideoView.videoBG.hidden == YES) {
        self.thirdAnchorVideoView.videoBG.hidden = NO;
        self.thirdAnchorVideoView.userId = userId;
        self.thirdAnchorVideoCanvas.uid = userId;
        _thirdAnchorVideoCanvas.view = nil;
        _thirdAnchorVideoCanvas.view = self.thirdAnchorVideoView.videoImageV;
        [[AgoraManager shareManager].rtcEngineKit setupRemoteVideo:self.thirdAnchorVideoCanvas];
        [self startTimer];
    } else if (self.fourthAnchorVideoView.videoBG.hidden == YES) {
        self.fourthAnchorVideoView.videoBG.hidden = NO;
        self.fourthAnchorVideoView.userId = userId;
        self.fourthAnchorVideoCanvas.uid = userId;
        _fourthAnchorVideoCanvas.view = nil;
        _fourthAnchorVideoCanvas.view = self.fourthAnchorVideoView.videoImageV;
        [[AgoraManager shareManager].rtcEngineKit setupRemoteVideo:self.fourthAnchorVideoCanvas];
    }
}

- (void)initVoiceVideoId:(int)userId {
    if (userId == self.ownerId) {
        self.ownerVideoCanvas.uid = _ownerId;
        return;
    }
    if (self.firstAnchorVideoView.videoBG.hidden == YES) {
        self.firstAnchorVideoView.videoBG.hidden = NO;
        self.firstAnchorVideoView.userId = userId;
        [self startTimer];
    } else if (self.secondAnchorVideoView.videoBG.hidden == YES) {
        self.secondAnchorVideoView.videoBG.hidden = NO;
        self.secondAnchorVideoView.userId = userId;
    } else if (self.thirdAnchorVideoView.videoBG.hidden == YES) {
        self.thirdAnchorVideoView.videoBG.hidden = NO;
        self.thirdAnchorVideoView.userId = userId;
    } else if (self.fourthAnchorVideoView.videoBG.hidden == YES) {
        self.fourthAnchorVideoView.videoBG.hidden = NO;
        self.fourthAnchorVideoView.userId = userId;
    }
}

#pragma mark - AgoraRtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    if (uid == [YLUserDefault userDefault].t_id) {
        return;
    }
    if (_chatType == MansionChatTypeVideo) {
        [self initTTTRoomOtherVideoCanvasWithId:(int)uid];
    } else {
        [self initVoiceVideoId:(int)uid];
    }
    
    [self requestMansionRoomInfo];
    self.cameraManager.isChatLived = YES;
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    NSLog(@"___府邸  userLog 用户离线回调 id:%ld reason:%lu", uid, (unsigned long)reason);
    if (uid == [YLUserDefault userDefault].t_id) {
        return;
    }
    if (uid == self.ownerId) {
        // 房主离线  直接退出
        [[AgoraManager shareManager] leaveChannel];
        [self.cameraManager stopCapture];
        [self hangupRoom:@"房主已挂断"];
    } else {
        [self otherAnchorDidOfflineOfUid:uid];
    }
}

- (void)otherAnchorDidOfflineOfUid:(NSUInteger)uid {
    for (NSDictionary *dic in self.anchors.copy) {
        int t_id = [[NSString stringWithFormat:@"%@", dic[@"t_id"]] intValue];
        if (t_id == uid) {
            [self.anchors removeObject:dic];
        }
    }
    if (self.isHouseOwner) {
        [self onwerHangupAnchorWithAnchor:(int)uid];
        if(self.anchors.count == 0 && self.matchTimer){
            dispatch_source_cancel(self.matchTimer);
            self.matchTimer = nil;
        }
    }
    if (uid == self.firstAnchorVideoView.userId) {
        self.firstAnchorVideoView.videoImageV.image = nil;
        self.firstAnchorVideoView.videoBG.hidden = YES;
        self.firstAnchorVideoView.voiceBtn.selected = NO;
        self.firstNameLabel.text = @"";
        self.firstTimeLabel.text = @"";
        self.firstCount = 0;
    } else if (uid == self.secondAnchorVideoView.userId) {
        self.secondAnchorVideoView.videoImageV.image = nil;
        self.secondAnchorVideoView.videoBG.hidden = YES;
        self.secondAnchorVideoView.voiceBtn.selected = NO;
        self.secondNameLabel.text = @"";
        self.secondTimeLabel.text = @"";
        self.secondCount = 0;
    } else if (uid == self.thirdAnchorVideoView.userId) {
        self.thirdAnchorVideoView.videoImageV.image = nil;
        self.thirdAnchorVideoView.videoBG.hidden = YES;
        self.thirdAnchorVideoView.voiceBtn.selected = NO;
        self.thirdNameLabel.text = @"";
        self.thirdTimeLabel.text = @"";
        self.thirdCount = 0;
    } else if (uid == self.fourthAnchorVideoView.userId) {
        self.fourthAnchorVideoView.videoImageV.image = nil;
        self.fourthAnchorVideoView.videoBG.hidden = YES;
        self.fourthAnchorVideoView.voiceBtn.selected = NO;
        self.fourthNameLabel.text = @"";
        self.fourthTimeLabel.text = @"";
        self.fourthCount = 0;
    }
}

#pragma mark - lazy loading
- (AgoraRtcVideoCanvas *)ownerVideoCanvas {
    if (!_ownerVideoCanvas) {
        _ownerVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        _ownerVideoCanvas.renderMode = AgoraVideoRenderModeHidden;
        _ownerVideoCanvas.view = _ownerVideoView.videoImageV;
    }
    return _ownerVideoCanvas;
}

- (AgoraRtcVideoCanvas *)firstAnchorVideoCanvas {
    if (!_firstAnchorVideoCanvas) {
        _firstAnchorVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        _firstAnchorVideoCanvas.renderMode = AgoraVideoRenderModeHidden;
        _firstAnchorVideoCanvas.view = _firstAnchorVideoView.videoImageV;
    }
    return _firstAnchorVideoCanvas;
}

- (AgoraRtcVideoCanvas *)secondAnchorVideoCanvas {
    if (!_secondAnchorVideoCanvas) {
        _secondAnchorVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        _secondAnchorVideoCanvas.renderMode = AgoraVideoRenderModeHidden;
        _secondAnchorVideoCanvas.view = _secondAnchorVideoView.videoImageV;
    }
    return _secondAnchorVideoCanvas;
}

- (AgoraRtcVideoCanvas *)thirdAnchorVideoCanvas {
    if (!_thirdAnchorVideoCanvas) {
        _thirdAnchorVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        _thirdAnchorVideoCanvas.renderMode = AgoraVideoRenderModeHidden;
        _thirdAnchorVideoCanvas.view = _thirdAnchorVideoView.videoImageV;
    }
    return _thirdAnchorVideoCanvas;
}

- (AgoraRtcVideoCanvas *)fourthAnchorVideoCanvas {
    if (!_fourthAnchorVideoCanvas) {
        _fourthAnchorVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        _fourthAnchorVideoCanvas.renderMode = AgoraVideoRenderModeHidden;
        _fourthAnchorVideoCanvas.view = _fourthAnchorVideoView.videoImageV;
    }
    return _fourthAnchorVideoCanvas;
}

- (TUIFaceView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[TUIFaceView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height, App_Frame_Width, 180)];
        _emojiView.delegate = self;
        _emojiView.hidden = YES;
        [_emojiView setData:[NSMutableArray arrayWithArray:[TUIKit sharedInstance].config.faceGroups]];
        [self.view addSubview:_emojiView];
        
        UIButton *sendBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-70, 140, 70, 40) text:@"发送" font:15 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
        sendBtn.backgroundColor = UIColor.grayColor;
        [sendBtn addTarget:self action:@selector(sendEmojiMessage) forControlEvents:UIControlEventTouchUpInside];
        [_emojiView addSubview:sendBtn];
    }
    return _emojiView;
}

#pragma mark - FU camera
- (FUCameraManager *)cameraManager {
    if (!_cameraManager) {
        _cameraManager = [[FUCameraManager alloc] init];
        [_cameraManager setLocalView:self.selfVideoView.videoImageV];
    }
    return _cameraManager;
}

#pragma mark - dealloc
- (void)dealloc {
//    if (_matchTimer) {
//        dispatch_source_cancel(_matchTimer);
//        _matchTimer = nil;
//    }
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 1v2 鉴黄
- (void)requestScreenShotStatus {
    if (self.chatType == MansionChatTypeVoice) return;
    //鉴黄开关
    self.totleCount = 0;
    self.t_screenshot_time_list = [NSMutableArray array];
    [YLNetworkInterface getVideoScreenshotStatusSuccess:^(NSDictionary *dataDic) {
        self.t_screenshot_anchor_switch = [dataDic[@"t_screenshot_anchor_switch"] boolValue];
        self.t_screenshot_user_switch = [dataDic[@"t_screenshot_user_switch"] boolValue];
        self.t_screenshot_time_list = [NSMutableArray arrayWithArray:dataDic[@"t_screenshot_time_list"]];
        self.totleCount = self.t_screenshot_time_list.count;
        if (![[NSString stringWithFormat:@"%@", dataDic[@"t_screenshot_video_content"]] containsString:@"null"]) {
            self.tipContent = [NSString stringWithFormat:@"%@", dataDic[@"t_screenshot_video_content"]];
        }
    }];
    self.animationCount = MAXFLOAT;
}

- (UILabel *)yellowTipLabel {
    if (!_yellowTipLabel) {
        NSString *text = @"注意注意注意 十秒后要鉴黄截图 请规范视频";
        _yellowTipLabel = [UIManager initWithLabel:CGRectMake(App_Frame_Width, SafeAreaTopHeight-44+200, App_Frame_Width-60, 90) text:text font:16 textColor:UIColor.redColor];
        _yellowTipLabel.numberOfLines = 3;
        [self.view addSubview:_yellowTipLabel];
    }
    return _yellowTipLabel;
}

- (void)showTipAnimationWithCount:(NSInteger)count {
    self.yellowTipLabel.text = self.tipContent;
    self.animationCount = count;
    self.yellowTipLabel.x = App_Frame_Width;
    [UIView animateWithDuration:1 animations:^{
        self.yellowTipLabel.x = 30;
    }];
}

- (void)removeTipAnimation {
    if (!_yellowTipLabel) return;
    [UIView animateWithDuration:1 animations:^{
        self.yellowTipLabel.x = -self.yellowTipLabel.width;
    }];
}

//截图鉴黄  鉴定
- (void)screenShot {
    UIImage *image = self.selfVideoView.videoImageV.image;
    [YLNetworkInterface qiniuPictureIdentify:image result:^(bool isPulp) {
        if (isPulp == 1) {
            [self postPulpResult];
            [self addSelfPulpShadeView];
            [self showPulpAlertView];
        }
    }];
}

- (void)showPulpAlertView {
    if (!_alertView) {
        _alertView = [[VideoWarningAlertView alloc] init];
        [_alertView showWithContent:@"你可能存在不文明行为，系统已将你的视频关闭，请规范自己的行为。15秒后视频将重新打开。"];
    }
}

- (void)postPulpResult {
    NSDictionary *param = @{@"userId":[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                            @"videoUserId":@"0",
                            @"videoAnchorUserId":@"0",
                            @"roomId":[NSString stringWithFormat:@"%d", self.roomId],
                            @"mansionRoomId":[NSString stringWithFormat:@"%d", self.mansionRoomId],
    };
    [YLNetworkInterface addVideoScreenshotInfoWithParam:param];
}

- (void)sendPulpIMMessage {
    NSDictionary *dataDic = @{@"type" : @"pulp"};
    NSString *jsonStr = [YLJsonExtension jsonStrWitNSDictonary:dataDic];
    NSData *data =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    TIMCustomElem *customElem = [[TIMCustomElem alloc] init];
    [customElem setData:data];
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:customElem];
    [self.grpConversation sendMessage:msg succ:nil fail:nil];
}

- (void)addSelfPulpShadeView {
    [self sendPulpIMMessage];
    self.selfShade = [[PulpShadeView alloc] initWithSuperView:self.selfVideoView isSelf:YES];
}

- (void)addOtherPulpShadeViewWithId:(int)otherId {
    MansionVideoShowView *showView;
    
    if (otherId == self.ownerId) {
        showView = self.ownerVideoView;
    } else if (otherId == self.firstAnchorVideoView.userId) {
        showView = self.firstAnchorVideoView;
    } else if (otherId == self.secondAnchorVideoView.userId) {
        showView = self.secondAnchorVideoView;
    } else if (otherId == self.thirdAnchorVideoView.userId) {
        showView = self.thirdAnchorVideoView;
    } else if (otherId == self.fourthAnchorVideoView.userId) {
        showView = self.fourthAnchorVideoView;
    }
    
    if (!_firstShade) {
        self.firstShade = [[PulpShadeView alloc] initWithSuperView:showView isSelf:NO];
    } else {
        self.secondShade = [[PulpShadeView alloc] initWithSuperView:showView isSelf:NO];
    }
}

- (void)pulpTimeCountDown {
    [self.selfShade pulpViewCountDown];
    if (self.selfShade.pulpCount <= 0) {
        self.selfShade = nil;
        if (_alertView) {
            [_alertView removeFromSuperview];
            _alertView = nil;
        }
    }
    
    [self.firstShade pulpViewCountDown];
    if (self.firstShade.pulpCount <= 0) {
        self.firstShade = nil;
    }
    
    [self.secondShade pulpViewCountDown];
    if (self.secondShade.pulpCount <= 0) {
        self.secondShade = nil;
    }
    
}



@end
