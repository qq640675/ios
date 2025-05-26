//
//  InvitationListTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/3/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "InvitationListTableViewCell.h"
#import "anchorAddGuildHandle.h"

@implementation InvitationListTableViewCell

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
    self.numberLb = [UIManager initWithLabel:CGRectMake(10, 30, 20, 20) text:@"1" font:15.0f textColor:XZRGB(0x353535)];
    _numberLb.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.contentView addSubview:_numberLb];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 15, 50, 50)];
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 25.0f;
    _iconImageView.backgroundColor = XZRGB(0xebebeb);
    [self.contentView addSubview:_iconImageView];
    
    self.nikeNameLb = [UIManager initWithLabel:CGRectMake(100, 30, 100, 20) text:@"" font:14.0f textColor:XZRGB(0x868686)];
    _nikeNameLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nikeNameLb];
    
    self.moneyLb = [UIManager initWithLabel:CGRectMake(205, 30, App_Frame_Width-220, 20) text:@"" font:14.0f textColor:XZRGB(0x868686)];
    _moneyLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_moneyLb];
}

- (void)initWithData:(SLBaseListModel *)listModel {
    anchorAddGuildHandle *model = (anchorAddGuildHandle *)listModel;
    
    _numberLb.text = [NSString stringWithFormat:@"%ld",(long)model.index];
    _nikeNameLb.text = [NSString stringWithFormat:@"%@",model.t_nickName];
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.t_handImg] placeholderImage:IChatUImage(@"default")];
    
    if (model.type == 1) {
        NSString *totalGold =  [NSString stringWithFormat:@"共奖励%d金币",model.totalGold];
        
        NSMutableAttributedString *profitDestri = [[NSMutableAttributedString alloc] initWithString:totalGold];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f], NSForegroundColorAttributeName:XZRGB(0x333333)};
    
        [profitDestri addAttributes:dic range:[totalGold rangeOfString:[NSString stringWithFormat:@"%d",model.totalGold]]];
        _moneyLb.attributedText = profitDestri;
    } else {
        
        NSInteger count = model.totalCount;
        if (model.type == 3) {
            count = model.userCount;
        }
        
        NSString *totalGold =  [NSString stringWithFormat:@"共邀请%ld人",(long)count];
        
        NSMutableAttributedString *profitDestri = [[NSMutableAttributedString alloc] initWithString:totalGold];
        
        NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f], NSForegroundColorAttributeName:XZRGB(0x333333)};
        
        [profitDestri addAttributes:dic range:[totalGold rangeOfString:[NSString stringWithFormat:@"%d",model.totalCount]]];
        _moneyLb.attributedText = profitDestri;
    }
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    return 80.0f;
}

@end
