//
//  DynamicCommentListTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/1/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicCommentListTableViewCell.h"

@implementation DynamicCommentListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self.contentView addSubview:self.iconImageView];
    
    [self.contentView addSubview:self.nickNameLb];
    [_nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
        make.top.equalTo(self.iconImageView.mas_top).offset(0);
        make.height.offset(15);
    }];
    
    [self.contentView addSubview:self.sexImageView];
    [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLb.mas_right).offset(5);
        make.top.equalTo(self.nickNameLb.mas_top).offset(0);
    }];
    
    [self.contentView addSubview:self.contentLb];
    [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLb.mas_left).offset(0);
        make.top.equalTo(self.nickNameLb.mas_bottom).offset(12);
        make.width.offset(App_Frame_Width-100);
    }];
    
    [self.contentView addSubview:self.timeLb];
    [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLb.mas_left).offset(0);
        make.top.equalTo(self.contentLb.mas_bottom).offset(19);
        make.height.offset(15);
    }];
    
    [self.contentView addSubview:self.deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(App_Frame_Width-50);
        make.top.equalTo(self.contentLb.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

- (void)initWithData:(SLBaseListModel *)listModel {
    DynamicCommentListModel *model = (DynamicCommentListModel *)listModel;
    self.commentListModel = model;
    _deleteBtn.hidden = YES;
    if (model.comType == 1) {
        _deleteBtn.hidden = NO;
    }
    
    _sexImageView.image = [UIImage imageNamed:@"near_img_girl"];
    if (model.t_sex == 1) {
        _sexImageView.image = [UIImage imageNamed:@"near_img_boy"];
    }
    
    _nickNameLb.text = model.t_nickName;
    _timeLb.text = [SLHelper updateTimeForRow:model.t_create_time];
    _contentLb.text = model.t_comment;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    
}

- (void)clickedDeleteBtn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicCommentListTableViewCellWithDelete:)]) {
        [_delegate didSelectDynamicCommentListTableViewCellWithDelete:_commentListModel];
    }
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    DynamicCommentListModel *model = (DynamicCommentListModel *)listModel;
    CGFloat height = 103+[SLHelper labelHeight:model.t_comment font:PingFangSCFont(15.0f) labelWidth:App_Frame_Width-100];
    return height;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 20;
    }
    return _iconImageView;
}

- (UIImageView *)sexImageView {
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _sexImageView.image = [UIImage imageNamed:@"near_img_girl"];
    }
    return _sexImageView;
}

- (UILabel *)nickNameLb {
    if (!_nickNameLb) {
        _nickNameLb = [UIManager initWithLabel:CGRectZero text:@"用户昵称" font:14.0f textColor:XZRGB(0x868686)];
        _nickNameLb.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UIManager initWithLabel:CGRectZero text:@"1天前" font:12.0f textColor:XZRGB(0x868686)];
        _timeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLb;
}

- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [UIManager initWithLabel:CGRectZero text:@"这个是动态内容" font:15.0 textColor:XZRGB(0x333333)];
        _contentLb.textAlignment = NSTextAlignmentLeft;
        _contentLb.numberOfLines = 0;
    }
    return _contentLb;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIManager initWithButton:CGRectZero text:@"删除" font:12.0f textColor:XZRGB(0x868686) normalImg:nil highImg:nil selectedImg:nil];
        [_deleteBtn addTarget:self action:@selector(clickedDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}


@end
