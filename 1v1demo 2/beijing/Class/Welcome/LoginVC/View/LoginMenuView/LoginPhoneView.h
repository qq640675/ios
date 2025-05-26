//
//  LoginPhoneView.h
//  beijing
//
//  Created by yiliaogao on 2019/3/12.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LoginPhoneViewDelegate <NSObject>

- (void)didSelectLoginPhoneViewWithCodeBtn;

@end

@interface LoginPhoneView : BaseView

@property (nonatomic, strong) UITextField   *phoneTextField;

@property (nonatomic, strong) UITextField   *codeTextField;

@property (nonatomic, strong) UIButton      *codeBtn;

@property (nonatomic, weak) id<LoginPhoneViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
