//
//  DynamicAddressListTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicAddressListTableViewCell.h"
#import "DynamicAddressListModel.h"

@implementation DynamicAddressListTableViewCell

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
    [self.contentView addSubview:self.nameLb];
    [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.offset(20);
    }];
    
    [self.contentView addSubview:self.addressLb];
    [_addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.nameLb.mas_bottom).offset(0);
        make.height.offset(20);
    }];
    
    [self.contentView addSubview:self.tempImageView];
    [_tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-20);
    }];
}

- (void)initWithData:(SLBaseListModel *)listModel {
    DynamicAddressListModel *model = (DynamicAddressListModel *)listModel;
    
    _nameLb.text = model.name;
    _addressLb.text = model.address;
    _tempImageView.hidden = !model.isSelected;
    if (model.isCity || model.isNoLocation) {
        _addressLb.hidden = YES;
    } else {
        _addressLb.hidden = NO;
    }
    if (model.isNoLocation) {
        _nameLb.textColor = XZRGB(0x4d00fb);
    } else {
        _nameLb.textColor = [UIColor blackColor];
    }
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    DynamicAddressListModel *model = (DynamicAddressListModel *)listModel;
    if (model.isCity || model.isNoLocation) {
        return 52.0f;
    } else {
        return 72.0f;
    }
}

- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [UIManager initWithLabel:CGRectZero text:nil font:15.0f textColor:[UIColor blackColor]];
        _nameLb.font = [UIFont fontWithName:@"MicrosoftYaHei" size:15.0f];
        _nameLb.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLb;
}

- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb = [UIManager initWithLabel:CGRectZero text:nil font:15.0f textColor:XZRGB(0x868686)];
        _addressLb.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLb;
}

- (UIImageView *)tempImageView {
    if (!_tempImageView) {
        _tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dynamic_address_gou"]];
    }
    return _tempImageView;
}

@end
