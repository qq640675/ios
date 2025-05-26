//
//  PulpShadeView.h
//  beijing
//
//  Created by 黎 涛 on 2020/11/26.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PulpShadeView : UIImageView

@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, assign) BOOL isBig;
@property (nonatomic, strong) UILabel *pulpTipLabel;
@property (nonatomic, strong) UIImageView *pulpEmoji;
@property (nonatomic, assign) NSInteger pulpCount;

- (instancetype)initWithSuperView:(UIView *)superView isSelf:(BOOL)isSelf isBig:(BOOL)isBig;
- (instancetype)initWithSuperView:(UIView *)superView isSelf:(BOOL)isSelf;
- (void)changeSuperView:(UIView *)superV isBig:(BOOL)isBig;
- (void)pulpViewCountDown;

@end

NS_ASSUME_NONNULL_END
