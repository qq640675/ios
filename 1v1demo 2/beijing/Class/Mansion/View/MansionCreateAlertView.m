//
//  MansionCreateAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionCreateAlertView.h"
#import "MansionVideoViewController.h"

@implementation MansionCreateAlertView
{
    UITextField *nameTaxtField;
//    UIView *shortLine;
    UIButton *videoBtn;
//    UIButton *voiceBtn;
    MansionChatType selectedType;//  1视频  2语音
}

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        [self setSubViews];
    }
    return self;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark - sunViews
- (void)setSubViews {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((App_Frame_Width-310)/2, (APP_Frame_Height-310)/2, 310, 310)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10;
    bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bgView];
    
    UILabel *titleLabel = [UIManager initWithLabel:CGRectMake(40, 0, bgView.width-80, 40) text:@"创建房间" font:18 textColor:XZRGB(0x333333)];
    [bgView addSubview:titleLabel];
    
//    UILabel *tip1 = [UIManager initWithLabel:CGRectMake(15, 55, 180, 25) text:@"选择创建房间类型" font:14 textColor:XZRGB(0x333333)];
//    tip1.textAlignment = NSTextAlignmentLeft;
//    [bgView addSubview:tip1];
    
    selectedType = MansionChatTypeVideo;
    videoBtn = [UIManager initWithButton:CGRectMake(25, 80, 130, 30) text:@"视频房间" font:14 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
//    [videoBtn addTarget:self action:@selector(videoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:videoBtn];
    
//    voiceBtn = [UIManager initWithButton:CGRectMake(25+130, 80, 130, 30) text:@"语音房间" font:14 textColor:XZRGB(0x868686) normalImg:nil highImg:nil selectedImg:nil];
//    [voiceBtn addTarget:self action:@selector(voiceButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:voiceBtn];
//
//    shortLine = [[UIView alloc] initWithFrame:CGRectMake(25+65-8, 107, 16, 3)];
//    shortLine.backgroundColor = XZRGB(0x7948fb);
//    shortLine.layer.masksToBounds = YES;
//    shortLine.layer.cornerRadius = 1.5;
//    [bgView addSubview:shortLine];
    
    UILabel *tip2 = [UIManager initWithLabel:CGRectMake(15, 125, 180, 25) text:@"请输入房间名称" font:14 textColor:XZRGB(0x333333)];
    tip2.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:tip2];
    
    UIView *tfBGView = [[UIView alloc] initWithFrame:CGRectMake(15, 165, bgView.width-30, 45)];
    tfBGView.backgroundColor = XZRGB(0xf2f3f7);
    tfBGView.layer.masksToBounds = YES;
    tfBGView.layer.cornerRadius = 4;
    [bgView addSubview:tfBGView];
    
    nameTaxtField = [[UITextField alloc] initWithFrame:CGRectMake(7.5, 7.5, tfBGView.width-15, 30)];
    nameTaxtField.textColor = XZRGB(0x868686);
    nameTaxtField.text = [NSString stringWithFormat:@"%@的欢乐房间", [YLUserDefault userDefault].t_nickName];
    [tfBGView addSubview:nameTaxtField];
    
    CGFloat gap = (bgView.width-180)/3;
    UIButton *cancleBtn = [UIManager initWithButton:CGRectMake(gap, bgView.height-35-18, 90, 35) text:@"取消" font:18 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
    cancleBtn.backgroundColor = XZRGB(0xf2f3f7);
    cancleBtn.layer.masksToBounds = YES;
    cancleBtn.layer.cornerRadius = 17.5;
    [cancleBtn addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancleBtn];
    
    UIButton *sureBtn = [UIManager initWithButton:CGRectMake(gap*2+90, bgView.height-35-18, 90, 35) text:@"创建" font:18 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    sureBtn.backgroundColor = [XZRGB(0xae4ffd) colorWithAlphaComponent:0.72];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 17.5;
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureBtn];
}

#pragma mark - func
//- (void)videoButtonClick {
//    selectedType = MansionChatTypeVideo;
//    [videoBtn setTitleColor:XZRGB(0x333333) forState:0];
//    [voiceBtn setTitleColor:XZRGB(0x868686) forState:0];
//    shortLine.x = 25+65-8;
//}
//
//- (void)voiceButtonClick {
//    selectedType = MansionChatTypeVoice;
//    [voiceBtn setTitleColor:XZRGB(0x333333) forState:0];
//    [videoBtn setTitleColor:XZRGB(0x868686) forState:0];
//    shortLine.x = 25+65-8+130;
//}

- (void)cancleButtonClick {
    [self removeFromSuperview];
}

- (void)sureButtonClick {
    NSString *string = nameTaxtField.text;
    if (string.length == 0) {
        string = [NSString stringWithFormat:@"%@的欢乐房间", [YLUserDefault userDefault].t_nickName];
    }
    [YLNetworkInterface addMansionHouseRoomWithId:_mansionId roomName:string chatType:selectedType success:^(int mansionRoomId) {
        [self toChatWithRoomId:mansionRoomId name:string];
    }];
}

- (void)toChatWithRoomId:(int)roomId name:(NSString *)name{
    [self removeFromSuperview];
    UIViewController *nowVC = [SLHelper getCurrentVC];
    if (selectedType == MansionChatTypeVideo) {
        int camera = [self checkCamera];
        if (camera == 0) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            }];
            return;
        } else if (camera == 2) {
            [self showAlertWithName:@"相机"];
            return;
        } else {
            int mic = [self checkRecordService];
            if (mic == 0) {
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                }];
                return;
            } else if (mic == 2) {
                [self showAlertWithName:@"麦克风"];
                return;
            }
        }
    } else if (selectedType == MansionChatTypeVoice) {
        int mic = [self checkRecordService];
        if (mic == 0) {
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            }];
            return;
        } else if (mic == 2) {
            [self showAlertWithName:@"麦克风"];
            return;
        }
    }
    [LXTAlertView dismiss:^{
        MansionVideoViewController *videoVC = [[MansionVideoViewController alloc] init];
        videoVC.titleStr = name;
        videoVC.isHouseOwner = YES;
        videoVC.mansionRoomId = roomId;
        videoVC.ownerId = [YLUserDefault userDefault].t_id;
        videoVC.chatType = self->selectedType;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:videoVC];
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [nowVC presentViewController:navi animated:YES completion:nil];
    }];
}

- (int)checkCamera {
    __block int isOpen = 0;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        isOpen = 0;
    } else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        isOpen = 2;
    } else {
        isOpen = 1;
    }
    return isOpen;
}

- (int)checkRecordService {
    __block int isOpen = 0;
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    if (permissionStatus == AVAudioSessionRecordPermissionUndetermined) {
        isOpen = 0;
    } else if (permissionStatus == AVAudioSessionRecordPermissionDenied) {
        isOpen = 2;
    } else {
        isOpen = 1;
    }
    
    return isOpen;
}

- (void)showAlertWithName:(NSString *)name {
    [LXTAlertView alertViewWithTitle:@"提示" message:[NSString stringWithFormat:@"此App会在视频聊天服务中访问您的%@权限", name] cancleTitle:@"取消" sureTitle:@"去开启" sureHandle:^{
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
            [[UIApplication sharedApplication] openURL:settingsURL];
        }
    }];
}



@end
