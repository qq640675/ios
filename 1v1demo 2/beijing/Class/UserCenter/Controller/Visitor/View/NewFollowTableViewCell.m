//
//  NewFollowTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2019/6/27.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "NewFollowTableViewCell.h"
#import "BaseView.h"
#import "ToolManager.h"

@implementation NewFollowTableViewCell
{
    UIImageView *headImageView;
    UILabel     *nameLabel;
    UIImageView *sexImageView;
    UILabel     *ageLabel;
    UILabel     *timeLabel;
    UIButton *cancleFollowBtn;
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
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    headImageView.image = [UIImage imageNamed:@"default"];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 25;
    [self.contentView addSubview:headImageView];
    
    nameLabel = [UIManager initWithLabel:CGRectMake(75, 10, App_Frame_Width-180, 25) text:@"昵称" font:15 textColor:XZRGB(0x333333)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    
    sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 40, 15, 15)];
    sexImageView.image = [UIImage imageNamed:@"new_rank_sex_girl"];
    [self.contentView addSubview:sexImageView];
    
    ageLabel = [UIManager initWithLabel:CGRectMake(CGRectGetMaxX(sexImageView.frame)+5, 35, 40, 25) text:@"18岁" font:14 textColor:XZRGB(0xff7689)];
    ageLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:ageLabel];
    
    timeLabel = [UIManager initWithLabel:CGRectMake(CGRectGetMaxX(ageLabel.frame)+10, 35, App_Frame_Width-CGRectGetMaxX(ageLabel.frame)-110, 25) text:@"关注时间:2019-6-27" font:12 textColor:XZRGB(0x868686)];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeLabel];
    
    //65 24
    cancleFollowBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-80, 23, 65, 24) text:@"已关注" font:13 textColor:XZRGB(0x868686) normalImg:nil highImg:nil selectedImg:nil];
    cancleFollowBtn.layer.masksToBounds = YES;
    cancleFollowBtn.layer.cornerRadius = 12;
    cancleFollowBtn.layer.borderWidth = 1;
    cancleFollowBtn.layer.borderColor = XZRGB(0x868686).CGColor;
    [cancleFollowBtn addTarget:self action:@selector(cancleFollow) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancleFollowBtn];
}

#pragma mark - set date
- (void)setHandle:(attentionInfoHandle *)handle {
    timeLabel.hidden = YES;
    //昵称
    if (![NSString isNullOrEmpty:handle.t_nickName]) {
        nameLabel.text = handle.t_nickName;
    }else{
        nameLabel.text = [NSString stringWithFormat:@"%d",handle.t_id];
    }
    
    if (handle.t_age.length > 0 && ![handle.t_age containsString:@"null"]) {
        ageLabel.text = [NSString stringWithFormat:@"%@岁", handle.t_age];
    }
    
    if (handle.t_sex == 0) {
        sexImageView.image = [UIImage imageNamed:@"new_rank_sex_girl"];
        ageLabel.textColor = XZRGB(0xff7689);
    } else {
        sexImageView.image = [UIImage imageNamed:@"new_rank_sex_boy"];
        ageLabel.textColor = XZRGB(0x17e1ff);
    }
    //头像
    if (![NSString isNullOrEmpty:handle.t_handImg]) {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:handle.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    }else{
        headImageView.image = [UIImage imageNamed:@"default"];
    }
    timeLabel.text = [NSString stringWithFormat:@"关注时间:%@", [ToolManager getTimeFromTimestamp:handle.t_create_time formatStr:@"YYYY-MM-dd"]];
    if (handle.isFollow == 0) {
        [cancleFollowBtn setTitle:@"关注" forState:0];
        [cancleFollowBtn setTitleColor:XZRGB(0xAE4FFD) forState:0];
        cancleFollowBtn.layer.borderColor = XZRGB(0xAE4FFD).CGColor;
    } else {
        [cancleFollowBtn setTitleColor:XZRGB(0x868686) forState:0];
        cancleFollowBtn.layer.borderColor = XZRGB(0x868686).CGColor;
        if (handle.isCoverFollow == 1) {
            [cancleFollowBtn setTitle:@"互相关注" forState:0];
        } else {
            [cancleFollowBtn setTitle:@"已关注" forState:0];
        }
    }
}

- (void)setModel:(WatchedModel *)model {
    //昵称
    if (![NSString isNullOrEmpty:model.t_nickName]) {
        nameLabel.text = model.t_nickName;
    }else{
        nameLabel.text = [NSString stringWithFormat:@"%ld", (long)model.t_id];
    }
    
    if (model.t_age.length > 0 && ![model.t_age containsString:@"null"]) {
        ageLabel.text = [NSString stringWithFormat:@"%@岁", model.t_age];
    }
    
    if (model.t_sex == 0) {
        sexImageView.image = [UIImage imageNamed:@"new_rank_sex_girl"];
        ageLabel.textColor = XZRGB(0xff7689);
    } else {
        sexImageView.image = [UIImage imageNamed:@"new_rank_sex_boy"];
        ageLabel.textColor = XZRGB(0x17e1ff);
    }
    //头像
    if (![NSString isNullOrEmpty:model.t_handImg]) {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:model.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    }else{
        headImageView.image = [UIImage imageNamed:@"default"];
    }
    if (self.isFootPoint == YES) {
        timeLabel.text = [ToolManager getTimeFromTimestamp:model.t_create_time formatStr:@"YYYY-MM-dd"];
    } else {
        timeLabel.text = [ToolManager getTimeFromTimestamp:model.t_create_time formatStr:@"MM-dd HH:mm"];
    }
    
    if (self.isBlackUser == YES) {
        timeLabel.text = [NSString stringWithFormat:@"拉黑时间:%@", [ToolManager getTimeFromTimestamp:model.t_create_time formatStr:@"YYYY-MM-dd"]];
        [cancleFollowBtn setTitleColor:XZRGB(0x868686) forState:0];
        cancleFollowBtn.layer.borderColor = XZRGB(0x868686).CGColor;
        [cancleFollowBtn setTitle:@"取消黑名单" forState:0];
        cancleFollowBtn.frame = CGRectMake(App_Frame_Width-95, 23, 80, 24);
        return;
    }
    if (model.isFollow == 0) {
        [cancleFollowBtn setTitle:@"关注" forState:0];
        [cancleFollowBtn setTitleColor:XZRGB(0xAE4FFD) forState:0];
        cancleFollowBtn.layer.borderColor = XZRGB(0xAE4FFD).CGColor;
    } else {
        [cancleFollowBtn setTitleColor:XZRGB(0x868686) forState:0];
        cancleFollowBtn.layer.borderColor = XZRGB(0x868686).CGColor;
        if (model.isCoverFollow == 1) {
            [cancleFollowBtn setTitle:@"互相关注" forState:0];
        } else {
            [cancleFollowBtn setTitle:@"已关注" forState:0];
        }
    }
}

#pragma mark - func
- (void)cancleFollow {
    if (self.followButtonClick) {
        self.followButtonClick();
    }
}




@end
