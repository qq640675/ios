//
//  DetailHeaderView.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/4.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "DetailHeaderView.h"
#import "XLPhotoBrowser.h"
#import "YLNetworkInterface.h"
#import "ShareManager.h"

@implementation DetailHeaderView
{
    UILabel *nameLabel;
    UIImageView *vipImageView;
    UILabel *videoPriceLabel;
    UILabel *idLabel;
    UILabel *signLabel;
    UIButton *followBtn;
    UIViewController *nowVC;
    
    UIView *statusView;
    UIView *statusPoint;
    UILabel *statusLabel;
        
    UIView *sexBgView;
    UIImageView *sexImageView;
    UILabel *ageLabel;
    
    UIButton *guardBtn;
    UILabel *jdlL;//接单量
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, App_Frame_Width+140);
        self.backgroundColor = UIColor.whiteColor;
        nowVC = [SLHelper getCurrentVC];
        [self setSubViuews];
    }
    return self;
}

#pragma mark - subViews
- (void)setSubViuews {
    [self setBannerView];
    [self setInfoView];
}

- (void)setBannerView {
    [self addSubview:self.imageScrollView];
    [self addSubview:self.imageCountLb];
    WEAKSELF;
    _imageScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        // 封面图点击block
        [weakSelf clickedBannerImage:currentIndex];
    };
    
    statusView = [[UIView alloc] initWithFrame:CGRectMake(15, self.imageScrollView.height-36, 50, 22)];
    statusView.layer.masksToBounds = YES;
    statusView.layer.cornerRadius = 11;
    statusView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
    [self.imageScrollView addSubview:statusView];

    statusPoint = [[UIView alloc] initWithFrame:CGRectMake(7, 7, 8, 8)];
    statusPoint.layer.masksToBounds = YES;
    statusPoint.layer.cornerRadius = 4;
    statusPoint.backgroundColor = XZRGB(0x868686);
    [statusView addSubview:statusPoint];

    statusLabel = [UIManager initWithLabel:CGRectMake(20, 0, 28, 22) text:@"离线" font:12 textColor:XZRGB(0x868686)];
    statusLabel.textAlignment = NSTextAlignmentLeft;
    [statusView addSubview:statusLabel];
}

- (void)setInfoView {
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, App_Frame_Width, App_Frame_Width, 140)];
    [self addSubview:infoView];
    
    nameLabel = [UIManager initWithLabel:CGRectZero text:@"昵称" font:18 textColor:XZRGB(0x333333)];
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    [infoView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.width.mas_lessThanOrEqualTo(App_Frame_Width-260);
    }];
    
    vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"near_vip"]];
    vipImageView.clipsToBounds = YES;
    vipImageView.hidden = YES;
    [infoView addSubview:vipImageView];
    [vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->nameLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self->nameLabel.mas_centerY);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(0);
    }];
    
    sexBgView = [[UIView alloc] initWithFrame:CGRectZero];
    sexBgView.backgroundColor = [XZRGB(0xae4ffd) colorWithAlphaComponent:0.15];
    sexBgView.clipsToBounds = YES;
    sexBgView.layer.cornerRadius = 7.5f;
    [self addSubview:sexBgView];
    [sexBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->vipImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self->vipImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(35, 15));
    }];
    
    sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 13, 13)];
    sexImageView.image = IChatUImage(@"dynamic_sex_girl");
    [sexBgView addSubview:sexImageView];
    
    ageLabel = [UIManager initWithLabel:CGRectMake(16, 0, 19, 15) text:@"18" font:12.0f textColor:XZRGB(0xfda5bc)];
    ageLabel.textAlignment = NSTextAlignmentLeft;
    [sexBgView addSubview:ageLabel];
    
    followBtn = [UIManager initWithButton:CGRectZero text:@"关注" font:10 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    followBtn.backgroundColor = XZRGB(0xFF426E);
    followBtn.layer.masksToBounds = YES;
    followBtn.layer.cornerRadius = 7.5;
    [followBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [followBtn addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:followBtn];
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->sexBgView.mas_right).offset(5);
        make.centerY.mas_equalTo(self->vipImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
    videoPriceLabel = [UIManager initWithLabel:CGRectMake(App_Frame_Width-135, 10, 120, 25) text:@"视频:0金币/分钟" font:12 textColor:XZRGB(0x868686)];
    videoPriceLabel.textAlignment = NSTextAlignmentRight;
    [infoView addSubview:videoPriceLabel];
    
    if([YLUserDefault userDefault].t_sex == 1){
        UILabel *managerGoldLable = [UIManager initWithLabel:CGRectMake(App_Frame_Width-175, 32, 160, 25) text:@"视频管理费:0金币/分钟" font:12 textColor:XZRGB(0x868686)];
        managerGoldLable.textAlignment = NSTextAlignmentRight;
        NSString *videoPrice = [NSString stringWithFormat:@"视频管理费:%@金币/分钟", [SLDefaultsHelper getSLDefaults:@"managerGold"]];
        NSString *fg = (NSString *)[SLDefaultsHelper getSLDefaults:@"managerGold"];
        NSMutableAttributedString *videoAttri = [[NSMutableAttributedString alloc] initWithString:videoPrice];
        [videoAttri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(6, fg.length)];
        [videoAttri addAttribute:NSForegroundColorAttributeName value:XZRGB(0xfb3b96) range:NSMakeRange(6, fg.length)];
        managerGoldLable.attributedText = videoAttri;
        [infoView addSubview:managerGoldLable];
    }
    
    if ([YLUserDefault userDefault].t_sex == 1) {
        guardBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-100, 45, 80, 80) text:@"" font:1 textColor:nil normalImg:@"chat_item_guard" highImg:nil selectedImg:nil];
        [guardBtn addTarget:self action:@selector(guardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        guardBtn.hidden = YES;
        [infoView addSubview:guardBtn];
    }
    
    idLabel = [UIManager initWithLabel:CGRectMake(15, 45, 200, 20) text:@"新游山号:" font:14 textColor:XZRGB(0x666666)];
    idLabel.textAlignment = NSTextAlignmentLeft;
    [infoView addSubview:idLabel];
    
    signLabel = [UIManager initWithLabel:CGRectMake(15, 65, App_Frame_Width-130, 20) text:@"这个人很懒，还没来得及写签名~" font:14 textColor:XZRGB(0x666666)];
    signLabel.textAlignment = NSTextAlignmentLeft;
    [infoView addSubview:signLabel];
    
    jdlL = [UIManager initWithLabel:CGRectMake(15, 85, App_Frame_Width-130, 35) text:@"接单量:               接听率:" font:13 textColor:XZRGB(0x333333)];
    jdlL.textAlignment = NSTextAlignmentLeft;
    jdlL.font = [UIFont boldSystemFontOfSize:13];
    jdlL.hidden = YES;
    [infoView addSubview:jdlL];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, infoView.height-13, App_Frame_Width-30, 3)];
    line.backgroundColor = XZRGB(0xeeeeee);
    [infoView addSubview:line];
    
}

- (void)guardButtonClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    if (self.guardButtonClickBlock) {
        self.guardButtonClickBlock();
    }
}

#pragma mark - set data
- (void)setInfoHandle:(godnessInfoHandle *)infoHandle {
    _infoHandle = infoHandle;
    NSMutableArray *imageUrlArray = [NSMutableArray new];
    if ([infoHandle.lunbotu count] == 0) {
        NSString *headImageUrl = [NSString stringWithFormat:@"%@", infoHandle.t_handImg];
        [imageUrlArray addObject:headImageUrl];
    } else {
        for (int i = 0; i < [infoHandle.lunbotu count]; i++) {
            NSDictionary *dic = infoHandle.lunbotu[i];
            [imageUrlArray addObject:dic[@"t_img_url"]];
        }
    }
    _imageScrollView.imageURLStringsGroup = imageUrlArray;
    if ([imageUrlArray count] > 0) {
        _imageCountLb.text = [NSString stringWithFormat:@"1/%ld",imageUrlArray.count];
    }
    nameLabel.text = infoHandle.t_nickName;
    if (infoHandle.t_sex == 1) {
        sexImageView.image = IChatUImage(@"dynamic_sex_boy");
        ageLabel.textColor = XZRGB(0x7cdff9);
    } else {
        sexImageView.image = IChatUImage(@"dynamic_sex_girl");
        ageLabel.textColor = XZRGB(0xfda5bc);
    }
    ageLabel.text = [NSString stringWithFormat:@"%d", infoHandle.t_age];
    if (infoHandle.t_role == 1) {
        guardBtn.hidden = NO;
    } else {
        guardBtn.hidden = YES;
    }
    if (infoHandle.t_is_vip == 0) {
        vipImageView.hidden = NO;
        [vipImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(38);
        }];
    } else {
        vipImageView.hidden = YES;
        [vipImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
    
    for (int i = 0; i < 5; i++) {
        UIImageView *star = [self viewWithTag:666+i];
        star.hidden = YES;
    }
    int t_scoreNum = [infoHandle.t_score intValue];
    for (int i = 0 ; i < t_scoreNum; i ++) {
        UIImageView *star = [self viewWithTag:666+i];
        star.hidden = NO;
    }
    
    if (infoHandle.t_role == 1) {
        videoPriceLabel.hidden = NO;
        
        if ([infoHandle.anchorSetup count] > 0) {
            NSDictionary *dic  = [infoHandle.anchorSetup firstObject];
            
            NSString *t_video_gold = [NSString stringWithFormat:@"%@", dic[@"t_video_gold"]];
            NSString *videoPrice = [NSString stringWithFormat:@"视频:%@金币/分钟", t_video_gold];
            NSMutableAttributedString *videoAttri = [[NSMutableAttributedString alloc] initWithString:videoPrice];
            [videoAttri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(3, t_video_gold.length)];
            [videoAttri addAttribute:NSForegroundColorAttributeName value:XZRGB(0xfb3b96) range:NSMakeRange(3, t_video_gold.length)];
            videoPriceLabel.attributedText = videoAttri;
        }
    } else {
        videoPriceLabel.hidden = YES;
    }
    
    if (infoHandle.t_autograph.length > 0 && ![infoHandle.t_autograph containsString:@"null"]) {
        signLabel.text = infoHandle.t_autograph;
    }
    
    idLabel.text = [NSString stringWithFormat:@"新游山号:%d", infoHandle.t_idcard];
    if (infoHandle.t_city.length > 0 && ![infoHandle.t_city containsString:@"null"]) {
        idLabel.text = [NSString stringWithFormat:@"新游山号:%d  |  %@", infoHandle.t_idcard, infoHandle.t_city];
    }
    followBtn.selected = infoHandle.isFollow;
    NSString *t_called_video = @"0";
    if (infoHandle.t_called_video.length > 0 && ![infoHandle.t_called_video containsString:@"null"]) {
        t_called_video = infoHandle.t_called_video;
    }
    if (infoHandle.t_role == 1) {
        jdlL.hidden = NO;
        jdlL.text = [NSString stringWithFormat:@"接单量:%@               接听率:%@", t_called_video, infoHandle.t_reception];
    }
    
    if (!infoHandle.t_is_not_disturb) {
        statusLabel.text = @"勿扰";
        statusView.backgroundColor = XZRGB(0xF5F5F5);
        statusPoint.backgroundColor = XZRGB(0x868686);
        statusLabel.textColor = XZRGB(0x868686);
    } else {
        if (infoHandle.t_onLine == 0) {
            statusLabel.text = @"在线";
            statusView.backgroundColor = XZRGB(0x31df9b);
            statusPoint.backgroundColor = UIColor.whiteColor;
            statusLabel.textColor = UIColor.whiteColor;
        } else if (infoHandle.t_onLine == 1) {
            statusLabel.text = @"在聊";
            statusView.backgroundColor = XZRGB(0xffeaed);
            statusPoint.backgroundColor = XZRGB(0xfe2947);
            statusLabel.textColor = XZRGB(0xfe2947);
        } else {
            statusLabel.text = @"离线";
            statusView.backgroundColor = XZRGB(0xF5F5F5);
            statusPoint.backgroundColor = XZRGB(0x868686);
            statusLabel.textColor = XZRGB(0x868686);
        }
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    _imageCountLb.text = [NSString stringWithFormat:@"%ld/%lu",(long)index+1,(unsigned long)_infoHandle.lunbotu.count];
}

#pragma mark - func
- (void)clickedBannerImage:(NSInteger)index {
    [XLPhotoBrowser showPhotoBrowserWithImages:_imageScrollView.imageURLStringsGroup currentImageIndex:index];
}

- (void)backButtonClick {
    [nowVC.navigationController popViewControllerAnimated:YES];
}

- (void)followButtonClick:(UIButton *)sender {
    if (_infoHandle.t_sex == [YLUserDefault userDefault].t_sex) {
        [SVProgressHUD showInfoWithStatus:@"暂未开放同性用户交流"];
        return;
    }
    if (followBtn.selected == NO) {
        [self follow];
    } else {
        [self cancleFollow];
    }
}

- (void)follow {
    WEAKSELF
    [YLNetworkInterface addAttention:[YLUserDefault userDefault].t_id coverFollowUserId:_infoHandle.t_idcard-10000 block:^(BOOL isSuccess) {
        if (isSuccess) {
            self->followBtn.selected = YES;
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            if (weakSelf.followButtonClickBlock) {
                weakSelf.followButtonClickBlock(1);
            }
        }
    }];
}

- (void)cancleFollow {
    WEAKSELF
    [YLNetworkInterface cancelAtttention:[YLUserDefault userDefault].t_id coverFollowUserId:_infoHandle.t_idcard-10000  block:^(BOOL isSuccess) {
        if (isSuccess) {
            self->followBtn.selected = NO;
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            if (weakSelf.followButtonClickBlock) {
                weakSelf.followButtonClickBlock(0);
            }
        }
    }];
}

- (void)shareButtonClick:(UIButton *)sender {
    NSString *imageUrl = nil;
    if (_infoHandle.lunbotu.count > 0) {
        NSDictionary *dic = [_infoHandle.lunbotu firstObject];
        imageUrl = dic[@"t_img_url"];
    }
    
    id obj = nil;
    if (imageUrl.length > 0) {
        obj = imageUrl;
    } else {
        obj = [UIImage imageNamed:@"logo60"];
    }
    
    [[ShareManager shareInstance] shareWithTitle:[NSString stringWithFormat:@"您的好友[%@]邀请您——视频私聊",_infoHandle.t_nickName] content:@"请注意查收！" image:obj url:nil];
}


#pragma mark - lazy loading
- (SDCycleScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, App_Frame_Width)];
        _imageScrollView.delegate = self;
        _imageScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _imageScrollView.backgroundColor = XZRGB(0xebebeb);
        _imageScrollView.placeholderImage = [UIImage imageNamed:@"loading"];
    }
    return _imageScrollView;
}

- (UILabel *)imageCountLb {
    if (!_imageCountLb) {
        _imageCountLb = [UIManager initWithLabel:CGRectMake(App_Frame_Width-55, App_Frame_Width-35, 40, 20) text:@"0/0" font:14.0f textColor:[UIColor whiteColor]];
        _imageCountLb.clipsToBounds = YES;
        _imageCountLb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        _imageCountLb.layer.cornerRadius = 10;
    }
    return _imageCountLb;
}


@end
