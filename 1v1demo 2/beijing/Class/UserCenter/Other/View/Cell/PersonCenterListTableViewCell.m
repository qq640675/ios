//
//  PersonCenterListTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/3/1.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "PersonCenterListTableViewCell.h"

@implementation PersonCenterListTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.iconImageBtn = [UIManager initWithButton:CGRectMake(5, 0, 55, 55) text:nil font:12.0f textColor:[UIColor whiteColor] normalImg:nil highImg:nil selectedImg:nil];
    _iconImageBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_iconImageBtn];
    
    self.titleLb = [UIManager initWithLabel:CGRectMake(58, 0, 200, 55) text:nil font:15.0f textColor:XZRGB(0x333333)];
    _titleLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLb];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 54, App_Frame_Width-15, 1)];
    _lineView.backgroundColor = XZRGB(0xebebeb);
    [self.contentView addSubview:_lineView];
    
    self.nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-25, 20, 8, 14)];
    _nextImageView.image = IChatUImage(@"PersonCenter_next");
    [self.contentView addSubview:_nextImageView];
    
    self.switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(App_Frame_Width-65, 8, 50, 40)];
    _switchBtn.onTintColor = XZRGB(0x0bceb0);
    _switchBtn.tag = 100;
    [self.contentView addSubview:self.switchBtn];
}

- (void)initWithData:(SLBaseListModel *)listModel {
    PersonCenterListModel *model = (PersonCenterListModel *)listModel;
    _titleLb.text = model.title;
    if (model.iconName.length == 0) {
        _titleLb.x = 15;
    } else {
        _titleLb.x = 58;
        [_iconImageBtn setImage:IChatUImage(model.iconName) forState:UIControlStateNormal];
    }
    
    _switchBtn.hidden = !model.isSwitch;
    _nextImageView.hidden = model.isSwitch;
    _switchBtn.on = model.isSwitchSelected;
    if (model.isSwitch) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    return 55;
}

@end
