//
//  QCloudHTTPRetryHanlder.m
//  QCloudNetworking
//
//  Created by tencent on 16/2/24.
//  Copyright © 2016年 QCloudTernimalLab. All rights reserved.
//

#import "QCloudHTTPRetryHanlder.h"
#import "QCloudNetEnv.h"
#import "QCloudLogger.h"
#import "NSError+QCloudNetworking.h"

@implementation QCloudHTTPRetryConfig

+ (QCloudHTTPRetryConfig *)globalRetryConfig{
    static QCloudHTTPRetryConfig * config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[QCloudHTTPRetryConfig alloc]init];
    });
    return config;
}

- (instancetype)init{
    if(self = [super init]){
        _maxCount = 0;
        _sleepStep = 0;
    }
    return self;
}

@end

@interface QCloudHTTPRetryHanlder ()
@end

@implementation QCloudHTTPRetryHanlder {
    int _currentTryCount;
    //    NSSet* _errorRetryCode;
    QCloudHTTPRetryFunction _retryFunction;
}

+ (QCloudHTTPRetryHanlder *)defaultRetryHandler {
    return [[QCloudHTTPRetryHanlder alloc] initWithMaxCount:3 sleepTime:1];
}
- (instancetype)initWithMaxCount:(NSInteger)maxCount sleepTime:(NSTimeInterval)sleepStep {
    self = [super init];
    if (!self) {
        return self;
    }
    _sleepStep = sleepStep;
    _maxCount = maxCount;
    [self reset];
    return self;
}

- (void)reset {
    _currentTryCount = 0;
}

- (BOOL)retryFunction:(QCloudHTTPRetryFunction)function whenError:(NSError *)error;
{
    QCloudLogTrance();
    if (!function) {
        return NO;
    }
    if (![self canRetryWhenError:error]) {
        return NO;
    }
    if (function) {
        function();
    }
    _currentTryCount++;
    return YES;
}

- (BOOL)canRetryWhenError:(NSError *)error {
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        if (error.code == NSURLErrorTimedOut) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkSituationChangeKey object:@(QCloudNetworkSituationWeakNetwork)];
        }
    }

    if (_currentTryCount >= self.maxCount) {
        QCloudLogDebug(@"超过了最大重试次数，不再重试");
        return NO;
    }
    
    if(error.code == QCloudNetworkErrorCodeDomainInvalid){
        return YES;
    }

    return [NSError isNetworkErrorAndRecoverable:error] || ([error.domain isEqualToString:kQCloudNetworkDomain] && error.code >= 500);
}

- (NSInteger)maxCount{
    if(QCloudHTTPRetryConfig.globalRetryConfig.openConfig){
        return QCloudHTTPRetryConfig.globalRetryConfig.maxCount;
    }
    return _maxCount;
}

- (NSTimeInterval)sleepStep{
    if(QCloudHTTPRetryConfig.globalRetryConfig.openConfig){
        return QCloudHTTPRetryConfig.globalRetryConfig.sleepStep;
    }
    return _sleepStep;
}

@end
