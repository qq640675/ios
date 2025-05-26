//
//  LoginPwdView.m
//  beijing
//
//  Created by yiliaogao on 2019/3/12.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LoginPwdView.h"

@implementation LoginPwdView

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
        make.top.equalTo(self).offset(0);
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
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(phoneBgView.mas_bottom).offset(18);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    UILabel *pwdLb = [UIManager initWithLabel:CGRectMake(15, 0, 65, 50) text:@"密   码:" font:17.0f textColor:XZRGB(0x333333)];
    pwdLb.textAlignment = NSTextAlignmentLeft;
    [pwdBgView addSubview:pwdLb];
    
    self.pwdTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _pwdTextField.placeholder = @"请输入密码";
    _pwdTextField.secureTextEntry = YES;
    [pwdBgView addSubview:_pwdTextField];
    [_pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pwdLb.mas_right).offset(10);
        make.top.equalTo(pwdBgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(195, 50));
    }];
    
    UIButton *pwdBtn = [UIManager initWithButton:CGRectZero text:@"忘记密码" font:15.0f textColor:XZRGB(0xAE4FFD) normalImg:nil highImg:nil selectedImg:nil];
    [pwdBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pwdBtn];
    [pwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdBgView.mas_bottom).offset(5);
        make.right.equalTo(pwdBgView.mas_right).offset(-25);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
}

- (void)clickedBtn:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectLoginPwdViewWithBtn:)]) {
        [_delegate didSelectLoginPwdViewWithBtn:btn.tag];
    }
}

@end
