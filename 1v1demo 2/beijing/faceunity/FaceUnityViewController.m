//
//  DemoChatViewController.m
//  beijing
//
//  Created by Mailin Lin on 2022/1/15.
//  Copyright © 2022 zhou last. All rights reserved.
//

#import "FaceUnityViewController.h"
#import <AGMBase/AGMBase.h>
#import <AGMCapturer/AGMCapturer.h>
#import <AGMRenderer/AGMRenderer.h>
#import <GLKit/GLKit.h>
#import "FUCamera.h"
#import "FUDemoManager.h"
//#import "MHMeiyanMenusView.h"
//#import <MHBeautySDK/MHBeautySDK.h>
//#import "MHBeautyParams.h"
//#import "MHUIHelper.h"

// MHMeiyanMenusViewDelegate,
@interface FaceUnityViewController ()<AgoraRtcEngineDelegate, AgoraVideoSourceProtocol,
FUCameraDelegate,AGMVideoCameraDelegate>
{
    GLKView* _glView;
    EAGLContext* _glContext;
    CIContext* _ciContext;
    UIView *localVideo;
    BOOL isFirstLoad;
    BOOL _isRenderInit;
}


@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) AGMCameraCapturer *cameraCapturer;
@property (nonatomic, strong) AGMCapturerVideoConfig *videoConfig;


@property (strong, nonatomic) FUCamera *mCamera ;
@property (nonatomic, strong) AGMEAGLVideoView *glVideoView;
@property (nonatomic, assign) BOOL isNeed;


@property (nonatomic, strong) UIView *viewBeauty;
//@property (nonatomic, strong) MTUIDefaultButtonView *defaultButton;


@end
 
@implementation FaceUnityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFirstLoad = YES;
    localVideo = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:localVideo];
    
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _ciContext = [CIContext contextWithEAGLContext:_glContext];
    _glView = [[GLKView alloc] initWithFrame:localVideo.bounds context:_glContext];
    _glView.context = _glContext;
    
    _glView = [[GLKView alloc] initWithFrame:localVideo.bounds context:_glContext];
    _glView.context = _glContext;
    _isNeed = YES;
    
    
    if (![EAGLContext setCurrentContext:_glContext]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
    
    
    self.glVideoView = [[AGMEAGLVideoView alloc] initWithFrame:localVideo.bounds];
    self.glVideoView.renderMode = AGMRenderMode_Hidden;
    [localVideo addSubview:self.glVideoView];
    
    [self setupButtons];
    [self hideVideoMuted];
    [self initializeAgoraEngine];
    [self setupVideo];
    [self setupLocalVideo];
    [self joinChannel];
    [self initCapturer];
    
//    [self.view addSubview:[MTUIManager shareManager].defaultButton];
  
    
    
    UIButton *backBtn = [UIManager initWithButton:CGRectMake(0, SafeAreaTopHeight-64, 88, 88) text:nil font:15.0f textColor:[UIColor clearColor] normalImg:@"PersonCenter_beauty_back" highImg:nil selectedImg:nil];
    [backBtn addTarget:self action:@selector(clickedBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    if ([FUDemoManager shared].supportBeauty){
        
        self.viewBeauty = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.viewBeauty.hidden = YES;
        [self.view addSubview:self.viewBeauty];
        
        
        [[FUDemoManager shared] addDemoViewToView:self.viewBeauty originY:CGRectGetHeight(self.view.frame) - FUBottomBarHeight - FUSafaAreaBottomInsets()];
        
        
//        self.defaultButton = [[MTUIDefaultButtonView alloc]initWithFrame:CGRectMake(0, MTScreenHeight - MTUIViewBoxTotalHeight, MTScreenWidth, MTUIViewBoxTotalHeight)];
//        [self.defaultButton setOnClickBlock:^(NSInteger tag) {
//            switch (tag) {
//                case 0:
//                case 3:
//                    //显示美颜UI
//                    self.viewBeauty.hidden = NO;
//                    self.defaultButton.hidden = YES;
//
//                    break;
//                default:
//                    break;
//            }
//
//        }];

//        [self.view addSubview:self.defaultButton];
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFirstLoad == YES)
    {
        isFirstLoad = NO;
    }
}


- (void)changeSize{
    [self viewDidLayoutSubviews];
//
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
//    [self leaveChannel];
    //todo --- toivan start ---
//    [[MtSDK Get] destroyRenderPixels];
    _isRenderInit = false;
//    [[MTUIManager shareManager] destroy];
   //todo --- toivan end ---
}


- (void)initializeAgoraEngine {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:basicAgoraAppId delegate:self];
    [self.agoraKit enableVideo];
    [self.agoraKit setVideoSource:self];
   NSLog(@"version-%@",[AgoraRtcEngineKit getSdkVersion]) ;
    [self.agoraKit enableWebSdkInteroperability:YES];
}



- (void)setupVideo {
    [self.agoraKit enableVideo];
    // Default mode is disableVideo
    AgoraVideoEncoderConfiguration *encoderConfiguration =
    [[AgoraVideoEncoderConfiguration alloc] initWithSize:AgoraVideoDimension640x480
                                               frameRate:AgoraVideoFrameRateFps15
                                                 bitrate:AgoraVideoBitrateCompatible
                                         orientationMode:AgoraVideoOutputOrientationModeFixedPortrait];
    [self.agoraKit setVideoEncoderConfiguration:encoderConfiguration];
}

-(FUCamera *)mCamera {
    if (!_mCamera) {
        _mCamera = [[FUCamera alloc] init];
        _mCamera.delegate = self ;
    }
    return _mCamera ;
}

- (void)initCapturer {
#pragma mark Capturer
    self.videoConfig = [AGMCapturerVideoConfig defaultConfig];
    self.videoConfig.pixelFormat = AGMVideoPixelFormatBGRA;
    self.videoConfig.sessionPreset = AVCaptureSessionPreset640x480;
    self.videoConfig.fps = 15;
    self.cameraCapturer = [[AGMCameraCapturer alloc] initWithConfig:self.videoConfig];
    self.cameraCapturer.delegate = self;
    [self.cameraCapturer start];

}

- (id<AgoraVideoFrameConsumer>)consumer{
    return nil;
}

- (AgoraVideoContentHint)contentHint{
    return AgoraVideoContentHintNone;
}





- (void)setupLocalVideo {
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    // UID = 0 means we let Agora pick a UID for us

    videoCanvas.view = localVideo;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    [self.agoraKit setupLocalVideo:videoCanvas];
    // Bind local video stream to view
}




- (void)joinChannel {
}


- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
}



- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteStateReason)reason elapsed:(NSInteger)elapsed
{
    NSLog(@"remoteVideoStateChangedOfUid %@ %@ %@", @(uid), @(state), @(reason));
}

- (IBAction)hangUpButton:(UIButton *)sender {
    [self leaveChannel];
}



///  Leave the channel and handle UI change when it is done.
- (void)leaveChannel {
    [self.agoraKit leaveChannel:^(AgoraChannelStats *stat) {
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }];
}


/// Callback to handle an user offline event.
/// @param engine - RTC engine instance
/// @param uid - user id
/// @param reason - why is the user offline
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
//    self.remoteVideo.hidden = true;
}

- (void)setupButtons {
   
}

- (void)hideControlButtons {
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([[FUDemoManager shared] hideCurrentView] == NO)
    {
        self.viewBeauty.hidden = YES;
//        self.defaultButton.hidden = NO;
    }
}

- (void)resetHideButtonsTimer {
}

- (IBAction)didClickMuteButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    [self.agoraKit muteLocalAudioStream:sender.selected];
    [self resetHideButtonsTimer];
}

- (IBAction)didClickVideoMuteButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.agoraKit muteLocalVideoStream:sender.selected];
    localVideo.hidden = sender.selected;
    [self resetHideButtonsTimer];
}


/// A callback to handle muting of the audio
/// @param engine  - RTC engine instance
/// @param muted  - YES if muted; NO otherwise
/// @param uid  - user id
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid {
}

- (void) hideVideoMuted {
}

- (IBAction)didClickSwitchCameraButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.mCamera changeCameraInputDeviceisFront:sender.selected];
    [self.cameraCapturer switchCamera];
    [self.agoraKit switchCamera];
    [self resetHideButtonsTimer];
}

- (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef {
    CVImageBufferRef imageBuffer =  pixelBufferRef;
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrderDefault, provider, NULL, true, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return image;
}

- (void)clickedBackBtn {
//    [self releaseData];
    
//    [FUDemoManager destory];
    
    [FUDemoManager saveFUManager];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)releaseData
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.cameraCapturer != nil)
    {
        self.cameraCapturer.delegate = nil;
        [self.cameraCapturer stop];
        self.cameraCapturer = nil;
    }
    
 
}

#pragma mark -AGMVideoCameraDelegate
- (void)didOutputVideoFrame:(id<AGMVideoFrame>)frame{
    if ([frame isKindOfClass:AGMCVPixelBuffer.class]) {
        AGMCVPixelBuffer *agmPixelBuffer = frame;
        /**
         美狐相关
         */
//        CVPixelBufferRef pixelBuffer = agmPixelBuffer.pixelBuffer;
        CVPixelBufferRef pixelBuffer = [self processFrame:agmPixelBuffer.pixelBuffer];
        
        //渲染
//        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//        OSType formatType = CVPixelBufferGetPixelFormatType(pixelBuffer);
//
//
//        //todo --- toivan start3 ---
////        int imageWidth = (int)CVPixelBufferGetBytesPerRow(pixelBuffer) / 4;
////        int imageHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
//
////        if (!isRenderInit) {
////            isRenderInit = MtSDK.get().initRenderPixelsFormat(.BGRA, width: videoFrame.strideInPixels, height: videoFrame.height, rotation: MtRotation(rawValue: rotation) ?? .CLOCKWISE_0, mirror: false, faceNumber: 5)
////        }
////
//
//        unsigned char *pixels = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
//        if (!_isRenderInit) {
//            _isRenderInit = [[MtSDK Get] initRenderPixelsFormat:BGRA Width:(int)agmPixelBuffer.width Height:(int)agmPixelBuffer.height Rotation:(int)agmPixelBuffer.rotation Mirror:false FaceNumber:5];
//        }
//        [[MtSDK Get] renderPixels:pixels];
        
//        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        //todo --- toivan end3 ---
        
        if (!pixelBuffer) return;
        if (self.glVideoView) {
            AGMCVPixelBuffer *newPixelBuffer = [[AGMCVPixelBuffer alloc] initWithPixelBuffer:pixelBuffer];
            [newPixelBuffer setParamWithWidth:agmPixelBuffer.width height:agmPixelBuffer.height rotation:agmPixelBuffer.rotation timeStampMs:agmPixelBuffer.timeStampMs];
            /** 刷新视频 */
            [self.glVideoView renderFrame:newPixelBuffer];
            
        }
        //传给sdk
        CMTime time = CMTimeMake(frame.timeStampMs * 1000, (int)1);
        AgoraVideoFrame *frame1 = [[AgoraVideoFrame alloc] init];
        frame1.format = 12;
        frame1.textureBuf = pixelBuffer;
        frame1.time = time;
        frame1.rotation = 0;
        BOOL is =  [self.agoraKit pushExternalVideoFrame:frame1];
        if (is) {
//            NSLog(@"+++++++");
        }else{
//            NSLog(@"-------");
        }
        
    }
}


//// 相芯美颜
- (CVPixelBufferRef)processFrame:(CVPixelBufferRef)frame {
    [[FUTestRecorder shareRecorder] processFrameWithLog];
    if (![FUDemoManager shared].shouldRender) {
        return frame;
    }
    if (![FUDemoManager shared].supportBeauty) {
        return frame;
    }
    
    [[FUDemoManager shared] checkAITrackedResult];
    [FUDemoManager updateBeautyBlurEffect];
    FURenderInput *input = [[FURenderInput alloc] init];
    input.pixelBuffer = frame;
    //默认图片内部的人脸始终是朝上，旋转屏幕也无需修改该属性。
    input.renderConfig.imageOrientation = FUImageOrientationUP;
    //开启重力感应，内部会自动计算正确方向，设置fuSetDefaultRotationMode，无须外面设置
    input.renderConfig.gravityEnable = YES;
    input.renderConfig.stickerFlipH = YES;
    input.renderConfig.isFromFrontCamera = YES;
//    input.renderConfig.isFromMirroredCamera = YES;
    FURenderOutput *output = [[FURenderKit shareRenderKit] renderWithInput:input];
    return output.pixelBuffer;
}

@end
