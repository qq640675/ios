//
//  InvitationTudiListTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/3/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "InvitationTudiListTableViewCell.h"
#import "shareUserHandle.h"

@implementation InvitationTudiListTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.timeLb = [UIManager initWithLabel:CGRectMake(75, 40, 120, 20) text:@"1" font:12.0f textColor:XZRGB(0x868686)];
    _timeLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_timeLb];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 25.0f;
    _iconImageView.backgroundColor = XZRGB(0xebebeb);
    [self.contentView addSubview:_iconImageView];
    
    self.nikeNameLb = [UIManager initWithLabel:CGRectMake(75, 20, 100, 20) text:@"" font:14.0f textColor:XZRGB(0x353535)];
    _nikeNameLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nikeNameLb];
    
    self.moneyLb = [UIManager initWithLabel:CGRectMake(205, 10, App_Frame_Width-220, 20) text:@"" font:14.0f textColor:XZRGB(0x868686)];
    _moneyLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_moneyLb];
    
    self.allBuyGoldLb = [UIManager initWithLabel:CGRectMake(205, 30, App_Frame_Width-220, 20) text:@"" font:14.0f textColor:XZRGB(0x868686)];
    _allBuyGoldLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_allBuyGoldLb];
    
    
    self.goldLb = [UIManager initWithLabel:CGRectMake(205, 50, App_Frame_Width-220, 20) text:@"" font:14.0f textColor:XZRGB(0x868686)];
    _goldLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_goldLb];
    
}

- (void)initWithData:(SLBaseListModel *)listModel {
    shareUserHandle *model = (shareUserHandle *)listModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    _nikeNameLb.text = model.t_nickName;
    _timeLb.text = model.t_create_time;

    NSString *totalGold =  [NSString stringWithFormat:@"共贡献%@金币",model.spreadMoney];
    
    NSMutableAttributedString *profitDestri = [[NSMutableAttributedString alloc] initWithString:totalGold];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f], NSForegroundColorAttributeName:XZRGB(0x333333)};
    
    [profitDestri addAttributes:dic range:[totalGold rangeOfString:[NSString stringWithFormat:@"%@",model.spreadMoney]]];
    _moneyLb.attributedText = profitDestri;
    
    NSString *buyTotalGold =  [NSString stringWithFormat:@"共充值%@金币",model.totalStorageGold];
    
    NSMutableAttributedString *buyDestri = [[NSMutableAttributedString alloc] initWithString:buyTotalGold];
    
    [buyDestri addAttributes:dic range:[buyTotalGold rangeOfString:[NSString stringWithFormat:@"%@",model.totalStorageGold]]];
    _allBuyGoldLb.attributedText = buyDestri;
    
    
    NSString *gold =  [NSString stringWithFormat:@"剩余%@金币",model.balance];
    
    NSMutableAttributedString *goldDestri = [[NSMutableAttributedString alloc] initWithString:gold];
    
    [goldDestri addAttributes:dic range:[gold rangeOfString:[NSString stringWithFormat:@"%@",model.balance]]];
    _goldLb.attributedText = goldDestri;
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    return 80.0f;
}

@end
