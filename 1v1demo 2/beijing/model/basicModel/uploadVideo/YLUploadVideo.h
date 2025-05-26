//
//  YLUploadVideo.h
//  beijing
//
//  Created by zhou last on 2018/7/14.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLUploadVideo : UIViewController

typedef void(^YLChooseVideoFinish)(NSString *videoUrl);
typedef void(^YLUploadVideoFinish)(NSString *videoUrl,BOOL isSuccess,NSString *videoId);


+ (id)shareInstance;

- (void)customPickerController:(UIViewController *)selfVC Block:(YLChooseVideoFinish)block;

- (void)uploadVideo:(NSString *)videoPath sign:(NSString *)sign block:(YLUploadVideoFinish)block;

+(UIImage*)getCoverImage:(NSString*)outMovieURL;


@end
