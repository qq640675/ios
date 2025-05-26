//
//  LoginMainView.m
//  beijing
//
//  Created by yiliaogao on 2019/3/12.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LoginMainView.h"
#import "ToolManager.h"

@implementation LoginMainView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.loginMenuView = [[LoginMenuView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    _loginMenuView.delegate = self;
    [self addSubview:_loginMenuView];
    
    //账号密码登录
    self.loginPwdView = [[LoginPwdView alloc] initWithFrame:CGRectMake(0, 90, self.width, 150)];
    [self addSubview:_loginPwdView];
    
    //验证码登录
    self.loginPhoneView = [[LoginPhoneView alloc] initWithFrame:CGRectMake(0, 90, self.width, 150)];
    [self addSubview:_loginPhoneView];
    _loginPhoneView.hidden = YES;
    
    UIButton *loginBtn = [ToolManager defaultMutableColorButtonWithFrame:CGRectMake((App_Frame_Width-300)/2, 280, 300, 50) title:@"登录" isCycle:YES];
    [loginBtn addTarget:self action:@selector(clickedLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    
    _loginPhoneView.hidden = NO;
    _loginPwdView.hidden   = YES;
}

- (void)didSelectLoginMenuViewWithBtnTag:(NSInteger)btnTag {
    [self endEditing:YES];
    if (btnTag == 0) {
        //账号密码登录
        _loginPwdView.hidden = NO;
        _loginPhoneView.hidden = YES;
    } else {
        //验证码登录
        _loginPhoneView.hidden = NO;
        _loginPwdView.hidden   = YES;
    }
}

- (void)clickedLoginBtn {
    if (_loginMenuView.selectedBtn.tag == 0) {
        if (_loginPwdView.phoneTextField.text.length == 0 || _loginPwdView.phoneTextField.text.length != 11) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确格式的手机号码"];
            return;
        }
        if (_loginPwdView.pwdTextField.text.length < 6 || _loginPwdView.pwdTextField.text.length > 16) {
            [SVProgressHUD showInfoWithStatus:@"请输入6-16位的密码"];
            return;
        }
        
        _phoneString = _loginPwdView.phoneTextField.text;
        _pwdString  = _loginPwdView.pwdTextField.text;
        _codeString = @"";
        
    } else {
        if (_loginPhoneView.phoneTextField.text.length == 0 || _loginPhoneView.phoneTextField.text.length != 11) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确格式的手机号码"];
            return;
        }
        if (_loginPhoneView.codeTextField.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
            return;
        }
        _phoneString = _loginPhoneView.phoneTextField.text;
        _pwdString  = @"";
        _codeString = _loginPhoneView.codeTextField.text;
        
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectLoginMainViewLoginBtnWithPhone:code:pwd:)]) {
        [_delegate didSelectLoginMainViewLoginBtnWithPhone:_phoneString code:_codeString pwd:_pwdString];
    }
}

@end
