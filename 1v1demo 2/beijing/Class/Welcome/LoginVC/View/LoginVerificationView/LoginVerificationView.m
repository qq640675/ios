//
//  LoginVerificationView.m
//  beijing
//
//  Created by yiliaogao on 2019/1/22.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LoginVerificationView.h"

@implementation LoginVerificationView

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
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 330, 315)];
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 5;
    centerView.layer.masksToBounds = YES;
    
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-100);
        make.size.mas_equalTo(CGSizeMake(330, 315));
    }];
    
    UILabel *titleLb = [UIManager initWithLabel:CGRectMake(0, 0, 330, 44) text:@"安全验证" font:15.0f textColor:[UIColor whiteColor]];
    titleLb.backgroundColor = XZRGB(0x3f3b48);
    [centerView addSubview:titleLb];
    
    UIButton *closeBtn = [UIManager initWithButton:CGRectMake(286, 0, 44, 44) text:nil font:0.0f textColor:[UIColor clearColor] normalImg:@"newshare_cancel" highImg:nil selectedImg:nil];
    [closeBtn addTarget:self action:@selector(clickedBgView) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:closeBtn];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(40, 74, centerView.width-80, 40)];
    _textField.clipsToBounds = YES;
    _textField.layer.cornerRadius = 20;
    _textField.textColor = XZRGB(0x3f3b48);
    _textField.font = PingFangSCFont(15.0f);
    _textField.backgroundColor = XZRGB(0xeaeaea);
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.keyboardType  = UIKeyboardTypeNumberPad;
    _textField.placeholder = @"请输入下列字符";
    [centerView addSubview:_textField];
    
    self.codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 127, 150, 75)];
    _codeImageView.contentMode = UIViewContentModeCenter;
    [centerView addSubview:_codeImageView];
    
    UIButton  *changeBtn = [UIManager initWithButton:CGRectMake(90, 200, 150, 40) text:@"看不清？换一张" font:12.0f textColor:XZRGB(0x3f3b48) normalImg:nil highImg:nil selectedImg:nil];
    changeBtn.tag = 1;
    [changeBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:changeBtn];
    
    UIButton *okBtn = [UIManager initWithButton:CGRectMake(40, 250, centerView.width-80, 45) text:@"确定" font:15.0f textColor:[UIColor whiteColor] normalImg:nil highImg:nil selectedImg:nil];
    okBtn.clipsToBounds = YES;
    okBtn.layer.cornerRadius = 5;
    okBtn.tag = 2;
    [okBtn setBackgroundColor:XZRGB(0xAE4FFD)];
    [okBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:okBtn];
}

- (void)clickedBgView {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectLoginVerificationViewWithBgView
                                                             )]) {
        [_delegate didSelectLoginVerificationViewWithBgView];
    }
}

- (void)clickedBtn:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectLoginVerificationViewWithBtn:)]) {
        if (btn.tag == 1) {
            //换一张
            [_delegate didSelectLoginVerificationViewWithBtn:nil];
        } else {
            if (_textField.text.length == 0) {
                [SVProgressHUD showInfoWithStatus:@"请输入图片中的字符"];
                return;
            }
            [_delegate didSelectLoginVerificationViewWithBtn:_textField.text];
        }
    }
}

@end
