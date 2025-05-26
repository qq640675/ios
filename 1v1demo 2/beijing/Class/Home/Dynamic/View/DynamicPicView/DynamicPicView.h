//
//  DynamicPicView.h
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "BaseView.h"

@protocol DynamicPicViewDelegate <NSObject>

- (void)didSelectDynamicPicViewBtn:(NSUInteger)btnTag;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DynamicPicView : BaseView

@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UIButton      *deleteBtn;
//@property (nonatomic, strong) UIButton      *freeBtn;

@property (nonatomic, weak)   id<DynamicPicViewDelegate>    delegate;

- (void)setupWithImage:(UIImage *)image title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
