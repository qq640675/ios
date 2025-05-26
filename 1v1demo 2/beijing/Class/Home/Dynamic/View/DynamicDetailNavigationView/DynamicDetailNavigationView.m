//
//  DynamicDetailNavigationView.m
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicDetailNavigationView.h"
#import "DefineConstants.h"

@implementation DynamicDetailNavigationView

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
    UIButton *backBtn = [UIManager initWithButton:CGRectZero text:nil font:0.0f textColor:KBLACKCOLOR normalImg:@"Dynamic_detail_back" highImg:nil selectedImg:nil];
    [backBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 1;
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-2);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self addSubview:self.iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(55);
        make.bottom.equalTo(self).offset(-2);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self addSubview:self.nickNameLb];
    [_nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
        make.top.equalTo(self.iconImageView.mas_top).offset(2);
        make.height.offset(15);
    }];
    
    [self addSubview:self.sexImageView];
    [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLb.mas_right).offset(5);
        make.top.equalTo(self.nickNameLb.mas_top).offset(0);
    }];
    
    [self addSubview:self.ageLb];
    [_ageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexImageView.mas_right).offset(5);
        make.top.equalTo(self.sexImageView.mas_top).offset(0);
        make.height.offset(15);
    }];
    
    [self addSubview:self.chatBtn];
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(App_Frame_Width-60);
        make.top.equalTo(self.iconImageView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(55, 25));
    }];
    
    [self addSubview:self.timeLb];
    [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
        make.top.equalTo(self.nickNameLb.mas_bottom).offset(8);
        make.height.offset(12);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = XZRGB(0x868686);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(App_Frame_Width, .5));
    }];
}

- (void)setDynamicListModel:(DynamicListModel *)dynamicListModel {
    _dynamicListModel = dynamicListModel;
    _nickNameLb.text= dynamicListModel.t_nickName;
    _timeLb.text = [SLHelper updateTimeForRow:dynamicListModel.t_create_time];
    if (dynamicListModel.t_age == 0) {
        _ageLb.text = @"18岁";
    } else {
        _ageLb.text = [NSString stringWithFormat:@"%ld岁",(long)dynamicListModel.t_age];
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:dynamicListModel.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
}

- (void)clickedBtn:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicDetailNavigationViewWithBtn:)]) {
        [_delegate didSelectDynamicDetailNavigationViewWithBtn:btn.tag];
    }
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.backgroundColor = [UIColor redColor];
    }
    return _iconImageView;
}

- (UIImageView *)sexImageView {
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _sexImageView.image = [UIImage imageNamed:@"Dynamic_list_nv"];
    }
    return _sexImageView;
}

- (UILabel *)nickNameLb {
    if (!_nickNameLb) {
        _nickNameLb = [UIManager initWithLabel:CGRectZero text:@"用户昵称" font:15.0f textColor:KOFFLINECOLOR];
        _nickNameLb.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLb;
}

- (UILabel *)ageLb {
    if (!_ageLb) {
        _ageLb = [UIManager initWithLabel:CGRectZero text:@"24岁" font:15.0f textColor:XZRGB(0xAE4FFD)];
        _ageLb.textAlignment = NSTextAlignmentLeft;
    }
    return _ageLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UIManager initWithLabel:CGRectZero text:@"1天前" font:12.0f textColor:XZRGB(0x868686)];
        _timeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLb;
}

- (UIButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = [UIManager initWithButton:CGRectZero text:nil font:0.0f textColor:KWHITECOLOR normalImg:@"Dynamic_list_chat" highImg:nil selectedImg:nil];
        [_chatBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        _chatBtn.tag = 2;
    }
    return _chatBtn;
}
@end
