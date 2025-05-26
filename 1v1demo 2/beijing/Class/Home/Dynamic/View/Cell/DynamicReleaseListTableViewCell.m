//
//  DynamicReleaseListTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "DynamicReleaseListTableViewCell.h"

@implementation DynamicReleaseListTableViewCell

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
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.iconImageView];
}

- (void)initWithData:(SLBaseListModel *)listModel {
    self.releaseListModel = (DynamicReleaseListModel *)listModel;
    _titleLb.text = _releaseListModel.listTitle;
    
    if (_releaseListModel.isSelected) {
        _iconImageView.image = [UIImage imageNamed:_releaseListModel.listSelectedImageName];
        _titleLb.textColor = XZRGB(0xAE4FFD);
    } else {
        _iconImageView.image = [UIImage imageNamed:_releaseListModel.listImageName];
        _titleLb.textColor = XZRGB(0x868686);
    }
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    return 60;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [UIManager initWithLabel:CGRectMake(50, 5, App_Frame_Width-70, 50) text:nil font:15.0f textColor:XZRGB(0x868686)];
        _titleLb.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLb;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 21, 21)];
    }
    return _iconImageView;
}



@end
