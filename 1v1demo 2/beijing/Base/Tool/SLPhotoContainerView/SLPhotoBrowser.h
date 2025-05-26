//
//  SLPhotoBrowser.h
//  GY_Teacher
//
//  Created by apple on 2017/4/25.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBrowserImageView.h"
#import "SLPhotoBrowserConfig.h"

@class SLPhotoBrowser;

@protocol SLPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(SLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(SLPhotoBrowser *)browser imageURLForIndex:(NSInteger)index;

- (BOOL)photoBrowser:(SLPhotoBrowser *)browser isImagePrivateForIndex:(NSInteger)index;

- (void)photoBrowser:(SLPhotoBrowser *)browser lookImagePrivateForIndex:(NSInteger)index;


@end

@interface SLPhotoBrowser : UIView

@property (nonatomic, strong) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) id<SLPhotoBrowserDelegate> delegate;

- (void)show;

@end
