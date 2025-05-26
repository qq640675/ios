//
//  RecommendBannerView.m
//  beijing
//
//  Created by 黎 涛 on 2019/6/10.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "RecommendBannerView.h"
#import "BaseView.h"
#import "JChatConstants.h"

@implementation RecommendBannerView
{
    SDCycleScrollView *imageScrollView;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self setSubViews];
    }
    return self;
}

#pragma mark - set SubViews
- (void)setSubViews
{
    imageScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 15, self.width, 110) imageNamesGroup:nil];
    imageScrollView.backgroundColor = UIColor.whiteColor;
    imageScrollView.autoScrollTimeInterval = 4;
    imageScrollView.layer.masksToBounds = YES;
    imageScrollView.layer.cornerRadius = 6;
    WEAKSELF
    imageScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        if (weakSelf.bannerClicked) {
            weakSelf.bannerClicked(currentIndex);
        }
    };
    [self addSubview:imageScrollView];
}

- (void)setBanners:(NSArray *)banners
{
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < banners.count; i ++) {
        @autoreleasepool {
            bannerHandle *handle = banners[i];
            [images addObject:handle.t_img_url];
        }
    }
    imageScrollView.imageURLStringsGroup = images;
    
}



@end
