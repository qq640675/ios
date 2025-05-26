//
//  DynamicMineSendTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/1/23.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicMineSendTableViewCell.h"

@implementation DynamicMineSendTableViewCell

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
    
    UIButton *sendBtn = [UIManager initWithButton:CGRectZero text:nil font:0.0 textColor:[UIColor clearColor] normalImg:@"Dynamic_sendmine" highImg:nil selectedImg:nil];
    [sendBtn addTarget:self action:@selector(clickedSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sendBtn];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(110, 44));
    }];
}

- (void)clickedSendBtn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicMineSendTableViewCellWithSendBtn)]) {
        [_delegate didSelectDynamicMineSendTableViewCellWithSendBtn];
    }
}



@end
