//
//  AnchorVideoView.h
//  beijing
//
//  Created by yiliaogao on 2019/3/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "videoPictureHandle.h"
#import "SLPhotoLockView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnchorVideoView : BaseView

@property (nonatomic, strong) UIImageView   *imageView;

@property (nonatomic, strong) UIImageView   *videoTempImageView;

@property (nonatomic, strong) UILabel       *moneyLb;

@property (nonatomic, strong) UILabel       *titleLb;

@property (nonatomic, strong) UILabel       *desLb;

@property (nonatomic, strong) videoPictureHandle    *handle;

@property (nonatomic, assign) BOOL          isAnchorDetail;

@property (nonatomic, strong) SLPhotoLockView *lockView;

@end

NS_ASSUME_NONNULL_END
