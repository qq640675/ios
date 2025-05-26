//
//  LoginRegisterView.h
//  beijing
//
//  Created by yiliaogao on 2019/3/12.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LoginRegisterViewDelegate <NSObject>

- (void)didSelectLoginRegisterViewWithBtn:(UIButton *)btn;

@end

@interface LoginRegisterView : BaseView

@property (nonatomic, strong) UITextField   *phoneTextField;

@property (nonatomic, strong) UITextField   *codeTextField;

@property (nonatomic, strong) UIButton      *codeBtn;

@property (nonatomic, strong) UITextField   *pwdTextField;

@property (nonatomic, strong) UIButton      *registerBtn;

@property (nonatomic, weak) id<LoginRegisterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
