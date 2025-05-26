//
//  MessageListTableViewCell.m
//  Qiaqia
//
//  Created by yiliaogao on 2019/6/13.
//  Copyright © 2019 yiliaogaoke. All rights reserved.
//

#import "MessageListTableViewCell.h"
#import "SLDateHelper.h"

@implementation MessageListTableViewCell

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
        self.selectionStyle  = UITableViewCellSelectionStyleGray;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 25.0f;
    [self.contentView addSubview:_iconImageView];
    
    self.nickNameLb = [UIManager initWithLabel:CGRectZero text:@"昵称" font:14.0f textColor:[UIColor blackColor]];
    [self.contentView addSubview:_nickNameLb];
    [_nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.iconImageView.mas_top).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    self.descLb = [UIManager initWithLabel:CGRectZero text:@"[视频通话] 30:25" font:14.0f textColor:XZRGB(0x868686)];
    _descLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_descLb];
    [_descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-35);
        make.bottom.equalTo(self.iconImageView.mas_bottom).offset(-4);
        make.height.mas_equalTo(20);
    }];
    
    self.timeLb = [UIManager initWithLabel:CGRectZero text:@"11:11" font:12.0f textColor:XZRGB(0x868686)];
    [self.contentView addSubview:_timeLb];
    [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickNameLb.mas_centerY);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    self.numberLb = [UIManager initWithLabel:CGRectZero text:@"0" font:10.0f textColor:[UIColor whiteColor]];
    _numberLb.backgroundColor = XZRGB(0xfe1947);
    _numberLb.clipsToBounds = YES;
    _numberLb.layer.cornerRadius = 10;
    _numberLb.hidden = YES;
    [self.contentView addSubview:_numberLb];
    [_numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.descLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
}

- (void)initWithData:(SLBaseListModel *)listModel {
    MessageListModel *model = (MessageListModel *)listModel;
    if (model.isTop) {
        self.contentView.backgroundColor = XZRGB(0xebebeb);
    } else {
        self.contentView.backgroundColor = UIColor.whiteColor;
    }
    if (model.isTextMessage) {
        //文字
        _descLb.textColor = XZRGB(0x868686);
        _nickNameLb.text = model.dataModel.nickName;
        
        
        _descLb.text = model.dataModel.msgText;
        _timeLb.text = [SLDateHelper getMessageTimeWithDate:model.dataModel.timestamp];
        
        _numberLb.hidden = YES;
        if (model.dataModel.unReadMsgCount > 0) {
            _numberLb.hidden = NO;
            _numberLb.text = [NSString stringWithFormat:@"%ld",(long)model.dataModel.unReadMsgCount];
        }
        
        if (model.isGroup == 0) {
            [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.dataModel.handImg] placeholderImage:IChatUImage(@"default")];
        } else {
            if (model.dataModel.handImg.length > 0) {
                [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.dataModel.handImg] placeholderImage:IChatUImage(@"message_top_group")];
            } else {
                _iconImageView.image = [UIImage imageNamed:@"message_top_group"];
            }
        }
    }
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    return 80.0f;
}

@end
