//
//  NewMessageAlertView.h
//  beijing
//
//  Created by 黎 涛 on 2019/10/16.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewMessageAlertView : BaseView

@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic, strong) NSDictionary *nowParam;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;

+ (instancetype)shareView;
+ (void)tearDownView;

- (void)setSubViews;

- (void)showWithAnimationWithParam:(NSDictionary *)param;

- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
