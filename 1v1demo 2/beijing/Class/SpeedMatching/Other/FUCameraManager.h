//
//  FUCameraManager.h
//  beijing
//
//  Created by 黎 涛 on 2020/11/23.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUCameraManager : NSObject<FUCameraDelegate>

@property (nonatomic, strong) UIImageView *videoView;
@property (nonatomic, strong) CIContext *temporaryContext;
@property (strong, nonatomic) FUCamera *mCamera ; //相机
@property (nonatomic, assign) BOOL cameraIsFront;
//是否连接成功
@property (nonatomic, assign) BOOL isChatLived;

- (void)startCapture;
- (void)stopCapture;
- (void)switchCamera;
- (void)setLocalView:(UIImageView *)view;

@end

NS_ASSUME_NONNULL_END
