//
//  LoginPwdView.h
//  beijing
//
//  Created by yiliaogao on 2019/3/12.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LoginPwdViewDelegate <NSObject>

- (void)didSelectLoginPwdViewWithBtn:(NSInteger)btnTag;

@end

@interface LoginPwdView : BaseView

@property (nonatomic, strong) UITextField   *phoneTextField;

@property (nonatomic, strong) UITextField   *pwdTextField;

@property (nonatomic, weak) id<LoginPwdViewDelegate>    delegate;

@end

NS_ASSUME_NONNULL_END
