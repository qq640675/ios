//
//  HomeHeaderCollectionReusableView.m
//  beijing
//
//  Created by 黎 涛 on 2020/4/30.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "HomeHeaderCollectionReusableView.h"
#import "BaseView.h"
#import "SDCycleScrollView.h"
#import "bannerHandle.h"
#import "YLPushManager.h"
#import "UIButton+LXMImagePosition.h"

@implementation HomeHeaderCollectionReusableView
{
    UIView *bannerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self ) {
        self.backgroundColor = UIColor.whiteColor;
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    bannerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.height.mas_equalTo(0);
    }];
}



- (void)setBannerArray:(NSArray *)bannerArray bannerHeight:(CGFloat)bannerHeight {
    
    self.height = bannerHeight;
    if (bannerHeight > 0) {
        [bannerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(bannerHeight);
        }];
    }
    _bannerArray = bannerArray;
    [self reSetBannerView];
}

- (void)reSetBannerView {
    [bannerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    SDCycleScrollView *imageScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(7, 7, App_Frame_Width-14, 106) imageNamesGroup:nil];
    imageScrollView.backgroundColor = UIColor.whiteColor;
    imageScrollView.autoScrollTimeInterval = 4;
    imageScrollView.layer.masksToBounds = YES;
    imageScrollView.layer.cornerRadius = 5;
    imageScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
//        bannerHandle *handle = self.bannerArray[currentIndex];
        NSDictionary *dic = self.bannerArray[currentIndex];
        [YLPushManager bannerPushClass:[NSString stringWithFormat:@"%@", dic[@"t_link_url"]]];
    };
    [bannerView addSubview:imageScrollView];
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < _bannerArray.count; i ++) {
        @autoreleasepool {
//            bannerHandle *handle = _bannerArray[i];
            NSDictionary *dic = _bannerArray[i];
            [images addObject:[NSString stringWithFormat:@"%@", dic[@"t_img_url"]]];
        }
    }
    imageScrollView.imageURLStringsGroup = images;
}


@end
