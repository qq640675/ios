//
//  YLUploadVideoManager.h
//  beijing
//
//  Created by yiliaogao on 2019/1/4.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"
#import "TXUGCPublish.h"

typedef void(^YLUploadVideoFinishBlock)(TXPublishResult * _Nullable publishResult);

NS_ASSUME_NONNULL_BEGIN

@interface YLUploadVideoManager : NSObject

<
TXVideoPublishListener
>

@property (nonatomic, copy) YLUploadVideoFinishBlock  uploadVideoFinishBlock;

+ (instancetype)shareInstance;

- (void)uploadVideoWithPath:(NSString *)videoPath coverPath:(NSString *)coverPath signature:(NSString *)signature finishBlock:(YLUploadVideoFinishBlock)finishBlock;

@end

NS_ASSUME_NONNULL_END
