//
//  AnchorMatchingLivingPersonView.m
//  beijing
//
//  Created by yiliaogao on 2019/2/21.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "AnchorMatchingLivingPersonView.h"

@implementation AnchorMatchingLivingPersonView

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
    [self addSubview:self.iconImageView];
    
    [self addSubview:self.nickNameLb];
    
//    [self addSubview:self.levelLb];
    
    [self addSubview:self.addressLb];
    
    [self addSubview:self.followBtn];
    
    [self addSubview:self.goldLb];
}

- (void)initWithData:(PersonalDataHandle *)handle {
    _nickNameLb.text = handle.t_nickName;
//    _levelLb.text    = [NSString stringWithFormat:@"LV%d",handle.goldLevel];
    _addressLb.text  = handle.t_city;
    _goldLb.text     = [NSString stringWithFormat:@"对方剩余金币：%ld",[handle.balance integerValue]];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:handle.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    
    if (handle.isFollow == 0) {
        [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
    } else {
        [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.borderWidth  = 1;
        _iconImageView.layer.borderColor  = [UIColor whiteColor].CGColor;
        _iconImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _iconImageView;
}

- (UILabel *)goldLb {
    if (!_goldLb) {
        _goldLb = [UIManager initWithLabel:CGRectMake(15, 60, 300, 20) text:@"对方剩余金币：0" font:14.0f textColor:[UIColor whiteColor]];
        _goldLb.textAlignment = NSTextAlignmentLeft;
    }
    return _goldLb;
}

- (UILabel *)nickNameLb {
    if (!_nickNameLb) {
        _nickNameLb = [UIManager initWithLabel:CGRectMake(60, 10, 150, 20) text:@"" font:14.0f textColor:[UIColor whiteColor]];
        _nickNameLb.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLb;
}

//- (UILabel *)levelLb {
//    if (!_levelLb) {
//        _levelLb = [UIManager initWithLabel:CGRectMake(60, 30, 30, 15) text:@"" font:10.0f textColor:[UIColor whiteColor]];
//        _levelLb.backgroundColor = XZRGB(0xAE4FFD);
//        _levelLb.layer.cornerRadius = 2.0f;
//        _levelLb.clipsToBounds = YES;
//
//    }
//    return _levelLb;
//}

- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb = [UIManager initWithLabel:CGRectMake(60, 30, 100, 15) text:@"" font:12.0f textColor:[UIColor whiteColor]];
        _addressLb.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLb;
}

- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [UIManager initWithButton:CGRectMake(20, 43, 30, 14) text:@"关注" font:8.0f textColor:[UIColor whiteColor] normalImg:nil highImg:nil selectedImg:nil];
        _followBtn.backgroundColor = XZRGB(0xAE4FFD);
        _followBtn.layer.cornerRadius = 7;
    }
    return _followBtn;
}

@end
