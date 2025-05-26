//
//  RecommendBannerCollectionReusableView.h
//  beijing
//
//  Created by yiliaogao on 2019/3/6.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bannerHandle.h"

@protocol RecommendBannerCollectionReusableViewDelegate <NSObject>

- (void)didSelectBanner:(NSInteger)bannerIndex;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RecommendBannerCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UIScrollView  *scrollView;

@property (nonatomic, copy) NSArray     *banners;

@property (nonatomic, weak) id<RecommendBannerCollectionReusableViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
