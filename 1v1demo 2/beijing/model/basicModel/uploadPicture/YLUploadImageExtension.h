//
//  YLUploadImageExtension.h
//  beijing
//
//  Created by zhou last on 2018/7/3.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface YLUploadImageExtension : NSObject

typedef void(^YLUploadImageFinish)(NSString *backImageUrl);

+ (id)shareInstance;

- (void)uploadImage:(UIImage *)pickImage uplodImageblock:(YLUploadImageFinish)block;

- (void)uploadKindsOfPictures:(NSMutableArray *)pictureArray block:(YLUploadImageFinish)block;

@end
