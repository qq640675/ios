//
//  BanPactAlertView.h
//  beijing
//
//  Created by 黎 涛 on 2021/4/1.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BanPactAlertView : BaseView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *picIV;
@property (nonatomic, copy) NSString *pactUrl;

- (void)showWithImageUrl:(NSString *)imageUrl pactUrl:(NSString *)pactUrl;

@end

NS_ASSUME_NONNULL_END
