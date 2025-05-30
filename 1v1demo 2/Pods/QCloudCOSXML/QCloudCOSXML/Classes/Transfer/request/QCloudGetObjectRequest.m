//
//  GetObject.m
//  GetObject
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗
//   ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║ ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║ ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║ ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║
//  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝ ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _
//                                                          __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \
//                                                         '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/
//                                                         |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/
//                                                         \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//

#import "QCloudGetObjectRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudConfiguration_Private.h>
#import "QCloudGetObjectRequest+Custom.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudGetObjectRequest
- (void)dealloc {
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.objectKeySimplifyCheck = YES;
    return self;
}
- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[ QCloudURLFuseSimple, QCloudURLFuseWithURLEncodeParamters ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),

        QCloudResponseAppendHeadersSerializerBlock,
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (!self.object || ([self.object isKindOfClass:NSString.class] && ((NSString *)self.object).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                      qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                      message:[NSString stringWithFormat:
                               @"InvalidArgument:paramter[object] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    if (self.objectKeySimplifyCheck && [[self simplifyPath:self.object] isEqualToString:@"/"]) {
        if (error != NULL) {
            *error = [NSError
                      qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                      message:[NSString stringWithFormat:
                               @"The Getobject Key is illegal"]];
            return NO;
        }
    }
    
    if (!self.bucket || ([self.bucket isKindOfClass:NSString.class] && ((NSString *)self.bucket).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                      qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                      message:[NSString stringWithFormat:
                               @"InvalidArgument:paramter[bucket] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    if (self.responseContentType) {
        [self.requestData setValue:self.responseContentType forHTTPHeaderField:@"response-content-type"];
    }
    if (self.responseContentLanguage) {
        [self.requestData setValue:self.responseContentLanguage forHTTPHeaderField:@"response-content-language"];
    }
    if (self.responseContentExpires) {
        [self.requestData setValue:self.responseContentExpires forHTTPHeaderField:@"response-expires"];
    }
    if (self.responseCacheControl) {
        [self.requestData setValue:self.responseCacheControl forHTTPHeaderField:@"response-cache-control"];
    }
    if (self.responseContentDisposition) {
        [self.requestData setValue:self.responseContentDisposition forHTTPHeaderField:@"response-content-disposition"];
    }
    if (self.responseContentEncoding) {
        [self.requestData setValue:self.responseContentEncoding forHTTPHeaderField:@"response-content-encoding"];
    }
    if (self.localCacheDownloadOffset) {
        self.range = [NSString stringWithFormat:@"bytes=%lld-", self.localCacheDownloadOffset];
    }
    if (self.range) {
        [self.requestData setValue:self.range forHTTPHeaderField:@"Range"];
    }
    if (self.ifModifiedSince) {
        [self.requestData setValue:self.ifModifiedSince forHTTPHeaderField:@"If-Modified-Since"];
    }
    if (self.ifUnmodifiedModifiedSince) {
        [self.requestData setValue:self.ifUnmodifiedModifiedSince forHTTPHeaderField:@"If-Unmodified-Since"];
    }
    if (self.ifMatch) {
        [self.requestData setValue:self.ifMatch forHTTPHeaderField:@"If-Match"];
    }
    if (self.ifNoneMatch) {
        [self.requestData setValue:self.ifNoneMatch forHTTPHeaderField:@"If-None-Match"];
    }
    if (self.versionID) {
        [self.requestData setParameter:self.versionID withKey:@"versionId"];
    }
    if (self.trafficLimit) {
        [self.requestData setValue:@(self.trafficLimit).stringValue forHTTPHeaderField:@"x-cos-traffic-limit"];
    }
    
    if(![self.customHeaders isKindOfClass:NSMutableDictionary.class]){
        self.customHeaders = self.customHeaders.mutableCopy;
    }
    [self.customHeaders setObject:@"no-cache" forKey:@"Cache-Control"];
    
    NSURL *__serverURL = [self.runOnService.configuration.endpoint serverURLWithBucket:self.bucket
                                                                                 appID:self.runOnService.configuration.appID
                                                                            regionName:self.regionName];
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.object)
        [__pathComponents addObject:self.object];
    self.requestData.URIComponents = __pathComponents;
   
    if (self.watermarkRule) {
        [self.requestData setQueryStringParamter:@"" withKey:self.watermarkRule];
    }
    

   
    if (![self customBuildRequestData:error])
        return NO;
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }
    return YES;
}

- (QCloudSignatureFields *)signatureFields {
    QCloudSignatureFields *fileds = [QCloudSignatureFields new];

    return fileds;
}

- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))finishBlock {
    
    if (finishBlock) {
        QCloudWeakSelf(self);
        [super setFinishBlock:^(id outputObject, NSError *error) {
            QCloudStrongSelf(self);
            NSError * lError;
            if (QCloudFileExist(strongself.downloadingTempURL.relativePath) && !error) {
                if (QCloudFileExist(strongself.downloadingURL.relativePath)) {
                    QCloudRemoveFileByPath(strongself.downloadingURL.relativePath);
                }
                QCloudMoveFile(strongself.downloadingTempURL.relativePath, strongself.downloadingURL.relativePath, &lError);
            }
            finishBlock(outputObject,error);
        }];
    }
}
- (NSArray<NSMutableDictionary *> *)scopesArray {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *separatetmpArray = [self.requestData.serverURL componentsSeparatedByString:@"://"];
    NSString *str = separatetmpArray[1];
    NSArray *separateArray = [str componentsSeparatedByString:@"."];
    dic[@"bucket"] = separateArray[0];
    dic[@"region"] = self.runOnService.configuration.endpoint.regionName;
    dic[@"prefix"] = self.object;
    dic[@"action"] = @"name/cos:GetObject";
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:dic];
    return [array copy];
}

- (NSString *)simplifyPath:(NSString *)path {
    NSArray *names = [path componentsSeparatedByString:@"/"];
    NSMutableArray *stack = [NSMutableArray array];
    for (NSString *name in names) {
        if ([name isEqualToString:@".."]) {
            if (stack.count > 0) {
                [stack removeLastObject];
            }
        } else if (name.length > 0 && ![name isEqualToString:@"."]) {
            [stack addObject:name];
        }
    }
    return [@"/" stringByAppendingString:[stack componentsJoinedByString:@"/"]];
}


@end
NS_ASSUME_NONNULL_END
