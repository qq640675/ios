//
//  SLImageCacheHelper.h
//  Qiaqia
//
//  Created by yiliaogao on 2019/7/12.
//  Copyright © 2019 yiliaogaoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLImageCacheHelper : NSObject

typedef void (^TAsyncImageComplete)(NSString *path, UIImage *image);

+ (void)asyncDecodeImage:(NSString *)path complete:(TAsyncImageComplete)complete;

@end

NS_ASSUME_NONNULL_END
