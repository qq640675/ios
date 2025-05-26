//
//  NearTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/5/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "NearTableViewCell.h"
#import "BaseView.h"
#import "YLNetworkInterface.h"
#import "ChatLiveManager.h"
#import "YLPushManager.h"

@implementation NearTableViewCell
{
    UIImageView *headImageView;
    UILabel *nameLabel;
    UIImageView *vipImageView;
    UILabel *distanceLabel;
    UILabel *statusLabel;
    UIImageView *sexImageView;
    UILabel *ageLabel;
    UILabel *signLabel;
    UIButton *followBtn;
    UIButton *chatBtn;
    UIButton *videoBtn;
    
    distanceHandle *nearHandle;
    fansListHandle *fansHandle;
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
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}

#pragma mark - subViews
- (void)setSubViews {
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 60, 60)];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 4;
    [self.contentView addSubview:headImageView];
    headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewClick)];
    [headImageView addGestureRecognizer:tap];
    
    nameLabel = [UIManager initWithLabel:CGRectZero text:@"昵称" font:15 textColor:XZRGB(0x333333)];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->headImageView.mas_right).offset(10);
        make.top.mas_equalTo(self->headImageView.mas_top).offset(-2);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(App_Frame_Width-230);
    }];
    
    vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"near_vip"]];
    vipImageView.hidden = YES;
    [self.contentView addSubview:vipImageView];
    [vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->nameLabel.mas_right).offset(8);
        make.centerY.mas_equalTo(self->nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(38, 15));
    }];
    
    statusLabel = [UIManager initWithLabel:CGRectMake(App_Frame_Width-15-30, 20, 30, 16) text:@". 在线" font:11 textColor:XZRGB(0x868686)];
    statusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:statusLabel];
    
    distanceLabel = [UIManager initWithLabel:CGRectMake(statusLabel.x-50, 20, 50, 16) text:@"1.5km" font:11 textColor:XZRGB(0x868686)];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:distanceLabel];
    
    sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 40, 20, 20)];
    sexImageView.image = [UIImage imageNamed:@"near_img_boy"];
    sexImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:sexImageView];
    
    ageLabel = [UIManager initWithLabel:CGRectMake(CGRectGetMaxX(sexImageView.frame)+5, sexImageView.y, 150, 20) text:@"25岁 | 175cm | 学生" font:11 textColor:XZRGB(0x868686)];
    ageLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:ageLabel];
    
    signLabel = [UIManager initWithLabel:CGRectMake(85, 62, App_Frame_Width-180, 20) text:@"这个人很懒，还没有写签名" font:11 textColor:XZRGB(0x868686)];
    signLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:signLabel];
    
    followBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-50, 50, 35, 35) text:@"" font:1 textColor:nil normalImg:@"newmessage_btn_follow" highImg:nil selectedImg:@"newmessage_btn_follow_sel"];
    followBtn.selected = NO;
    [followBtn addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:followBtn];
    
    videoBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-50, 50, 35, 35) text:@"" font:1 textColor:nil normalImg:@"near_btn_video" highImg:nil selectedImg:nil];
    videoBtn.hidden = YES;
    [videoBtn addTarget:self action:@selector(videoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:videoBtn];
    
    chatBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-50-50, 50, 35, 35) text:@"" font:1 textColor:nil normalImg:@"near_btn_chat" highImg:nil selectedImg:nil];
    chatBtn.hidden = YES;
    [chatBtn addTarget:self action:@selector(chatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:chatBtn];
}

- (void)setIsBoyUser:(BOOL)isBoyUser {
    _isBoyUser = isBoyUser;
    if (isBoyUser == YES) {
        followBtn.hidden = YES;
        chatBtn.hidden = NO;
        videoBtn.hidden = NO;
        distanceLabel.hidden = YES;
    } else {
        followBtn.hidden = NO;
        chatBtn.hidden = YES;
        videoBtn.hidden = YES;
        distanceLabel.hidden = NO;
    }
}

- (void)headImageViewClick {
    if (_isBoyUser == YES) {
        [YLPushManager pushFansDetail:fansHandle.t_id];
    } else {
        if (nearHandle.t_role == 1) {
            [YLPushManager pushAnchorDetail:nearHandle.t_id];
        } else {
            [YLPushManager pushFansDetail:nearHandle.t_id];
        }
    }
}

- (void)followButtonClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    
    if (sender.selected == NO) {
        [YLNetworkInterface addAttention:[YLUserDefault userDefault].t_id
                       coverFollowUserId:nearHandle.t_id
                                   block:^(BOOL isSuccess)
         {
             if (isSuccess) {
                 sender.selected = !sender.selected;
                 [SVProgressHUD showSuccessWithStatus:@"关注成功"];
             }
         }];
    } else {
        [YLNetworkInterface cancelAtttention:[YLUserDefault userDefault].t_id coverFollowUserId:nearHandle.t_id block:^(BOOL isSuccess) {
            if (isSuccess) {
                sender.selected = !sender.selected;
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            }
        }];
    }
}

- (void)chatButtonClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    
    [YLPushManager pushChatViewController:fansHandle.t_id otherSex:fansHandle.t_sex];
}

- (void)videoButtonClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    
    [[ChatLiveManager shareInstance] getVideoChatAutographWithOtherId:fansHandle.t_id type:1 fail:nil];
}

- (void)setNearHandle:(distanceHandle *)handle {
    nearHandle = handle;
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", handle.t_handImg]]];
    nameLabel.text = handle.t_nickName;
    if (handle.t_is_vip == 0) {
        vipImageView.hidden = NO;
    } else {
        vipImageView.hidden = YES;
    }
    distanceLabel.text = [NSString stringWithFormat:@"%@km", handle.distance];
    if (handle.t_onLine == 0) {
        statusLabel.text = @". 在线";
    }else if (handle.t_onLine == 1){
        statusLabel.text = @". 在聊";
    }else{
        statusLabel.text = @". 离线";
    }
    if (handle.t_sex == 0) {
        sexImageView.image = [UIImage imageNamed:@"near_img_girl"];
    } else {
        sexImageView.image = [UIImage imageNamed:@"near_img_boy"];
    }
    NSString *height = @"";
    if (handle.t_height.length > 0 && ![handle.t_height containsString:@"null"]) {
        height = [NSString stringWithFormat:@" | %@cm", handle.t_height];
    }
    NSString *voc = @"";
    if (handle.t_vocation.length > 0 && ![handle.t_vocation containsString:@"null"]) {
        voc = [NSString stringWithFormat:@" | %@", handle.t_vocation];
    }
    ageLabel.text = [NSString stringWithFormat:@"%@岁%@%@", handle.t_age, height, voc];
    if (handle.t_autograph.length > 0 && ![handle.t_autograph containsString:@"null"]) {
        signLabel.text = handle.t_autograph;
    }
    followBtn.selected = handle.isFollow;
}


- (void)setFansHandle:(fansListHandle *)handle {
    fansHandle = handle;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", handle.t_handImg]]];
    nameLabel.text = handle.t_nickName;
    if (handle.t_is_vip == 0) {
        vipImageView.hidden = NO;
    } else {
        vipImageView.hidden = YES;
    }
//    distanceLabel.text = [NSString stringWithFormat:@"%@km", handle.distance];
    if (handle.t_onLine == 0) {
        statusLabel.text = @" 在线";
    }else if (handle.t_onLine == 1){
        statusLabel.text = @" 在聊";
    }else{
        statusLabel.text = @" 离线";
    }
    if (handle.t_sex == 0) {
        sexImageView.image = [UIImage imageNamed:@"near_img_girl"];
    } else {
        sexImageView.image = [UIImage imageNamed:@"near_img_boy"];
    }
    NSString *height = @"";
    if (handle.t_height.length > 0 && ![handle.t_height containsString:@"null"]) {
        height = [NSString stringWithFormat:@" | %@cm", handle.t_height];
    }
    NSString *voc = @"";
    if (handle.t_vocation.length > 0 && ![handle.t_vocation containsString:@"null"]) {
        voc = [NSString stringWithFormat:@" | %@", handle.t_vocation];
    }
    ageLabel.text = [NSString stringWithFormat:@"%@岁%@%@", handle.t_age, height, voc];
//    if (handle.t_autograph.length > 0 && ![handle.t_autograph containsString:@"null"]) {
//        signLabel.text = handle.t_autograph;
//    }
    // 男用户列表不展示签名  展示财富值。
    signLabel.text = [NSString stringWithFormat:@"财富值：%@", handle.balance];
}



@end
