//
//  LoginRegisterView.m
//  beijing
//
//  Created by yiliaogao on 2019/3/12.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LoginRegisterView.h"
#import "ToolManager.h"

@implementation LoginRegisterView

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
    
    UIView *phoneBgView = [[UIView alloc] initWithFrame:CGRectZero];
    phoneBgView.clipsToBounds = YES;
    phoneBgView.layer.cornerRadius = 25.0f;
    phoneBgView.layer.borderColor = KDEFAULTCOLOR.CGColor;
    phoneBgView.layer.borderWidth = 1.0f;
    [self addSubview:phoneBgView];
    [phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).offset(30);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    UILabel *phoneLb = [UIManager initWithLabel:CGRectMake(15, 0, 65, 50) text:@"手机号:" font:17.0f textColor:XZRGB(0x333333)];
    phoneLb.textAlignment = NSTextAlignmentLeft;
    [phoneBgView addSubview:phoneLb];
    
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _phoneTextField.placeholder = @"请输入手机号码";
    _phoneTextField.keyboardType= UIKeyboardTypeNumberPad;
    [phoneBgView addSubview:_phoneTextField];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLb.mas_right).offset(10);
        make.top.equalTo(phoneBgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(195, 50));
    }];
    
    UIView *pwdBgView = [[UIView alloc] initWithFrame:CGRectZero];
    pwdBgView.clipsToBounds = YES;
    pwdBgView.layer.cornerRadius = 25.0f;
    pwdBgView.layer.borderColor = KDEFAULTCOLOR.CGColor;
    pwdBgView.layer.borderWidth = 1.0f;
    [self addSubview:pwdBgView];
    [pwdBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneBgView.mas_left);
        make.top.equalTo(phoneBgView.mas_bottom).offset(18);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    
    UILabel *pwdLb = [UIManager initWithLabel:CGRectMake(15, 0, 65, 50) text:@"验证码:" font:17.0f textColor:XZRGB(0x333333)];
    pwdLb.textAlignment = NSTextAlignmentLeft;
    [pwdBgView addSubview:pwdLb];
    
    self.codeTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _codeTextField.placeholder = @"请输入验证码";
    _codeTextField.keyboardType= UIKeyboardTypeNumberPad;
    [pwdBgView addSubview:_codeTextField];
    [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pwdLb.mas_right).offset(10);
        make.top.equalTo(pwdBgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(110, 50));
    }];
    
    self.codeBtn = [UIManager initWithButton:CGRectZero text:@"获取验证码" font:14.0f textColor:XZRGB(0xb4b4b4) normalImg:nil highImg:nil selectedImg:nil];
    _codeBtn.titleLabel.numberOfLines = 2;
    _codeBtn.clipsToBounds = YES;
    _codeBtn.layer.cornerRadius = 25.0f;
    _codeBtn.layer.borderColor = KDEFAULTCOLOR.CGColor;
    _codeBtn.layer.borderWidth = 1.0f;
    [_codeBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_codeBtn];
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pwdBgView.mas_right).offset(10);
        make.top.equalTo(pwdBgView.mas_top);
        make.size.mas_equalTo(CGSizeMake(90, 50));
    }];
    
    UIView *pwBgView = [[UIView alloc] initWithFrame:CGRectZero];
    pwBgView.clipsToBounds = YES;
    pwBgView.layer.cornerRadius = 25.0f;
    pwBgView.layer.borderColor = KDEFAULTCOLOR.CGColor;
    pwBgView.layer.borderWidth = 1.0f;
    [self addSubview:pwBgView];
    [pwBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(pwdBgView.mas_bottom).offset(18);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    UILabel *pwLb = [UIManager initWithLabel:CGRectMake(15, 0, 65, 50) text:@"新密码:" font:17.0f textColor:XZRGB(0x333333)];
    pwLb.textAlignment = NSTextAlignmentLeft;
    [pwBgView addSubview:pwLb];
    
    self.pwdTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _pwdTextField.placeholder = @"请输入密码";
    _pwdTextField.secureTextEntry = YES;
    [pwBgView addSubview:_pwdTextField];
    [_pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pwdLb.mas_right).offset(10);
        make.top.equalTo(pwBgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(195, 50));
    }];
    
    self.registerBtn = [ToolManager defaultMutableColorButtonWithFrame:CGRectMake((App_Frame_Width-300)/2, 280, 300, 50) title:@"注册" isCycle:YES];
    _registerBtn.tag = 1;
    [_registerBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_registerBtn];
    
}

- (void)clickedBtn:(UIButton *)btn {
    if (_phoneTextField.text.length == 0 || _phoneTextField.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确格式的手机号码"];
        return;
    }
    if (btn.tag == 1) {
        //注册或者找回密码
        if (_codeTextField.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
            return;
        }
        
        if (_pwdTextField.text.length < 6 || _pwdTextField.text.length > 16) {
            [SVProgressHUD showInfoWithStatus:@"请输入6-16位的密码"];
            return;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectLoginRegisterViewWithBtn:)]) {
        [_delegate didSelectLoginRegisterViewWithBtn:btn];
    }
}

@end
