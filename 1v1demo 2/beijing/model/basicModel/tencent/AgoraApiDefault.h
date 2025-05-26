//
//  AgoraApiDefault.h
//  beijing
//
//  Created by wjx on 2024/12/21.
//  Copyright © 2024 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AgoraApiDefault : NSObject
@property (nonatomic ,strong) NSString *appid;

+ (AgoraApiDefault *)apiDefault;
+ (void)saveTmpAppid:(NSString *)appid;
@end

NS_ASSUME_NONNULL_END
