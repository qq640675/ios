//
//  HelpCenterListTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/3/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "HelpCenterListTableViewCell.h"
#import "HelpCenterListModel.h"

@implementation HelpCenterListTableViewCell

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
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.titleLb];
    
    [self.contentView addSubview:self.arrowImageView];
    
    [self.contentView addSubview:self.descLb];
    [_descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(55);
        make.bottom.equalTo(self.contentView).offset(-30);
        make.width.offset(App_Frame_Width-80);
    }];
    _descLb.hidden = YES;
}

- (void)initWithData:(SLBaseListModel *)listModel {
    HelpCenterListModel *model = (HelpCenterListModel *)listModel;
    _titleLb.text = model.t_title;
    _descLb.text  = model.t_content;
    if (model.isOpen) {
        _descLb.hidden = NO;
        _arrowImageView.image = IChatUImage(@"PersenCenter_top");
    } else {
        _descLb.hidden = YES;
        _arrowImageView.image = IChatUImage(@"PersenCenter_below");
    }
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    HelpCenterListModel *model = (HelpCenterListModel *)listModel;
    if (model.isOpen) {
        CGFloat height = [SLHelper labelHeight:[NSString stringWithFormat:@"%@\n", model.t_content] font:PingFangSCFont(15.0f) labelWidth:App_Frame_Width-80];
        return height + 55 + 40;
    }
    return 55;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [UIManager initWithLabel:CGRectMake(15, 0, App_Frame_Width-80, 55) text:nil font:17.0f textColor:XZRGB(0x333333)];
        _titleLb.numberOfLines = 2;
        _titleLb.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLb;
}

- (UILabel *)descLb {
    if (!_descLb) {
        _descLb = [UIManager initWithLabel:CGRectZero text:nil font:15.0f textColor:XZRGB(0x868686)];
        _descLb.numberOfLines = 0;
        _descLb.textAlignment = NSTextAlignmentLeft;
    }
    return _descLb;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-30, 24, 14, 7)];
        _arrowImageView.image = IChatUImage(@"PersenCenter_below");
    }
    return _arrowImageView;
}

@end
