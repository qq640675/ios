//
//  DetailHeaderView.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/4.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "SDCycleScrollView.h"
#import "godnessInfoHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailHeaderView : BaseView<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *imageScrollView;
@property (nonatomic, strong) UILabel   *imageCountLb;
@property (nonatomic, strong) godnessInfoHandle *infoHandle;
@property (nonatomic, copy) void (^followButtonClickBlock)(bool isFollow);
@property (nonatomic, copy) void (^guardButtonClickBlock)(void);


@end

NS_ASSUME_NONNULL_END
