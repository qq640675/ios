//
//  DynamicDetailPicView.m
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicDetailPicView.h"
#import "DynamicFileModel.h"
#import "UIImage+FEBoxBlur.h"
#import "SLPhotoLockView.h"

@implementation DynamicDetailPicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
    [_timer invalidate];
}

- (void)setupUI {
    self.backgroundColor = KWHITECOLOR;
    
    [self addSubview:self.imageScrollView];
    [self addSubview:self.pageControl];
    _pageControl.hidden = YES;
    
    self.imageViewArray = [NSMutableArray new];
    self.lockViewArray = [NSMutableArray new];
    
    //最多9张图片，初始化imageView
    for (int i = 0; i < 9; i ++) {
        UIImageView *imageView = [UIImageView new];
        [_imageScrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = i+100;
        imageView.hidden = YES;
        [_imageViewArray addObject:imageView];
        
        SLPhotoLockView *lockView = [SLPhotoLockView new];
        UIImageView *lockImageView = [lockView viewWithTag:10];
        lockImageView.image = [UIImage imageNamed:@"Dynamic_list_lock_big"];
        lockView.hidden = YES;
        UITapGestureRecognizer *tapLock = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedImageView:)];
        [lockView addGestureRecognizer:tapLock];
        [self addSubview:lockView];
        lockView.tag = 1000+i;
        [_lockViewArray addObject:lockView];
    }
    
}

- (void)clickedImageView:(UITapGestureRecognizer *)tap {
    
}

- (void)setFileModelArray:(NSMutableArray *)fileModelArray {
    _fileModelArray = fileModelArray;
    
    if ([fileModelArray count] > 1) {
        _pageControl.hidden = NO;
        _pageControl.numberOfPages = [fileModelArray count];
        [_timer invalidate];
        [self valtimers];
    }
    
    //枚举
    [fileModelArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imageView = self.imageViewArray[idx];
        imageView.hidden = NO;
        imageView.frame  = CGRectMake(idx*self.width, 0, self.width, self.height);
        DynamicFileModel *model = fileModelArray[idx];
        NSString *imgUrl = model.t_file_url;
        if (model.t_file_type == 1) {
            //视频显示封面
            imgUrl = model.t_cover_img_url;
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (model.isPrivate && !model.isConsume) {
                imageView.image = [UIImage coreBlurImage:image withBlurNumber:40];
                SLPhotoLockView *lockView = self.lockViewArray[idx];
                lockView.frame = imageView.frame;
                lockView.hidden = NO;
            }else{
                imageView.image = image;
                if (model.t_file_type == 1) {
                    SLPhotoLockView *lockView = self.lockViewArray[idx];
                    lockView.frame = imageView.frame;
                    UIImageView *lockImageView = [lockView viewWithTag:10];
                    lockView.backgroundColor = KCLEARCOLOR;
                    lockImageView.image = [UIImage imageNamed:@"myalbum_Videoplayback"];
                    lockView.hidden = NO;
                }
            }
        }];
        
    }];
    
    _animationImageViewArray = [NSMutableArray new];
    for (int i = 0; i < [_fileModelArray count]; i++) {
        UIImageView *imageView = _imageViewArray[i];
        [_animationImageViewArray addObject:imageView];
    }
    
    [_imageScrollView scrollRectToVisible:_imageScrollView.frame animated:NO];
    
    _imageScrollView.contentSize = CGSizeMake(self.width*fileModelArray.count, self.height);
    
}

- (void)valtimers {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoPage) userInfo:nil repeats:YES];
}

- (void)autoPage {
    if([_fileModelArray count] >= 2){
        [UIView beginAnimations:@"autoPage" context:nil];
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint newOffset = self->_imageScrollView.contentOffset;
            if (newOffset.x == ([self->_animationImageViewArray count] - 1) * self->_imageScrollView.bounds.size.width) {
                newOffset.x = self->_imageScrollView.bounds.size.width;
            } else {
                newOffset.x += self->_imageScrollView.bounds.size.width;
            }
            self->_imageScrollView.contentOffset = newOffset;
        } completion:^(BOOL finished) {
            if(self->_imageScrollView.contentOffset.x == ([self->_animationImageViewArray count] - 1) * self->_imageScrollView.bounds.size.width){
                [self pageMoveToLeft];
                CGPoint newOffset = self->_imageScrollView.contentOffset;
                newOffset.x -= self->_imageScrollView.bounds.size.width;
                [self->_imageScrollView setContentOffset:newOffset animated:NO];
                [self.pageControl setCurrentPage:[self currentDisplayPage]];
            }
        }];
        [UIView commitAnimations];
        [self.pageControl setCurrentPage:[self currentDisplayPage]];
    }
}

- (void)pageMoveToRight {
    NSMutableArray *temp = [NSMutableArray array];
    [temp addObject:[_animationImageViewArray objectAtIndex:[_animationImageViewArray count] - 1]];
    for(int i = 0; i < [_animationImageViewArray count] - 1; i ++){
        [temp addObject:[_animationImageViewArray objectAtIndex:i]];
    }
    
    _animationImageViewArray = temp;
    [self setPageFrame];
}

- (void)pageMoveToLeft {
    NSMutableArray *temp = [NSMutableArray array];
    for(int i = 1; i < [_animationImageViewArray count]; i ++){
        [temp addObject:[_animationImageViewArray objectAtIndex:i]];
    }
    [temp addObject:[_animationImageViewArray objectAtIndex:0]];
    
    _animationImageViewArray = temp;
    [self setPageFrame];
}

- (NSUInteger)currentDisplayPage {
    CGFloat pageWidth = _imageScrollView.bounds.size.width;
    
    int page = floor((_imageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    UIView *view = [_animationImageViewArray objectAtIndex:page];
    return view.tag-100;
}

- (void)setPageFrame {
    for(int i = 0; i < [_animationImageViewArray count]; i ++){
        UIView *view = [_animationImageViewArray objectAtIndex:i];
        view.frame = CGRectMake(i * _imageScrollView.bounds.size.width, 0, _imageScrollView.bounds.size.width, _imageScrollView.bounds.size.height);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_timer invalidate];
    [self valtimers];
    CGFloat pageWidth = _imageScrollView.bounds.size.width;
    
    int page = floor((_imageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if(page == 0) {
        [self pageMoveToRight];
        CGPoint p = CGPointZero;
        p.x = pageWidth;
        [scrollView setContentOffset:p animated:NO];
    } else if (page == [_animationImageViewArray count] - 1) {
        [self pageMoveToLeft];
        CGPoint p = CGPointZero;
        p.x = ([_animationImageViewArray count] - 2) * pageWidth;
        [scrollView setContentOffset:p animated:NO];
    }
    
    [self.pageControl setCurrentPage:[self currentDisplayPage]];
}

- (UIScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.delegate = self;
        _imageScrollView.bounces = NO;
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.showsVerticalScrollIndicator   = NO;
    }
    return _imageScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height-30, self.width, 30)];
        _pageControl.currentPageIndicatorTintColor = XZRGB(0xAE4FFD);
        _pageControl.pageIndicatorTintColor = KOFFLINECOLOR;
    }
    return _pageControl;
}

@end
