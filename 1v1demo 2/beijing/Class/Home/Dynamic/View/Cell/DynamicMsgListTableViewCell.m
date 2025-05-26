//
//  DynamicMsgListTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/1/18.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicMsgListTableViewCell.h"
#import "DynamicMsgListModel.h"

@implementation DynamicMsgListTableViewCell

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
    
    [self.contentView addSubview:self.picImageView];
    [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(9);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.contentView addSubview:self.videoTempImageView];
    [_videoTempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picImageView.mas_left).offset(2);
        make.bottom.equalTo(self.picImageView.mas_bottom).offset(-2);
        make.size.mas_equalTo(CGSizeMake(20, 11));
    }];
    
    [self.contentView addSubview:self.nameLb];
    [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(7);
        make.top.equalTo(self.iconImageView.mas_top);
        make.height.offset(15);
    }];
    
    [self.contentView addSubview:self.commentContentLb];
    [_commentContentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(7);
        make.top.equalTo(self.nameLb.mas_bottom).offset(10);
        make.width.offset(App_Frame_Width-144);
    }];
    
    [self.contentView addSubview:self.timeLb];
    [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(7);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.offset(15);
    }];
    
    [self.contentView addSubview:self.contentLb];
    [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.commentContentLb.mas_right).offset(10);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)initWithData:(SLBaseListModel *)listModel {
    DynamicMsgListModel *model = (DynamicMsgListModel *)listModel;
    
    _picImageView.hidden = YES;
    _contentLb.hidden = YES;
    _videoTempImageView.hidden = YES;
    
    _nameLb.text = model.t_nickName;
    _commentContentLb.text = model.t_comment;
    _timeLb.text = [SLHelper updateTimeForRow:model.t_create_time];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.t_handImg] placeholderImage:IChatUImage(@"loading")];
    
    //动态类型: -1.文本动态 0.图片 1.视频动态
    if (model.dynamic_type == -1) {
        _contentLb.hidden = NO;
        _contentLb.text = model.dynamic_com;
    } else if (model.dynamic_type == 0) {
        _picImageView.hidden = NO;
        [_picImageView sd_setImageWithURL:[NSURL URLWithString:model.t_cover_img_url] placeholderImage:IChatUImage(@"loading")];
    } else {
        _picImageView.hidden = NO;
        _videoTempImageView.hidden = NO;
        [_picImageView sd_setImageWithURL:[NSURL URLWithString:model.t_cover_img_url] placeholderImage:IChatUImage(@"loading")];
    }
    
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    DynamicMsgListModel *model = (DynamicMsgListModel *)listModel;
    
    CGFloat height = 65+[SLHelper labelHeight:model.t_comment font:PingFangSCFont(13.0f) labelWidth:App_Frame_Width-144];
    return height;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 47, 47)];
        _iconImageView.layer.cornerRadius = 2;
    }
    return _iconImageView;
}

- (UIImageView *)picImageView {
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _picImageView;
}

- (UIImageView *)videoTempImageView {
    if (!_videoTempImageView) {
        _videoTempImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _videoTempImageView.image = [UIImage imageNamed:@"Dynamic_msg_video"];
    }
    return _videoTempImageView;
}

- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [UIManager initWithLabel:CGRectZero text:@"昵称" font:14.0f textColor:XZRGB(0xc15078)];
        _nameLb.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLb;
}

- (UILabel *)commentContentLb {
    if (!_commentContentLb) {
        _commentContentLb = [UIManager initWithLabel:CGRectZero text:@"内容" font:13.0f textColor:XZRGB(0x333333)];
        _commentContentLb.textAlignment = NSTextAlignmentLeft;
        _commentContentLb.numberOfLines = 0;
    }
    return _commentContentLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UIManager initWithLabel:CGRectZero text:@"刚刚" font:12.0f textColor:XZRGB(0x868686)];
        _timeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLb;
}

- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [UIManager initWithLabel:CGRectZero text:@"内容" font:13.0f textColor:XZRGB(0x333333)];
        _contentLb.textAlignment = NSTextAlignmentLeft;
        _contentLb.numberOfLines = 3;
    }
    return _contentLb;
}

@end
