//
//  LoginVerificationView.h
//  beijing
//
//  Created by yiliaogao on 2019/1/22.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

@protocol LoginVerificationViewDelegate <NSObject>

- (void)didSelectLoginVerificationViewWithBgView;

- (void)didSelectLoginVerificationViewWithBtn:(NSString *)code;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LoginVerificationView : BaseView

@property (nonatomic, strong) UITextField   *textField;

@property (nonatomic, strong) UIImageView   *codeImageView;

@property (nonatomic, weak) id<LoginVerificationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
