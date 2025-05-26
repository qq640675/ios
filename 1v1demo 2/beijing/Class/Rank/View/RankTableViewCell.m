//
//  RankTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/5/21.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "RankTableViewCell.h"
#import "BaseView.h"

@implementation RankTableViewCell
{
    UILabel *rankLabel;
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *idLabel;
    UIImageView *typeImageView;
    UILabel *coinLabel;
//    UIButton *moreBtn;
    
//    UILabel *awardLabel;  //奖励金额
//    UILabel *getStatusL;  //领奖状态
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}

- (void)setGuardRankData:(NSDictionary *)guardRankDic {
    coinLabel.frame = CGRectMake(App_Frame_Width-70, 10, 60, 54);
    nameLabel.frame = CGRectMake(105, 10, App_Frame_Width-200, 54);
    nameLabel.numberOfLines = 2;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", guardRankDic[@"t_handImg"]]]];
    nameLabel.text = [NSString stringWithFormat:@"%@", guardRankDic[@"t_nickName"]];
    coinLabel.text = [NSString stringWithFormat:@"%@个", guardRankDic[@"giftCount"]];
//    getStatusL.hidden = YES;
    idLabel.hidden = YES;
    typeImageView.hidden = YES;
}

#pragma mark - data
- (void)setRankType:(RankListType)rankType {
    _rankType = rankType;
    if (rankType == RankListTypeGoddess) {
//        moreBtn.hidden = YES;
        typeImageView.image = [UIImage imageNamed:@"rank_cell_fire"];
    } else {
//        moreBtn.hidden = YES;
        typeImageView.image = [UIImage imageNamed:@"rank_cell_diamond"];
    }
}

- (void)setRankButtonType:(YLRankBtnType)buttonType {
//    getStatusL.hidden = YES;
//    awardLabel.hidden = YES;
//    idLabel.y = 38;

//    if (buttonType == YLRankBtnTypeYesterday) {
//        NSDictionary *awardSetDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANKAWARDSETTING"];
//        if (awardSetDic) {
//            int glamour_day = [[NSString stringWithFormat:@"%@", awardSetDic[@"glamour_day"]] intValue];
//            int invite_day = [[NSString stringWithFormat:@"%@", awardSetDic[@"invite_day"]] intValue];
//            int wealth_day = [[NSString stringWithFormat:@"%@", awardSetDic[@"wealth_day"]] intValue];
//            int guard_day  = [[NSString stringWithFormat:@"%@", awardSetDic[@"guard_day"]] intValue];
//            if ((_rankType == RankListTypeGoddess && glamour_day) || (_rankType == RankListTypeInvited && invite_day) || (_rankType == RankListTypeConsume && wealth_day) || (_rankType == RankListTypeGuard && guard_day)) {
//                getStatusL.hidden = NO;
//                awardLabel.hidden = NO;
//                idLabel.y = 33;
//            }
//        }
//    } else if (buttonType == YLRankBtnTypeLastWeek || buttonType == YLRankBtnTypeLastMonth) {
//        getStatusL.hidden = NO;
//        awardLabel.hidden = NO;
//        idLabel.y = 33;
//    }
}

- (void)setRankHandle:(rankingHandle *)rankHandle {
    _rankHandle = rankHandle;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", rankHandle.t_handImg]]];
    nameLabel.text = rankHandle.t_nickName;
    idLabel.text = [NSString stringWithFormat:@"ID：%d", rankHandle.t_idcard];
    coinLabel.text = [NSString stringWithFormat:@"距离上名:%ld", (long)rankHandle.newGold];
    
//    awardLabel.text = [NSString stringWithFormat:@"奖励：%d金币", rankHandle.t_rank_gold];
//    if (rankHandle.t_is_receive) {
//        getStatusL.text = @"已领取";
//        getStatusL.textColor = XZRGB(0x999999);
//        getStatusL.backgroundColor = XZRGB(0xE8E7E7);
//    } else {
//        getStatusL.text = @"未领取";
//        getStatusL.textColor = UIColor.whiteColor;
//        getStatusL.backgroundColor = XZRGB(0xC5AFFF);
//    }
    
    if (_rankType == RankListTypeGoddess || _rankType == RankListTypeConsume || _rankType == RankListTypeGuard) {
        idLabel.hidden = NO;
        if (rankHandle.t_rank_switch) {
            idLabel.hidden = YES;
        } else {
            idLabel.hidden = NO;
        }
    } else {
        idLabel.hidden = YES;
    }
    if (_rankType == RankListTypeInvited && !rankHandle.t_rank_switch) {
        if (nameLabel.text.length > 1) {
            nameLabel.text = [NSString stringWithFormat:@"%@***", [nameLabel.text substringToIndex:1]];
        } else {
            nameLabel.text = [NSString stringWithFormat:@"%@***", nameLabel.text];
        }
    }
}

- (void)setRankNum:(NSInteger)rankNum {
    if (rankNum < 10) {
        rankLabel.text = [NSString stringWithFormat:@"0%ld", (long)rankNum];
    } else {
        rankLabel.text = [NSString stringWithFormat:@"%ld", (long)rankNum];
    }
}

#pragma mark - func
- (void)moreButtonClick {
    if (self.moreButtonClickBlock) {
        self.moreButtonClickBlock();
    }
}

#pragma mark - view
- (void)setSubViews {
    rankLabel = [UIManager initWithLabel:CGRectMake(0, 20, 45, 30) text:@"04" font:14 textColor:XZRGB(0x868686)];
    rankLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:rankLabel];
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 11, 48, 48)];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 24;
    [self.contentView addSubview:headImageView];
    
    nameLabel = [UIManager initWithLabel:CGRectMake(105, 13, 100, 25) text:@"昵称" font:15 textColor:XZRGB(0x333333)];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    
    idLabel = [UIManager initWithLabel:CGRectMake(105, 38, 100, 20) text:@"ID：00000" font:12 textColor:XZRGB(0x868686)];
    idLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:idLabel];
    
//    awardLabel = [UIManager initWithLabel:CGRectMake(105, 50, 180, 20) text:@"奖励：5000金币" font:12 textColor:XZRGB(0x868686)];
//    awardLabel.textAlignment = NSTextAlignmentLeft;
//    awardLabel.hidden = YES;
//    [self.contentView addSubview:awardLabel];
    
//    moreBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-45, 15, 40, 40) text:@"" font:1 textColor:nil normalImg:@"rank_cell_more" highImg:nil selectedImg:nil];
//    [moreBtn addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:moreBtn];
//    moreBtn.hidden = YES;
    
    coinLabel = [UIManager initWithLabel:CGRectZero text:@"0" font:12 textColor:XZRGB(0xfe2947)];
    coinLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.contentView addSubview:coinLabel];
    [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-10);
        make.width.mas_lessThanOrEqualTo(App_Frame_Width-100);
    }];
    
    typeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rank_cell_fire"]];
    typeImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:typeImageView];
    [typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self->coinLabel.mas_left);
        make.centerY.mas_equalTo(self->coinLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
//    getStatusL = [UIManager initWithLabel:CGRectZero text:@"未领取" font:11 textColor:UIColor.whiteColor];
//    getStatusL.backgroundColor = XZRGB(0xC5AFFF);
//    getStatusL.hidden = YES;
//    getStatusL.layer.masksToBounds = YES;
//    getStatusL.layer.cornerRadius = 10;
//    [self.contentView addSubview:getStatusL];
//    [getStatusL mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
//            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(15);
//            make.size.mas_equalTo(CGSizeMake(46, 20));
//    }];
    
}




@end
