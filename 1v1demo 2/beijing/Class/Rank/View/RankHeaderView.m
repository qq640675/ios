//
//  RankHeaderView.m
//  beijing
//
//  Created by 黎 涛 on 2020/5/21.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "RankHeaderView.h"
#import "YLPushManager.h"
#import "MysteriousView.h"

@implementation RankHeaderView
{
    UIView *btnLine;
}

#pragma mark - init
- (instancetype)initWithType:(RankListType)rankType {
    self = [super init];
    if (self) {
        _rankListType = rankType;
        self.frame = CGRectMake(0, 0, App_Frame_Width, 350+(SafeAreaTopHeight-64));
        [self setSubViews];
    }
    return self;
}

#pragma mark - set data
- (void)setHeaderData:(NSArray *)dataArray {
    [self reSetDefaultData];
    if (dataArray.count > 0) {
        _firstRankHandle = dataArray.firstObject;
        [self setDataWithRank:1 handle:_firstRankHandle];
    }
    if (dataArray.count > 1) {
        _secondRankHandle = dataArray[1];
        [self setDataWithRank:2 handle:_secondRankHandle];
    }
    if (dataArray.count > 2) {
        _thirdRankHandle = dataArray[2];
        [self setDataWithRank:3 handle:_thirdRankHandle];
    }
}

- (void)setDataWithRank:(int)rank handle:(rankingHandle *)handle {
    UIView *view = [self viewWithTag:rank*100];
    UIImageView *headImageView = [view viewWithTag:view.tag+10];
    UILabel *nameLabel = [view viewWithTag:view.tag+20];
    UILabel *idLabel = [view viewWithTag:view.tag+30];
    UIButton *coinBtn = [view viewWithTag:view.tag+40];
    UILabel *getStatusL = [view viewWithTag:view.tag+50];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", handle.t_handImg]]];
    nameLabel.text = handle.t_nickName;
    idLabel.text = [NSString stringWithFormat:@"ID：%d", handle.t_idcard];
    [coinBtn setTitle:[NSString stringWithFormat:@"距离上名:%ld", (long)handle.newGold] forState:0];
    [coinBtn setImagePosition:0 spacing:1];
    if (handle.t_is_receive) {
        getStatusL.text = @"已领取";
        getStatusL.textColor = XZRGB(0x999999);
        getStatusL.backgroundColor = XZRGB(0xE8E7E7);
    } else {
        getStatusL.text = @"未领取";
        getStatusL.textColor = UIColor.whiteColor;
        getStatusL.backgroundColor = XZRGB(0xC5AFFF);
    }
    
//    if (_rankListType == RankListTypeGoddess || _rankListType == RankListTypeConsume || _rankListType == RankListTypeGuard) {
        if (handle.t_rank_switch) {
            idLabel.hidden = YES;
        } else {
            idLabel.hidden = NO;
        }
//    } else {
//        if (_btnType == YLRankBtnTypeYesterday) {
//            idLabel.hidden = NO;
//        } else {
//            idLabel.hidden = YES;
//        }
//    }
    if (_rankListType == RankListTypeInvited && !handle.t_rank_switch) {
        if (nameLabel.text.length > 1) {
            nameLabel.text = [NSString stringWithFormat:@"%@***", [nameLabel.text substringToIndex:1]];
        } else {
            nameLabel.text = [NSString stringWithFormat:@"%@***", nameLabel.text];
        }
    }
//    if (_btnType == YLRankBtnTypeYesterday) {
//        idLabel.text = [NSString stringWithFormat:@"奖励：%d金币", handle.t_rank_gold];
//    }
}

- (void)reSetDefaultData {
    for (int i = 1; i < 4; i ++) {
        UIView *view = [self viewWithTag:i*100];
        UIImageView *headImageView = [view viewWithTag:view.tag+10];
        UILabel *nameLabel = [view viewWithTag:view.tag+20];
        UILabel *idLabel = [view viewWithTag:view.tag+30];
        UIButton *coinBtn = [view viewWithTag:view.tag+40];
        UILabel *getStatusL = [view viewWithTag:view.tag+50];
        headImageView.image = nil;
        nameLabel.text = @"无";
        idLabel.text = @"ID：0";
        [coinBtn setTitle:@"0" forState:0];
        [coinBtn setImagePosition:0 spacing:8];
        getStatusL.text = @"未领取";
        getStatusL.textColor = UIColor.whiteColor;
        getStatusL.backgroundColor = XZRGB(0xC5AFFF);
    }
    _firstRankHandle = nil;
    _secondRankHandle = nil;
    _thirdRankHandle = nil;
}

- (void)setRankButtonType:(YLRankBtnType)buttonType {
//    _btnType = buttonType;
//    for (int i = 1; i < 4; i ++) {
//        UIView *view = [self viewWithTag:i*100];
//        UILabel *getStatusL = [view viewWithTag:view.tag+50];
//        getStatusL.hidden = YES;
//    }
//    NSDictionary *awardSetDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANKAWARDSETTING"];
//    if (awardSetDic) {
//        int glamour_day = [[NSString stringWithFormat:@"%@", awardSetDic[@"glamour_day"]] intValue];
//        int invite_day = [[NSString stringWithFormat:@"%@", awardSetDic[@"invite_day"]] intValue];
//        int wealth_day = [[NSString stringWithFormat:@"%@", awardSetDic[@"wealth_day"]] intValue];
//        int guard_day  = [[NSString stringWithFormat:@"%@", awardSetDic[@"guard_day"]] intValue];
//        UILabel *getStatusL_1 = [self viewWithTag:100+50];
//        UILabel *getStatusL_2 = [self viewWithTag:200+50];
//        UILabel *getStatusL_3 = [self viewWithTag:300+50];
//        if (self.rankListType == RankListTypeGoddess) {
//            if ((buttonType == YLRankBtnTypeYesterday && glamour_day)) {
//                if (_firstRankHandle) {
//                    getStatusL_1.hidden = NO;
//                    if (_secondRankHandle) {
//                        getStatusL_2.hidden = NO;
//                        if ((_thirdRankHandle)) {
//                            getStatusL_3.hidden = NO;
//                        }
//                    }
//                }
//            }
//        } else if (self.rankListType == RankListTypeInvited) {
//            if ((buttonType == YLRankBtnTypeYesterday && invite_day)) {
//                if (_firstRankHandle) {
//                    getStatusL_1.hidden = NO;
//                    if (_secondRankHandle) {
//                        getStatusL_2.hidden = NO;
//                        if ((_thirdRankHandle)) {
//                            getStatusL_3.hidden = NO;
//                        }
//                    }
//                }
//            }
//        } else if (self.rankListType == RankListTypeConsume) {
//            if ((buttonType == YLRankBtnTypeYesterday && wealth_day)) {
//                if (_firstRankHandle) {
//                    getStatusL_1.hidden = NO;
//                    if (_secondRankHandle) {
//                        getStatusL_2.hidden = NO;
//                        if ((_thirdRankHandle)) {
//                            getStatusL_3.hidden = NO;
//                        }
//                    }
//                }
//            }
//        } else if (self.rankListType == RankListTypeGuard) {
//            if ((buttonType == YLRankBtnTypeYesterday && guard_day)) {
//                if (_firstRankHandle) {
//                    getStatusL_1.hidden = NO;
//                    if (_secondRankHandle) {
//                        getStatusL_2.hidden = NO;
//                        if ((_thirdRankHandle)) {
//                            getStatusL_3.hidden = NO;
//                        }
//                    }
//                }
//            }
//        }
//    }
}

#pragma mark - func
- (void)buttonTypeChanged:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [self viewWithTag:1000+i];
        [btn setTitleColor:XZRGB(0x333333) forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    [sender setTitleColor:XZRGB(0xfe2947) forState:0];
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [UIView animateWithDuration:0.5 animations:^{
        self->btnLine.x = sender.x+(sender.width/2)-8;
    }];
    
    YLRankBtnType type = YLRankBtnTypeDay;
//    if (sender.tag == 1000) {
//        type = YLRankBtnTypeYesterday;
//    } else
        if (sender.tag == 1000) {
        type = YLRankBtnTypeDay;
    } else if (sender.tag == 1001) {
        type = YLRankBtnTypeWeek;
    } else if (sender.tag == 1002) {
        type = YLRankBtnTypeMonth;
    }
    [self setRankButtonType:type];
    if (self.headerTypeButtonClick) {
        
        self.headerTypeButtonClick((int)type);
    }
}

- (void)headImageViewClick:(UITapGestureRecognizer *)tap {
    if (_rankListType == RankListTypeInvited) return;
    
    if (tap.view.tag == 110 && _firstRankHandle) {
        if (_firstRankHandle.t_rank_switch) {
            [self showMysteriousView];
            return;
        }
        if (_firstRankHandle.t_role == 1) {
            [YLPushManager pushAnchorDetail:_firstRankHandle.t_id];
        } else {
            [YLPushManager pushFansDetail:_firstRankHandle.t_id];
        }
    } else if (tap.view.tag == 210 && _secondRankHandle) {
        if (_secondRankHandle.t_rank_switch) {
            [self showMysteriousView];
            return;
        }
        if (_secondRankHandle.t_role == 1) {
            [YLPushManager pushAnchorDetail:_secondRankHandle.t_id];
        } else {
            [YLPushManager pushFansDetail:_secondRankHandle.t_id];
        }
    } else if (tap.view.tag == 310 && _thirdRankHandle) {
        if (_thirdRankHandle.t_rank_switch) {
            [self showMysteriousView];
            return;
        }
        if (_thirdRankHandle.t_role == 1) {
            [YLPushManager pushAnchorDetail:_thirdRankHandle.t_id];
        } else {
            [YLPushManager pushFansDetail:_thirdRankHandle.t_id];
        }
    }
}

- (void)showMysteriousView {
    MysteriousView *view = [[MysteriousView alloc] init];
    [view show];
}

- (void)coinButtonClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    rankingHandle *handle;
    if (sender.tag == 140 && _firstRankHandle) {
        handle = _firstRankHandle;
    } else if (sender.tag == 240 && _secondRankHandle) {
        handle = _secondRankHandle;
    } else if (sender.tag == 340 && _thirdRankHandle) {
        handle = _thirdRankHandle;
    }
    if (self.coinButtonClickBlock && handle) {
        self.coinButtonClickBlock(handle);
    }
}

#pragma mark - subViews
- (void)setSubViews {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    if (_rankListType == RankListTypeGoddess || _rankListType == RankListTypeConsume) {
        bgImageView.image = [UIImage imageNamed:@"rank_header_nsbg"];
    } else {
        bgImageView.image = [UIImage imageNamed:@"rank_header_thbg"];
    }
    [self addSubview:bgImageView];
    
    UIView *firstView = [self rankViewWithX:(self.width-130)/2 Y:SafeAreaTopHeight+5 rank:1];
    [self addSubview:firstView];
    
    UIView *secondView = [self rankViewWithX:firstView.x-130+10 Y:firstView.y+17 rank:2];
    [self addSubview:secondView];
    
    UIView *thirdView = [self rankViewWithX:CGRectGetMaxX(firstView.frame)-10 Y:secondView.y rank:3];
    [self addSubview:thirdView];
    
    NSArray *titleArr = @[@"日榜", @"周榜", @"月榜"];
    CGFloat width = (App_Frame_Width-30)/titleArr.count;
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *btn = [UIManager initWithButton:CGRectMake(15+width*i, self.height-60, width, 30) text:titleArr[i] font:15 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(buttonTypeChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (i == 0) {
            [btn setTitleColor:XZRGB(0xfe2947) forState:0];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            
            btnLine = [[UIView alloc] initWithFrame:CGRectMake(btn.x+(btn.width/2)-8, btn.y+30, 16, 3)];
            btnLine.backgroundColor = XZRGB(0xfe2947);
            btnLine.layer.masksToBounds = YES;
            btnLine.layer.cornerRadius = 1.5;
            [self addSubview:btnLine];
        }
    }
}

- (UIView *)rankViewWithX:(CGFloat)x Y:(CGFloat)y rank:(int)rank {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, 130, 200)];
    view.backgroundColor = UIColor.clearColor;
    view.tag = rank*100;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35, 130, 165)];
    bgImageView.image = [UIImage imageNamed:@"rank_header_rankbg"];
    [view addSubview:bgImageView];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((view.width-55)/2, 35-22.5, 55, 55)];
    headImageView.tag = view.tag+10;
    headImageView.backgroundColor = UIColor.whiteColor;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 27.5;
    headImageView.layer.borderWidth = 2;
    [view addSubview:headImageView];
    headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewClick:)];
    [headImageView addGestureRecognizer:tap];
    
    UIImageView *crown = [[UIImageView alloc] initWithFrame:CGRectMake((view.width-28)/2, headImageView.y-16, 28, 28)];
    [view addSubview:crown];
    
    UIImageView *flower = [[UIImageView alloc] initWithFrame:CGRectMake((view.width-88)/2, headImageView.y-1, 88, 80)];
    [view addSubview:flower];
    
    UILabel *nameLabel = [UIManager initWithLabel:CGRectMake(15, CGRectGetMaxY(flower.frame), view.width-30, 20) text:@"无" font:15 textColor:XZRGB(0x333333)];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.tag = view.tag+20;
    [view addSubview:nameLabel];
    
    UILabel *idLabel = [UIManager initWithLabel:CGRectMake(15, CGRectGetMaxY(nameLabel.frame), view.width-30, 20) text:@"ID：0" font:12 textColor:XZRGB(0x868686)];
    idLabel.tag = view.tag+30;
    [view addSubview:idLabel];
    
    
    UIButton *coinBtn = [UIManager initWithButton:CGRectMake(0, CGRectGetMaxY(idLabel.frame), view.width, 30) text:@"0" font:12 textColor:XZRGB(0xfe2947) normalImg:nil highImg:nil selectedImg:nil];
    coinBtn.tag = view.tag+40;
    [coinBtn setImagePosition:0 spacing:8];
    [coinBtn addTarget:self action:@selector(coinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:coinBtn];
    if (_rankListType == RankListTypeGoddess) {
        [coinBtn setImage:[UIImage imageNamed:@"rank_cell_fire"] forState:0];
        coinBtn.userInteractionEnabled = YES;
    } else {
        [coinBtn setImage:[UIImage imageNamed:@"rank_cell_diamond"] forState:0];
        coinBtn.userInteractionEnabled = NO;
    }
    
    UILabel *getStatusL = [UIManager initWithLabel:CGRectMake((view.width-46)/2, CGRectGetMaxY(coinBtn.frame), 46, 20) text:@"未领取" font:11 textColor:UIColor.whiteColor];
    getStatusL.backgroundColor = XZRGB(0xC5AFFF);
    getStatusL.hidden = YES;
    getStatusL.tag = view.tag+50;
    getStatusL.layer.masksToBounds = YES;
    getStatusL.layer.cornerRadius = 10;
    [view addSubview:getStatusL];
    
    if (rank == 1) {
        headImageView.layer.borderColor = XZRGB(0xf0dd21).CGColor;
        crown.image = [UIImage imageNamed:@"renk_header_first"];
        flower.image = [UIImage imageNamed:@"rank_img_first"];
    } else if (rank == 2) {
        headImageView.layer.borderColor = XZRGB(0xc8c8c8).CGColor;
        crown.image = [UIImage imageNamed:@"rank_header_second"];
        flower.image = [UIImage imageNamed:@"rank_img_second"];
    } else if (rank == 3) {
        headImageView.layer.borderColor = XZRGB(0xc39191).CGColor;
        crown.image = [UIImage imageNamed:@"rank_header_third"];
        flower.image = [UIImage imageNamed:@"rank_img_third"];
    }
    return view;
}

@end
