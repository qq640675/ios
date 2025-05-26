//
//  DynamicDetailContentTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicDetailContentTableViewCell.h"

@implementation DynamicDetailContentTableViewCell

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
    [self.contentView addSubview:self.contentLb];
    [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(18);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = XZRGB(0xe1e1e1);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(App_Frame_Width, 10));
    }];
}

- (void)initWithData:(SLBaseListModel *)listModel {
    DynamicDetailContentModel *model = (DynamicDetailContentModel *)listModel;
    _contentLb.text = model.content;
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    DynamicDetailContentModel *model = (DynamicDetailContentModel *)listModel;
    CGFloat height = [SLHelper labelHeight:model.content font:PingFangSCFont(14.0f) labelWidth:App_Frame_Width-30]+46;
    if (model.content.length == 0) {
        height = 0.0;
    }
    return height;
}

- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [UIManager initWithLabel:CGRectZero text:@"" font:14.0 textColor:XZRGB(0x333333)];
        _contentLb.numberOfLines = 0;
        _contentLb.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLb;
}

@end
