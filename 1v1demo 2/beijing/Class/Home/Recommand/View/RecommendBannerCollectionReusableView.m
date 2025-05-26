//
//  RecommendBannerCollectionReusableView.m
//  beijing
//
//  Created by yiliaogao on 2019/3/6.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "RecommendBannerCollectionReusableView.h"
#import "BaseView.h"

@implementation RecommendBannerCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 5, self.width, 95)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    UIImageView *hotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 111, 26, 33)];
    hotImageView.image = IChatUImage(@"HomePgae_hot");
    [self addSubview:hotImageView];
    
    UILabel *lb = [UIManager initWithLabel:CGRectMake(35, 108, 100, 33) text:@"官方热门" font:20 textColor:XZRGB(0xAE4FFD)];
    lb.font = [UIFont boldSystemFontOfSize:20.0f];
    lb.textAlignment = NSTextAlignmentLeft;
    [self addSubview:lb];
}

- (void)setBanners:(NSArray *)banners {
    NSInteger count = [banners count];
    CGFloat width = 160;
    for (int i = 0; i < count; i ++) {
        bannerHandle *handle = banners[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width+5)*i, 0, width, 95)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = XZRGB(0xebebeb);
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 5;
        imageView.tag = i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:handle.t_img_url] placeholderImage:IChatUImage(@"loading")];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedBannerImage:)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }
    [_scrollView setContentSize:CGSizeMake((width+5)*count, 95)];
}

- (void)clickedBannerImage:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectBanner:)]) {
        [_delegate didSelectBanner:tap.view.tag];
    }
}

@end
