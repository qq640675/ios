//
//  YLUploadVideoManager.m
//  beijing
//
//  Created by yiliaogao on 2019/1/4.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "YLUploadVideoManager.h"

static YLUploadVideoManager *uploadVideoManager = nil;

@implementation YLUploadVideoManager

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!uploadVideoManager) {
            uploadVideoManager = [[YLUploadVideoManager alloc] init];
        }
    });
    return uploadVideoManager;
}

- (void)uploadVideoWithPath:(NSString *)videoPath coverPath:(NSString *)coverPath signature:(NSString *)signature finishBlock:(YLUploadVideoFinishBlock)finishBlock {
    _uploadVideoFinishBlock = finishBlock;
    
    TXPublishParam * param = [[TXPublishParam alloc] init];
    // 需要填写第四步中计算的上传签名
    param.signature = signature;
    
    param.videoPath = videoPath;

    param.coverPath = coverPath;
    
    param.enableResume = YES;
    
    TXUGCPublish *_ugcPublish = [[TXUGCPublish alloc] init];
    // 文件发布默认是采用断点续传
    _ugcPublish.delegate = self;
    // 设置 TXVideoPublishListener 回调
    [_ugcPublish publishVideo:param];
}

-(void)onPublishProgress:(NSInteger)uploadBytes totalBytes:(NSInteger)totalBytes {
    
}

- (void)onPublishComplete:(TXPublishResult *)result {
    if (_uploadVideoFinishBlock) {
        _uploadVideoFinishBlock(result);
    }
}

@end
