//
//  LoginMainView.h
//  beijing
//
//  Created by yiliaogao on 2019/3/12.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "LoginMenuView.h"
#import "LoginPwdView.h"
#import "LoginPhoneView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LoginMainViewDelegate <NSObject>

- (void)didSelectLoginMainViewLoginBtnWithPhone:(NSString *)phone code:(NSString *)code pwd:(NSString *)pwd;

@end

@interface LoginMainView : BaseView
<
LoginMenuViewDelegate
>

@property (nonatomic, strong) LoginMenuView     *loginMenuView;

@property (nonatomic, strong) LoginPwdView      *loginPwdView;

@property (nonatomic, strong) LoginPhoneView    *loginPhoneView;

@property (nonatomic, copy) NSString    *phoneString;

@property (nonatomic, copy) NSString    *codeString;

@property (nonatomic, copy) NSString    *pwdString;

@property (nonatomic, weak) id<LoginMainViewDelegate>   delegate;

@end

NS_ASSUME_NONNULL_END
