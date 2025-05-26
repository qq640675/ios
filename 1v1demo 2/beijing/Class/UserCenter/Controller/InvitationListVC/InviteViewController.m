//
//  InviteViewController.m
//  Qiaqia
//
//  Created by 刘森林 on 2020/9/27.
//  Copyright © 2020 yiliaogaoke. All rights reserved.
//

#import "InviteViewController.h"
#import "InviteSonViewController.h"
#import "ShareActionView.h"
#import "MyInvitedViewController.h"

@interface InviteViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel   *contentLb;

@property (nonatomic, strong) UILabel   *coinLb;

@property (nonatomic, strong) UILabel   *numberLb;

@property (nonatomic, strong) UIButton   *groupAnimationBtn;

@property (nonatomic, strong) UIButton   *groupBtn;

@end

@implementation InviteViewController

#pragma mark - VC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UI
- (void)setupUI {
    
    self.navigationItem.title = @"邀请好友";
    
//    UIButton *topBtn = [UIManager initWithButton:CGRectMake(7.5, 10+NAVIGATIONBAR_HEIGHT, APP_FRAME_WIDTH-15, 100) text:nil font:14.0f textColor:XZRGB(0x333333) normalBackGroudImg:@"PersonCenter_invite_top" highBackGroudImg:nil selectedBackGroudImg:nil];
//    [topBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:topBtn];

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(16, 24+NAVIGATIONBAR_HEIGHT, APP_FRAME_WIDTH-32, 168)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.masksToBounds = YES;
    topView.layer.cornerRadius  = 8;
    [self.view addSubview:topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedBtn)];
    [topView addGestureRecognizer:tap];
    
    UIImageView *topBgImageView = [[UIImageView alloc] initWithImage:SLImageName(@"PersonCenter_invite_top_bg")];
    [topView addSubview:topBgImageView];
    [topBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.centerY.equalTo(topView);
    }];
    
//    UILabel *detailLb = [UIManager initWithLabel:CGRectZero text:@"我的邀请" font:14 textColor:XZRGB(0xFF579D)];
//    [topView addSubview:detailLb];
//    [detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(3);
//        make.centerX.equalTo(topView);
//    }];
    
    UIView *topLine1 = [[UIView alloc] init];
    topLine1.backgroundColor = XZRGB(0xe9e9e9);
    [topView addSubview:topLine1];
    [topLine1 mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(57);
        make.width.offset(1);
        make.centerX.equalTo(topView);
        make.height.offset(40);
    }];
    
    UILabel *leftLb = [UIManager initWithLabel:CGRectZero text:@"累积邀请（人数）" font:13 textColor:XZRGB(0x333333)];
    [topView addSubview:leftLb];
    [leftLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.top.mas_equalTo(58);
    }];

    self.numberLb = [UIManager initWithLabel:CGRectZero text:@"0" font:14 textColor:XZRGB(0xFF579D)];
    _numberLb.font = [UIFont boldSystemFontOfSize:14];
    [topView addSubview:_numberLb];
    [_numberLb mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(leftLb);
        make.top.mas_equalTo(85);
    }];

    UILabel *rightLb = [UIManager initWithLabel:CGRectZero text:@"累积奖励（金币）" font:13 textColor:XZRGB(0x333333)];
    [topView addSubview:rightLb];
    [rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-35);
        make.top.mas_equalTo(58);
    }];

    self.coinLb = [UIManager initWithLabel:CGRectZero text:@"0" font:18 textColor:XZRGB(0xFF579D)];
    _coinLb.font = [UIFont boldSystemFontOfSize:14];
    [topView addSubview:_coinLb];
    [_coinLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightLb);
        make.top.mas_equalTo(85);
    }];
    
    UILabel *detailLb1 = [UIManager initWithLabel:CGRectZero text:@"邀请详情" font:11 textColor:XZRGB(0x999999)];
    [topView addSubview:detailLb1];
    [detailLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-17);
        make.centerX.equalTo(topView);
    }];
    

    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:SLImageName(@"newcenter_img_jt")];//Common_next
    [topView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(detailLb1);
        make.left.equalTo(detailLb1.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(topBgImageView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(APP_FRAME_WIDTH-32, APP_FRAME_HEIGHT-NAVIGATIONBAR_HEIGHT-330));
    }];
    
    UIImageView *topBgImageView1 = [[UIImageView alloc] initWithImage:SLImageName(@"PersonCenter_invite_top_bg1")];
    topBgImageView1.image = [topBgImageView1.image resizableImageWithCapInsets:UIEdgeInsetsMake(80, 80, 80, 80) resizingMode:UIImageResizingModeStretch];
    [bgView addSubview:topBgImageView1];
    [topBgImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(-10);
    }];
    
    UILabel *detailLb2 = [UIManager initWithLabel:CGRectZero text:@"奖励内容" font:14 textColor:XZRGB(0xFF579D)];
    [bgView addSubview:detailLb2];
    [detailLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.centerX.equalTo(bgView);
    }];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((APP_FRAME_WIDTH-327)/2, 50, 295, APP_FRAME_HEIGHT-430-NAVIGATIONBAR_HEIGHT)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(295, 100);
    [bgView addSubview:_scrollView];

    self.contentLb = [UIManager initWithLabel:CGRectZero text:@"" font:13 textColor:XZRGB(0xFF579D)];
    _contentLb.textAlignment = NSTextAlignmentLeft;
    _contentLb.numberOfLines = 0;
    _contentLb.adjustsFontSizeToFitWidth = YES;
    _contentLb.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_scrollView addSubview:_contentLb];
    [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(0);
//        make.left.equalTo(self.scrollView).offset(0);
//        make.right.equalTo(bgView.mas_right).offset(0);
        make.width.mas_equalTo(295);
        make.centerX.mas_equalTo(self.scrollView.mas_centerX);
    }];

    UIButton *sureBtn = [UIManager initWithButton:CGRectZero text:@"立即邀请" font:17 textColor:UIColor.whiteColor normalBackGroudImg:@"insufficient_coin_pay" highBackGroudImg:nil selectedBackGroudImg:nil];
    [sureBtn addTarget:self action:@selector(clickedSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(300, 55));
    }];

    
//    self.groupAnimationBtn = [UIManager initWithButton:CGRectMake(APP_FRAME_WIDTH - 90, 100+NAVIGATIONBAR_HEIGHT, 68, 78) text:nil font:16 textColor:nil normalImg:@"PersonCenter_invite_btn_jiang" highImg:nil selectedImg:nil];
//    [self.view addSubview:_groupAnimationBtn];
//
//    self.groupBtn = [UIManager initWithButton:CGRectMake(APP_FRAME_WIDTH - 90, 100+NAVIGATIONBAR_HEIGHT, 68, 78) text:nil font:16 textColor:nil normalImg:nil highImg:nil selectedImg:nil];
//    [_groupBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_groupBtn];
//
//    [self addGroupBtnAnimation];
    
    [self getDataWithShare];
    
}

- (void)addGroupBtnAnimation {
    [UIView animateWithDuration:.6 animations:^{
        self.groupAnimationBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {

        [UIView animateWithDuration:.6 animations:^{
            self.groupAnimationBtn.transform = CGAffineTransformIdentity;
            
        }];
        [self performSelector:@selector(addGroupBtnAnimation) withObject:nil afterDelay:.6];
        
    }];
}

#pragma mark - Net
- (void)getDataWithShare {
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [YLNetworkInterface getShareTotal:[YLUserDefault userDefault].t_id block:^(shareEarnHandle *handle) {

        self.coinLb.text = [NSString stringWithFormat:@"%.1f", handle.profitTotal];
        self.numberLb.text = [NSString stringWithFormat:@"%d",handle.oneSpreadCount + handle.twoSpreadCount];
        
        [self getDataWithRule];
        
    }];
}

- (void)getDataWithRule {
    [YLNetworkInterface getSpreadAward:[YLUserDefault userDefault].t_id block:^(NSString *t_award_rule) {
        if (![NSString isNullOrEmpty:t_award_rule]) {
            CGFloat height = [ToolManager getHeightWithText:t_award_rule font:[UIFont systemFontOfSize:15] maxWidth:295];
            self.scrollView.contentSize = CGSizeMake(295, height+30);
            self.contentLb.text = t_award_rule;
        }
    }];
    
}

- (void)clickedBtn:(UIButton *)btn {
    InviteSonViewController *sonVC = [[InviteSonViewController alloc] init];
    [self.navigationController pushViewController:sonVC animated:YES];
}

- (void)clickedBtn {
    // 我的邀请
    MyInvitedViewController *myInvite = [[MyInvitedViewController alloc] init];
    [self.navigationController pushViewController:myInvite animated:YES];
}

- (void)clickedSureBtn {
    
    ShareActionView *shareView = [[ShareActionView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height) shareTitle:@"【新游山】与真人美女零距离互动" shareContent:@"玩嗨同城附近" shareImage:[UIImage imageNamed:@"logo60"] shareLink:(NSString *)[SLDefaultsHelper getSLDefaults:@"common_share_url"]];
    [shareView show];
    
}


@end
