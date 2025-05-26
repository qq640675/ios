//
//  FullScreenNotView.h
//  beijing
//
//  Created by 黎 涛 on 2019/9/19.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FullScreenNotView : BaseView

@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *notImageView;
@property (nonatomic, strong) NSDictionary *nowParam;

+ (instancetype)shareView;
+ (void)tearDownView;

- (void)setSubViews;

- (void)showWithAnimationWithParam:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
