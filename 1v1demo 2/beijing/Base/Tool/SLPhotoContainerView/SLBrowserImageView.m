//
//  SLBrowserImageView.m
//  GY_Teacher
//
//  Created by apple on 2017/4/25.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLBrowserImageView.h"
#import "SLWaitingView.h"

@interface SLBrowserImageView ()
<
UIGestureRecognizerDelegate
>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView  *scrollImageView;

@property (nonatomic, strong) UIScrollView *zoomingScrollView;

@property (nonatomic, strong) UIImageView  *zoomingScrollImageView;

@property (nonatomic, assign) CGFloat       totalScale;

@property (nonatomic, strong) SLWaitingView *waitingView;

@end

@implementation SLBrowserImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        _totalScale = 1.0;
        // 捏合手势缩放图片
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
        pinch.delegate = self;
        [self addGestureRecognizer:pinch];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize imageSize = self.image.size;
    if (self.bounds.size.width * (imageSize.height / imageSize.width) > self.bounds.size.height) {
        [self.scrollView addSubview:self.scrollImageView];
        
        [self addSubview:self.scrollView];
        
        //图片的高
        CGFloat imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
        
        self.scrollImageView.bounds = CGRectMake(0, 0, self.scrollView.frame.size.width, imageViewH);
        self.scrollImageView.center = CGPointMake(self.scrollView.frame.size.width * 0.5, self.scrollImageView.frame.size.height * 0.5);
        self.scrollView.contentSize = CGSizeMake(0, self.scrollImageView.bounds.size.height);
    } else {
        if (self.scrollView) {
            [self.scrollView removeFromSuperview];
        }
    }
}


- (BOOL)isScaled {
    return _totalScale != 1;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.waitingView = [[SLWaitingView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.waitingView.center = window.center;
    [self.waitingView.indicatorView startAnimating];
    [self addSubview:self.waitingView];
    
    __weak SLBrowserImageView *imageViewWeak = self;
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveLoad;
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [imageViewWeak.waitingView removeFromSuperview];
        
        if (error) {
            NSLog(@">>> error");
        } else {
            imageViewWeak.scrollImageView.image = image;
            [imageViewWeak.scrollImageView setNeedsDisplay];
        }
    }];
}

- (void)zoomImage:(UIPinchGestureRecognizer *)recognizer
{
    [self prepareForImageViewScaling];
    CGFloat scale = recognizer.scale;
    CGFloat temp = _totalScale + (scale - 1);
    [self setTotalScale:temp];
    recognizer.scale = 1.0;
}

- (void)setTotalScale:(CGFloat)totalScale {
    if ((_totalScale < 0.5 && totalScale < _totalScale) || (_totalScale > 2.0 && totalScale > _totalScale)) return; // 最大缩放 2倍,最小0.5倍
    
    [self zoomWithScale:totalScale];
}


- (void)doubleTapToZommWithScale:(CGFloat)scale {
    [self prepareForImageViewScaling];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self zoomWithScale:scale];
    } completion:^(BOOL finished) {
        if (scale == 1) {
            [self clear];
        }
    }];
}

- (void)zoomWithScale:(CGFloat)scale
{
    _totalScale = scale;
    
    _zoomingScrollImageView.transform = CGAffineTransformMakeScale(scale, scale);
    
    if (scale > 1) {
        CGFloat contentW = _zoomingScrollImageView.frame.size.width;
        CGFloat contentH = MAX(_zoomingScrollImageView.frame.size.height, self.frame.size.height);
        
        _zoomingScrollImageView.center = CGPointMake(contentW * 0.5, contentH * 0.5);
        _zoomingScrollView.contentSize = CGSizeMake(contentW, contentH);
        
        
        CGPoint offset = _zoomingScrollView.contentOffset;
        offset.x = (contentW - _zoomingScrollView.frame.size.width) * 0.5;
        _zoomingScrollView.contentOffset = offset;
        
    } else {
        _zoomingScrollView.contentSize = _zoomingScrollImageView.frame.size;
        _zoomingScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _zoomingScrollImageView.center = _zoomingScrollView.center;
    }
}

- (void)prepareForImageViewScaling {
    if (!_zoomingScrollView) {
        _zoomingScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _zoomingScrollView.backgroundColor = [UIColor blackColor];
        _zoomingScrollView.contentSize = self.bounds.size;
        UIImageView *zoomingImageView = [[UIImageView alloc] initWithImage:self.image];
        CGSize imageSize = zoomingImageView.image.size;
        CGFloat imageViewH = self.bounds.size.height;
        if (imageSize.width > 0) {
            imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
        }
        zoomingImageView.bounds = CGRectMake(0, 0, self.bounds.size.width, imageViewH);
        zoomingImageView.center = _zoomingScrollView.center;
        zoomingImageView.contentMode = UIViewContentModeScaleAspectFit;
        _zoomingScrollImageView = zoomingImageView;
        [_zoomingScrollView addSubview:zoomingImageView];
        [self addSubview:_zoomingScrollView];
    }
}

// 清除缩放
- (void)eliminateScale {
    [self clear];
    _totalScale = 1.0;
}

- (void)clear {
    [_zoomingScrollView removeFromSuperview];
    _zoomingScrollView = nil;
    _zoomingScrollImageView = nil;
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.frame = self.bounds;
    }
    return _scrollView;
}

- (UIImageView *)scrollImageView {
    if (!_scrollImageView) {
        _scrollImageView = [[UIImageView alloc] init];
        _scrollImageView.image = self.image;
    }
    return _scrollImageView;
}



@end
