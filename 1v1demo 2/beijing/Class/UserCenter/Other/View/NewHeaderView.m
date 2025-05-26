//
//  NewHeaderView.m
//  beijing
//
//  Created by 黎 涛 on 2020/4/21.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "NewHeaderView.h"

// info
#import "YLEditPersonalController.h"
#import "YLNCertifyController.h"
#import "YLSetupChargingItemsController.h"
#import "YLCertifyNowController.h"
//indenti
#import "AuthenticationVideoViewController.h"
#import "YLEditPhoneController.h"
#import "AuthenticationPicViewController.h"
//function
#import "MePhotoViewController.h"
#import "MeDynamicViewController.h"
#import "RankViewController.h"
//follow
#import "VisitorViewController.h"
#import "WatchedMeViewController.h"
#import "NewFollowViewController.h"//balance
#import "YLNAccountBalanceController.h"
#import "YLRechargeVipController.h"
#import "YLNWithDrawController.h"

@implementation NewHeaderView
{
    CGFloat topHeight;
    CGFloat functionTop;
    int balanceNum;
    int withdrawNum;
    BOOL isFirst;
    
    UIViewController *nowVC;
}

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        topHeight = SafeAreaTopHeight-64;
//        if ([YLUserDefault userDefault].t_sex == 0) {
            functionTop = SafeAreaTopHeight+65+120;
            self.frame = CGRectMake(0, 0, App_Frame_Width, 600+topHeight);
//        } else {
//            functionTop = SafeAreaTopHeight+65+25;
//            self.frame = CGRectMake(0, 0, App_Frame_Width, 600+topHeight-95);
//        }
        
        self.backgroundColor = UIColor.whiteColor;
        isFirst = YES;
        balanceNum = 0;
        withdrawNum = 0;
        nowVC = [SLHelper getCurrentVC];
        [self setSubViews];
    }
    return self;
}

#pragma mark - set data
- (void)setHeaderData:(personalCenterHandle *)handle {
    _handle = handle;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", handle.handImg]] placeholderImage:[UIImage imageNamed:@"default"]];
    _nameLabel.text = handle.nickName;
    
    if (handle.t_age > 0) {
        _ageLabel.text = [NSString stringWithFormat:@"%d",handle.t_age];
    }
    if (handle.t_sex == 1) {
        _sexImageView.image = [UIImage imageNamed:@"dynamic_sex_boy"];
//        _sexBgView.backgroundColor = XZRGB(0xcaf3fd);
        _ageLabel.textColor = XZRGB(0x7cdff9);
    } else {
        _sexImageView.image = [UIImage imageNamed:@"dynamic_sex_girl"];
//        _sexBgView.backgroundColor = XZRGB(0xfff1f5);
        _ageLabel.textColor = XZRGB(0xfda5bc);
    }
    if (handle.isApplyGuild == 1) {
        _companyImageView.hidden = NO;
    } else {
        _companyImageView.hidden = YES;
    }
    _idLabel.text = [NSString stringWithFormat:@"ID:%@",handle.t_idcard];
    if (handle.t_autograph.length > 0) {
        _signLabel.text = handle.t_autograph;
    } else {
        _signLabel.text = @"这个人很懒，什么都没留下～";
    }
    if (handle.t_is_vip == 0) {
        _vipHeadLogo.hidden = NO;
        _getVipImageV.hidden = YES;
        _vipTimeLabel.hidden = NO;
        _vipTimeLabel.text = [NSString stringWithFormat:@"VIP将于 %@ 到期", handle.endTime];
    } else {
        _vipHeadLogo.hidden = YES;
        _getVipImageV.hidden = NO;
        _vipTimeLabel.hidden = YES;
    }
    
    
    [self setIdentiStatus];
    [self setFollowRedPoint];
    [self setBalanceAnimation];
}

- (void)setIdentiStatus {
    UIButton *spBtn = [self viewWithTag:100];
    UIButton *sjBtn = [self viewWithTag:101];
    UIButton *sfBtn = [self viewWithTag:102];
    if (_handle.videoIdentity == 1) {
        spBtn.selected = YES;
        spBtn.userInteractionEnabled = NO;
    } else if (_handle.videoIdentity == 2) {
        spBtn.selected = NO;
        [spBtn setTitle:@"视频认证中" forState:0];
        spBtn.userInteractionEnabled = NO;
    } else {
        spBtn.selected = NO;
        [spBtn setTitle:@"视频未认证" forState:0];
        spBtn.userInteractionEnabled = YES;
    }
    
    if (_handle.phoneIdentity == 1) {
        sjBtn.selected = YES;
        sjBtn.userInteractionEnabled = NO;
    } else {
        sjBtn.selected = NO;
        sjBtn.userInteractionEnabled = YES;
    }
    
    if (_handle.idcardIdentity == 1) {
        sfBtn.selected = YES;
        sfBtn.userInteractionEnabled = NO;
    } else if (_handle.idcardIdentity == 2) {
        sfBtn.selected = NO;
        [sfBtn setTitle:@"身份认证中" forState:0];
        sfBtn.userInteractionEnabled = NO;
    } else {
        sfBtn.selected = NO;
        [sfBtn setTitle:@"身份未认证" forState:0];
        sfBtn.userInteractionEnabled = YES;
    }
}

- (void)setFollowRedPoint {
    UIView *lookmePoint = [self viewWithTag:310];
    UIView *likemePoint = [self viewWithTag:311];
    UIView *mylikePoint = [self viewWithTag:312];
    UIView *ehlikePoint = [self viewWithTag:313];
    if (_handle.browerCount > 0) {
        lookmePoint.hidden = NO;
    } else {
        lookmePoint.hidden = YES;
    }
    
    if (_handle.likeMeCount > 0) {
        likemePoint.hidden = NO;
    } else {
        likemePoint.hidden = YES;
    }
    
    if (_handle.myLikeCount > 0) {
        mylikePoint.hidden = NO;
    } else {
        mylikePoint.hidden = YES;
    }
    
    if (_handle.eachLikeCount > 0) {
        ehlikePoint.hidden = NO;
    } else {
        ehlikePoint.hidden = YES;
    }
}

- (void)setBalanceAnimation {
    int balance = [_handle.amount intValue];
    int withdraw = [_handle.extractGold intValue];
    if (isFirst) {
        _balanceLabel = [[DPScrollNumberLabel alloc] initWithNumber:@(balance) font:[UIFont boldSystemFontOfSize:20] textColor:XZRGB(0x333333)];
        _balanceLabel.frame = CGRectMake((_balanceBGView.width-_balanceLabel.width)/2, (_balanceBGView.height-_balanceLabel.height)/2, _balanceLabel.width, _balanceLabel.height);
        [_balanceBGView addSubview:_balanceLabel];
        
        _withdrawLabel = [[DPScrollNumberLabel alloc] initWithNumber:@(withdraw) font:[UIFont boldSystemFontOfSize:20] textColor:XZRGB(0x222222)];
        _withdrawLabel.frame = CGRectMake((_withdrawBGView.width-_withdrawLabel.width)/2, (_withdrawBGView.height-_withdrawLabel.height)/2, _withdrawLabel.width, _withdrawLabel.height);
        [_withdrawBGView addSubview:_withdrawLabel];
        
        isFirst = NO;
    } else {
        if (balance != balanceNum) {
            [_balanceLabel changeToNumber:@(balance) animated:YES];
            _balanceLabel.frame = CGRectMake((_balanceBGView.width-_balanceLabel.width)/2, (_balanceBGView.height-_balanceLabel.height)/2, _balanceLabel.width, _balanceLabel.height);
        }
        if (withdraw != withdrawNum) {
            [_withdrawLabel changeToNumber:@(withdraw) animated:YES];
            _withdrawLabel.frame = CGRectMake((_withdrawBGView.width-_withdrawLabel.width)/2, (_withdrawBGView.height-_withdrawLabel.height)/2, _withdrawLabel.width, _withdrawLabel.height);
        }
    }
    balanceNum = balance;
    withdrawNum = withdraw;
}

- (void)setAnchorStatus:(int)status {
    _authenticationStatus = status;
    if (status == 0) {
        [_anchorBtn setTitle:@"申请审核中" forState:0];
    } else if (status == 1) {
        [_anchorBtn setTitle:@"收费设置" forState:0];
    } else {
        [_anchorBtn setTitle:@"申请主播" forState:0];
    }
}

#pragma mark - info func
- (void)editInformationButtonClick {
    YLEditPersonalController *editPersonalInfoVC = [YLEditPersonalController new];
    editPersonalInfoVC.title = @"编辑资料";
    [nowVC.navigationController pushViewController:editPersonalInfoVC animated:YES];
}

- (void)applyForAnchorButtonClick {
    if (_authenticationStatus == 2) {
        //未认证跳到认证界面
        if (_handle.t_sex == 1) {
            [SVProgressHUD showInfoWithStatus:@"暂未开通男主播功能！"];
        }else{
            YLNCertifyController *applyCertificationVC = [YLNCertifyController new];
            applyCertificationVC.title = @"申请认证";
            [nowVC.navigationController pushViewController:applyCertificationVC animated:YES];
        }
        
    } else if (_authenticationStatus == 1) {
        //认证过后设置收费情况
        YLSetupChargingItemsController *setchargeVC = [YLSetupChargingItemsController new];
        setchargeVC.title = @"收费设置";
        [nowVC.navigationController pushViewController:setchargeVC animated:YES];
    } else {
        YLCertifyNowController *CertifyNowVC = [YLCertifyNowController new];
        CertifyNowVC.title = @"主播资料审核中";
        [nowVC.navigationController pushViewController:CertifyNowVC animated:YES];
    }
}

- (void)companyImageViewClick {
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"所属公会:%@",_handle.guildName]];
}

#pragma mark - identi func
- (void)identButtonClick:(UIButton *)sender {
    NSInteger index = sender.tag-100;
    if (index == 0) {
        // 视频认证
        AuthenticationVideoViewController *videoVC = [[AuthenticationVideoViewController alloc] init];
        [nowVC.navigationController pushViewController:videoVC animated:YES];
    } else if (index == 1) {
        // 手机认证
        YLEditPhoneController *editPhoneVC = [YLEditPhoneController new];
        editPhoneVC.title = @"手机号认证";
        [nowVC.navigationController pushViewController:editPhoneVC animated:YES];
    } else if (index == 2) {
        // 身份认证
        AuthenticationPicViewController *picVC = [[AuthenticationPicViewController alloc] init];
        [nowVC.navigationController pushViewController:picVC animated:YES];
    }
}

#pragma mark - function func
- (void)functionButtonClick:(UIButton *)sender {
    NSInteger index = sender.tag-200;
    if (index == 0 || index == 1) {
        // 相册
        MePhotoViewController *photoVC = [[MePhotoViewController alloc] init];
        photoVC.type = (int)index;
        [nowVC.navigationController pushViewController:photoVC animated:YES];
    } else if (index == 2) {
        // 动态
        MeDynamicViewController *vc = [[MeDynamicViewController alloc] init];
        [nowVC.navigationController pushViewController:vc animated:YES];
    } else if (index == 3) {
        // 排行
        RankViewController *rankVC = [[RankViewController alloc] init];
        [nowVC.navigationController pushViewController:rankVC animated:YES];
    }
}

#pragma mark - follow func
- (void)followButtonClick:(UIButton *)sender {
    NSInteger index = sender.tag-300;
    if (index == 0) {
        // 谁看过我
        WatchedMeViewController *watchMeVC = [[WatchedMeViewController alloc] init];
        [nowVC.navigationController pushViewController:watchMeVC animated:YES];
    } else if (index == 1 || index == 2 || index == 3) {
        NewFollowViewController *followVC = [[NewFollowViewController alloc] init];
        followVC.type = (int)index-1;
        [nowVC.navigationController pushViewController:followVC animated:YES];
    }
}

#pragma mark - vip func
- (void)VIPButtonClick {
    [YLPushManager pushVipWithEndTime:_handle.endTime];
}

#pragma mark - balance func
- (void)rechargeButtonClick {
    YLRechargeVipController *rechargeVipVC = [YLRechargeVipController new];
    [nowVC.navigationController pushViewController:rechargeVipVC animated:YES];
}

- (void)withdrawButtonClick {
    YLNWithDrawController *withdrawVC = [YLNWithDrawController new];
    withdrawVC.title  = @"提现";
    withdrawVC.balance= [NSString stringWithFormat:@"%@",_handle.extractGold];
    [nowVC.navigationController pushViewController:withdrawVC animated:YES];
}

- (void)balanceLabelClick {
    YLNAccountBalanceController *accountBalanceVC = [YLNAccountBalanceController new];
    accountBalanceVC.title = @"账号余额";
    [nowVC.navigationController pushViewController:accountBalanceVC animated:YES];
}

#pragma mark - subViews
- (void)setSubViews {
    [self infoView];
//    if ([YLUserDefault userDefault].t_sex == 0) {
        [self identiView];
//    }
    [self functionView];
    [self followView];
    [self vipView];
    [self balanceView];
}

- (void)infoView {
    _vipHeadLogo = [[UIImageView alloc] initWithFrame:CGRectMake(17, SafeAreaTopHeight-10, 22, 22)];
    _vipHeadLogo.image = [UIImage imageNamed:@"newcenter_logo_vip"];
    _vipHeadLogo.hidden = YES;
    [self addSubview:_vipHeadLogo];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, SafeAreaTopHeight, 65, 65)];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 32.5;
//    _headImageView.layer.borderWidth = 2;
//    _headImageView.layer.borderColor = XZRGB(0xae4ffd).CGColor;
    [self addSubview:_headImageView];
    
    _nameLabel = [UIManager initWithLabel:CGRectZero text:@"昵称" font:18 textColor:XZRGB(0x333333)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.headImageView.mas_top).offset(5);
        make.width.mas_lessThanOrEqualTo(App_Frame_Width-250);
    }];
    
    _sexBgView = [[UIView alloc] initWithFrame:CGRectZero];
    _sexBgView.backgroundColor = [XZRGB(0xae4ffd) colorWithAlphaComponent:0.15];
    _sexBgView.clipsToBounds = YES;
    _sexBgView.layer.cornerRadius = 7.5f;
    [self addSubview:_sexBgView];
    [_sexBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(35, 15));
    }];
    
    _sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 13, 13)];
    _sexImageView.image = IChatUImage(@"dynamic_sex_girl");
    [_sexBgView addSubview:_sexImageView];
    
    _ageLabel = [UIManager initWithLabel:CGRectMake(16, 0, 19, 15) text:@"18" font:12.0f textColor:XZRGB(0xfda5bc)];
    _ageLabel.textAlignment = NSTextAlignmentLeft;
    [_sexBgView addSubview:_ageLabel];
    
    _companyImageView = [[UIImageView alloc] initWithImage:IChatUImage(@"Personcenter_company")];
    _companyImageView.userInteractionEnabled = YES;
    _companyImageView.hidden = YES;
    [self addSubview:_companyImageView];
    [_companyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexBgView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22, 23));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyImageViewClick)];
    [_companyImageView addGestureRecognizer:tap];
    
    _idLabel = [UIManager initWithLabel:CGRectMake(CGRectGetMaxX(_headImageView.frame)+10, SafeAreaTopHeight+35, 120, 15) text:@"ID:" font:13 textColor:XZRGB(0x868686)];
    _idLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_idLabel];
    
    _signLabel = [UIManager initWithLabel:CGRectMake(CGRectGetMaxX(_headImageView.frame)+10, SafeAreaTopHeight+50, App_Frame_Width-100, 18) text:@"这个人很懒，什么都没留下～" font:13 textColor:XZRGB(0x868686)];
    _signLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_signLabel];
    
    if ([YLUserDefault userDefault].t_sex == 0) {
        _anchorBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-80, CGRectGetMinY(_signLabel.frame)-25, 65, 20) text:@"申请主播" font:12 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
        _anchorBtn.layer.masksToBounds = YES;
        _anchorBtn.layer.cornerRadius = 3;
        _anchorBtn.layer.borderWidth = 1;
        _anchorBtn.layer.borderColor = XZRGB(0x333333).CGColor;
        [_anchorBtn addTarget:self action:@selector(applyForAnchorButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_anchorBtn];
    }
    
    UIButton *editBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-80, CGRectGetMinY(_signLabel.frame)-25-30, 65, 20) text:@"编辑资料" font:12 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
    editBtn.layer.masksToBounds = YES;
    editBtn.layer.cornerRadius = 3;
    editBtn.layer.borderWidth = 1;
    editBtn.layer.borderColor = XZRGB(0x333333).CGColor;
    [editBtn addTarget:self action:@selector(editInformationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editBtn];
}

- (void)identiView {
    CGFloat width = (App_Frame_Width-80)/3;
    NSArray *imgArr = @[@"newcenter_btn_sprz", @"newcenter_btn_sjrz", @"newcenter_btn_sfrz"];
    NSArray *titleArr = @[@"视频未认证", @"手机未认证", @"身份未认证"];
    NSArray *selTitleArr = @[@"视频已认证", @"手机已认证", @"身份已认证"];
    for (int i = 0; i < imgArr.count; i ++) {
        UIButton *identBtn = [UIManager initWithButton:CGRectMake(20+(20+width)*i, CGRectGetMaxY(_headImageView.frame)+25, width, 80) text:titleArr[i] font:12 textColor:XZRGB(0xfa0825) normalImg:imgArr[i] highImg:nil selectedImg:nil];
        identBtn.tag = 100+i;
        identBtn.selected = NO;
        [identBtn setImagePosition:2 spacing:8];
        [identBtn setTitle:selTitleArr[i] forState:UIControlStateSelected];
        [identBtn setTitleColor:XZRGB(0x868686) forState:UIControlStateSelected];
        [identBtn addTarget:self action:@selector(identButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:identBtn];
    }
}

- (void)functionView {
    NSArray *imgArr = @[@"newcenter_btn_photo", @"newcenter_btn_video", @"newcenter_btn_dynamic", @"newcenter_btn_rank"];
    NSArray *titleArr = @[@"相册", @"视频", @"动态", @"榜单"];
    CGFloat width = App_Frame_Width/imgArr.count;
    for (int i = 0; i < imgArr.count; i ++) {
        UIButton *functionBtn = [UIManager initWithButton:CGRectMake(width*i, functionTop, width, 65) text:titleArr[i] font:13 textColor:XZRGB(0x868686) normalImg:imgArr[i] highImg:nil selectedImg:nil];
        functionBtn.tag = 200+i;
        [functionBtn setImagePosition:2 spacing:12];
        [functionBtn addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:functionBtn];
    }
}

- (void)followView {
    //200
    NSArray *imgArr = @[@"newcenter_btn_lookme", @"newcenter_btn_likeme", @"newcenter_btn_ikile", @"newcenter_btn_liketoo"];
    NSArray *titleArr = @[@"谁看过我", @"谁喜欢我", @"我喜欢谁", @"相互喜欢"];
    CGFloat width = App_Frame_Width/2;
    for (int i = 0; i < imgArr.count; i ++) {
        UIButton *followBtn = [UIManager initWithButton:CGRectMake(i%2*width, functionTop+80+45*(i/2), width, 40) text:@"" font:1 textColor:nil normalImg:nil highImg:nil selectedImg:nil];
        followBtn.tag = 300+i;
        [followBtn addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:followBtn];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
        imageV.image = [UIImage imageNamed:imgArr[i]];
        imageV.contentMode = UIViewContentModeCenter;
        [followBtn addSubview:imageV];
        
        UILabel *titleL = [UIManager initWithLabel:CGRectMake(50, 0, 80, 40) text:titleArr[i] font:15 textColor:XZRGB(0x333333)];
        titleL.textAlignment = NSTextAlignmentLeft;
        [followBtn addSubview:titleL];
        
        UIView *redPoint = [[UIView alloc] initWithFrame:CGRectMake(followBtn.width-31, 17, 6, 6)];
        redPoint.tag = 310+i;
        redPoint.hidden = YES;
        redPoint.backgroundColor = XZRGB(0xfe2947);
        redPoint.layer.masksToBounds = YES;
        redPoint.layer.cornerRadius = 3;
        [followBtn addSubview:redPoint];
    }
}

- (void)vipView {
    UIImageView *vipBG = [[UIImageView alloc] initWithFrame:CGRectMake((App_Frame_Width-346)/2, functionTop+175, 346, 61)];
    vipBG.image = [UIImage imageNamed:@"newcenter_bg_vip"];
    [self addSubview:vipBG];
    vipBG.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(VIPButtonClick)];
    [vipBG addGestureRecognizer:tap];
    
    _getVipImageV = [[UIImageView alloc] initWithFrame:CGRectMake(vipBG.width-265, 10, 200, 46)];
    _getVipImageV.image = [UIImage imageNamed:@"newcenter_text_vip"];
//    _getVipImageV.hidden = YES;
    [vipBG addSubview:_getVipImageV];
    
    _vipTimeLabel = [UIManager initWithLabel:CGRectMake(vipBG.width-265, 10, 200, 41) text:@"VIP将于 2020.10.23 到期" font:15 textColor:UIColor.whiteColor];
    _vipTimeLabel.font = [UIFont boldSystemFontOfSize:15];
    _vipTimeLabel.hidden = YES;
    [vipBG addSubview:_vipTimeLabel];
    
    UIImageView *vipLogo = [[UIImageView alloc] initWithFrame:CGRectMake(vipBG.width-65, 6, 51, 51)];
    vipLogo.image = [UIImage imageNamed:@"newcenter_btn_vip"];
    [vipBG addSubview:vipLogo];
}

- (void)balanceView {
    UIImageView *balanceBG = [[UIImageView alloc] initWithFrame:CGRectMake(7, functionTop+250, App_Frame_Width-14, 101)];
    balanceBG.image = [UIImage imageNamed:@"newcenter_bg_balance"];
    [self addSubview:balanceBG];
    balanceBG.userInteractionEnabled = YES;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(balanceBG.width/2, (balanceBG.height-60)/2, 1, 60)];
    line.backgroundColor = XZRGB(0xebebeb);
    [balanceBG addSubview:line];
    
    UIButton *rechargeBtn = [UIManager initWithButton:CGRectMake((balanceBG.width/2-60)/2, balanceBG.height-40, 60, 20) text:@"充值" font:17 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
//    rechargeBtn.backgroundColor = XZRGB(0xae4ffd);
    rechargeBtn.layer.masksToBounds = YES;
    rechargeBtn.layer.cornerRadius = 3;
    [rechargeBtn addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [balanceBG addSubview:rechargeBtn];
    
    UIButton *withdrawBtn = [UIManager initWithButton:CGRectMake((balanceBG.width/2-60)/2+balanceBG.width/2, balanceBG.height-40, 60, 20) text:@"提现" font:17 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];//0xae4ffd
//    withdrawBtn.backgroundColor = UIColor.whiteColor;
    withdrawBtn.layer.masksToBounds = YES;
    withdrawBtn.layer.cornerRadius = 3;
//    withdrawBtn.layer.borderWidth = 1;
//    withdrawBtn.layer.borderColor = XZRGB(0xae4ffd).CGColor;
    [withdrawBtn addTarget:self action:@selector(withdrawButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [balanceBG addSubview:withdrawBtn];
    
    UILabel *yeLabel = [UIManager initWithLabel:CGRectMake(0, 25, 55, 20) text:@"余额:" font:13 textColor:XZRGB(0x868686)];
    yeLabel.textAlignment = NSTextAlignmentRight;
    [balanceBG addSubview:yeLabel];
    
    UIImageView *yeJT = [[UIImageView alloc] initWithFrame:CGRectMake(balanceBG.width/2-35, 29, 12, 12)];
    yeJT.image = [UIImage imageNamed:@"newcenter_img_jt"];
    [balanceBG addSubview:yeJT];
    
    _balanceBGView = [[UIView alloc] initWithFrame:CGRectMake(55, 15, balanceBG.width/2-90, 40)];
    [balanceBG addSubview:_balanceBGView];
    UITapGestureRecognizer *balanceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(balanceLabelClick)];
    [_balanceBGView addGestureRecognizer:balanceTap];
    
    UILabel *syLabel = [UIManager initWithLabel:CGRectMake(balanceBG.width/2, 25, 55, 20) text:@"收益:" font:13 textColor:XZRGB(0x868686)];
    syLabel.textAlignment = NSTextAlignmentRight;
    [balanceBG addSubview:syLabel];
    
    UIImageView *syJT = [[UIImageView alloc] initWithFrame:CGRectMake(balanceBG.width-35, 29, 12, 12)];
    syJT.image = [UIImage imageNamed:@"newcenter_img_jt"];
    [balanceBG addSubview:syJT];
    
    _withdrawBGView = [[UIView alloc] initWithFrame:CGRectMake(55+balanceBG.width/2, 15, balanceBG.width/2-90, 40)];
    [balanceBG addSubview:_withdrawBGView];
    UITapGestureRecognizer *withdrawTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(withdrawButtonClick)];
    [_withdrawBGView addGestureRecognizer:withdrawTap];
}



@end
