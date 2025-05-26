//
//  FUCameraManager.m
//  beijing
//
//  Created by 黎 涛 on 2020/11/23.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "FUCameraManager.h"
#import "AgoraManager.h"
#import <TiSDK/TiSDK.h>

#import "FUDemoManager.h"

@implementation FUCameraManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cameraIsFront = YES;
        self.isChatLived = NO;
    }
    return self;
}

- (void)startCapture {
    [[AgoraManager shareManager] setVideoEncoderMirrorMode:AgoraVideoMirrorModeEnabled];
    [self.mCamera startCapture];
}

- (void)stopCapture {
    [self.mCamera stopCapture];
}

- (void)switchCamera {
    _cameraIsFront = !_cameraIsFront;
    [_mCamera changeCameraInputDeviceisFront:_cameraIsFront];
    if (_cameraIsFront) {
        [[AgoraManager shareManager] setVideoEncoderMirrorMode:AgoraVideoMirrorModeEnabled];
    } else {
        [[AgoraManager shareManager] setVideoEncoderMirrorMode:AgoraVideoMirrorModeDisabled];
    }
}

- (void)setLocalView:(UIImageView *)view {
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.videoView = view;
}

#pragma mark - FUCameraDelegate
-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) ;
    
    // 相芯美颜
    pixelBuffer = [self processFrame:pixelBuffer];
    
    
    if (!pixelBuffer) return;
    
    [self transBufferToImage:pixelBuffer];
    
    AgoraVideoFrame *videoFrame = [[AgoraVideoFrame alloc] init];
    videoFrame.format = 12;
    videoFrame.textureBuf = pixelBuffer;
    videoFrame.time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    [[AgoraManager shareManager].rtcEngineKit pushExternalVideoFrame:videoFrame];
    
//    //[FUUserDefault loadFilterWithPixelBuffer:pixelBuffer];
//    
//    
//    BOOL isMirror = YES;
//    
//    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//    unsigned char *baseAddress = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
//    
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    TiRotationEnum rotation;
//    switch (orientation) {
//        case UIDeviceOrientationPortrait:
//            rotation = CLOCKWISE_90;
//            break;
//        case UIDeviceOrientationLandscapeLeft:
//            rotation = isMirror ? CLOCKWISE_180 : CLOCKWISE_0;
//            break;
//        case UIDeviceOrientationLandscapeRight:
//            rotation = isMirror ? CLOCKWISE_0 : CLOCKWISE_180;
//            break;
//        case UIDeviceOrientationPortraitUpsideDown:
//            rotation = CLOCKWISE_270;
//            break;
//        default:
//            rotation = CLOCKWISE_90;
//            break;
//    }
//    
//    // 视频帧格式
//    TiImageFormatEnum format;
//    switch (CVPixelBufferGetPixelFormatType(pixelBuffer)) {
//        case kCVPixelFormatType_32BGRA:
//            format = BGRA;
//            break;
//        case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange:
//            format = NV12;
//            break;
//        case kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:
//            format = NV12;
//            break;
//        default:
//            NSLog(@"错误的视频帧格式！");
//            format = BGRA;
//            break;
//    }
//    
//    int imageWidth, imageHeight;
//    if (format == BGRA) {
//        imageWidth = (int)CVPixelBufferGetBytesPerRow(pixelBuffer) / 4;
//        imageHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
//    } else {
//        imageWidth = (int)CVPixelBufferGetWidthOfPlane(pixelBuffer , 0);
//        imageHeight = (int)CVPixelBufferGetHeightOfPlane(pixelBuffer , 0);
//    }
//    
////    [FUUserDefault loadFilterWithPixelBuffer:pixelBuffer];
//    
//    [[TiSDKManager shareManager] renderPixels:baseAddress Format:format Width:imageWidth Height:imageHeight Rotation:CLOCKWISE_0 Mirror:isMirror];
//    [self transBufferToImage:pixelBuffer];
//    
////    if (!_isChatLived) return;
//    
//    AgoraVideoFrame *videoFrame = [[AgoraVideoFrame alloc] init];
//    videoFrame.format = 12;
//    videoFrame.textureBuf = pixelBuffer;
//    videoFrame.time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
//    [[AgoraManager shareManager].rtcEngineKit pushExternalVideoFrame:videoFrame];
}

- (void)transBufferToImage:(CVImageBufferRef)imageBuffer {
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    if (ciImage == nil) {
        return;
    }
    CGFloat imageWidth = CVPixelBufferGetWidth(imageBuffer);
    CGFloat imageHeight = CVPixelBufferGetHeight(imageBuffer);
    CGImageRef videoImage = [self.temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, imageWidth, imageHeight)];
    if (videoImage == nil) {
        CVPixelBufferRelease(imageBuffer);
        return;
    }
    UIImage *image = [[UIImage alloc] initWithCGImage:videoImage];
    CGImageRelease(videoImage);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoView.contentMode = UIViewContentModeScaleAspectFit;
        self.videoView.image = image;
    });
}

#pragma mark - lazyloading
-(FUCamera *)mCamera {
    if (!_mCamera) {
        _mCamera = [[FUCamera alloc] init];
        _mCamera.delegate = self ;
        [_mCamera changeCameraInputDeviceisFront:YES];
    }
    return _mCamera ;
}

- (CIContext *)temporaryContext {
    if (!_temporaryContext) {
        _temporaryContext = [CIContext contextWithOptions:nil];
    }
    return _temporaryContext;
}


//// 相芯美颜
- (CVPixelBufferRef)processFrame:(CVPixelBufferRef)frame {
    [[FUTestRecorder shareRecorder] processFrameWithLog];
    if (![FUDemoManager shared].shouldRender) {
        return frame;
    }
    
    if (![FUDemoManager shared].supportBeauty){
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
