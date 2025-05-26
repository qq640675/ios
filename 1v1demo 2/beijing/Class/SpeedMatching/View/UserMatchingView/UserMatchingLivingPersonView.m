//
//  UserMatchingLivingPersonView.m
//  beijing
//
//  Created by yiliaogao on 2019/2/21.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "UserMatchingLivingPersonView.h"

@implementation UserMatchingLivingPersonView

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
    
    [self addSubview:self.ageLb];
    
//    [self addSubview:self.occupationLb];
    
    [self addSubview:self.addressLb];
    
    [self addSubview:self.followBtn];
}

- (void)initWithData:(UserMatchingAnchorModel *)model {
    _nickNameLb.text = model.t_nickName;
    _ageLb.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.t_age];
//    _occupationLb.text = model.t_vocation;
    _addressLb.text = model.t_city;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    if (model.isFollow == 0) {
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

- (UILabel *)nickNameLb {
    if (!_nickNameLb) {
        _nickNameLb = [UIManager initWithLabel:CGRectMake(60, 10, 150, 20) text:@"" font:14.0f textColor:[UIColor whiteColor]];
        _nickNameLb.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLb;
}

- (UILabel *)ageLb {
    if (!_ageLb) {
        _ageLb = [UIManager initWithLabel:CGRectMake(60, 30, 30, 15) text:@"" font:10.0f textColor:[UIColor whiteColor]];
        _ageLb.backgroundColor = XZRGB(0x2cd4f2);
        _ageLb.layer.cornerRadius = 7;
        _ageLb.clipsToBounds = YES;
    }
    return _ageLb;
}

//- (UILabel *)occupationLb {
//    if (!_occupationLb) {
//        _occupationLb = [UIManager initWithLabel:CGRectMake(95, 30, 30, 15) text:@"" font:10.0f textColor:[UIColor whiteColor]];
//        _occupationLb.backgroundColor = XZRGB(0xffa0e1);
//        _occupationLb.layer.cornerRadius = 7;
//        _occupationLb.clipsToBounds = YES;
//    }
//    return _occupationLb;
//}

- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb = [UIManager initWithLabel:CGRectMake(95, 30, 100, 15) text:@"" font:12.0f textColor:[UIColor whiteColor]];
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
