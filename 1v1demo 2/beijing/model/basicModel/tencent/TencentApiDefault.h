//
//  TencentApiDefault.h
//  beijing
//
//  Created by zhengzw on 2024/12/7.
//  Copyright © 2024 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TencentApiDefault : NSObject

@property (nonatomic ,strong) NSString *tmpSecretId;
@property (nonatomic ,strong) NSString *tmpSecretKey;
@property (nonatomic ,strong) NSString *sessionToken;
@property (nonatomic ,strong) NSString *region;
@property (nonatomic ,strong) NSString *appid;
@property (nonatomic ,strong) NSString *bucket;

+ (TencentApiDefault *)apiDefault;
+ (void)saveTmpBucket:(NSString *)bucket;
+ (void)saveTmpAppid:(NSString *)appid;
+ (void)saveTmpRegion:(NSString *)region;

+ (void)saveTmpSessionToken:(NSString *)sessionToken;
+ (void)saveTmpSecretKey:(NSString *)tmpSecretKey;
+ (void)saveTmpSecretId:(NSString *)tmpSecretId;
@end

NS_ASSUME_NONNULL_END
