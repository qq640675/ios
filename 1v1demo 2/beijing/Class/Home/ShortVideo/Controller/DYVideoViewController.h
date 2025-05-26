//
//  DYVideoViewController.h
//  beijing
//
//  Created by 黎 涛 on 2019/8/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYVideoViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *videoArray; //当前的已请求的视频数组集合
@property (nonatomic, assign) NSInteger videoIndex; //当前是第几个视频
@property (nonatomic, assign) int page; //当前页码
@property (nonatomic, assign) int videoType; //视频类型 -1全部 0 免费 1付费

//查询视频类型 0.相册视频 1.动态视频
@property (nonatomic ,assign) int queryType;


@end

NS_ASSUME_NONNULL_END
