//
//  UserChatLivingViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/2/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "UserChatLivingViewController.h"
#import "YLRechargeVipController.h"
#import "ChatLiveMeCallOtherView.h"
#import "ChatLiveOtherCallMeView.h"
#import "YLTapGesture.h"
#import "UIAlertCon+Extension.h"
#import "YLValidExtension.h"
#import "ZYGiftRedEnvep.h"
#import "YLJsonExtension.h"
#import "GiftModel.h"
#import "YLBrushGigft.h"
#import "YLAudioPlay.h"
#import "UserMatchingLivingView.h"
#import "YLInsufficientManager.h"
#import "liveSuffiView.h"
#import "SVGAParser.h"
#import "SVGAPlayer.h"
#import "NewMessageAlertView.h"
#import "SensitiveWordTools.h"

#import "LXTAlertView.h"
#import "VideoWarningAlertView.h"
#import "YLUploadImageExtension.h"
#import "BanRecordingManager.h"
#import "APIManager.h"

#import "AgoraManager.h"
#import "FUCameraManager.h"

#import "PulpShadeView.h"

#import "TiUIManager.h"
#import <TiSDK/TiSDK.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "WelcomeViewController.h"

@interface UserChatLivingViewController ()

<
SVGAPlayerDelegate,
AgoraRtcEngineDelegate
>

//呼叫视图
@property (nonatomic, strong) ChatLiveMeCallOtherView   *chatLiveMeCallOtherView;
//被呼叫视图
@property (nonatomic, strong) ChatLiveOtherCallMeView   *chatLiveOtherCallMeView;
//主播数据
@property (nonatomic, strong) PersonalDataHandle        *personalHandle;
//主窗口
@property (nonatomic, strong) UIImageView   *windowBigImageView;
//接通视频试图
@property (nonatomic, strong) UserMatchingLivingView    *liveView;
//余额不足
@property (nonatomic, strong) liveSuffiView             *suffiView;
//计时器
@property (nonatomic, strong) dispatch_source_t matchTimer;
//切换大小画面标识
@property (nonatomic, assign) BOOL          isChangedViewTemp;
//是否连接成功
@property (nonatomic, assign) BOOL          isChatLived;

/** 视频时聊天信息 */
@property (nonatomic, strong) TIMConversation *c2cConversation;
/** 收到的上一条消息 */
@property (nonatomic, strong) TIMMessage      *lastMessage;

//礼物特效
@property (nonatomic, strong) SVGAParser    *parser;
@property (nonatomic, strong) SVGAPlayer    *player;

@property (nonatomic, strong) UIImageView    *locationVideoImageView;

@property (nonatomic, strong) UIImageView *otherImageView;
@property (nonatomic, strong) UILabel *cameraLabel;
@property (nonatomic, strong) UIImageView *selfHeadImageV;
@property (nonatomic, strong) UIImageView *cycleImageView;

//截图鉴黄
@property (nonatomic, assign) BOOL t_screenshot_user_switch;
@property (nonatomic, strong) NSMutableArray *t_screenshot_time_list;
@property (nonatomic, assign) NSInteger totleCount;
@property (nonatomic, strong) UILabel *yellowTipLabel;
@property (nonatomic, assign) NSInteger animationCount;
@property (nonatomic, copy) NSString *tipContent;
@property (nonatomic, strong) VideoWarningAlertView *alertView;
@property (nonatomic, strong) UIView *selfView; //用于添加自己视图的蒙版
@property (nonatomic, strong) UIView *anchorView; //用于添加用用户视图的蒙版
@property (nonatomic, strong) PulpShadeView *selfShade;
@property (nonatomic, strong) PulpShadeView *otherShade;

@property (nonatomic, strong) FUCameraManager *cameraManager;

@property (nonatomic, assign) BOOL isCamereMuted;//是否关闭了摄像头

@property (nonatomic, strong) TiSDKManager   *tiSDKManager;

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, strong) UILabel *ocrTipLabel;

@end

@implementation UserChatLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.blackColor;
    
    //截图鉴黄  请求是否需要截图鉴黄开关和时间
    self.totleCount = 0;
    self.t_screenshot_time_list = [NSMutableArray array];
    [YLNetworkInterface getVideoScreenshotStatusSuccess:^(NSDictionary *dataDic) {
        self.t_screenshot_user_switch = [dataDic[@"t_screenshot_user_switch"] boolValue];
        self.t_screenshot_time_list = [NSMutableArray arrayWithArray:dataDic[@"t_screenshot_time_list"]];
        self.totleCount = self.t_screenshot_time_list.count;
        if (![[NSString stringWithFormat:@"%@", dataDic[@"t_screenshot_video_content"]] containsString:@"null"]) {
            self.tipContent = [NSString stringWithFormat:@"%@", dataDic[@"t_screenshot_video_content"]];
        }
    }];
    
    [self initWithVideoWindow];
    
    
    //金币耗尽，系统挂断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedLivingViewEndBtn) name:@"videoIsOnHangupNoti" object:nil];
    //余额不足
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coinsCannotPayVideochat) name:@"liveInsuffiveNoti" object:nil];
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    //视频接通后的系统消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSystemMsg:) name:@"ChatLivingSystemMsgNotification" object:nil];
    //收到新消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"receive_msg_notification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(warningAlert:) name:@"RECIEVEVIDEOWARNING" object:nil];
    
    self.animationCount = MAXFLOAT;
}

- (void)initWithTiLive {
    self.tiSDKManager = [[TiSDKManager alloc] init];
    
    [[TiUIManager shareManager] setShowsDefaultUI:YES];
    [[TiUIManager shareManager] loadToView:self.view forDelegate:nil];
}

- (void)dealloc {
    
    [self.tiSDKManager destroy];
}

- (void)warningAlert:(NSNotification *)not {
    NSString *content = (NSString *)not.object;
    VideoWarningAlertView *alert = [[VideoWarningAlertView alloc] init];
    [alert showWithContent:content];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[NewMessageAlertView shareView] stopAnimation];
    
    // 开启屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[BanRecordingManager shareManager] addBanScreenRecordingNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[MansionSendGiftView shareView] dismiss];
    [[BanRecordingManager shareManager] removeBanScreenRecordingNotification];
}


#pragma mark -- UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    if (_isMeCallOther) {
        //呼叫
        [self.view addSubview:self.chatLiveMeCallOtherView];
        _chatLiveMeCallOtherView.isUser = YES;
    } else {
        //被呼叫
        [self.view addSubview:self.chatLiveOtherCallMeView];
        _chatLiveOtherCallMeView.isUser = YES;
    }
    
    [self getDataWithAnthor];
    
    //添加事件
    [YLTapGesture addTaget:self sel:@selector(clickedLivingViewSwitchBtn) view:_chatLiveMeCallOtherView.switchBtn];
    [YLTapGesture addTaget:self sel:@selector(clickedLivingViewEndBtn) view:_chatLiveMeCallOtherView.endBtn];
    [YLTapGesture addTaget:self sel:@selector(clickedLivingViewEndBtn) view:_chatLiveOtherCallMeView.endBtn];
    [YLTapGesture addTaget:self sel:@selector(clickedLivingViewChatBtn) view:_chatLiveOtherCallMeView.chatBtn];
    [YLTapGesture addTaget:self sel:@selector(clickedLivingViewSwitchBtn) view:self.liveView.userMatchingLivingActionView.switchBtn];
    [YLTapGesture addTaget:self sel:@selector(clickedFollowBtn) view:_liveView.userMatchingLivingPersonView.followBtn];
    [YLTapGesture addTaget:self sel:@selector(clickedLivingViewChangeBtn) view:_liveView.userMatchingLivingActionView.changeBtn];
    [YLTapGesture addTaget:self sel:@selector(endButtonClick:) view:_liveView.userMatchingLivingActionView.endBtn];
    [YLTapGesture addTaget:self sel:@selector(clickedLivingViewGiftBtn) view:_liveView.userMatchingLivingActionView.giftBtn];
    [YLTapGesture addTaget:self sel:@selector(clickedLivingViewVoiceBtn) view:_liveView.userMatchingLivingActionView.voiceBtn];
    [YLTapGesture addTaget:self sel:@selector(clickedLivingViewMsgBtn) view:_liveView.userMatchingLivingActionView.msgBtn];
    
    [YLTapGesture tapGestureTarget:self sel:@selector(clickedLivingViewSmallBlackView) view:_liveView.smallRightTopVideoBlackView];
    
}


- (void)initWithVideoWindow {
    
    
    if (_isMeCallOther) {
        
        [self startMatchingGCDTimerIsFirst:YES];
        
        [self.view addSubview:self.windowBigImageView];
        
        [self joinChannel];
    }
    
    [self setupUI];
}

- (void)addSystemMsg:(NSNotification *)notification {
    NSString *strMsg  = notification.object;
    [_liveView chatLivingMsgListData:strMsg isSelf:NO isSystemMsg:YES];
}

#pragma mark -- Net
- (void)getDataWithAnthor {
    WEAKSELF
    //lsl update start
    [YLNetworkInterface getUserInfoByIdUser:_anthorId block:^(personalCenterHandle *handle) {
        PersonalDataHandle *dataHandle = [PersonalDataHandle new];
        
        dataHandle.t_nickName = handle.nickName;
        dataHandle.t_handImg = handle.handImg;
        dataHandle.t_cover_img = handle.t_cover_img;
        dataHandle.t_addres_url = handle.t_addres_url;
        dataHandle.t_video_img = handle.t_cover_img;
        dataHandle.t_age = [NSString stringWithFormat:@"%d",handle.t_age];
        dataHandle.t_vocation = handle.t_vocation;
        dataHandle.t_idcard = [handle.t_idcard intValue];
        dataHandle.isFollow = handle.isFollow;
        dataHandle.t_city = handle.t_city;
        
        weakSelf.personalHandle = dataHandle;
        
        if (weakSelf.isMeCallOther) {
            [weakSelf.chatLiveMeCallOtherView.chatLivePersonInfoView initWithData:dataHandle];
        } else {
            [weakSelf.chatLiveOtherCallMeView.chatLivePersonInfoView initWithData:dataHandle];
            weakSelf.chatLiveOtherCallMeView.tempLb.text = [NSString stringWithFormat:@"%@邀请您进行视频通话...",dataHandle.t_nickName];
            
            if (dataHandle.t_addres_url.length > 0) {
                //显示视频
                weakSelf.chatLiveOtherCallMeView.playerUrl = dataHandle.t_addres_url;
                if (dataHandle.t_video_img.length > 0) {
                    [weakSelf.chatLiveOtherCallMeView.coverImageView sd_setImageWithURL:[NSURL URLWithString:dataHandle.t_video_img]];
                }
                
            } else {
                //显示封面
                if (dataHandle.t_cover_img.length > 0) {
                    weakSelf.chatLiveOtherCallMeView.coverImageView.width = APP_Frame_Height;
                    weakSelf.chatLiveOtherCallMeView.coverImageView.center= weakSelf.chatLiveOtherCallMeView.center;
                    [weakSelf.chatLiveOtherCallMeView.coverImageView sd_setImageWithURL:[NSURL URLWithString:dataHandle.t_cover_img]];
                }
            }
        }
        
    }];
    //lsl update end
}

- (void)postDataWithFollow {
    [SVProgressHUD showWithStatus:@"关注中..."];
    WEAKSELF
    [YLNetworkInterface addAttention:[YLUserDefault userDefault].t_id coverFollowUserId:_anthorId block:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.liveView.anchorModel.isFollow = 1;
            [weakSelf.liveView.userMatchingLivingPersonView.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        }
    }];
}

- (void)postDataWithFollowed {

    WEAKSELF
    [YLNetworkInterface cancelAtttention:[YLUserDefault userDefault].t_id coverFollowUserId:_anthorId  block:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.liveView.anchorModel.isFollow = 0;
            [weakSelf.liveView.userMatchingLivingPersonView.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        }
    }];
}

- (void)beginTimer {
    WEAKSELF
    [YLNetworkInterface videoCharBeginTimingAnthorId:_anthorId userId:[YLUserDefault userDefault].t_id roomId:_roomId chatType:1 block:^(int code) {
        if (code == 1) {
            if (!weakSelf.isMeCallOther) {
                [self joinChannel];
            }
            
            //创建单聊会话
            NSString *identifier = [NSString stringWithFormat:@"%d",self.anthorId+10000];
            self.c2cConversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:identifier];
            
            //保存主播ID 用于结束后的评价主播
            NSDictionary *dic = @{@"connectUserId":@(weakSelf.anthorId)};
            [YLUserDefault saveDic:dic];
            
        } else if (code == -1) {
            //余额不足
            weakSelf.chatLiveOtherCallMeView.chatBtn.enabled = YES;
            [[YLInsufficientManager shareInstance] insufficientShow];
        } else {
            weakSelf.chatLiveOtherCallMeView.chatBtn.enabled = YES;
            weakSelf.isChatLived = NO;
            if (code == -7) {
                [LXTAlertView videoVIPAlert];
            } else {
                [weakSelf clickedLivingViewEndBtn];
            }
        }
    }];
}

- (void)sendIMText:(NSString *)text {
    NSString *sendText = text;
    //判断输入的内容是否含有敏感词
    BOOL hasSensitive = [[SensitiveWordTools sharedInstance] hasSensitiveWord:text];
    if (hasSensitive) {
        sendText = [[SensitiveWordTools sharedInstance] filter:text];
    }
    
    TIMTextElem *textElem = [[TIMTextElem alloc] init];
    [textElem setText:sendText];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:textElem];
    
    [self.c2cConversation sendMessage:msg succ:^(){
        
        [self updateMessage:msg];
        
    }fail:^(int code, NSString * err) {
        NSString *error = [NSString stringWithFormat:@"出错了->code:%d,msg:%@",code,err];
        [SLAlertController alertControllerWithStyle:UIAlertControllerStyleAlert controller:self alertControllerTitle:@"温馨提示" alertControllerMessage:error alertControllerSheetActionTitles:nil alertControllerSureActionTitle:nil alertControllerCancelActionTitle:@"知道了" alertControllerSheetActionBlock:nil alertControllerAlertSureActionBlock:nil alertControllerAlertCancelActionBlock:nil];
    }];
    
}

- (void)updateMessage:(TIMMessage *)msg {
    
    //上报已读
    [self.c2cConversation setReadMessage:nil succ:nil fail:nil];
    
    if ([msg isEqual:_lastMessage]) {
        return;
    }
    
    _lastMessage = msg;
    
    
    int cnt = [msg elemCount];
    for (int i = 0; i < cnt; i++) {
        TIMElem *elem = [msg getElem:i];
        
        //文字消息
        if ([elem isKindOfClass:[TIMTextElem class]]) {
            TIMTextElem *textElem = (TIMTextElem *)elem;
            if (msg.isSelf) {
                NSString *msg = [NSString stringWithFormat:@"我：%@",textElem.text];
                [_liveView chatLivingMsgListData:msg isSelf:YES isSystemMsg:NO];
                
            } else {
                [_liveView chatLivingMsgListData:textElem.text isSelf:NO isSystemMsg:NO];
            }
        }
        
    }
    
}


#pragma mark -- Action
- (void)clickedLivingViewSwitchBtn {
    if (self.chatLiveMeCallOtherView.switchBtn.selected) {
        _chatLiveMeCallOtherView.switchBtn.selected = NO;
        self.liveView.userMatchingLivingActionView.switchBtn.selected = NO;
        _chatLiveMeCallOtherView.tempLb.text = @"关闭摄像头";
        [[AgoraManager shareManager] muteLocalVideoStream:NO];
        [YLUserDefault saveLocalVideo:YES];
//        _liveView.smallRightTopVideoBlackView.backgroundColor = [UIColor clearColor];
//        _liveView.fullVideoBlackView.backgroundColor = [UIColor clearColor];

        //开启摄像头之后能切换
//        _liveView.smallRightTopVideoBlackView.userInteractionEnabled = YES;
        
        self.isCamereMuted = NO;
    } else {
        //关闭右上角的视图,主播的视图变回满屏视图
//        self.locationVideoImageView = _liveView.smallRightTopVideoImageView;
//        self.selfView = _liveView.smallRightTopVideoBlackView;
//        self.anchorView = _liveView.fullVideoBlackView;
//        _liveView.smallRightTopVideoBlackView.backgroundColor = [UIColor blackColor];
//        _liveView.fullVideoBlackView.backgroundColor = [UIColor clearColor];

//        _isChangedViewTemp = NO;
        //关闭摄像头之后不能切换
//        _liveView.smallRightTopVideoBlackView.userInteractionEnabled = NO;
        
        _chatLiveMeCallOtherView.switchBtn.selected = YES;
        self.liveView.userMatchingLivingActionView.switchBtn.selected = YES;
        _chatLiveMeCallOtherView.tempLb.text = @"开启摄像头";
        [[AgoraManager shareManager] muteLocalVideoStream:YES];
        [YLUserDefault saveLocalVideo:NO];
        
        self.isCamereMuted = YES;
    }
    
    if (self.isCamereMuted) {
        [_liveView setIsShowCloseCamera:YES isBigView:_isChangedViewTemp isSelf:YES];
    } else {
        [_liveView setIsShowCloseCamera:NO isBigView:_isChangedViewTemp isSelf:YES];
    }
}

- (void)endButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    [LXTAlertView alertViewWithTitle:@"" message:@"你确定退出聊天吗？" cancleTitle:@"狠心挂断" sureTitle:@"再聊一会" sureHandle:^{
        
    } cancleHandle:^{
        [self clickedLivingViewEndBtn];
    }];
}

- (void)clickedLivingViewEndBtn {
    [LXTAlertView dismiss:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        if (self.matchTimer) {
            dispatch_source_cancel(self.matchTimer);
        }
        
        [[YLAudioPlay shareInstance] callEndPlay];
        [[YLAudioPlay shareInstance] stopDisplayLink];
        [YLUserDefault saveConnet:NO];
        [YLUserDefault saveAppOnBack:NO roomId:self.roomId socketOnLine:NO];
        [YLNetworkInterface breakLinkRoomId:self.roomId];
        
        [self.cameraManager stopCapture];
        [[AgoraManager shareManager] leaveChannel];
                
        // 关闭屏幕常亮
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        if (self.isChatLived) {
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"inputStarRateVCNoti" object:nil userInfo:@{@"id":[NSString stringWithFormat:@"%d", self.anthorId], @"roomId":[NSString stringWithFormat:@"%d", self.roomId]}];
            }];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }];
}

- (void)clickedLivingViewChatBtn {
    _chatLiveOtherCallMeView.chatBtn.enabled = NO;
    //开始计时
    [self beginTimer];
}

- (void)clickedLivingViewChangeBtn {
    [self.cameraManager switchCamera];
}

- (void)clickedLivingViewVoiceBtn {
    [[AgoraManager shareManager] muteLocalAudioStream:!_liveView.userMatchingLivingActionView.voiceBtn.selected];
    _liveView.userMatchingLivingActionView.voiceBtn.selected = !_liveView.userMatchingLivingActionView.voiceBtn.selected;
}

- (void)clickedLivingViewVoiceBtn:(UIButton *)sender {
    [[AgoraManager shareManager] muteLocalAudioStream:!sender.selected];
    sender.selected = !sender.selected;
}

- (void)clickedLivingViewMsgBtn {
    [_liveView.chatLivingTextView.textView becomeFirstResponder];
}

- (void)clickedFollowBtn {
    if (_liveView.anchorModel.isFollow == 0) {
        [self postDataWithFollow];
    } else {
        [self postDataWithFollowed];
    }
}

- (void)clickedLivingViewGiftBtn {
    UIImage *headImage = [YLUserDefault userDefault].headImage;
    
    [[MansionSendGiftView shareView] showWithUserId:_anthorId isPlayGif:YES];
    [MansionSendGiftView shareView].playGiftGif = ^(NSString * _Nonnull gifUrl) {
        [self playGiftAnimation:gifUrl];
    };
    [MansionSendGiftView shareView].videoChatSendGiftSuccess = ^(NSDictionary * _Nonnull dataDic) {
        UIImageView *giftImageView = [UIImageView new];
        [giftImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"gift_still_url"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [self brushGift:headImage giftImage:image name:@"我" giftName:[NSString stringWithFormat:@"1个%@", dataDic[@"gift_name"]] userId:dataDic[@"gift_id"] count:[[NSString stringWithFormat:@"%@", dataDic[@"gift_number"]] intValue]];
            
            [giftImageView removeFromSuperview];
        }];
    };
}

- (void)playGiftAnimation:(NSString *)gifUrl {
    [self.parser parseWithURL:[NSURL URLWithString:gifUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        if (videoItem != nil) {
            self.player.videoItem = videoItem;
            [self.player startAnimation];
        }
    } failureBlock:nil];
}


- (void)clickedMoreMoneyBtn {    
    YLRechargeVipController *rechargeVC = [YLRechargeVipController new];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)clickedLivingViewSmallBlackView {
    //切换画面
    if (!_isChangedViewTemp) {
        //切换为用户大图，主播小图
        self.locationVideoImageView = _liveView.fullVideoImageView;
        self.selfView = _liveView.fullVideoBlackView;
        self.anchorView = _liveView.smallRightTopVideoBlackView;
        [self.cameraManager setLocalView:_locationVideoImageView];
        [[AgoraManager shareManager] setRemoteViewWithId:self.anthorId view:_liveView.smallRightTopVideoImageView];
    } else {
        //切换为主播大图，用户小图
        self.locationVideoImageView = _liveView.smallRightTopVideoImageView;
        self.selfView = _liveView.smallRightTopVideoBlackView;
        self.anchorView = _liveView.fullVideoBlackView;
        [self.cameraManager setLocalView:_locationVideoImageView];
        [[AgoraManager shareManager] setRemoteViewWithId:self.anthorId view:_liveView.fullVideoImageView];
    }
    _isChangedViewTemp = !_isChangedViewTemp;
    [self reSetMyPulpViewFrame];
    
    if (self.isCamereMuted) {
        [_liveView setIsShowCloseCamera:YES isBigView:_isChangedViewTemp isSelf:YES];
    } else {
        [_liveView setIsShowCloseCamera:NO isBigView:_isChangedViewTemp isSelf:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    _liveView.msgListVC.view.hidden = !_liveView.msgListVC.view.hidden;
}

- (void)coinsCannotPayVideochat {
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"liveSuffiView" owner:nil options:nil];
    self.suffiView = xibArray[0];
    [self.view addSubview:_suffiView];
    [_suffiView cordius];
    
    //忽略
    [YLTapGesture addTaget:self sel:@selector(closeSuffiview) view:_suffiView.cancelBtn];
    //充值
    [YLTapGesture addTaget:self sel:@selector(clickedMoreMoneyBtn) view:_suffiView.rechargeBtn];
    
    [_suffiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(App_Frame_Width/2. - 310/2.);
        make.top.mas_equalTo(APP_Frame_Height/2. - 147/2.);
        make.width.mas_equalTo(310);
        make.height.mas_equalTo(147);
    }];
}

- (void)closeSuffiview {
    [self.suffiView removeFromSuperview];
}

- (void)startMatchingGCDTimerIsFirst:(BOOL)isFirst  {
    //倒计时30s，没人接听就挂断
//    if (isFirst == YES) {
//        [[YLAudioPlay shareInstance] callPlay];
//    }
    WEAKSELF
    __block NSInteger count = 30;
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.matchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_matchTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_matchTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (count >= 1) {
                count --;
            } else {
                [SVProgressHUD showInfoWithStatus:@"对方无应答,连接已挂断"];
                [weakSelf clickedLivingViewEndBtn];
            }
        });
    });
    dispatch_resume(_matchTimer);
}

- (void)startGCDTimer {
    WEAKSELF
    __block NSInteger timeCount = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.matchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_matchTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_matchTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            timeCount++;
            NSString *time = [NSString stringWithFormat:@"%lu",(unsigned long)timeCount];
            weakSelf.liveView.userMatchingLivingActionView.timeLb.text = [SLHelper getHHMMSSFromSS:time];
            
            [self pulpTimeCountDown];
            
            //轮询
            if (timeCount > 1 && timeCount%30 == 0) {
                [self requestVideoState];
            }
            
            //鉴黄截图
            if (self.t_screenshot_user_switch == 1 && self.t_screenshot_time_list.count > 0 && timeCount > 0) {
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
            
            if (timeCount == self.animationCount+15) {
                [self removeTipAnimation];
            }
        });
    });
    dispatch_resume(_matchTimer);
}

//轮询
- (void)requestVideoState {
    [YLNetworkInterface getVideoStatusWithUserId:[YLUserDefault userDefault].t_id anchorId:self.anthorId roomId:self.roomId result:^(bool isSuccess) {
        if (!isSuccess) {
            //挂断
            [self clickedLivingViewEndBtn];
        }
    }];
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

- (UILabel *)yellowTipLabel {
    if (!_yellowTipLabel) {
        NSString *text = @"注意注意注意 十秒后要鉴黄截图 请规范视频";
        _yellowTipLabel = [UIManager initWithLabel:CGRectMake(App_Frame_Width, SafeAreaTopHeight-44+200, App_Frame_Width-60, 90) text:text font:16 textColor:UIColor.redColor];
        _yellowTipLabel.numberOfLines = 3;
        [self.view addSubview:_yellowTipLabel];
    }
    return _yellowTipLabel;
}

//截图鉴黄  鉴定
- (void)screenShot {
    UIImage *image = _locationVideoImageView.image;
    [YLNetworkInterface qiniuPictureIdentify:image result:^(bool isPulp) {
        if (isPulp == 1) {
            [self postPulpResult];
            [self addSelfPulpShadeView];
            [self showPulpAlertView];
        }
    }];
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
    [[AipOcrService shardService] detectTextAccurateBasicFromImage:image withOptions:options successHandler:^(id result) {
        NSArray *arr = result[@"words_result"];
        if(arr){
            NSString *filter = (NSString *)[SLDefaultsHelper getSLDefaults:@"ocrWord"];
            NSArray *filterArr = [filter componentsSeparatedByString:@"|"];
            for (NSDictionary *words in arr) {
                NSString *word = words[@"words"];
                for (NSString *f in filterArr) {
                    if([word containsString:f]){
                        [self uploadOcrImage:image text:word];
                        [self.view addSubview:self.ocrTipLabel];
                        [self performSelector:@selector(ocrTipLabelDismiss) withObject:nil afterDelay:5];
                    }
                }
            }
        }
        } failHandler:^(NSError *err) {
            
        }];
}

- (void)ocrTipLabelDismiss{
    [_ocrTipLabel removeFromSuperview];
}

- (UILabel *)ocrTipLabel {
    if (!_ocrTipLabel) {
        NSString *text = @"系统检测到您视频通话过程中声音或画面出现违禁词，请您遵守平台规则。";
        _ocrTipLabel = [UIManager initWithLabel:CGRectMake(30, APP_FRAME_HEIGHT/2 - 45, App_Frame_Width-60, 90) text:text font:16 textColor:UIColor.redColor];
        _ocrTipLabel.numberOfLines = 3;
        _ocrTipLabel.textAlignment  = NSTextAlignmentCenter;
    }
    return _ocrTipLabel;
}

//获取当前时间戳
- (NSString *) getTimeNow{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    //设置时区,这一点对时间的处理很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *dateNow = [NSDate date];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    return timeStamp;
}

- (void)uploadOcrImage:(UIImage *)image text:(NSString *)text{
    
    [APIManager appendImagesDictionary:@{} andImageArray:@[image] andName:@"file" andFileName:[self getTimeNow] andSuccess:^(id responseObject) {
        [self addOcrLog:responseObject keyword:text];
        
    } andFail:^(NSError *error) {
        
    }];
    
}

- (void)addOcrLog:(NSString *)url keyword:(NSString *)keyword{
    NSDictionary *param = @{@"userId":[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                            @"videoUserId":[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                            @"videoAnchorUserId":[NSString stringWithFormat:@"%d", _anthorId],
                            @"videoImgUrl": url,
                            @"keyword":keyword,
                            @"roomId":[NSString stringWithFormat:@"%d", self.roomId],
    };
    [YLNetworkInterface addOcrScreenshotInfoWithParam:param result:^(bool isSuccess) {
//        [self disAction];
    }];
}

- (void)disAction{
    [YLNetworkInterface disableUser:[YLUserDefault userDefault].t_id success:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAlterView:@"你因违规操作，已被封号。"];
        });
    }];
}


- (void)showAlterView:(NSString *)msg {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if ([window.rootViewController isKindOfClass:[WelcomeViewController class]]) return;
    
    if([[YLAudioPlay shareInstance] playTime] > 0) {
        [[YLAudioPlay shareInstance] callEndPlay];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoIsOnHangupNoti" object:nil];
    [[AgoraManager shareManager] leaveChannel];
    [YLUserDefault saveUserDefault:@"0" t_id:@"0" t_is_vip:@"1" t_role:@"0"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"T_TOKEN"];
    WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
    
    window.rootViewController = welcomeVC;
    
    UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * knowAction =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertVc addAction:knowAction];
    [welcomeVC presentViewController:alertVc animated:YES completion:nil];
}


- (void)showPulpAlertView {
    if (!_alertView) {
        _alertView = [[VideoWarningAlertView alloc] init];
        [_alertView showWithContent:@"你可能存在不文明行为，系统已将你的视频关闭，请规范自己的行为。15秒后视频将重新打开。"];
    }
}

- (void)postPulpResult {
    NSDictionary *param = @{@"userId":[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                            @"videoUserId":[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                            @"videoAnchorUserId":[NSString stringWithFormat:@"%d", self.anthorId],
                            @"roomId":[NSString stringWithFormat:@"%d", self.roomId],
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
    [self.c2cConversation sendMessage:msg succ:nil fail:nil];
}

- (void)addSelfPulpShadeView {
    [self sendPulpIMMessage];
    self.selfShade = [[PulpShadeView alloc] initWithSuperView:self.selfView isSelf:YES isBig:_isChangedViewTemp];
}

- (void)addOtherPulpShadeView {
    self.otherShade = [[PulpShadeView alloc] initWithSuperView:self.anchorView isSelf:NO isBig:!_isChangedViewTemp];
}

- (void)reSetMyPulpViewFrame {
    [self.selfShade changeSuperView:self.selfView isBig:_isChangedViewTemp];
    [self.otherShade changeSuperView:self.anchorView isBig:!_isChangedViewTemp];
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
    
    [self.otherShade pulpViewCountDown];
    if (self.otherShade.pulpCount <= 0) {
        self.otherShade = nil;
    }
}

- (void)brushGift:(UIImage *)headImage giftImage:(UIImage *)giftImage name:(NSString *)name giftName:(NSString *)giftName userId:(NSString *)userId count:(int)count {
    GiftModel *model = [[YLBrushGigft sharedInstance] modelHeadImage:headImage name:name giftName:giftName gifImage:giftImage count:count];
    [[YLBrushGigft sharedInstance] brushUserId:userId model:model view:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - Keyboard notification
- (void)keyboardShow:(NSNotification *)note {
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.liveView.chatLivingTextView.y = APP_Frame_Height-50-deltaY;
    }];
    
}

- (void)keyboardHide:(NSNotification *)note {
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.liveView.chatLivingTextView.y = self.liveView.height;
    }];
    
}

- (void)receiveMessage:(NSNotification *)notification {
    
    NSMutableArray *array = [[notification userInfo] objectForKey:@"receive_msg_info_key"];
    TIMMessage *msg = array.firstObject;
    
    //判断是否是当前页面的用户发来的消息
    NSInteger msgUserId = [msg.sender integerValue];
    if (msgUserId == _anthorId + 10000) {
        
        TIMElem *elem = [msg getElem:0];
        if ([elem isKindOfClass:[TIMCustomElem class]]) {
            //收到礼物
            TIMCustomElem *customElem = (TIMCustomElem *)elem;
            NSString *jsonStr  = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
            if ([jsonStr hasPrefix:@"serverSend&&"]) {
                jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"serverSend&&" withString:@"{"];
            }
            NSDictionary *dic = [YLJsonExtension dictionaryWithJsonString:jsonStr];
            NSString *type = dic[@"type"];
            if ([type isEqualToString:@"0"] || [type isEqualToString:@"1"]) {
                UIImageView *giftImageView = [UIImageView new];
                [giftImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"gift_still_url"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [self brushGift:self.liveView.userMatchingLivingPersonView.iconImageView.image giftImage:image name:self.liveView.userMatchingLivingPersonView.nickNameLb.text giftName:[NSString stringWithFormat:@"1个%@", dic[@"gift_name"]] userId:dic[@"gift_id"]  count:[[NSString stringWithFormat:@"%@", dic[@"gift_number"]] intValue]];
                    [giftImageView removeFromSuperview];
                }];
                [self playGiftAnimation:dic[@"gift_gif_url"]];
            } else if ([type isEqualToString:@"pulp"]) {
                [self addOtherPulpShadeView];
            }
            
            
        } else {
            //更新消息
            [self updateMessage:msg];
        }
    }
    
}

#pragma mark -- Lazy loding
- (ChatLiveMeCallOtherView *)chatLiveMeCallOtherView {
    if (!_chatLiveMeCallOtherView) {
        _chatLiveMeCallOtherView = [[ChatLiveMeCallOtherView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    }
    return _chatLiveMeCallOtherView;
}

- (ChatLiveOtherCallMeView *)chatLiveOtherCallMeView {
    if (!_chatLiveOtherCallMeView) {
        _chatLiveOtherCallMeView = [[ChatLiveOtherCallMeView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    }
    return _chatLiveOtherCallMeView;
}

- (UIImageView *)windowBigImageView {
    if (!_windowBigImageView) {
        _windowBigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
        _windowBigImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _windowBigImageView;
}

- (UserMatchingLivingView *)liveView {
    if (!_liveView) {
        _liveView = [[UserMatchingLivingView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    }
    return _liveView;
}


#pragma mark - agora
- (void)joinChannel {
    [[AgoraManager shareManager] joinChannelWithRoomId:self.roomId addDelegate:self isVideo:YES success:^(NSString * _Nonnull token) {
        if (self.isMeCallOther) {
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"m4r"];
            [[AgoraManager shareManager].rtcEngineKit startAudioMixing:soundPath loopback:YES replace:YES cycle:-1];
        }
        [self.cameraManager startCapture];
        } fail:^{
            [self clickedLivingViewEndBtn];
        }];
}

- (void)callingSucessHandle {
    if (_matchTimer) {
        dispatch_source_cancel(_matchTimer);
    }
    
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    [[YLAudioPlay shareInstance] callEndPlay];
    [[YLAudioPlay shareInstance] stopDisplayLink];
    
    if (_chatLiveOtherCallMeView.player) {
        [_chatLiveOtherCallMeView.player stop];
        [_chatLiveOtherCallMeView.player.playerView removeFromSuperview];
    }
    
    if (_isMeCallOther) {
        [self beginTimer];
    }
    
    [self.view addSubview:self.liveView];
    
    self.player = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    _player.delegate = self;
    _player.loops = 1;
    _player.clearsAfterStop = YES;
    _player.userInteractionEnabled = NO;
    [self.view addSubview:_player];
    
    self.parser = [[SVGAParser alloc] init];
    
    //主播的数据
    UserMatchingAnchorModel *model = [[UserMatchingAnchorModel alloc] init];
    model.t_id = _personalHandle.t_idcard;
    model.t_age= [_personalHandle.t_age integerValue];
    model.t_handImg = _personalHandle.t_handImg;
    model.t_nickName= _personalHandle.t_nickName;
    model.t_vocation= _personalHandle.t_vocation;
    model.isFollow = _personalHandle.isFollow;
    model.t_city = _personalHandle.t_city;
    _liveView.anchorModel = model;
    
    _liveView.isUserMatching = YES;
    WEAKSELF
    _liveView.chatLivingTextView.ClickedSendBtnBlock = ^(NSString *content) {
        [weakSelf sendIMText:content];
    };
    
    _isChatLived = YES;
    self.cameraManager.isChatLived = YES;
    
    [self startGCDTimer];
}

#pragma mark - AgoraRtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    if (uid != self.anthorId) return;
    
    [engine stopAudioMixing];
   
    [self callingSucessHandle];
    _locationVideoImageView = _liveView.smallRightTopVideoImageView;
    self.selfView = _liveView.smallRightTopVideoBlackView;
    self.anchorView = _liveView.fullVideoBlackView;
    [self.cameraManager setLocalView:_locationVideoImageView];
    
    [self initWithTiLive];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size: (CGSize)size elapsed:(NSInteger)elapsed {
    [[AgoraManager shareManager] setRemoteViewWithId:uid view:_liveView.fullVideoImageView];
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    if (uid == self.anthorId) {
        [SVProgressHUD showInfoWithStatus:@"对方已挂断"];
        [self clickedLivingViewEndBtn];
    }
}

- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit * _Nonnull)engine {
    [SVProgressHUD showInfoWithStatus:@"agora连接超时"];
}

#pragma mark - FU camera
- (FUCameraManager *)cameraManager {
    if (!_cameraManager) {
        _cameraManager = [[FUCameraManager alloc] init];
        [_cameraManager setLocalView:self.windowBigImageView];
    }
    return _cameraManager;
}


@end
