//
//  DynamicAddressNavigationView.m
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicAddressNavigationView.h"
#import "DefineConstants.h"

@implementation DynamicAddressNavigationView

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
    self.backgroundColor = XZRGB(0xedeced);
    
    UIButton *cancelBtn = [UIManager initWithButton:CGRectZero text:@"取消" font:15.0f textColor:KBLACKCOLOR normalImg:nil highImg:nil selectedImg:nil];
    cancelBtn.tag = 1;
    [cancelBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    
    UIButton *finishBtn = [UIManager initWithButton:CGRectZero text:@"完成" font:15.0f textColor:XZRGB(0xAE4FFD) normalImg:nil highImg:nil selectedImg:nil];
    finishBtn.tag = 2;
    [finishBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:finishBtn];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    
    UILabel *lb = [UIManager initWithLabel:CGRectZero text:@"我的位置" font:16.0f textColor:KBLACKCOLOR];
    lb.font = [UIFont fontWithName:@"MicrosoftYaHei" size:16.0f];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
    
}

- (void)clickedBtn:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicAddressNavigationViewWithBtn:)]) {
        [_delegate didSelectDynamicAddressNavigationViewWithBtn:btn.tag];
    }
}

@end
