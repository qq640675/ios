//
//  LoginMenuView.m
//  beijing
//
//  Created by yiliaogao on 2019/3/12.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LoginMenuView.h"

@implementation LoginMenuView

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
    
    self.backgroundColor = [UIColor whiteColor];
    NSArray *titles = @[@"密码登录",@"验证码登录"];
    for (int i = 0; i < [titles count]; i ++) {
        CGFloat width = self.width/2;
        UIButton *btn = [UIManager initWithButton:CGRectMake(width*i, 0, width, self.height) text:titles[i] font:15.0f textColor:[UIColor blackColor] normalImg:nil highImg:nil selectedImg:nil];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (i == 1) {
            btn.selected = YES;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
            self.selectedBtn = btn;
            self.selectedView = [[UIView alloc] initWithFrame:CGRectZero];
            _selectedView.backgroundColor = XZRGB(0xAE4FFD);
            _selectedView.clipsToBounds = YES;
            _selectedView.layer.cornerRadius = 2.0f;
            [self addSubview:_selectedView];
            [_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(self.height-4);
                make.centerX.equalTo(self.selectedBtn.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(20, 4));
            }];
            
        }
    }
}

- (void)clickedBtn:(UIButton *)btn {
    [self endEditing:YES];
    if (btn.tag != _selectedBtn.tag) {
        [UIView animateWithDuration:.2 animations:^{
            self.selectedBtn.selected = NO;
            self.selectedBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            btn.selected = YES;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
            self.selectedBtn = btn;
            self.selectedView.x = btn.center.x-10;
        }];
        
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectLoginMenuViewWithBtnTag:)]) {
            [_delegate didSelectLoginMenuViewWithBtnTag:btn.tag];
        }
    }
}


@end
