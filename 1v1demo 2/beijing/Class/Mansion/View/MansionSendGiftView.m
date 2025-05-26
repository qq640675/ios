//
//  MansionSendGiftView.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/13.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionSendGiftView.h"
#import "giftListHandle.h"
#import "YLRechargeVipController.h"
#import "YLTapGesture.h"
#import "YLBasicView.h"
#import "YLInsufficientManager.h"
#import "YLJsonExtension.h"
#import "MansionMessageModel.h"
#import "MoreGiftNumberView.h"

@implementation MansionSendGiftView
{
    NSArray *userInfoArray;
    TIMConversation *conversation;
    NSMutableArray *selectedUserIdArray;
    
    UIView *userHeadView;
    UILabel *titleL;
    UIScrollView *headScr;
    
    UIView *lastTapView;
    UIView *giftView;
    UIScrollView *giftScr;
    UIPageControl *pagePoint;
    NSArray *giftListArray;
    UILabel *myCoinLabel;
    
    BOOL isPlayGiftGif;//是否播放礼物特效
    giftListHandle *selectedGiftHandle;
    
    int giftNum;
    UIView *buttonBGView;
    UIButton *sendBtn;
    UIButton *numberBtn;
    UIView *moreNumberView;
    UIScrollView *moreNumberScroll;
    NSMutableArray *twoGiftList;
}

#pragma mark - init
static MansionSendGiftView *giftView = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareView {
    dispatch_once(&onceToken, ^{
        giftView = [[MansionSendGiftView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
        giftView.backgroundColor = UIColor.clearColor;
        giftView.hidden = YES;
        [giftView setSubViews];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:giftView];
    });
    return giftView;
}

- (void)showWithUserArray:(NSArray *)userArray isShowHead:(BOOL)isShowHead {
    if (userArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"对方id异常"];
        return;
    }
    [self setDefault];
    self.hidden = NO;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window bringSubviewToFront:self];
    userInfoArray = userArray;
    [self setHeadViewDataIsShowHead:isShowHead];
    [self requestGiftListData];
    [self requestMyData];
}

- (void)showWithUserArray:(NSArray *)userArray isShowHead:(BOOL)isShowHead conversasion:(TIMConversation *)conv {
    [self showWithUserArray:userArray isShowHead:isShowHead];
    conversation = conv;
}

- (void)showWithUserId:(NSInteger)userId isPlayGif:(BOOL)isPlayGif {
    [self showWithUserArray:@[[NSString stringWithFormat:@"%ld", userId]] isShowHead:NO];
    isPlayGiftGif = isPlayGif;
}

- (void)setDefault {
    userInfoArray = nil;
    conversation = nil;
    selectedUserIdArray = [NSMutableArray array];
    selectedGiftHandle = nil;
    [giftScr.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [headScr.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    myCoinLabel.text = @"可用金币：0";
    userHeadView.hidden = YES;
    titleL.hidden = NO;
    isPlayGiftGif = NO;
    
    moreNumberView.hidden = YES;
    giftNum = 1;
    buttonBGView.width = 130;
    buttonBGView.x = giftView.width - buttonBGView.width - 10;
    [numberBtn setTitle:@"1" forState:0];
//    [numberBtn setImage:nil forState:0];
//    [numberBtn setImagePosition:LXMImagePositionRight spacing:0];
    [numberBtn setImage:[UIImage imageNamed:@"gift_top_jt"] forState:0];
    [numberBtn setImagePosition:LXMImagePositionRight spacing:7];
}

#pragma mark - setSubViews
- (void)setSubViews {
    [self setGrayView];
    [self setGiftBgView];
    [self setUserView];
}

- (void)setGiftBgView {
    CGFloat safeBottomHeight = SafeAreaBottomHeight-49;
    CGFloat height = safeBottomHeight + 300;
    giftView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-height, App_Frame_Width, height)];
    giftView.backgroundColor = UIColor.whiteColor;
    giftView.clipsToBounds = YES;
    [self addSubview:giftView];
    
    giftScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 8, App_Frame_Width, 212)];
    giftScr.showsHorizontalScrollIndicator = NO;
    giftScr.bounces = NO;
    giftScr.pagingEnabled = YES;
    giftScr.delegate = self;
    giftScr.clipsToBounds = YES;
    giftScr.backgroundColor = UIColor.whiteColor;
    [giftView addSubview:giftScr];
    
    pagePoint = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(giftScr.frame)+8, App_Frame_Width, 25)];
    pagePoint.pageIndicatorTintColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    pagePoint.currentPageIndicatorTintColor = [XZRGB(0xAE4FFD) colorWithAlphaComponent:0.5];
    [giftView addSubview:pagePoint];
    
    myCoinLabel = [UIManager initWithLabel:CGRectMake(10, 300-45, 140, 30) text:@"可用金币：0" font:15 textColor:XZRGB(0x333333)];
    myCoinLabel.textAlignment = NSTextAlignmentLeft;
    [giftView addSubview:myCoinLabel];
    
    UIButton *rechargeBtn = [UIManager initWithButton:CGRectMake(CGRectGetMaxX(myCoinLabel.frame)+5, 300-45, 60, 30) text:@"充值>>" font:15 textColor:XZRGB(0xae4ffd) normalImg:nil highImg:nil selectedImg:nil];
    [rechargeBtn addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [giftView addSubview:rechargeBtn];
    
    buttonBGView = [[UIView alloc] initWithFrame:CGRectMake(App_Frame_Width-130, 300-45, 130, 30)];
    buttonBGView.layer.masksToBounds = YES;
    buttonBGView.layer.cornerRadius = 15;
    buttonBGView.layer.borderWidth = 1;
    buttonBGView.layer.borderColor = XZRGB(0xFC6EF1).CGColor;
    buttonBGView.backgroundColor = XZRGB(0xFC6EF1);
    [giftView addSubview:buttonBGView];
    
    sendBtn = [UIManager initWithButton:CGRectZero text:@"打赏" font:15 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    [sendBtn addTarget:self action:@selector(sendGift:) forControlEvents:UIControlEventTouchUpInside];
    [buttonBGView addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(65);
    }];
    
    numberBtn = [UIManager initWithButton:CGRectZero text:@"1" font:15 textColor:UIColor.blackColor normalImg:nil highImg:nil selectedImg:nil];
    numberBtn.backgroundColor = UIColor.whiteColor;
//    numberBtn.userInteractionEnabled = NO;
    [numberBtn setImage:[UIImage imageNamed:@"gift_top_jt"] forState:0];
    [numberBtn setImagePosition:LXMImagePositionRight spacing:7];
    [numberBtn addTarget:self action:@selector(numberButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonBGView addSubview:numberBtn];
    [numberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self->sendBtn.mas_left);
    }];
    
    moreNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, giftView.width, giftView.height)];
    moreNumberView.backgroundColor = UIColor.clearColor;
    moreNumberView.hidden = YES;
    [giftView addSubview:moreNumberView];
    
    UIView *tapV = [[UIView alloc] initWithFrame:moreNumberView.bounds];
    tapV.backgroundColor = UIColor.clearColor;
    [moreNumberView addSubview:tapV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreNumberViewDismiss)];
    [tapV addGestureRecognizer:tap];
    
    UIView *moreNumberImageView = [[UIView alloc] initWithFrame:CGRectMake(moreNumberView.width-123, 10, 113, 240)];
    moreNumberImageView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.95];
    moreNumberImageView.layer.masksToBounds = YES;
    moreNumberImageView.layer.cornerRadius = 6;
    moreNumberImageView.layer.borderWidth = 0.5;
    moreNumberImageView.layer.borderColor = XZRGB(0xF2F3F7).CGColor;
    [moreNumberView addSubview:moreNumberImageView];
    
//    UILabel *jtL = [UIManager initWithLabel:CGRectMake(moreNumberImageView.x, CGRectGetMaxY(moreNumberImageView.frame)-6, moreNumberImageView.width, 20) text:@"▼" font:20 textColor:[UIColor.blackColor colorWithAlphaComponent:0.87]];
//    [moreNumberView addSubview:jtL];
    
    UILabel *otherL = [UIManager initWithLabel:CGRectMake(0, 0, moreNumberImageView.width, 35) text:@"自定义" font:15 textColor:XZRGB(0x999999)];
    [moreNumberImageView addSubview:otherL];
    UITapGestureRecognizer *otherTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(writeGiftNumer)];
    otherL.userInteractionEnabled = YES;
    [otherL addGestureRecognizer:otherTap];
    
    moreNumberScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 35, 100, 205)];
    moreNumberScroll.backgroundColor = UIColor.clearColor;
    moreNumberScroll.bounces = NO;
    moreNumberScroll.contentSize = CGSizeMake(moreNumberScroll.width, moreNumberScroll.height);
    [moreNumberImageView addSubview:moreNumberScroll];
    
    twoGiftList = [NSMutableArray array];
}

- (void)setUserView {
    titleL = [UIManager initWithLabel:CGRectMake(0, APP_Frame_Height-giftView.height-35, App_Frame_Width, 35) text:@"礼物" font:15 textColor:XZRGB(0x333333)];
    titleL.backgroundColor = UIColor.whiteColor;
    titleL.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:titleL];
    
    userHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-giftView.height-50, App_Frame_Width, 50)];
    userHeadView.backgroundColor = XZRGB(0xf2f3f7);
    userHeadView.hidden = YES;
    userHeadView.clipsToBounds = YES;
    [self addSubview:userHeadView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:userHeadView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = userHeadView.bounds;
    maskLayer.path = maskPath.CGPath;
    userHeadView.layer.mask = maskLayer;
    
    UILabel *label = [UIManager initWithLabel:CGRectMake(0, 0, 65, 50) text:@"打赏给：" font:12 textColor:XZRGB(0x333333)];
    [userHeadView addSubview:label];
    
    UIButton *closeBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-40, 4, 40, 40) text:@"" font:1 textColor:nil normalImg:@"mansion_alert_close" highImg:nil selectedImg:nil];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [userHeadView addSubview:closeBtn];
    
    headScr = [[UIScrollView alloc] initWithFrame:CGRectMake(65, 5, App_Frame_Width-110, 40)];
    headScr.backgroundColor = UIColor.clearColor;
    headScr.showsHorizontalScrollIndicator = NO;
    [userHeadView addSubview:headScr];
}

- (void)setGrayView {
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    grayView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
    [self addSubview:grayView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [grayView addGestureRecognizer:tap];
}

#pragma mark - net
- (void)requestGiftListData {
    [YLNetworkInterface getGiftList:^(NSMutableArray *listArray) {
        if (listArray.count == 0) return;
        self->giftListArray = listArray;
        [self setGiftItemWithGiftArray:listArray];
    }];
}

- (void)requestMyData {
    [YLNetworkInterface getUserMoney:[YLUserDefault userDefault].t_id block:^(myPurseHandle *handle) {
        self->myCoinLabel.text = [NSString stringWithFormat:@"可用金币：%@",handle.amount];
    }];
}

#pragma mark - head item
- (void)setHeadViewDataIsShowHead:(BOOL)isShowHead {
    userHeadView.hidden = !isShowHead;
    titleL.hidden = isShowHead;
    
    if (isShowHead) {
        for (int i = 0; i < userInfoArray.count; i++) {
            NSDictionary *dic = userInfoArray[i];
            NSString *t_id = [NSString stringWithFormat:@"%@", dic[@"t_id"]];
            if (![selectedUserIdArray containsObject:t_id]) {
                [selectedUserIdArray addObject:t_id];
            }
            
            NSString *headImagePath = [NSString stringWithFormat:@"%@", dic[@"t_handImg"]];
            UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55*i, 0, 40, 40)];
            [headImageView sd_setImageWithURL:[NSURL URLWithString:headImagePath] placeholderImage:[UIImage imageNamed:@"loading"]];
            headImageView.contentMode = UIViewContentModeScaleAspectFill;
            headImageView.layer.masksToBounds = YES;
            headImageView.layer.cornerRadius = 20;
            headImageView.layer.borderWidth = 2;
            headImageView.layer.borderColor = XZRGB(0xae4ffd).CGColor;
            [headScr addSubview:headImageView];
            
            headImageView.tag = 1000+i;
            headImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewClick:)];
            [headImageView addGestureRecognizer:tap];
        }
        headScr.contentSize = CGSizeMake(55*userInfoArray.count, 50);
    } else {
        NSString *t_id = userInfoArray.firstObject;
        if (![selectedUserIdArray containsObject:t_id]) {
            [selectedUserIdArray addObject:t_id];
        }
    }
    
}

- (void)headImageViewClick:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 1000;
    if (userInfoArray.count > index) {
        NSDictionary *dic = userInfoArray[index];
        NSString *t_id = [NSString stringWithFormat:@"%@", dic[@"t_id"]];
        if ([selectedUserIdArray containsObject:t_id]) {
            [selectedUserIdArray removeObject:t_id];
            UIImageView *headImageView = (UIImageView *)tap.view;
            headImageView.layer.borderColor = UIColor.clearColor.CGColor;
        } else {
            [selectedUserIdArray addObject:t_id];
            UIImageView *headImageView = (UIImageView *)tap.view;
            headImageView.layer.borderColor = XZRGB(0xae4ffd).CGColor;
        }
    }
}

#pragma mark - gift item
- (void)setGiftItemWithGiftArray:(NSArray *)array {
    float itemWidth = (App_Frame_Width/4);
    float itemHeight = (212/2);
    
    NSInteger totlePage = (array.count+7)/8;
    pagePoint.numberOfPages = totlePage;
    
    for (int i = 0; i < totlePage; i ++) {
        UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(App_Frame_Width*i, 0, App_Frame_Width, 212)];
        pageView.backgroundColor = UIColor.whiteColor;
        [giftScr addSubview:pageView];
        for (int j = 0; j < 8; j ++) {
            int tag = i*8+j;
            if (array.count > tag) {
                giftListHandle *handle = array[tag];
                UIView *giftBgView = [UIView new];
                giftBgView.frame = CGRectMake(itemWidth*(j%4), itemHeight*(j/4), itemWidth, itemHeight);
                giftBgView.backgroundColor = UIColor.whiteColor;
                giftBgView.userInteractionEnabled = YES;
                giftBgView.tag = 100+tag;
                giftBgView.layer.masksToBounds = YES;
                giftBgView.layer.borderWidth = 0.5;
                giftBgView.layer.borderColor = XZRGB(0xcccccc).CGColor;
                [YLTapGesture tapGestureTarget:self sel:@selector(giftViewTap:) view:giftBgView];
                [pageView addSubview:giftBgView];
                
                UIImageView *giftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(giftBgView.frame.size.width/2. - 23, 13, 46, 46)];
                if (![NSString isNullOrEmpty:handle.t_gift_still_url]) {
                    [giftImgView sd_setImageWithURL:[NSURL URLWithString:handle.t_gift_still_url] placeholderImage:[UIImage imageNamed:@"loading"]];
                }
                [giftBgView addSubview:giftImgView];
                
                UILabel *giftNameLabel = [UIManager initWithLabel:CGRectMake(3, CGRectGetMaxY(giftImgView.frame)+9, itemWidth - 6, 10) text:handle.t_gift_name font:10 textColor:XZRGB(0x333333)];
                [giftBgView addSubview:giftNameLabel];
                
                UILabel *coinLabel = [UIManager initWithLabel:CGRectMake(3, CGRectGetMaxY(giftNameLabel.frame)+8, itemWidth-6, 10) text:[NSString stringWithFormat:@"%@金币",handle.t_gift_gold] font:8 textColor:XZRGB(0x999999)];
                [giftBgView addSubview:coinLabel];
            }
        }
    }
        
    if (array.count/8 == array.count/8.) {
        giftScr.contentSize = CGSizeMake(App_Frame_Width * array.count/8, 212);
    }else{
        giftScr.contentSize = CGSizeMake(App_Frame_Width * (array.count/8 + 1), 212);
    }
}

- (void)giftViewTap:(UITapGestureRecognizer *)tap {
    lastTapView.layer.borderWidth = 0.5;
    [lastTapView.layer setBorderColor:XZRGB(0xcccccc).CGColor];

    tap.view.layer.borderWidth = 1;
    [tap.view.layer setBorderColor:XZRGB(0xAE4FFD).CGColor];
    NSInteger index = tap.view.tag-100;
    if (giftListArray.count > index) {
        selectedGiftHandle = giftListArray[tap.view.tag-100];
        if (selectedGiftHandle.twoGiftList.count > 0) {
            twoGiftList = [NSMutableArray arrayWithArray:selectedGiftHandle.twoGiftList];
        } else {
            [twoGiftList removeAllObjects];;
        }
        [self setNumberViewContent];
    }
    lastTapView = tap.view;
}

- (void)setNumberViewContent {
    giftNum = 1;
    [moreNumberScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    [numberBtn setTitle:@"1" forState:0];
//    [numberBtn setImagePosition:LXMImagePositionRight spacing:0];
//    moreNumberView.hidden = YES;
//
//    if (twoGiftList.count == 0) {
//        numberBtn.userInteractionEnabled = NO;
//        [numberBtn setImage:nil forState:0];
//        [UIView animateWithDuration:0.3 animations:^{
//            self->buttonBGView.width = 130;
//            self->buttonBGView.x = self->giftView.width - self->buttonBGView.width - 10;
//            [self->numberBtn setTitle:@"1" forState:0];
//            [self->numberBtn setImagePosition:LXMImagePositionRight spacing:0];
//        }];
//        return;
//    }
//    numberBtn.userInteractionEnabled = YES;
//    [numberBtn setImage:[UIImage imageNamed:@"gift_top_jt"] forState:0];
//    [numberBtn setImagePosition:LXMImagePositionRight spacing:7];
    
//    [UIView animateWithDuration:0.3 animations:^{
//        self->buttonBGView.width = 130;
//        self->buttonBGView.x = self->giftView.width - self->buttonBGView.width - 10;
//    }];
    
    CGFloat lineHeight = 35;
    CGFloat height = twoGiftList.count*lineHeight;
    
    if (height > moreNumberScroll.height) {
        moreNumberScroll.contentSize = CGSizeMake(moreNumberScroll.width, height);
    }
    for (int i = 0; i < twoGiftList.count; i ++) {
        NSDictionary *dic = twoGiftList[i];
//        NSString *title = [NSString stringWithFormat:@"%@  %@", dic[@"t_two_gift_name"], dic[@"t_two_gift_number"]];
        NSString *title = [NSString stringWithFormat:@"%@", dic[@"t_two_gift_number"]];
        UIButton *btn = [UIManager initWithButton:CGRectMake(0, lineHeight*i, moreNumberScroll.width, lineHeight) text:title font:15 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        btn.tag = 1234+i;
        [btn addTarget:self action:@selector(moreViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [moreNumberScroll addSubview:btn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, lineHeight*i, moreNumberScroll.width, 0.5)];
        line.backgroundColor = XZRGB(0xF2F3F7);
        [moreNumberScroll addSubview:line];
    }
}

- (void)moreNumberViewDismiss {
    moreNumberView.hidden = YES;
}

- (void)moreViewButtonClick:(UIButton *)sender {
    NSInteger index = sender.tag - 1234;
    if (twoGiftList.count > index) {
        NSDictionary *dic = twoGiftList[index];
        giftNum = [[NSString stringWithFormat:@"%@", dic[@"t_two_gift_number"]] intValue];
        [self setMoreButtonTitle:[NSString stringWithFormat:@"%d", giftNum]];
    }
    moreNumberView.hidden = YES;
}

- (void)setMoreButtonTitle:(NSString *)title {
    [numberBtn setTitle:title forState:0];
    [numberBtn setImagePosition:LXMImagePositionRight spacing:7];
    CGFloat width = [ToolManager getWidthWithText:[NSString stringWithFormat:@"%d", giftNum] font:[UIFont systemFontOfSize:15]];
    CGFloat btnWidth = width+100;
    if (btnWidth < 130) {
        btnWidth = 130;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self->buttonBGView.width = btnWidth;
        self->buttonBGView.x = self->giftView.width - self->buttonBGView.width - 10;
    }];
}

- (void)numberButtonClick:(UIButton *)sender {
    if (selectedGiftHandle == nil) {
        [SVProgressHUD showInfoWithStatus:@"请选选择一个礼物"];
        return;
    }
    moreNumberView.hidden = NO;
}

#pragma mark - 自定义数量
- (void)writeGiftNumer {
    [self moreNumberViewDismiss];
    MoreGiftNumberView *view = [[MoreGiftNumberView alloc] init];
    [view show];
    WEAKSELF;
    view.sureButtonClickBlock = ^(int number) {
        [weakSelf moreNumberText:number];
    };
}

- (void)moreNumberText:(int)number {
    giftNum = number;
    [self setMoreButtonTitle:[NSString stringWithFormat:@"%d", giftNum]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth) +1;
    [pagePoint setCurrentPage:page];
}

#pragma mark - func
- (void)dismiss {
    [moreNumberScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    moreNumberView.hidden = YES;
    self.hidden = YES;
}

- (void)rechargeButtonClick {
    [self dismiss];
    YLRechargeVipController *rechargeVC = [[YLRechargeVipController alloc] init];
    UIViewController *nowVC = [SLHelper getCurrentVC];
    [nowVC.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)sendGift:(UIButton *)sender {
    if (selectedUserIdArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请至少选择一个对象打赏礼物"];
        return;
    }
    
    if (selectedGiftHandle == nil) {
        [SVProgressHUD showInfoWithStatus:@"请先选择一个礼物"];
        return;
    }
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    CGFloat allGold = [selectedGiftHandle.t_gift_gold floatValue] * giftNum;
    if (allGold > 50000) {
        [LXTAlertView alertViewWithTitle:@"友情提示" message:@"你当前打赏的礼物超过500元，打赏后无法退回，请谨慎。" cancleTitle:@"取消" sureTitle:@"继续打赏" sureHandle:^{
            [self sendGiftRequest];
        }];
    } else {
        [self sendGiftRequest];
    }
    
}

- (void)sendGiftRequest {
    [SVProgressHUD show];
    NSString *ids = [selectedUserIdArray componentsJoinedByString:@","];
    
    [YLNetworkInterface userGiveGiftCoverConsumeUserIds:[NSString stringWithFormat:@"%@", ids] giftId:[selectedGiftHandle.t_gift_id intValue] giftNum:giftNum block:^(BOOL isSuccess) {
        [self dismiss];
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"打赏礼物成功"];
            if (self->isPlayGiftGif && self.playGiftGif) {
                self.playGiftGif(self->selectedGiftHandle.t_gift_gif_url);
            }
            if (self->conversation != nil) {
                for (int i = 0; i < self->selectedUserIdArray.count; i ++) {
                    NSString *t_id = self->selectedUserIdArray[i];
                    [self sendGiftMessageWithUserId:[t_id intValue]];
                }
            }
            if (self.videoChatSendGiftSuccess) {
                NSDictionary *dic = @{@"gift_id":[NSString stringWithFormat:@"%@", self->selectedGiftHandle.t_gift_id],
                                      @"gift_name":[NSString stringWithFormat:@"%@", self->selectedGiftHandle.t_gift_name],
                                      @"gift_still_url":[NSString stringWithFormat:@"%@", self->selectedGiftHandle.t_gift_still_url],
                                      @"gift_number":[NSString stringWithFormat:@"%d", self->giftNum]
                };
                self.videoChatSendGiftSuccess(dic);
            }
        }else{
            //余额不足
            [[YLInsufficientManager shareInstance] insufficientShow];
        }
    }];
}

- (void)sendGiftMessageWithUserId:(int)userId {
    NSString *otherName = [NSString stringWithFormat:@"%d", userId+10000];
    for (NSDictionary *dic in userInfoArray) {
        if ([[NSString stringWithFormat:@"%@", dic[@"t_id"]] intValue] == userId) {
            otherName = [NSString stringWithFormat:@"%@", dic[@"t_nickName"]];
        }
    }
    NSDictionary *param = @{@"messageType":@(MansionMessageTypeGift),
                            @"type":@"1",
                            @"gift_id":[NSString stringWithFormat:@"%@", selectedGiftHandle.t_gift_id],
                            @"gift_name":[NSString stringWithFormat:@"%@", selectedGiftHandle.t_gift_name],
                            @"gift_still_url":[NSString stringWithFormat:@"%@", selectedGiftHandle.t_gift_still_url],
                            @"gift_gif_url":[NSString stringWithFormat:@"%@", selectedGiftHandle.t_gift_gif_url],
                            @"gold_number":[NSString stringWithFormat:@"%@", selectedGiftHandle.t_gift_gold],
                            @"otherName":otherName,
                            @"nickName": [NSString stringWithFormat:@"%@", [YLUserDefault userDefault].t_nickName],
                            @"t_id":[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                            @"otherId":[NSString stringWithFormat:@"%d", userId]
    };
    
    NSString *jsonStr = [YLJsonExtension jsonStrWitNSDictonary:param];
    NSData *data =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];

    TIMCustomElem *customElem = [[TIMCustomElem alloc] init];
    [customElem setData:data];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:customElem];
    
    [conversation sendMessage:msg succ:^(){
        if (self.sendGiftIMMessageSeccess) {
            self.sendGiftIMMessageSeccess(param);
        }
    }fail:^(int code, NSString * err) {
//        NSString *error = [NSString stringWithFormat:@"出错了->code:%d,msg:%@",code,err];
//        NSLog(@"___mansion im send gift error:%@", error);
//        [LXTAlertView  alertViewDefaultOnlySureWithTitle:@"温馨提示" message:error];
    }];
}


@end
