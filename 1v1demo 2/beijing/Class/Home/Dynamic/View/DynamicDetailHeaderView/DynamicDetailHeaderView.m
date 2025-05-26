//
//  DynamicDetailHeaderView.m
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicDetailHeaderView.h"

@implementation DynamicDetailHeaderView

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
    
    [self addSubview:self.picView];
    
    CGFloat btnWidth = (self.width-100)/2;
    [self addSubview:self.loveBtn];
    [_loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(50);
        make.bottom.equalTo(self).offset(-1);
        make.size.mas_equalTo(CGSizeMake(btnWidth, 50));
    }];
    
    [self addSubview:self.commentBtn];
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loveBtn.mas_right).offset(0);
        make.bottom.equalTo(self).offset(-1);
        make.size.mas_equalTo(CGSizeMake(btnWidth, 50));
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = XZRGB(0xe1e1e1);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(App_Frame_Width, .5));
    }];
    
}

- (void)setListModel:(DynamicListModel *)listModel {
    _listModel = listModel;
    NSString *praise = [NSString stringWithFormat:@"%ld",(long)listModel.t_praiseCount];
    NSString *comment = [NSString stringWithFormat:@"%ld",(long)listModel.t_commentCount];
    [_loveBtn setTitle:praise forState:UIControlStateNormal];
    [_commentBtn setTitle:comment forState:UIControlStateNormal];
    _loveBtn.selected = listModel.isPraise;
    if ([listModel.fileArrays count] == 0) {
        UIView *view = [self viewWithTag:100];
        [view removeFromSuperview];
    }
    _picView.fileModelArray = listModel.fileArrays;
}

- (void)clickedBtn:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicDetailHeaderViewWithBtn:)]) {
        [_delegate didSelectDynamicDetailHeaderViewWithBtn:btn.tag];
    }
}

- (UIButton *)loveBtn {
    if (!_loveBtn) {
        _loveBtn = [UIManager initWithButton:CGRectZero text:@"100" font:12.0f textColor:KOFFLINECOLOR normalImg:@"Dynamic_list_love" highImg:nil selectedImg:@"Dynamic_list_loved"];
        _loveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [_loveBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        _loveBtn.tag = 1;
    }
    return _loveBtn;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIManager initWithButton:CGRectZero text:@"100" font:12.0f textColor:KOFFLINECOLOR normalImg:@"Dynamic_list_comment" highImg:nil selectedImg:@"Dynamic_list_comment_red"];
        _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [_commentBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.tag = 2;
    }
    return _commentBtn;
}

- (DynamicDetailPicView *)picView {
    if (!_picView) {
        _picView = [[DynamicDetailPicView alloc] initWithFrame:CGRectMake(16, 16, self.width-32, self.height-67)];
    }
    return _picView;
}

@end
