//
//  DynamicVideoView.h
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "BaseView.h"

@protocol DynamicVideoViewDelegate <NSObject>

- (void)didSelectDynamicVideoViewBtn:(NSUInteger)btnTag;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DynamicVideoView : BaseView

//@property (nonatomic, strong) UIButton      *freeBtn;
@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UILabel       *timeLb;

@property (nonatomic, weak)   id<DynamicVideoViewDelegate>    delegate;

- (void)setupWithImage:(UIImage *)image title:(NSString *)title secTime:(NSUInteger)time;

@end

NS_ASSUME_NONNULL_END
