//
//  UserInfoVideoView.h
//  beijing
//
//  Created by 黎 涛 on 2019/9/21.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "videoPayHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoVideoView : BaseView<PLPlayerDelegate>

@property (nonatomic, strong) PLPlayer  *player;
@property (nonatomic, assign) NSInteger anchorId;
@property (nonatomic, strong) videoPayHandle *videoHandle;



@end

NS_ASSUME_NONNULL_END
