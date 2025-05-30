//
//  SLPhotoBrowser.m
//  GY_Teacher
//
//  Created by apple on 2017/4/25.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLPhotoBrowser.h"
#import "SLBrowserImageView.h"
#import "SLPhotoLockView.h"

@interface SLPhotoBrowser ()
<
UIScrollViewDelegate
>

@property (nonatomic, strong) UIScrollView  *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) BOOL          hasShowedFistView;



@end

@implementation SLPhotoBrowser

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += SLPhotoBrowserImageViewMargin*2;
    
    self.scrollView.bounds = rect;
    self.scrollView.center = self.center;
    
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - SLPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(SLBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SLPhotoBrowserImageViewMargin + idx * (SLPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
}

//当视图移动完成之后会调用该方法
- (void)didMoveToSuperview {
    [self initWithScrollView];
    
    [self initWithPageControl];
}

- (void)initWithScrollView {
    
    [self addSubview:self.scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        SLBrowserImageView *imageView = [[SLBrowserImageView alloc] init];
        imageView.tag = i;
        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [imageView addGestureRecognizer:singleTap];
        
        //双击图片,用于图片放大查看
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        
        // 关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [imageView addGestureRecognizer:doubleTap];
        
        [self.scrollView addSubview:imageView];
    }
    
    [self setupImageForIndex:self.currentImageIndex];
}

- (void)initWithPageControl {
    if (_imageCount > 1) {
        self.pageControl.numberOfPages = _imageCount;
        self.pageControl.currentPage   = _currentImageIndex;
        [self addSubview:self.pageControl];
    }
}

//加载图片
- (void)setupImageForIndex:(NSInteger)index {
    SLBrowserImageView *imageView = self.scrollView.subviews[index];
    self.currentImageIndex = index;
    
    //图片加载过
    if (imageView.hasLoadedImage) {
        return;
    }
    
    //利用代理 拿到url
    if ([self imageURLForIndex:self.currentImageIndex]) {
        if ([self imageIsPrivateForIndex:index]) {
            //私密
            [imageView sd_setImageWithURL:[self imageURLForIndex:self.currentImageIndex] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                imageView.image = [UIImage coreBlurImage:image withBlurNumber:40];
                SLPhotoLockView *lockView = [SLPhotoLockView new];
                lockView.frame = imageView.frame;
                UIImageView *lockImageView = [lockView viewWithTag:10];
                lockImageView.image = [UIImage imageNamed:@"Dynamic_list_lock_big"];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedLockView:)];
                [lockView addGestureRecognizer:tap];
                lockView.tag = imageView.tag;
                lockView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
                UIVisualEffectView *effectView = [lockView viewWithTag:99];
                effectView.hidden = YES;
                
                [self.scrollView addSubview:lockView];
            }];
        } else {
            [imageView setImageWithURL:[self imageURLForIndex:self.currentImageIndex] placeholderImage:[self placeholderImageForIndex:index]];
        }
    } else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
    
}

- (void)clickedLockView:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:lookImagePrivateForIndex:)]) {
        [_delegate photoBrowser:self lookImagePrivateForIndex:_currentImageIndex];
    }
}

- (void)imageClicked:(UITapGestureRecognizer *)recognizer {
    _scrollView.hidden = YES;
    
    SLBrowserImageView *currentImageView = (SLBrowserImageView *)recognizer.view;
    NSInteger currentIndex = currentImageView.tag;
    
    UIImageView *tempView = [[UIImageView alloc] init];
    
    UIView *sourceView = [self.sourceImagesContainerView viewWithTag:currentIndex+100];
    // 获取点击图片的坐标及大小
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    tempView.contentMode = sourceView.contentMode;
    
    
    tempView.clipsToBounds = YES;
    tempView.image = currentImageView.image;
    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
    
    if (!currentImageView.image) {
        // 防止 image == nil
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    
    [self addSubview:tempView];
    
    
    [UIView animateWithDuration:SLPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.frame = rect;
        self.backgroundColor = [UIColor clearColor];
        self.pageControl.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer {
    SLBrowserImageView *imageView = (SLBrowserImageView *)recognizer.view;
    CGFloat scale = 2.0;
    if (imageView.isScaled) {
        scale = 1.0;
    }
    
    SLBrowserImageView *view = (SLBrowserImageView *)recognizer.view;
    
    [view doubleTapToZommWithScale:scale];
}

- (void)show {
    

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    
    //监听frame
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    
    [window addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        SLBrowserImageView *currentImageView = _scrollView.subviews[_currentImageIndex];
        if ([currentImageView isKindOfClass:[SLBrowserImageView class]]) {
            [currentImageView clear];
        }
    }
}

- (void)showFirstImage
{
    UIView *sourceView = [self.sourceImagesContainerView viewWithTag:_currentImageIndex+100];
    // 获取点击图片的坐标及大小
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    
    // 创建一个临时imageview
    UIImageView *tempView = [[UIImageView alloc] init];
    // 获取点击的image
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    [self addSubview:tempView];
    // 放大的坐标及大小
    CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
    
    tempView.frame = rect;
    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    
    // 放大动画
    [UIView animateWithDuration:SLPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        // 动画完成之后，临时imageview 移除掉
        self.hasShowedFistView = YES;
        [tempView removeFromSuperview];
        self.scrollView.hidden = NO;
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)imageURLForIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:imageURLForIndex:)]) {
        return [self.delegate photoBrowser:self imageURLForIndex:index];
    }
    return nil;
}

- (BOOL)imageIsPrivateForIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:isImagePrivateForIndex:)]) {
        return [self.delegate photoBrowser:self isImagePrivateForIndex:index];
    }
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    int scrX = scrollView.contentOffset.x;
    int w = _scrollView.width;
    int yu = scrX%w;
    int index = scrollView.contentOffset.x / _scrollView.bounds.size.width;
    self.pageControl.currentPage = index;
    [self setupImageForIndex:index];
    if (yu > 5 && index < [_scrollView.subviews count]-1) {
        [self setupImageForIndex:index+1];
    }
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height-SLPhotoBrowserPageControlMargin);
        _pageControl.backgroundColor = [UIColor redColor];
    }
    return _pageControl;
}

- (void)dealloc {
    [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"frame"];
}

@end
