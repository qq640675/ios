//
//  DynamicListTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2018/12/27.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "DynamicListTableViewCell.h"

@implementation DynamicListTableViewCell

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
    UIButton *iconBtn = [UIManager initWithButton:CGRectMake(5, 15, 40, 40) text:nil font:12.0f textColor:[UIColor whiteColor] normalImg:nil highImg:nil selectedImg:nil];
    [iconBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    iconBtn.tag = 107;
    [self.contentView addSubview:iconBtn];
    
    [self.contentView addSubview:self.nickNameLb];
    [_nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
        make.top.equalTo(self.iconImageView.mas_top).offset(2);
        make.height.offset(15);
    }];
    
    self.ageBgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    _ageBgImageView.backgroundColor = XZRGB(0xfff1f5);
    _ageBgImageView.backgroundColor = UIColor.clearColor;
    _ageBgImageView.clipsToBounds = YES;
    _ageBgImageView.layer.cornerRadius = 8.0f;
    [self.contentView addSubview:_ageBgImageView];
    [_ageBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLb.mas_right).offset(5);
        make.top.equalTo(self.nickNameLb.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(35, 16));
    }];
    
    
    [self.ageBgImageView addSubview:self.sexImageView];
    [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(1);
        make.centerY.mas_equalTo(self.ageBgImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [self.ageBgImageView addSubview:self.ageLb];
    [_ageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexImageView.mas_right).offset(2);
        make.right.mas_equalTo(0);
        make.height.offset(16);
    }];
    
    [self.contentView addSubview:self.chatBtn];
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(App_Frame_Width-50);
        make.centerY.mas_equalTo(self.nickNameLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 38));
    }];
    
    [self.contentView addSubview:self.timeLb];
    [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
        make.top.equalTo(self.nickNameLb.mas_bottom).offset(5);
        make.height.offset(12);
    }];
    
    [self.contentView addSubview:self.contentLb];
    [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(50);
        make.top.equalTo(self.timeLb.mas_bottom).offset(10);
        make.width.offset(App_Frame_Width-100);
    }];
    
    [self.contentView addSubview:self.openBtn];
    [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(45);
        make.top.equalTo(self.contentLb.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [self.contentView addSubview:self.photoContainerView];
    [_photoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(50);
        make.top.equalTo(self.contentLb.mas_bottom).offset(10);
        make.width.offset(App_Frame_Width-100);
        
    }];
    
    [self.contentView addSubview:self.addressLb];
    [_addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(50);
        make.top.equalTo(self.photoContainerView.mas_bottom).offset(10);
        make.height.offset(15);
    }];
    
    [self.contentView addSubview:self.loveBtn];
    CGFloat width = (App_Frame_Width-100)/3;
    [_loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(30);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(width, 20));
    }];
    
    [self.contentView addSubview:self.commentBtn];
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loveBtn.mas_right).offset(0);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(width, 20));
    }];
    
    [self.contentView addSubview:self.moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentBtn.mas_right).offset(0);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(width, 20));
    }];
    
    [self.contentView addSubview:self.followBtn];
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(App_Frame_Width-54);
        make.bottom.equalTo(self.contentView).offset(-22);
        make.size.mas_equalTo(CGSizeMake(45, 20));
    }];
    
    [self.contentView addSubview:self.deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(App_Frame_Width-50);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(44, 24));
    }];
}

- (void)setData:(DynamicListModel *)dynamicHandle {
    [self initWithData:dynamicHandle];
}

- (void)initWithData:(SLBaseListModel *)listModel {
    DynamicListModel *model = (DynamicListModel *)listModel;
    self.dynamicListModel = model;
    
    _openBtn.hidden = YES;
    _addressLb.hidden = YES;
    _chatBtn.hidden = NO;
    
    if (model.t_id == [YLUserDefault userDefault].t_id) {
        _chatBtn.hidden = YES;
    }
    
    _openBtn.selected = model.isOpen;
    if (model.isOpen) {
        _contentLb.numberOfLines = 0;
    } else {
        _contentLb.numberOfLines = 5;
    }
    _contentLb.text = model.t_content;
    _nickNameLb.text= model.t_nickName;
    _addressLb.text = model.t_address;
    _timeLb.text = [SLHelper updateTimeForRow:model.t_create_time];
    if (model.t_age == 0) {
        _ageLb.text = @"18";
    } else {
        _ageLb.text = [NSString stringWithFormat:@"%ld",(long)model.t_age];
    }
    
    if (model.t_sex == 1) {
        _sexImageView.image = [UIImage imageNamed:@"dynamic_sex_boy"];
//        _ageBgImageView.backgroundColor = XZRGB(0xcaf3fd);
        _ageBgImageView.backgroundColor = UIColor.clearColor;
        _ageLb.textColor = XZRGB(0x7cdff9);
    } else {
        _sexImageView.image = [UIImage imageNamed:@"dynamic_sex_girl"];
//        _ageBgImageView.backgroundColor = XZRGB(0xfff1f5);
        _ageBgImageView.backgroundColor = UIColor.clearColor;
        _ageLb.textColor = XZRGB(0xfda5bc);
    }
    
    NSString *praise = [NSString stringWithFormat:@"%ld",(long)model.t_praiseCount];
    NSString *comment = [NSString stringWithFormat:@"%ld",(long)model.t_commentCount];
    [_loveBtn setTitle:praise forState:UIControlStateNormal];
    [_commentBtn setTitle:comment forState:UIControlStateNormal];
    _loveBtn.selected = model.isPraise;
    if (model.isFollow) {
        [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];

    } else {
        [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    if (model.isPraise) {
        _loveBtn.selected = YES;

    } else {
        _loveBtn.selected = NO;
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    
    [_photoContainerView setupFileModelArray:model.fileArrays isMine:model.isMine];
    
    //图片和内容的上间距
    CGFloat topSpacing = 10;
    
    //内容高度
    CGFloat fDescHeight = [SLHelper labelHeight:model.t_content font:PingFangSCFont(15.0f) labelWidth:App_Frame_Width-100]+3;
    if (fDescHeight > 93) {
        fDescHeight = fDescHeight+30;
        _openBtn.hidden = NO;
        topSpacing = 40;
    }
    
    if (model.isHaveAddress) {
        _addressLb.hidden = NO;
    }
    
    CGFloat height = [DynamicListTableViewCell photoContainerViewHeight:listModel];
    if (height < 0) {
        height = 0;
    }
    [self.photoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(50);
        make.top.equalTo(self.contentLb.mas_bottom).offset(topSpacing);
        make.width.offset(App_Frame_Width-100);
        make.height.offset(height);
    }];
    
    if (model.isMine) {
        _chatBtn.hidden = YES;
        _moreBtn.hidden = YES;
        _followBtn.hidden = YES;
        _ageLb.hidden = YES;
        _sexImageView.hidden   = YES;
        _ageBgImageView.hidden = YES;
        _deleteBtn.hidden = NO;
    } else {
        _chatBtn.hidden = NO;
        _moreBtn.hidden = NO;
        _followBtn.hidden = NO;
        _ageLb.hidden = NO;
        _sexImageView.hidden   = NO;
        _ageBgImageView.hidden = NO;
        _deleteBtn.hidden = YES;
    }
    
    if (model.isAnchorDetail) {
        _chatBtn.hidden = YES;
        _ageLb.hidden = YES;
        _sexImageView.hidden = YES;
        _followBtn.hidden = YES;
        _ageBgImageView.hidden = YES;
    }
    
    if (model.t_sex == [YLUserDefault userDefault].t_sex) {
        _chatBtn.hidden = YES;
    }
}

- (void)clickedBtn:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicListTableViewCellWithBtn: curActionModel:)]) {
        [_delegate didSelectDynamicListTableViewCellWithBtn:btn.tag curActionModel:_dynamicListModel];
    }
}

- (void)lookPrivateFile:(DynamicFileModel *)model {
    if (_delegate && [_delegate respondsToSelector:@selector(lookPrivateFile:)]) {
        [_delegate lookPrivateFile:model];
    }
}

- (void)updateVip {
    if (_delegate && [_delegate respondsToSelector:@selector(updateVip)]) {
        [_delegate updateVip];
    }
}

- (void)playVideo {
    if (_delegate && [_delegate respondsToSelector:@selector(playVideo:)]) {
        [_delegate playVideo:_dynamicListModel];
    }
}

+ (CGFloat)photoContainerViewHeight:(SLBaseListModel *)listModel {
    DynamicListModel *model = (DynamicListModel *)listModel;
    if ([model.fileArrays count] == 0) {
        return -10;
    } else if ([model.fileArrays count] == 1) {
        return 240;
    } else if ([model.fileArrays count] == 2) {
        return 135;
    } else {
        //3张或者以上
        CGFloat width = (App_Frame_Width-106)/3+3;
        NSUInteger count = model.fileArrays.count/3;
        if (model.fileArrays.count%3 != 0) {
            count++;
        }
        return width*count;
    }
    return 0;
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    CGFloat fCellHeight = 0;
    DynamicListModel *model = (DynamicListModel *)listModel;
    
    //内容高度
    CGFloat fDescHeight = [SLHelper labelHeight:model.t_content font:PingFangSCFont(15.0f) labelWidth:App_Frame_Width-100]+3;
    if (fDescHeight > 93) {
        if (model.isOpen) {
            fDescHeight = fDescHeight+30;
        } else {
            fDescHeight = 90+30;
        }
    }
    CGFloat custHeight = 135;
    if (model.isHaveAddress) {
        custHeight = 150;
    }
    fCellHeight = fDescHeight + custHeight + [DynamicListTableViewCell photoContainerViewHeight:listModel];
    return fCellHeight;

}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 40, 40)];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 20;
    }
    return _iconImageView;
}

- (UIImageView *)sexImageView {
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _sexImageView.image = [UIImage imageNamed:@"dynamic_chat_girl"];
    }
    return _sexImageView;
}

- (UILabel *)nickNameLb {
    if (!_nickNameLb) {
        _nickNameLb = [UIManager initWithLabel:CGRectZero text:@"用户昵称" font:15.0f textColor:XZRGB(0x353553)];
        _nickNameLb.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLb;
}

- (UILabel *)ageLb {
    if (!_ageLb) {
        _ageLb = [UIManager initWithLabel:CGRectZero text:@"24" font:12.0f textColor:XZRGB(0xfda5bc)];
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

- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb = [UIManager initWithLabel:CGRectZero text:@"重庆市" font:12.0f textColor:XZRGB(0x868686)];
        _addressLb.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLb;
}

- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [UIManager initWithLabel:CGRectZero text:@"这个是动态内容,这个是动态内容,这个是动态内容,这个是动态内容,这个是动态内容,这个是动态内容." font:15.0 textColor:XZRGB(0x333333)];
        _contentLb.numberOfLines = 5;
        _contentLb.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLb;
}



- (UIButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = [UIManager initWithButton:CGRectZero text:@"" font:1 textColor:nil normalImg:@"dynamic_chat" highImg:nil selectedImg:nil];
        [_chatBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        _chatBtn.tag = 100;
    }
    return _chatBtn;
}

- (UIButton *)loveBtn {
    if (!_loveBtn) {
        _loveBtn = [UIManager initWithButton:CGRectZero text:@"100" font:12.0f textColor:XZRGB(0x353553) normalImg:@"Dynamic_list_love" highImg:nil selectedImg:@"Dynamic_list_loved"];
        _loveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [_loveBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        _loveBtn.tag = 102;
    }
    return _loveBtn;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIManager initWithButton:CGRectZero text:@"100" font:12.0f textColor:XZRGB(0x353553) normalImg:@"Dynamic_list_comment" highImg:nil selectedImg:@"Dynamic_list_comment_red"];
        _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [_commentBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.tag = 103;
    }
    return _commentBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIManager initWithButton:CGRectZero text:nil font:12.0f textColor:XZRGB(0x353553) normalImg:@"Dynamic_list_more" highImg:nil selectedImg:nil];
        [_moreBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.tag = 104;
    }
    return _moreBtn;
}

- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [UIManager initWithButton:CGRectZero text:@"关注" font:11.0f textColor:XZRGB(0x3f3b48) normalImg:nil highImg:nil selectedImg:nil];
        _followBtn.clipsToBounds = YES;
        _followBtn.layer.cornerRadius = 10.0f;
        _followBtn.layer.borderWidth = 1;
        _followBtn.layer.borderColor = XZRGB(0x3f3b48).CGColor;
        [_followBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        _followBtn.tag = 105;
    }
    return _followBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIManager initWithButton:CGRectZero text:@"删除" font:13.0f textColor:XZRGB(0x868686) normalImg:nil highImg:nil selectedImg:nil];
        [_deleteBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.tag = 106;
    }
    return _deleteBtn;
}

- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [UIManager initWithButton:CGRectZero text:@"全文" font:14.0f textColor:[UIColor blueColor] normalImg:nil highImg:nil selectedImg:nil];
        [_openBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_openBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        _openBtn.tag = 101;
    }
    return _openBtn;
}

- (SLPhotoContainerView *)photoContainerView {
    if (!_photoContainerView) {
        _photoContainerView = [[SLPhotoContainerView alloc] initWithFrame:CGRectZero];
        _photoContainerView.delegate = self;
    }
    return _photoContainerView;
}

@end
