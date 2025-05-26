//
//  MansionInviteTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionInviteTableViewCell.h"

@implementation MansionInviteTableViewCell
{
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *statusLabel;
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 40, 40)];
    headImageView.image = [UIImage imageNamed:@"loading"];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 20;
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:headImageView];
    
    nameLabel = [UIManager initWithLabel:CGRectMake(65, 12.5, App_Frame_Width-65-90, 20) text:@"昵称" font:14 textColor:XZRGB(0x333333)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    
    statusLabel = [UIManager initWithLabel:CGRectMake(65, 35, 38, 15) text:@"离线" font:10 textColor:UIColor.whiteColor];
    statusLabel.backgroundColor = XZRGB(0xbcbcbc);
    statusLabel.layer.masksToBounds = YES;
    statusLabel.layer.cornerRadius = 7.5;
    [self.contentView addSubview:statusLabel];
    
    UIButton *inviteBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-75, 20, 60, 25) text:@"邀请" font:14 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    inviteBtn.backgroundColor = XZRGB(0xfe2947);
    inviteBtn.layer.masksToBounds = YES;
    inviteBtn.layer.cornerRadius = 12.5;
    [inviteBtn addTarget:self action:@selector(inviteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:inviteBtn];
}

- (void)setMyFollowModel:(MansionMyFollowListModel *)myFollowModel {
    _myFollowModel = myFollowModel;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", myFollowModel.t_handImg]] placeholderImage:[UIImage imageNamed:@"loading"]];
    nameLabel.text = myFollowModel.t_nickName;
    [self setStatus:myFollowModel.t_onLine];
}

#pragma mark - func
- (void)setStatus:(int)status {
    if (status == 0) {
        // 在线
        statusLabel.text = @"在线";
        statusLabel.backgroundColor = XZRGB(0x1dec1d);
    } else if (status == 1) {
        // 在聊
        statusLabel.text = @"在聊";
        statusLabel.backgroundColor = XZRGB(0xfe2947);
    } else {
        // 离线
        statusLabel.text = @"离线";
        statusLabel.backgroundColor = XZRGB(0xbcbcbc);
    }
}

- (void)inviteButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    sender.backgroundColor = [XZRGB(0xae4ffd) colorWithAlphaComponent:0.72];
    [sender setTitle:@"已邀请" forState:0];
    sender.backgroundColor = XZRGB(0x999999);
    if (self.inviteButtonClickBlock) {
        self.inviteButtonClickBlock();
    }
}


@end
