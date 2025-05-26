//
//  MansionInviteListTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/7/13.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionInviteListTableViewCell.h"
#import "BaseView.h"

@implementation MansionInviteListTableViewCell
{
    UIImageView *headImageView;
    UILabel *nameLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 50, 50)];
    headImageView.image = [UIImage imageNamed:@"default"];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 25;
    [self.contentView addSubview:headImageView];
    
    nameLabel = [UIManager initWithLabel:CGRectMake(70, 5, App_Frame_Width-200, 27) text:@"" font:15 textColor:XZRGB(0x333333)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    
    UILabel *tipL = [UIManager initWithLabel:CGRectMake(70, 32, App_Frame_Width-200, 23) text:@"邀请你加入TA的府邸" font:14 textColor:XZRGB(0x333333)];
    tipL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:tipL];
    
    UIButton *sureBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-60, 16, 50, 28) text:@"接受" font:12 textColor:KDEFAULTCOLOR normalImg:nil highImg:nil selectedImg:nil];
    sureBtn.tag = 101;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 14;
    sureBtn.layer.borderWidth = 1;
    sureBtn.layer.borderColor = KDEFAULTCOLOR.CGColor;
    [sureBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sureBtn];
    
    UIButton *refuseBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-120, 16, 50, 28) text:@"拒绝" font:12 textColor:XZRGB(0x868686) normalImg:nil highImg:nil selectedImg:nil];
    refuseBtn.tag = 102;
    refuseBtn.layer.masksToBounds = YES;
    refuseBtn.layer.cornerRadius = 14;
    refuseBtn.layer.borderWidth = 1;
    refuseBtn.layer.borderColor = XZRGB(0x868686).CGColor;
    [refuseBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:refuseBtn];
}

- (void)buttonClick:(UIButton *)sender {
    if (self.inviteCellButtonClick) {
        self.inviteCellButtonClick(sender.tag-100);
    }
}

- (void)setInviteModel:(MansionInviteListModel *)inviteModel {
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", inviteModel.t_handImg]]];
    nameLabel.text = inviteModel.t_nickName;
}


@end
