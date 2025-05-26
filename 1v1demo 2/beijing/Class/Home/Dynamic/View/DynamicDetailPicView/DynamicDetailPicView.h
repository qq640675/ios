//
//  DynamicDetailPicView.h
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicDetailPicView : BaseView
<
UIScrollViewDelegate
>

@property (strong, nonatomic) UIScrollView  *imageScrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (copy,   nonatomic) NSArray        *fileModelArray;
@property (strong, nonatomic) NSMutableArray *imageViewArray;
@property (strong, nonatomic) NSMutableArray *lockViewArray;
@property (strong, nonatomic) NSMutableArray *animationImageViewArray;
@property (strong, nonatomic) NSTimer        *timer;

@property (assign, nonatomic) NSUInteger     curPage;

@end

NS_ASSUME_NONNULL_END
