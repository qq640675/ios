//
//  NewPersonHeadView.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/19.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "NewPersonHeadView.h"
// info
#import "YLEditPersonalController.h"
#import "YLNCertifyController.h"
#import "YLSetupChargingItemsController.h"
#import "YLCertifyNowController.h"
//follow
#import "VisitorViewController.h"
#import "WatchedMeViewController.h"
#import "NewFollowViewController.h"
#import "MeDynamicViewController.h"

@implementation NewPersonHeadView
{
    CGFloat topHeight;
    CGFloat functionTop;
    UIViewController *nowVC;
}

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        topHeight = SafeAreaTopHeight-64-20;
        functionTop = SafeAreaTopHeight+65+25-20;
        self.frame = CGRectMake(0, 0, App_Frame_Width, functionTop+60);
        self.backgroundColor = UIColor.whiteColor;
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
        _ageLabel.textColor = XZRGB(0x7cdff9);
    } else {
        _sexImageView.image = [UIImage imageNamed:@"dynamic_sex_girl"];
        _ageLabel.textColor = XZRGB(0xfda5bc);
    }
    _idLabel.text = [NSString stringWithFormat:@"新游山号:%@",handle.t_idcard];
    if (handle.t_autograph.length > 0) {
        _signLabel.text = handle.t_autograph;
    } else {
        _signLabel.text = @"这个人很懒，什么都没留下～";
    }
    if (handle.t_is_vip == 0) {
        _vipHeadLogo.hidden = NO;
    } else {
        _vipHeadLogo.hidden = YES;
    }
    
    UILabel *myLikeLb = [self viewWithTag:500];
    UILabel *likeMeLb = [self viewWithTag:501];
    UILabel *eachLikeLb = [self viewWithTag:502];
    UILabel *seeLb = [self viewWithTag:503];
    myLikeLb.text = [NSString stringWithFormat:@"%ld", handle.myLikeCount];
    likeMeLb.text = [NSString stringWithFormat:@"%ld", handle.likeMeCount];
    eachLikeLb.text = [NSString stringWithFormat:@"%ld", handle.dynamCount];
    seeLb.text = [NSString stringWithFormat:@"%ld", handle.browerCount];
    
}

//- (void)setAnchorStatus:(int)status {
//    _authenticationStatus = status;
//    if (status == 0) {
//        [_anchorBtn setTitle:@"申请审核中" forState:0];
//    } else if (status == 1) {
//        [_anchorBtn setTitle:@"收费设置" forState:0];
//    } else {
//        [_anchorBtn setTitle:@"申请主播" forState:0];
//    }
//}

#pragma mark - info func
- (void)editInformationButtonClick {
    YLEditPersonalController *editPersonalInfoVC = [YLEditPersonalController new];
    editPersonalInfoVC.title = @"编辑资料";
    [nowVC.navigationController pushViewController:editPersonalInfoVC animated:YES];
}

//- (void)applyForAnchorButtonClick {
//    if (_authenticationStatus == 2) {
//        //未认证跳到认证界面
//        if (_handle.t_sex == 1) {
//            [SVProgressHUD showInfoWithStatus:@"暂未开通男主播功能！"];
//        }else{
//            YLNCertifyController *applyCertificationVC = [YLNCertifyController new];
//            applyCertificationVC.title = @"申请认证";
//            [nowVC.navigationController pushViewController:applyCertificationVC animated:YES];
//        }
//    } else if (_authenticationStatus == 1) {
//        //认证过后设置收费情况
//        YLSetupChargingItemsController *setchargeVC = [YLSetupChargingItemsController new];
//        setchargeVC.title = @"收费设置";
//        [nowVC.navigationController pushViewController:setchargeVC animated:YES];
//    } else {
//        YLCertifyNowController *CertifyNowVC = [YLCertifyNowController new];
//        CertifyNowVC.title = @"主播资料审核中";
//        [nowVC.navigationController pushViewController:CertifyNowVC animated:YES];
//    }
//}

- (void)followButtonClick:(UIButton *)sender {
    NSInteger index = sender.tag-200;
    if (index == 3) {
        // 谁看过我
        WatchedMeViewController *watchMeVC = [[WatchedMeViewController alloc] init];
        [nowVC.navigationController pushViewController:watchMeVC animated:YES];
    } else if (index == 0 || index == 1) {
        NSInteger type = index;
        if (index == 0) {
            type = 1;
        } else if (index == 1) {
            type = 0;
        }
        NewFollowViewController *followVC = [[NewFollowViewController alloc] init];
        followVC.type = (int)type;
        [nowVC.navigationController pushViewController:followVC animated:YES];
    } else if (index == 2) {
        //我的动态
        MeDynamicViewController *vc = [[MeDynamicViewController alloc] init];
        [nowVC.navigationController pushViewController:vc animated:YES];
    }
}

- (void)copyButtonClick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _handle.t_idcard;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

#pragma mark - subViews
- (void)setSubViews {
    _vipHeadLogo = [[UIImageView alloc] initWithFrame:CGRectMake(17, SafeAreaTopHeight-10-20, 22, 22)];
    _vipHeadLogo.image = [UIImage imageNamed:@"newcenter_logo_vip"];
    _vipHeadLogo.hidden = YES;
    [self addSubview:_vipHeadLogo];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, SafeAreaTopHeight-20, 65, 65)];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 32.5;
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
    
    _idLabel = [UIManager initWithLabel:CGRectMake(CGRectGetMaxX(_headImageView.frame)+10, SafeAreaTopHeight+35-20, 120, 15) text:@"新游山号:" font:13 textColor:XZRGB(0x868686)];
    _idLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_idLabel];
    [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
            make.top.mas_equalTo(SafeAreaTopHeight+35-20);
            make.height.mas_equalTo(15);
    }];
    
    UIButton *copyB = [UIManager initWithButton:CGRectZero text:@"复制" font:10 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    copyB.backgroundColor = XZRGB(0x90836);
    copyB.layer.masksToBounds = YES;
    copyB.layer.cornerRadius = 2.5;
    [copyB addTarget:self action:@selector(copyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:copyB];
    [copyB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.idLabel.mas_right).offset(10);
            make.top.mas_equalTo(SafeAreaTopHeight+35-20);
            make.size.mas_equalTo(CGSizeMake(25, 15));
    }];
    
    _signLabel = [UIManager initWithLabel:CGRectMake(CGRectGetMaxX(_headImageView.frame)+10, SafeAreaTopHeight+50-20, App_Frame_Width-100, 18) text:@"这个人很懒，什么都没留下～" font:13 textColor:XZRGB(0x868686)];
    _signLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_signLabel];
    
//    _anchorBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-80, CGRectGetMinY(_signLabel.frame)-25, 65, 20) text:@"申请主播" font:12 textColor:XZRGB(0x666666) normalImg:nil highImg:nil selectedImg:nil];
//    _anchorBtn.layer.masksToBounds = YES;
//    _anchorBtn.layer.cornerRadius = 3;
//    _anchorBtn.layer.borderWidth = 1;
//    _anchorBtn.layer.borderColor = XZRGB(0x666666).CGColor;
//    [_anchorBtn addTarget:self action:@selector(applyForAnchorButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_anchorBtn];
    
    UIButton *editBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-80, CGRectGetMinY(_signLabel.frame)-25-30, 65, 20) text:@"编辑资料" font:12 textColor:XZRGB(0x666666) normalImg:nil highImg:nil selectedImg:nil];
    editBtn.layer.masksToBounds = YES;
    editBtn.layer.cornerRadius = 3;
    editBtn.layer.borderWidth = 1;
    editBtn.layer.borderColor = XZRGB(0x7948FB).CGColor;
    [editBtn addTarget:self action:@selector(editInformationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editBtn];
    
    NSArray *titleArr = @[@"我的关注", @"我的粉丝", @"我的动态", @"最近来访"];
    CGFloat width = App_Frame_Width/titleArr.count;
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *functionBtn = [UIManager initWithButton:CGRectMake(width*i, functionTop, width, 50) text:titleArr[i] font:13 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
        functionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        functionBtn.tag = 200+i;
        functionBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        [functionBtn addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:functionBtn];
        
        UILabel *numLabel = [UIManager initWithLabel:CGRectMake(10, 0, functionBtn.width-20, 25) text:@"0" font:15 textColor:XZRGB(0x333333)];
        numLabel.font = [UIFont boldSystemFontOfSize:15];
        numLabel.tag = 500+i;
        [functionBtn addSubview:numLabel];
    }
    
    [UIManager minePageLineWithY:self.height-4 superView:self];
}







@end
