//
//  RecommendBannerView.h
//  beijing
//
//  Created by 黎 涛 on 2019/6/10.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bannerHandle.h"
#import "SDCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendBannerView : UICollectionReusableView<SDCycleScrollViewDelegate>

@property (nonatomic, copy) NSArray *banners;
@property (nonatomic, copy) void (^bannerClicked)(NSInteger bannerIndex);

@end

NS_ASSUME_NONNULL_END
