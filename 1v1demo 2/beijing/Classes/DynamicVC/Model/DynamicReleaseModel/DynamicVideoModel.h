//
//  DynamicVideoModel.h
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicVideoModel : SLBaseListModel

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString  *title;
@property (nonatomic, copy) NSString  *money;
@property (nonatomic, copy) NSString  *videoPath;
@property (nonatomic, copy) NSString  *videoImagePath;

@property (nonatomic, assign) NSUInteger  videoSec;
@property (nonatomic, assign) NSUInteger  videoSize;


@end

NS_ASSUME_NONNULL_END
