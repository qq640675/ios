//
//  LaunchAdvViewController.h
//  beijing
//
//  Created by 黎 涛 on 2019/8/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LaunchAdvViewController : BaseViewController

@property (nonatomic, strong) NSString *advUrl;//web 地址
@property (nonatomic, copy) void(^cancleBlock)(void);//取消回调
@property (nonatomic, assign) int fromType; //0启动广告  1首页广告  2其他跳转过来的广告

@end

NS_ASSUME_NONNULL_END
