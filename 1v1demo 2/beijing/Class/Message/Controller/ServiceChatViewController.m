

#import "ServiceChatViewController.h"
#import "TUIKit.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "MMLayout/UIView+MMLayout.h"
#import "THelper.h"
#import "TUITextMessageCell.h"
#import "TUIVoiceMessageCell.h"
#import "TUIImageMessageCell.h"
#import "TUIFaceCell.h"
#import "TUIFaceView.h"
#import "UIView+MMLayout.h"
#import "TUIRecordView.h"

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


@interface ServiceChatViewController ()<TUIChatControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, LFImagePickerControllerDelegate, TFaceViewDelegate>
{
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
    
    NSString *guardGold;
    NSString *guardId;
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

@end

@implementation ServiceChatViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XZRGB(0xf5f5f5);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    coinLabelHeight = 0;
    
    
    if(![[AVAudioSession sharedInstance].category isEqualToString:AVAudioSessionCategoryPlayAndRecord] || !([AVAudioSession sharedInstance].categoryOptions ==  (AVAudioSessionCategoryOptionDefaultToSpeaker|AVAudioSessionCategoryOptionMixWithOthers))) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self setChatVC];
    
    [self addNotification];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self checkImState];
    
    //上报已读
    [_conv setReadMessage:nil succ:nil fail:nil];
    
    [[NewMessageAlertView shareView] stopAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    [self cancelRecord];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnReadMsgNoti" object:nil];
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
    CGFloat transformY = endFrame.origin.y - itemView.height + bottomHeight;
    if (beginFrame.size.height>0 && (beginFrame.origin.y-endFrame.origin.y>0)) {
        //执行动画
        [UIView animateWithDuration:duration animations:^{
            self->itemView.y = transformY-SafeAreaTopHeight;
            self.chat.messageController.tableView.height = transformY-SafeAreaTopHeight-self->coinLabelHeight;
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
        if ([title isEqualToString:@"图片"]) {
            [self choosePicWithCameraWithType:0]; //单张图片选择
        } else if ([title isEqualToString:@"拍摄"]) {
            [self choosePicWithCameraWithType:1];
        }
    } else if (sender.tag == 6888) {
        // 表情
        [self chatEmoji];
    }
}

#pragma mark - 发送文字
- (void)sendTextMessage {
    if (textField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"内容不能为空"];
        return;
    }

    TUITextMessageCellData *data = [[TUITextMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
    data.content = textField.text;
    [self.chat sendMessage:data];
    self->textField.text = nil;
}

#pragma mark - 发送emoji
- (void)chatEmoji {
    voiceBtn.selected = NO;
    textField.hidden = NO;
    recordButton.hidden = YES;
    self.emojiView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self->itemView.y -= 180;
        self.emojiView.y = CGRectGetMinY(self->itemView.frame)+125;
        self.chat.messageController.tableView.height -= 180;
        [self.chat.messageController scrollToBottom:NO];
    }];
}

- (void)hideEmojiView {
    if (_emojiView.hidden == NO) {
        [UIView animateWithDuration:0.25 animations:^{
            self->itemView.y = APP_Frame_Height-SafeAreaTopHeight-self->itemView.height;
            self.emojiView.y = APP_Frame_Height;
            self.chat.messageController.tableView.height = APP_Frame_Height-SafeAreaTopHeight-self->itemView.height-self->coinLabelHeight;
            [self.chat.messageController scrollToBottom:NO];
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
    NSData *data = UIImageJPEGRepresentation(image, 0.75);
    
    [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    
    TUIImageMessageCellData *cellData = [[TUIImageMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
    cellData.path = path;
    cellData.length = data.length;
    [self.chat sendMessage:cellData];
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
    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    int duration = (int)CMTimeGetSeconds(audioAsset.duration);
    int length = (int)[[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
    TUIVoiceMessageCellData *cellData = [[TUIVoiceMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
    cellData.path = path;
    cellData.duration = duration;
    cellData.length = length;
    [self.chat sendMessage:cellData];
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
    
    // 自定义inputbBar
    [self reSetInputBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewDidTouched)];
    [self.chat.messageController.tableView addGestureRecognizer:tap];
    _chat.messageController.tableView.y = coinLabelHeight;
    
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
            
        } fail:^(int code, NSString *msg) {
            
        }];
    }
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
    
    NSArray *iconArr = @[@"chat_item_pic", @"chat_item_camera"];
    NSArray *titleArr = @[@"图片", @"拍摄"];
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
    [itemView addSubview:voiceBtn];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, App_Frame_Width-100, 35)];
    textField.delegate = self;
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
    recordButton.frame = CGRectMake(50, 80, App_Frame_Width-100, 35);
    recordButton.backgroundColor = XZRGB(0xf5f5f5);
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
}


@end
