//
//  VideoPlayViewController.h
//  beijing
//
//  Created by 黎 涛 on 2020/5/26.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayViewController : BaseViewController

@property (nonatomic ,assign) int godId;
@property (nonatomic ,strong) NSString *videoUrl;
@property (nonatomic ,strong) NSString *coverImageUrl;
@property (nonatomic ,assign) int videoId;
//查询视频类型 0.相册视频 1.动态视频
@property (nonatomic ,assign) int queryType;

@end

NS_ASSUME_NONNULL_END
