//
//  HomeHeaderCollectionReusableView.h
//  beijing
//
//  Created by 黎 涛 on 2020/4/30.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) NSArray *bannerArray;

- (void)setBannerArray:(NSArray *)bannerArray bannerHeight:(CGFloat)bannerHeight;

@end

NS_ASSUME_NONNULL_END
