/**
 IMSDK 源码已做修改
 - 修改IMSDK源码  TUIMessageCellData.m
     - 初始化_showReadReceipt为NO  隐藏未读已读标签。
 - 修改IMSDK源码  TUIVoiceMessageCell.m
     - 设置语音时间对方的颜色为 RGB(51, 51, 51);
     - 设置语音时间自己方的颜色为 RGB(174, 79, 253);
     - 设置时长label的约束为10
     - 修改小红点的大小和位置 self.voiceReadPoint.mm_right(-16);
 - 修改IMSDK源码  TUIVoiceMessageCellData.m  TUIVoiceMessageCellData.h
     - 修改contentSize的高度和宽度：高度48 宽度注释掉bubble的判断代码
     - 初始化改变语音播放的默认图片
     if (self) {
             if (direction == MsgDirectionIncoming) {
     self.cellLayout = [TIncommingVoiceCellLayout new];
                 _voiceImage = [UIImage imageNamed:@"chat_voice_play_2"];
                 _voiceAnimationImages = @[[UIImage imageNamed:@"chat_voice_play_0"],
                 [UIImage imageNamed:@"chat_voice_play_1"],
                                                   [UIImage imageNamed:@"chat_voice_play_2"]];
                 _voiceTop = [[self class] incommingVoiceTop];
             } else {
                 self.cellLayout = [TOutgoingVoiceCellLayout new];

                 _voiceImage = [UIImage imageNamed:@"chat_voice_play_me_2"];
                 _voiceAnimationImages = @[[UIImage imageNamed:@"chat_voice_play_me_0"],
                 [UIImage imageNamed:@"chat_voice_play_me_1"],
                                                    [UIImage imageNamed:@"chat_voice_play_me_2"]];
                 _voiceTop = [[self class] outgoingVoiceTop];
             }
         }
     -修改自定义语音的路径以及播放
 - 修改获取消息改为获取本地 TUIConversationDataProviderService.m
 - 修改看大图时隐藏StatusBar  TUIImageViewController.m
 - 修改默认图片的显示大小 TUIImageMessageCellData.m
 - 修改图片的mode类型 TUIImageMessageCell.m
 */

#import "ChatViewController.h"
#import "TUIKit.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "MMLayout/UIView+MMLayout.h"
#import "THelper.h"
#import "GuardView.h"
#import "TUITextMessageCell.h"
#import "TUIVoiceMessageCell.h"
#import "TUIImageMessageCell.h"
#import "TUIFaceCell.h"
#import "TUIFaceView.h"
#import "UIView+MMLayout.h"
#import "TUIRecordView.h"
#import "IMRemakeAlertView.h"
#import "SLHelper.h"
#import "BaseView.h"
#import "YLPushManager.h"
#import "LFImagePickerController.h"
#import "ToolManager.h"
#import "LXTAlertView.h"
#import "YLNetworkInterface.h"
#import "YLTapGesture.h"
#import "ChatLiveManager.h"
#import "ZYGiftRedEnvep.h"
#import "YLJsonExtension.h"
#import "YLInsufficientManager.h"
#import "YLRechargeVipController.h"
#import "SensitiveWordTools.h"
#include <objc/NSObjCRuntime.h>
#import "NewMessageAlertView.h"
#import "MessageGiftCell.h"
#import "MessageVideoCell.h"
#import "MessageVideoUserCell.h"
#import "MessageVideoAnchorCell.h"
#import "MessageImageCell.h"
#import "BigImageViewController.h"
#import "UIButton+LXMImagePosition.h"
#import "BanRecordingManager.h"
#import "SVGAParser.h"
#import "SVGAPlayer.h"
#import "MessageHandleOptionsView.h"


@interface ChatViewController ()<TUIChatControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, LFImagePickerControllerDelegate, TFaceViewDelegate>
{
    UIView *topView;
    UIButton *voiceBtn;
    UIView *itemView;
    UITextField *textField;
    UIButton *recordButton;
    
    UIImageView *recordImageView;
    UIImageView *cancleImageView;
    UIImageView *sortImageView;
    
    // 录制时长
    int second;
    BOOL timerIsSuspend; // 定时器是否处于挂起状态
    NSString *fileName;
    BOOL isSendedVoice;
    
    CGFloat coinLabelHeight;
        
    UIButton *vipBtn;
    UIButton *guardBtn;
}
@property (nonatomic, strong) TUIChatController *chat;
@property (nonatomic, strong) TIMConversation *conv;
@property (nonatomic, strong) TUIInputBar *inputBar;
@property (nonatomic, strong) TUIFaceView *emojiView;

@property (nonatomic, strong) TUIRecordView *record;
@property (nonatomic, strong) NSDate *recordStartTime;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *recordTimer;
@property (nonatomic, strong) godnessInfoHandle *infoHandle;

//礼物特效
@property (nonatomic, strong) SVGAParser    *parser;
@property (nonatomic, strong) SVGAPlayer    *player;

@end

@implementation ChatViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XZRGB(0xf5f5f5);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    coinLabelHeight = 42;
    
    
    if(![[AVAudioSession sharedInstance].category isEqualToString:AVAudioSessionCategoryPlayAndRecord] || !([AVAudioSession sharedInstance].categoryOptions ==  (AVAudioSessionCategoryOptionDefaultToSpeaker|AVAudioSessionCategoryOptionMixWithOthers))) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self setChatVC];
    
//    [self setReceiver];// 设置红外感光的监听
    [self addNotification];
    [self addGiftAnimation];
    [self requestAnchorDetail];
    
    if ([YLUserDefault userDefault].t_sex == 1) {
        guardBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-70, itemView.y-100, 70, 70) text:@"" font:1 textColor:nil normalImg:@"chat_item_guard" highImg:nil selectedImg:nil];
        [guardBtn addTarget:self action:@selector(guardAnchor:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:guardBtn];
    }
    if ([YLUserDefault userDefault].t_is_vip == 1) {
        vipBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-70, itemView.y-180, 70, 70) text:@"" font:1 textColor:nil normalImg:@"chat_item_vip" highImg:nil selectedImg:nil];
        [vipBtn addTarget:self action:@selector(vipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:vipBtn];
    }
}

- (void)vipButtonClick {
    [YLPushManager pushVipWithEndTime:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self checkImState];
    
    //上报已读
    [_conv setReadMessage:nil succ:nil fail:nil];
    
    [[NewMessageAlertView shareView] stopAnimation];
    [[BanRecordingManager shareManager] addBanScreenRecordingNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    [self cancelRecord];
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];//关闭感光
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnReadMsgNoti" object:nil];
    [[BanRecordingManager shareManager] removeBanScreenRecordingNotification];
}

#pragma mark - 礼物特效
- (void)addGiftAnimation {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"receive_msg_notification" object:nil];
    
    self.parser = [[SVGAParser alloc] init];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.player = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    _player.loops = 1;
    _player.clearsAfterStop = YES;
    _player.userInteractionEnabled = NO;
    [window addSubview:_player];
}

- (void)playGiftAnimation:(NSString *)gifUrl {
    [self.parser parseWithURL:[NSURL URLWithString:gifUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        if (videoItem != nil) {
            self.player.videoItem = videoItem;
            [self.player startAnimation];
        }
    } failureBlock:nil];
}

- (void)receiveMessage:(NSNotification *)notification {
    NSMutableArray *array = [[notification userInfo] objectForKey:@"receive_msg_info_key"];
    TIMMessage *msg = array.firstObject;
    
    //判断是否是当前页面的用户发来的消息
    NSInteger msgUserId = [msg.sender integerValue];
    if (msgUserId == _otherUserId + 10000) {
        
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
                
                [self playGiftAnimation:dic[@"gift_gif_url"]];
            }
        }
    }
}

#pragma mark - not
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat bottomHeight = SafeAreaBottomHeight - 49;
    CGFloat transformY = endFrame.origin.y - itemView.height + bottomHeight+70;
    if (beginFrame.size.height>0 && (beginFrame.origin.y-endFrame.origin.y>0)) {
        //执行动画
        [UIView animateWithDuration:duration animations:^{
            self->itemView.y = transformY-SafeAreaTopHeight;
            self.chat.messageController.tableView.height = transformY-SafeAreaTopHeight-self->coinLabelHeight;
            self->guardBtn.y = self->itemView.y-100;
            self->vipBtn.y = self->itemView.y-170;
        }];
        
        [self.chat.messageController scrollToBottom:NO];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification{
    [self hideEmojiView];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transformY = endFrame.origin.y - itemView.height;
    [UIView animateWithDuration:duration animations:^{
        self->itemView.y = transformY-SafeAreaTopHeight;;
        self.chat.messageController.tableView.height = transformY-SafeAreaTopHeight-self->coinLabelHeight;
        self->guardBtn.y = self->itemView.y-100;
        self->vipBtn.y = self->itemView.y-170;
    }];

    [self.chat.messageController scrollToBottom:NO];
}

#pragma mark - func
- (void)checkImState {
    //检测IM登录状态
    if ([[TIMManager sharedInstance] getLoginStatus] != 1) {
        [SLHelper TIMLoginSuccess:^{
            [self setChatNavigationTitle];
        } fail:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [self setChatNavigationTitle];
    }
}

- (void)voiceButtonClick:(UIButton *)sender {
    if (sender.selected == NO  && [YLUserDefault userDefault].t_is_vip != 0) {
        [LXTAlertView vipWithContet:@"VIP用户才能发送语音消息"];
        return;
    }
    sender.selected = !sender.selected;
    textField.hidden = sender.selected;
    recordButton.hidden = !sender.selected;
    if (sender.selected == YES) {
        [self.view endEditing:YES];
    } else {
        [textField becomeFirstResponder];
    }
    [self hideEmojiView];
}

- (void)chatItemButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    [self.view endEditing:YES];
    [self hideEmojiView];
    if (sender.tag < 6666+6) {
        NSString *title = sender.titleLabel.text;
        if ([title isEqualToString:@"视频通话"]) {
            [self clickedVideo];
        } else if ( [title isEqualToString:@"守护"]) {
            [self guardAnchor:sender];
        } else if ([title isEqualToString:@"礼物"]) {
            [self sendGift];
        } else if ([title isEqualToString:@"相册"]) {
            if ([YLUserDefault userDefault].t_is_vip != 0) {
                [LXTAlertView vipWithContet:@"VIP用户才能发送图片消息"];
                return;
            }
            [self choosePicWithCameraWithType:0]; //单张图片选择
//            [self choosePicWithLibrary]; //多张图片选择
        } else if ([title isEqualToString:@"拍摄"]) {
            if ([YLUserDefault userDefault].t_is_vip != 0) {
                [LXTAlertView vipWithContet:@"VIP用户才能发送图片消息"];
                return;
            }
            [self choosePicWithCameraWithType:1];
        }
    } else if (sender.tag == 6888) {
        // 表情
        [self chatEmoji];
    }
}

#pragma mark - 发送礼物
- (void)sendGift {
    [[MansionSendGiftView shareView] showWithUserId:self.otherUserId isPlayGif:YES];
    [MansionSendGiftView shareView].playGiftGif = ^(NSString * _Nonnull gifUrl) {
        [self playGiftAnimation:gifUrl];
    };
}
#pragma mark - 发送文字
- (void)sendTextMessage {
    if (textField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"内容不能为空"];
        return;
    }
    NSString *sendText = textField.text;
    
    //判断输入的内容是否含有敏感词
    BOOL hasSensitive = [[SensitiveWordTools sharedInstance] hasSensitiveWord:textField.text];
    if (hasSensitive) {
        sendText = [[SensitiveWordTools sharedInstance] filter:textField.text];
    }
    [YLNetworkInterface sendTextConsumeUserId:[YLUserDefault userDefault].t_id coverConsumeUserId:(int)_otherUserId block:^(int code) {
        if (code == 1 || code == 3) {
            TUITextMessageCellData *data = [[TUITextMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
            data.content = sendText;
            [self.chat sendMessage:data];
            self->textField.text = nil;
        } else if (code == -1){
            //余额不足
            [self.view endEditing:YES];
            [self hideEmojiView];
            [[YLInsufficientManager shareInstance] insufficientShow];
        }
    }];
}

#pragma mark - 发送emoji
- (void)chatEmoji {
    voiceBtn.selected = NO;
    textField.hidden = NO;
    recordButton.hidden = YES;
    self.emojiView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self->itemView.y -= 110;
        self.emojiView.y = CGRectGetMinY(self->itemView.frame)+55;
        self.chat.messageController.tableView.height -= 110;
        [self.chat.messageController scrollToBottom:NO];
        self->guardBtn.y = self->itemView.y-100;
        self->vipBtn.y = self->itemView.y-170;
    }];
}

- (void)hideEmojiView {
    if (_emojiView.hidden == NO) {
        [UIView animateWithDuration:0.25 animations:^{
            self->itemView.y = APP_Frame_Height-SafeAreaTopHeight-self->itemView.height;
            self.emojiView.y = APP_Frame_Height;
            self.chat.messageController.tableView.height = APP_Frame_Height-SafeAreaTopHeight-self->itemView.height-self->coinLabelHeight;
            [self.chat.messageController scrollToBottom:NO];
            self->guardBtn.y = self->itemView.y-100;
            self->vipBtn.y = self->itemView.y-170;
        }];
        _emojiView.hidden = YES;
    }
}

#pragma mark - 发送图片
- (void)choosePicWithCameraWithType:(int)type {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    if (type == 0) {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    pickerController.delegate = self;
    pickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    UIImageOrientation imageOrientation = resultImage.imageOrientation;
    if(imageOrientation != UIImageOrientationUp)
    {
        CGFloat aspectRatio = MIN ( 1920 / resultImage.size.width, 1920 / resultImage.size.height );
        CGFloat aspectWidth = resultImage.size.width * aspectRatio;
        CGFloat aspectHeight = resultImage.size.height * aspectRatio;

        UIGraphicsBeginImageContext(CGSizeMake(aspectWidth, aspectHeight));
        [resultImage drawInRect:CGRectMake(0, 0, aspectWidth, aspectHeight)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    NSString *path = [TUIKit_Image_Path stringByAppendingString:[THelper genImageName:nil]];
    [self sendPictureMessageWithImage:resultImage path:path];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)choosePicWithLibrary {
    LFImagePickerController *imagePicker = [[LFImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePicker.allowPickingVideo = NO;
    imagePicker.allowTakePicture = NO;
    imagePicker.supportAutorotate = NO;
    imagePicker.allowPickingGif = YES; /** 支持GIF */
    imagePicker.allowPickingLivePhoto = NO; /** 支持Live Photo */
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        imagePicker.syncAlbum = YES; /** 实时同步相册 */
    }
    imagePicker.doneBtnTitleStr = @"确定"; //最终确定按钮名称
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)lf_imagePickerController:(LFImagePickerController *)picker didFinishPickingResult:(NSArray<LFResultObject *> *)results {
    for (int i = 0; i < results.count; i++) {
        LFResultObject *result = results[i];
        if ([result isKindOfClass:[LFResultImage class]]) {
            LFResultImage *resultImage = (LFResultImage *)result;
            UIImage *image = resultImage.originalImage;
            UIImageOrientation imageOrientation = image.imageOrientation;
            if(imageOrientation != UIImageOrientationUp)
            {
                CGFloat aspectRatio = MIN ( 1920 / image.size.width, 1920 / image.size.height );
                CGFloat aspectWidth = image.size.width * aspectRatio;
                CGFloat aspectHeight = image.size.height * aspectRatio;

                UIGraphicsBeginImageContext(CGSizeMake(aspectWidth, aspectHeight));
                [image drawInRect:CGRectMake(0, 0, aspectWidth, aspectHeight)];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }

            NSString *path = [NSString stringWithFormat:@"%@_%d", [TUIKit_Image_Path stringByAppendingString:[THelper genImageName:nil]], i];
            [self sendPictureMessageWithImage:image path:path];
        }
    }
}

- (void)sendPictureMessageWithImage:(UIImage *)image path:(NSString *)path{
    [YLNetworkInterface sendTextConsumeUserId:[YLUserDefault userDefault].t_id coverConsumeUserId:(int)_otherUserId block:^(int code) {
        if (code == 1 || code == 3) {
            NSData *data = UIImageJPEGRepresentation(image, 0.75);
            
            [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            
            TUIImageMessageCellData *cellData = [[TUIImageMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
            cellData.path = path;
            cellData.length = data.length;
            [self.chat sendMessage:cellData];
        }else if(code == -1){
            //余额不足
            [self.view endEditing:YES];
            [self hideEmojiView];
            [[YLInsufficientManager shareInstance] insufficientShow];
        }
    }];
}

#pragma mark - 发送语音
- (void)recordBtnDown:(UIButton *)sender {
    AVAudioSessionRecordPermission permission = AVAudioSession.sharedInstance.recordPermission;
    //在此添加新的判定 undetermined，否则新安装后的第一次询问会出错。新安装后的第一次询问为 undetermined，而非 denied。
    if (permission == AVAudioSessionRecordPermissionDenied || permission == AVAudioSessionRecordPermissionUndetermined) {
        [AVAudioSession.sharedInstance requestRecordPermission:^(BOOL granted) {
            if (!granted) {
                [SVProgressHUD showInfoWithStatus:@"无法访问麦克风"];
            }
        }];
        return;
    }
    //在此包一层判断，添加一层保护措施。
    if(permission == AVAudioSessionRecordPermissionGranted){
        if(!_record){
            _record = [[TUIRecordView alloc] init];
            _record.frame = [UIScreen mainScreen].bounds;
        }
        [self.view.window addSubview:_record];
        _recordStartTime = [NSDate date];
        [_record setStatus:Record_Status_Recording];
        recordButton.backgroundColor = [UIColor lightGrayColor];
        [recordButton setTitle:@"松开 结束" forState:UIControlStateNormal];
        [self startRecord];
    }
}

- (void)recordBtnUp:(UIButton *)sender {
    if (AVAudioSession.sharedInstance.recordPermission == AVAudioSessionRecordPermissionDenied) {
        return;
    }
    recordButton.backgroundColor = XZRGB(0xf5f5f5);
    [recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_recordStartTime];
    if(interval < 1 || interval > 60){
        if(interval < 1){
            [_record setStatus:Record_Status_TooShort];
        }
        else{
            [_record setStatus:Record_Status_TooLong];
        }
        [self cancelRecord];
        __weak typeof(self) ws = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ws.record removeFromSuperview];
        });
    }
    else{
        [_record removeFromSuperview];
        NSString *path = [self stopRecord];
        _record = nil;
        
        if (path) {
            [self sendVoiceWithPath:path];
        }
    }
}

- (void)recordBtnCancel:(UIButton *)sender {
    [_record removeFromSuperview];
    recordButton.backgroundColor = XZRGB(0xf5f5f5);
    [recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self cancelRecord];
}

- (void)recordBtnExit:(UIButton *)sender {
    [_record setStatus:Record_Status_Cancel];
    [recordButton setTitle:@"松开 取消" forState:UIControlStateNormal];
}

- (void)recordBtnEnter:(UIButton *)sender {
    [_record setStatus:Record_Status_Recording];
    [recordButton setTitle:@"松开 结束" forState:UIControlStateNormal];
}

- (void)startRecord {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setActive:YES error:&error];

    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatMPEG4AAC],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];

    NSString *path = [TUIKit_Voice_Path stringByAppendingString:[THelper genVoiceName:nil withExtension:@"m4a"]];
    NSURL *url = [NSURL fileURLWithPath:path];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    [_recorder record];
    [_recorder updateMeters];

    _recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(recordTick:) userInfo:nil repeats:YES];
}

- (void)recordTick:(NSTimer *)timer {
    [_recorder updateMeters];
    float power = [_recorder averagePowerForChannel:0];
    [_record setPower:power];
    
    //在此处添加一个时长判定，如果时长超过60s，则取消录制，提示时间过长,同时不再显示 recordView。
    //此处使用 recorder 的属性，使得录音结果尽量精准。注意：由于语音的时长为整形，所以 60.X 秒的情况会被向下取整。但因为 ticker 0.5秒执行一次，所以因该都会在超时时显示为60s
    NSTimeInterval interval = _recorder.currentTime;
    if(interval >= 55 && interval < 60){
        NSInteger seconds = 60 - interval;
        NSString *secondsString = [NSString stringWithFormat:@"将在 %ld 秒后结束录制",(long)seconds + 1];//此处加long，是为了消除编译器警告。此处 +1 是为了向上取整，优化时间逻辑。
        _record.title.text = secondsString;
    }
    if(interval >= 60){
        NSString *path = [self stopRecord];
        [_record setStatus:Record_Status_TooLong];
        __weak typeof(self) ws = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ws.record removeFromSuperview];
        });
        if (path) {
            [self sendVoiceWithPath:path];
        }
    }
}

- (NSString *)stopRecord {
    if(_recordTimer){
        [_recordTimer invalidate];
        _recordTimer = nil;
    }
    if([_recorder isRecording]){
        [_recorder stop];
    }
    return _recorder.url.path;
}

- (void)cancelRecord {
    if(_recordTimer){
        [_recordTimer invalidate];
        _recordTimer = nil;
    }
    if([_recorder isRecording]){
        [_recorder stop];
    }
    NSString *path = _recorder.url.path;
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

- (void)sendVoiceWithPath:(NSString *)path {
    [YLNetworkInterface sendTextConsumeUserId:[YLUserDefault userDefault].t_id coverConsumeUserId:(int)self.otherUserId block:^(int code) {
        if (code == 1 || code == 3) {
            NSURL *url = [NSURL fileURLWithPath:path];
            AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
            int duration = (int)CMTimeGetSeconds(audioAsset.duration);
            int length = (int)[[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
            TUIVoiceMessageCellData *cellData = [[TUIVoiceMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
            cellData.path = path;
            cellData.duration = duration;
            cellData.length = length;
            [self.chat sendMessage:cellData];
        }else if(code == -1){
            //余额不足
            [self.view endEditing:YES];
            [self hideEmojiView];
            [[YLInsufficientManager shareInstance] insufficientShow];
        }
    }];
}

#pragma mark - 视频通话
- (void)clickedVideo {
    [[ChatLiveManager shareInstance] getVideoChatAutographWithOtherId:(int)_otherUserId type:1 fail:nil];
}

#pragma mark - chat vc
- (void)setChatVC {
    NSInteger idCard = _otherUserId+10000;
    NSString *receiver = [NSString stringWithFormat:@"%ld",(long)idCard];
    _conv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:receiver];
    _chat = [[TUIChatController alloc] initWithConversation:_conv];
    _chat.delegate = self;
    _chat.messageController.tableView.backgroundColor = XZRGB(0xf5f5f5);
    [self addChildViewController:_chat];
    [self.view addSubview:_chat.view];
    
    // 设置气泡 和文本颜色
    TUITextMessageCellData.outgoingTextColor = XZRGB(0xae4ffd);
    TUITextMessageCellData.incommingTextColor = XZRGB(0x333333);
    TUIBubbleMessageCellData.outgoingBubble = [UIImage imageNamed:@"message_bubble_me"];
    TUIBubbleMessageCellData.incommingBubble = [UIImage imageNamed:@"message_bubble"];
    
    [TUIKit sharedInstance].config.defaultAvatarImage = [UIImage imageNamed:@"default"];//设置默认头像
    [TUIKit sharedInstance].config.avatarType = TAvatarTypeRounded; // 设置头像为圆形
    
    [self topView];
    // 自定义inputbBar
    [self reSetInputBar];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewDidTouched)];
    [self.chat.messageController.tableView addGestureRecognizer:tap];
    _chat.messageController.tableView.y = coinLabelHeight;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AnthorDetail_more_black"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
}

- (void)rightItemClick {
    MessageHandleOptionsView *optionsV = [[MessageHandleOptionsView alloc] initWithId:self.otherUserId covId:[self.conv getReceiver] isFollow:_infoHandle.isFollow sex:(int)_infoHandle.t_sex];
    [optionsV show];
    WEAKSELF;
    optionsV.followButtonClickBlock = ^(bool isFollow) {
        weakSelf.infoHandle.isFollow = isFollow;
    };
    optionsV.remarkButtonClickBlock = ^{
        [weakSelf remarkButtonClick];
    };
}

- (void)remarkButtonClick {
    IMRemakeAlertView *view = [[IMRemakeAlertView alloc] initWithFriendIMId:_otherUserId+10000];
    view.setRemakeSuccess = ^(NSString * _Nonnull remake) {
        self.navigationItem.title = remake;
    };
}

- (void)tableViewDidTouched {
    [self.view endEditing:YES];
    [self hideEmojiView];
}

- (void)setChatNavigationTitle {
    NSInteger idCard = _otherUserId+10000;
    NSString *identifier = [NSString stringWithFormat:@"%ld",(long)idCard];
    TIMUserProfile *file = [[TIMFriendshipManager sharedInstance] queryUserProfile:identifier];
    if (file) {
        NSString *nickName;
        if ([file.nickname isEqualToString:@"(null)"] || file.nickname.length == 0) {
            nickName = [NSString stringWithFormat:@"聊友:%@",identifier];
        } else {
            nickName = file.nickname;
        }
        
        self.navigationItem.title = nickName;
        TIMFriend *friend = [[TIMFriendshipManager sharedInstance] queryFriend:identifier];
        if (friend.remark) {
            self.navigationItem.title = friend.remark;
        }
    } else {
        //获取用户信息
        [[TIMFriendshipManager sharedInstance] getUsersProfile:@[identifier] forceUpdate:YES succ:^(NSArray<TIMUserProfile *> *profiles) {
            TIMUserProfile *file = [profiles firstObject];
            NSString *nickName;
            if ([file.nickname isEqualToString:@"(null)"] || file.nickname.length == 0) {
                nickName = [NSString stringWithFormat:@"聊友:%@",identifier];
            } else {
                nickName = file.nickname;
            }
            self.navigationItem.title = file.nickname;
            TIMFriend *friend = [[TIMFriendshipManager sharedInstance] queryFriend:identifier];
            if (friend.remark) {
                self.navigationItem.title = friend.remark;
            }
        } fail:^(int code, NSString *msg) {
            
        }];
    }
}

#pragma mark - top view
- (void)topView {
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, coinLabelHeight)];
    topV.backgroundColor = XZRGB(0xf6ebbc);
    [self.view addSubview:topV];
    
    UILabel *tipL = [UIManager initWithLabel:CGRectMake(8, 0, App_Frame_Width-16, coinLabelHeight) text:@"任何以可线下约会见面为由要求打赏礼物或者添加微信、QQ等第三方工具发红包的均是骗子。" font:13 textColor:XZRGB(0xf74c31)];
    tipL.textAlignment = NSTextAlignmentLeft;
    tipL.numberOfLines = 2;
    tipL.adjustsFontSizeToFitWidth = YES;
    [topV addSubview:tipL];
}

- (void)requestAnchorDetail {
    [YLNetworkInterface getGodnessUserData:[YLUserDefault userDefault].t_id coverUserId:(int)_otherUserId block:^(godnessInfoHandle *handle) {
        self.infoHandle = handle;
//        [self setTopButtonStatus];
    }];
}

//- (void)setTopButtonStatus {
//    UIButton *wechatBtn = [topView viewWithTag:7777];
//    UIButton *qqBtn = [topView viewWithTag:7778];
//    UIButton *phoneBtn = [topView viewWithTag:7779];
//    if (_infoHandle.t_weixin.length > 0 && ![_infoHandle.t_weixin containsString:@"null"]) {
//        if (_infoHandle.anchorSetup.count > 0) {
//            NSDictionary *dic = _infoHandle.anchorSetup[0];
//            int gold = [dic[@"t_weixin_gold"] intValue];
//            if (gold > 0) {
//                wechatBtn.enabled = YES;
//                wechatBtn.alpha = 1;
//            }
//        }
//    }
//
//    if (_infoHandle.t_qq.length > 0 && ![_infoHandle.t_qq containsString:@"null"]) {
//        if (_infoHandle.anchorSetup.count > 0) {
//            NSDictionary *dic = _infoHandle.anchorSetup[0];
//            int gold = [dic[@"t_qq_gold"] intValue];
//            if (gold > 0) {
//                qqBtn.enabled = YES;
//                qqBtn.alpha = 1;
//            }
//        }
//    }
//
//    if (_infoHandle.t_phone.length > 0 && ![_infoHandle.t_phone containsString:@"null"]) {
//        if (_infoHandle.anchorSetup.count > 0) {
//            NSDictionary *dic = _infoHandle.anchorSetup[0];
//            int gold = [dic[@"t_phone_gold"] intValue];
//            if (gold > 0) {
//                phoneBtn.enabled = YES;
//                phoneBtn.alpha = 1;
//            }
//        }
//    }
//}

//- (void)topButtonClick:(UIButton *)sender {
//    sender.enabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        sender.enabled = YES;
//    });
//    NSInteger index = sender.tag - 7777;
//    [self contectButtonClick:index];
//}

#pragma mark - contect button click
//- (void)contectButtonClick:(NSInteger)index {
//    if ([YLUserDefault userDefault].t_is_vip != 0) {
//        [LXTAlertView vipWithContet:@"VIP用户才可查看联系方式"];
//        return;
//    }
//    NSString *msg = nil;
//    NSDictionary *dic  = [_infoHandle.anchorSetup firstObject];
//    if (index == 0) {
//        //微信
//        if (_infoHandle.isWeixin == 1 || _infoHandle.t_idcard == [YLUserDefault userDefault].t_id+10000) {
//            [self showLookUserInfoAlertWithData:_infoHandle.t_weixin name:@"微信号"];
//            return;
//        }
//        msg = [NSString stringWithFormat:@"本次查看将消费您%@金币",dic[@"t_weixin_gold"]];
//
//    } else if (index == 1) {
//        // QQ
//        if (_infoHandle.isQQ == 1 || _infoHandle.t_idcard == [YLUserDefault userDefault].t_id+10000) {
//            [self showLookUserInfoAlertWithData:_infoHandle.t_qq name:@"QQ号"];
//            return;
//        }
//        msg = [NSString stringWithFormat:@"本次查看将消费您%@金币",dic[@"t_qq_gold"]];
//    } else {
//        //手机
//        if (_infoHandle.isPhone == 1 || _infoHandle.t_idcard == [YLUserDefault userDefault].t_id+10000) {
//            [self showLookUserInfoAlertWithData:_infoHandle.t_phone name:@"手机号"];
//            return;
//        }
//        msg = [NSString stringWithFormat:@"本次查看将消费您%@金币",dic[@"t_phone_gold"]];
//    }
//    [self showAlertView:msg index:index];
//}

//- (void)showLookUserInfoAlertWithData:(NSString *)string name:(NSString *)name{
//    [LXTAlertView alertViewWithTitle:@"" message:[NSString stringWithFormat:@"%@:%@", name, string] cancleTitle:@"取消" sureTitle:@"复制" sureHandle:^{
//
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        pasteboard.string = string;
//        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@复制成功", name]];
//    }];
//}

//- (void)showAlertView:(NSString *)msg index:(NSInteger)index {
//    [LXTAlertView alertViewDefaultWithTitle:@"温馨提示" message:msg sureHandle:^{
//        if (index == 0) {
//            [self seeWeixin];
//        } else if (index == 1) {
//            [self seeQQ];
//        } else if (index == 2) {
//            [self seePhone];
//        }
//    }];
//}

//- (void)seeWeixin {
//    [YLNetworkInterface seeWeiXinConsumeUserId:[YLUserDefault userDefault].t_id
//                            coverConsumeUserId:(int)self.otherUserId
//                                        block:^(NSDictionary *dic)
//    {
//        NSInteger code = [dic[@"m_istatus"]intValue];
//        if (code == 1) {
//            self.infoHandle.isWeixin = 1;
//            self.infoHandle.t_weixin = dic[@"m_object"];
//            [self showLookUserInfoAlertWithData:self.infoHandle.t_weixin name:@"微信号"];
//        } else if (code == -1) {
//            //余额不足
//            [[YLInsufficientManager shareInstance] insufficientShow];
//        }
//    }];
//}

//- (void)seeQQ {
//    [YLNetworkInterface seeQQConsumeUserId:[YLUserDefault userDefault].t_id
//                           coverConsumeUserId:(int)self.otherUserId
//                                        block:^(NSDictionary *dic)
//    {
//        NSInteger code = [dic[@"m_istatus"]intValue];
//        if (code == 1) {
//            self.infoHandle.isQQ = 1;
//            self.infoHandle.t_qq = dic[@"m_object"];
//            [self showLookUserInfoAlertWithData:self.infoHandle.t_qq name:@"QQ号"];
//        } else if (code == -1) {
//            //余额不足
//            [[YLInsufficientManager shareInstance] insufficientShow];
//        }
//    }];
//}

//- (void)seePhone {
//    [YLNetworkInterface seePhoneConsumeUserId:[YLUserDefault userDefault].t_id coverConsumeUserId:(int)self.otherUserId block:^(NSDictionary *dic) {
//        NSInteger code = [dic[@"m_istatus"]intValue];
//        if (code == 1) {
//            self.infoHandle.isPhone = 1;
//            self.infoHandle.t_phone = dic[@"m_object"];
//            [self showLookUserInfoAlertWithData:self.infoHandle.t_phone name:@"手机号"];
//        } else if (code == -1){
//            //余额不足
//            [[YLInsufficientManager shareInstance] insufficientShow];
//        }
//    }];
//}

#pragma mark - guard
- (void)guardAnchor:(UIButton *)sender {
    if (_infoHandle.t_sex == [YLUserDefault userDefault].t_sex) {
        [SVProgressHUD showInfoWithStatus:@"暂未开放同性用户交流"];
        return;
    }
    
    [YLNetworkInterface getGuardWithAnchorId:self.otherUserId Success:^(NSDictionary *dataDic) {
        GuardView *alertV = [[GuardView alloc] initWithId:self.otherUserId];
        [alertV showWithDataDic:dataDic];
    }];
}

#pragma mark - input bar
- (void)reSetInputBar {
    // 移除自身的inputbar  需自定义UI
    [_chat.inputController.view removeFromSuperview];
    
    CGFloat itemHeight = SafeAreaBottomHeight-49+125;
    itemView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-itemHeight-SafeAreaTopHeight, App_Frame_Width, itemHeight)];
    itemView.backgroundColor = XZRGB(0xf5f5f5);
    [self.view addSubview:itemView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, itemView.width, 70)];
    bgView.backgroundColor = XZRGB(0xf5f5f5);
    [itemView addSubview:bgView];
    //
    NSArray *iconArr = @[@"chat_item_video",@"chat_item_gift"];
    NSArray *titleArr = @[@"视频通话", @"礼物"];
    CGFloat width = App_Frame_Width/iconArr.count;
    for (int i = 0; i < iconArr.count; i ++) {
        UIButton *itemBtn = [UIManager initWithButton:CGRectMake(width*i, 0, width, 70) text:titleArr[i] font:14 textColor:XZRGB(0x333333) normalImg:iconArr[i] highImg:nil selectedImg:nil];
        [itemBtn setImagePosition:2 spacing:2];
        itemBtn.tag = 6666+i;
        [itemBtn addTarget:self action:@selector(chatItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:itemBtn];
    }

    voiceBtn = [UIManager initWithButton:CGRectMake(5, 10, 40, 35) text:@"" font:1 textColor:nil normalImg:@"newmessage_btn_sendvoice" highImg:nil selectedImg:@"chat_btn_jp"];
    voiceBtn.selected = NO;
    [voiceBtn addTarget:self action:@selector(voiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [itemView addSubview:voiceBtn];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, App_Frame_Width-100, 35)];
    textField.delegate = self;
//    textField.backgroundColor = XZRGB(0xf5f5f5);
    textField.backgroundColor = UIColor.whiteColor;
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 4;
    textField.font = [UIFont systemFontOfSize:16];
    [textField setReturnKeyType:UIReturnKeySend];
    [itemView addSubview:textField];
    
    UIButton *emojiBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-45, 10, 40, 35) text:@"" font:1 textColor:nil normalImg:@"newmessage_btn_emoji" highImg:nil selectedImg:nil];
    emojiBtn.tag = 6888;
    [emojiBtn addTarget:self action:@selector(chatItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:emojiBtn];
    
    recordButton = [UIButton buttonWithType:0];
    recordButton.frame = CGRectMake(50, 10, App_Frame_Width-100, 35);
//    recordButton.backgroundColor = XZRGB(0xf5f5f5);
    recordButton.backgroundColor = UIColor.whiteColor;
    [recordButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [recordButton.layer setMasksToBounds:YES];
    [recordButton.layer setCornerRadius:4.0f];
    [recordButton.layer setBorderWidth:0.5f];
    [recordButton.layer setBorderColor:TTextView_Line_Color.CGColor];
    [recordButton addTarget:self action:@selector(recordBtnDown:) forControlEvents:UIControlEventTouchDown];
    [recordButton addTarget:self action:@selector(recordBtnUp:) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(recordBtnCancel:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [recordButton addTarget:self action:@selector(recordBtnExit:) forControlEvents:UIControlEventTouchDragExit];
    [recordButton addTarget:self action:@selector(recordBtnEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    recordButton.hidden = YES;
    [itemView addSubview:recordButton];
    
    
    
    [self emojiView];
    _chat.messageController.tableView.height = self.view.height - itemView.height - coinLabelHeight;
//    APP_Frame_Height-SafeAreaTopHeight-itemView.height-coinLabelHeight;
}

#pragma mark - chat vc delegate
- (void)chatController:(TUIChatController *)chatController onSelectMoreCell:(TUIInputMoreCell *)cell {
    
}

- (TUIMessageCellData *)chatController:(TUIChatController *)controller onNewMessage:(TIMMessage *)msg {
    if (msg && msg.elemCount > 0) {
        TIMElem *elem = [msg getElem:0];
        //判断是否为自定义元素。
        if([elem isKindOfClass:[TIMCustomElem class]]) {
            
            NSInteger idCard = _otherUserId+10000;
            NSString *receiver = [NSString stringWithFormat:@"%ld",(long)idCard];
            
            TIMCustomElem *customElem = (TIMCustomElem *)elem;
        
            NSString *jsonStr = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
            // 这里是服务端的虚拟主播发送过来的自定义消息 不知什么原因带有{}包含的字符串发过来 客户端接收到的data为空，就用字符serverSend&&代替{, 然后解析时如果以字符serverSend&&开头则替换为{再进行转dic。
            if ([jsonStr hasPrefix:@"serverSend&&"]) {
                jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"serverSend&&" withString:@"{"];
            }
            NSDictionary *dic = [SLHelper dictionaryWithJsonString:jsonStr];
            NSString *type = dic[@"type"];
            
            if ([type isEqualToString:@"0"] || [type isEqualToString:@"1"]) {
                // 类型为0 1 的自定义消息为礼物或者红包（红包已废弃）
                MessageGiftCellData *cellData = [[MessageGiftCellData alloc] initWithDirection:msg.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
                cellData.giftData = customElem.data;
                cellData.isSelf = msg.isSelf;
                if (msg.isSelf == YES) {
                    cellData.headImage = [YLUserDefault userDefault].headImage;
                } else {
                    [msg getSenderProfile:^(TIMUserProfile *profile) {
                        cellData.avaterImageUrl = profile.faceURL;
                    }];
                    cellData.identifier = receiver;
                }
                cellData.innerMessage = msg;
                return cellData;
            } else if ([type isEqualToString:@"video_connect"]) {
                // video_connect 已接通
                MessageVideoCellData *cellData = [[MessageVideoCellData alloc] initWithDirection:msg.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
                cellData.videoData = customElem.data;
                cellData.isSelf = msg.isSelf;
                if (msg.isSelf == YES) {
                    cellData.headImage = [YLUserDefault userDefault].headImage;
                } else {
                    [msg getSenderProfile:^(TIMUserProfile *profile) {
                        cellData.avaterImageUrl = profile.faceURL;
                    }];
                    cellData.identifier = receiver;
                }
                cellData.innerMessage = msg;
                return cellData;
            } else if ([type isEqualToString:@"video_unconnect_user"] || ([type isEqualToString:@"video_unconnect_anchor"] && msg.isSelf == YES)) {
                // video_unconnect_user 用户呼主播  未接通
                // video_unconnect_anchor 主播呼用户 未接通 自己方
                MessageVideoUserCellData *cellData = [[MessageVideoUserCellData alloc] initWithDirection:msg.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
                cellData.isSelf = msg.isSelf;
                cellData.callType = dic[@"call_type"];
                if (msg.isSelf == YES) {
                    cellData.headImage = [YLUserDefault userDefault].headImage;
                } else {
                    [msg getSenderProfile:^(TIMUserProfile *profile) {
                        cellData.avaterImageUrl = profile.faceURL;
                    }];
                    cellData.identifier = receiver;
                }
                cellData.innerMessage = msg;
                return cellData;
            } else if ([type isEqualToString:@"video_unconnect_anchor"] && msg.isSelf == NO) {
                // video_unconnect_anchor 主播呼用户 未接通 对方
                MessageVideoAnchorCellData *cellData = [[MessageVideoAnchorCellData alloc] initWithDirection:msg.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
                cellData.videoData = customElem.data;
                if (msg.isSelf == YES) {
                    cellData.headImage = [YLUserDefault userDefault].headImage;
                } else {
                    [msg getSenderProfile:^(TIMUserProfile *profile) {
                        cellData.avaterImageUrl = profile.faceURL;
                    }];
                    cellData.identifier = receiver;
                }
                cellData.innerMessage = msg;
                return cellData;
            } else if ([type isEqualToString:@"picture"]) {
                // 服务端发送的图片消息  以自定义消息发送
                MessageImageData *cellData = [[MessageImageData alloc] initWithDirection:msg.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
                cellData.imageUrl = dic[@"fileUrl"];
                if (msg.isSelf == YES) {
                    cellData.headImage = [YLUserDefault userDefault].headImage;
                } else {
                    [msg getSenderProfile:^(TIMUserProfile *profile) {
                        cellData.avaterImageUrl = profile.faceURL;
                    }];
                    cellData.identifier = receiver;
                }
                cellData.innerMessage = msg;
                return cellData;
            } else if ([type isEqualToString:@"voice"]) {
                // 服务端发送的语音消息  以自定义消息发送  使用的TUI里的data 修改源码以适应我们需要展示的内容
                TUIVoiceMessageCellData *cellData = [[TUIVoiceMessageCellData alloc] initWithDirection:msg.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
                cellData.voicePath = dic[@"fileUrl"];
                cellData.duration = [dic[@"duration"] intValue];
                NSString *ident = [NSString stringWithFormat:@"%llu_%@", msg.uniqueId , msg.sender];
                cellData.ident = ident;
                NSString *localIdent = [[NSUserDefaults standardUserDefaults] objectForKey:@"MESSAGE_LOCAL_IDENT"];
                if ([localIdent containsString:ident]) {
                    cellData.customInt = 1;
                }
                [msg getSenderProfile:^(TIMUserProfile *profile) {
                    cellData.avatarUrl = [NSURL URLWithString:profile.faceURL];
                }];
                if (msg.isSelf == NO) {
                    cellData.identifier = receiver;
                }
                cellData.innerMessage = msg;
                return cellData;
            }
        }
    }
    return nil;
}

- (TUIMessageCell *)chatController:(TUIChatController *)controller onShowMessageData:(TUIMessageCellData *)data {
    if ([data isKindOfClass:[MessageGiftCellData class]]) {
        MessageGiftCell *giftCell = [[MessageGiftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"giftCell"];
        [giftCell fillWithData:(MessageGiftCellData *)data];
        return giftCell;
    } else if ([data isKindOfClass:[MessageVideoCellData class]]) {
        // 通话时间cell
        MessageVideoCell *videoCell = [[MessageVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoCell"];
        [videoCell fillWithData:(MessageVideoCellData *)data];
        return videoCell;
    } else if ([data isKindOfClass:[MessageVideoUserCellData class]]) {
        // 未接听cell  用户显示
        MessageVideoUserCell *videoUserCell = [[MessageVideoUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoUserCell"];
        [videoUserCell fillWithData:(MessageVideoCellData *)data];
        return videoUserCell;
    } else if ([data isKindOfClass:[MessageVideoAnchorCellData class]]) {
        // 未接听cell  主播显示
        MessageVideoAnchorCell *videoAnchorCell = [[MessageVideoAnchorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoAnchorCell"];
        [videoAnchorCell fillWithData:(MessageVideoCellData *)data];
        return videoAnchorCell;
    } else if ([data isKindOfClass:[MessageImageData class]]) {
        // 自定义  图片
        MessageImageCell *imagCell = [[MessageImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
        [imagCell fillWithData:(MessageImageData *)data];
        return imagCell;
    }

    return nil;
}

- (void)chatController:(TUIChatController *)controller onSelectMessageContent:(TUIMessageCell *)cell {
    [self.view endEditing:YES];
    [self hideEmojiView];
    
    if ([cell isKindOfClass:[MessageImageCell class]]) {
        // 图片点击
        MessageImageCell *imageCell = (MessageImageCell *)cell;
        BigImageViewController *imageVC = [[BigImageViewController alloc] init];
        imageVC.bigImage = imageCell.contentImageView.image;
        [self.navigationController pushViewController:imageVC animated:YES];
    }
}

- (void)chatController:(TUIChatController *)controller onSelectMessageAvatar:(TUIMessageCell *)cell {
    // 点击头像
    NSInteger idCard = _otherUserId+10000;
    NSString *receiver = [NSString stringWithFormat:@"%ld",(long)idCard];
    NSLog(@"__receiver:%@    cell.messageData.identifier:%@", receiver, cell.messageData.identifier);
    if ([cell.messageData.identifier isEqualToString:receiver]) {
        if (_infoHandle.t_role == 1) {
            [YLPushManager pushAnchorDetail:_otherUserId];
        } else {
            [YLPushManager pushFansDetail:_otherUserId];
        }
    }
}

#pragma mark - TUIFaceView Delegate
- (void)faceView:(TUIFaceView *)faceView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TFaceGroup *group = [TUIKit sharedInstance].config.faceGroups[indexPath.section];
    TFaceCellData *face = group.faces[indexPath.row];
    [textField setText:[textField.text stringByAppendingString:face.name]];
    
}

- (void)faceViewDidBackDelete:(TUIFaceView *)faceView {
    if (textField.text.length != 0) {
        UITextPosition *position = [textField endOfDocument];
        textField.selectedTextRange = [textField textRangeFromPosition:position toPosition:position];
        [textField deleteBackward];
    }
}

- (void)faceViewDidSendMsg:(TUIFaceView *)faceView {
    if (textField.text.length > 0) {
        [self sendTextMessage];
    }
}

#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        return NO;
    }
    [self sendTextMessage];
    return YES;
}

//#pragma mark - 扬声器 听筒切换
//- (void)setReceiver {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(sensorStateChange:)
//                                                 name:@"UIDeviceProximityStateDidChangeNotification"
//                                               object:nil];
//}
//
//-(void)sensorStateChange:(NSNotificationCenter *)notification {
//    if ([[UIDevice currentDevice] proximityState] == YES) {
//        [SVProgressHUD showInfoWithStatus:@"切换为听筒播放"];
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//
//    } else {
//        [SVProgressHUD showInfoWithStatus:@"切换为扬声器播放"];
//        if(![[AVAudioSession sharedInstance].category isEqualToString:AVAudioSessionCategoryPlayAndRecord] || !([AVAudioSession sharedInstance].categoryOptions ==  (AVAudioSessionCategoryOptionDefaultToSpeaker|AVAudioSessionCategoryOptionMixWithOthers))) {
//            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
//        }
//        [[AVAudioSession sharedInstance] setActive:YES error:nil];
//    }
//}

#pragma mark - lazy loading
- (TUIFaceView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[TUIFaceView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height, App_Frame_Width, 180)];
        _emojiView.delegate = self;
        _emojiView.hidden = YES;
        [_emojiView setData:[NSMutableArray arrayWithArray:[TUIKit sharedInstance].config.faceGroups]];
        [self.view addSubview:_emojiView];
        
        UIButton *sendBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-70, 140, 70, 40) text:@"发送" font:15 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
        sendBtn.backgroundColor = UIColor.grayColor;
        [sendBtn addTarget:self action:@selector(sendTextMessage) forControlEvents:UIControlEventTouchUpInside];
        [_emojiView addSubview:sendBtn];
    }
    return _emojiView;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_player removeFromSuperview];
}


@end
