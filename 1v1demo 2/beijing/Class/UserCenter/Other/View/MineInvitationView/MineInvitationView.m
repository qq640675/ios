//
//  MineInvitationView.m
//  beijing
//
//  Created by yiliaogao on 2019/1/14.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "MineInvitationView.h"

@implementation MineInvitationView

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedBgView)];
    [self addGestureRecognizer:tap];
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 330, 428)];
    centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(330, 428));
    }];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedCenterView)];
    [centerView addGestureRecognizer:tap1];
    
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 330, 428)];
    bgImageView.image = [UIImage imageNamed:@"Invitation_bg"];
    [centerView addSubview:bgImageView];
    
    UILabel *topLb = [UIManager initWithLabel:CGRectMake(15, 15, centerView.width-30, 45) text:@"我的邀请码" font:15.0f textColor:XZRGB(0x3f3b48)];
    topLb.clipsToBounds   = YES;
    topLb.layer.cornerRadius = 5;
    [centerView addSubview:topLb];
    
    
    self.codeLb = [UIManager initWithLabel:CGRectMake(15, 70, centerView.width-30, 40) text:@"10086" font:40 textColor:XZRGB(0xAE4FFD)];
    _codeLb.font = [UIFont boldSystemFontOfSize:52.0f];
    [centerView addSubview:_codeLb];
    
    UIButton *copBtn = [UIManager initWithButton:CGRectMake((centerView.width-87)/2, 130, 87, 41) text:@"复制" font:15.0f textColor:[UIColor whiteColor] normalBackGroudImg:@"Invitation_copy_bg" highBackGroudImg:nil selectedBackGroudImg:nil];
    copBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    [copBtn addTarget:self action:@selector(clickedCopyBtn) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:copBtn];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(40, 220, centerView.width-80, 60)];
    _textField.textColor = XZRGB(0x333333);
    _textField.font = [UIFont boldSystemFontOfSize:35.0f];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.keyboardType  = UIKeyboardTypeNumberPad;
    [centerView addSubview:_textField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(40, 280, centerView.width-80, 2)];
    lineView.backgroundColor = XZRGB(0xebebeb);
    [centerView addSubview:lineView];
    
    UILabel *tipLb = [UIManager initWithLabel:CGRectMake(40, 282, centerView.width-80, 40) text:@"请输入好友邀请码" font:15.0f textColor:XZRGB(0x868686)];
    [centerView addSubview:tipLb];
    
    UIButton *okBtn = [UIManager initWithButton:CGRectMake((centerView.width-160)/2, 340, 160, 44) text:@"确定" font:15.0f textColor:[UIColor whiteColor] normalImg:nil highImg:nil selectedImg:nil];
    okBtn.clipsToBounds = YES;
    okBtn.layer.cornerRadius = 22;
    [okBtn setBackgroundColor:XZRGB(0xAE4FFD)];
    [okBtn addTarget:self action:@selector(clickedSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:okBtn];
    
}

- (void)clickedCenterView {
    
}

- (void)clickedBgView {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectMineInvitationViewWithBgView)]) {
        [_delegate didSelectMineInvitationViewWithBgView];
    }
}

- (void)clickedCopyBtn {
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _codeLb.text;
    
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}

- (void)clickedSureBtn {
    if (_textField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入Ta人邀请码！"];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectMineInvitationViewWithSureBtn:)]) {
        [_delegate didSelectMineInvitationViewWithSureBtn:[_textField.text integerValue]];
    }
}

@end
