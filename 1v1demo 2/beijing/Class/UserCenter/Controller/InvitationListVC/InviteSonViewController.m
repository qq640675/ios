//
//  InviteSonViewController.m
//  Qiaqia
//
//  Created by 刘森林 on 2020/12/15.
//  Copyright © 2020 yiliaogaoke. All rights reserved.
//

#import "InviteSonViewController.h"
#import "InviteSonItemView.h"
#import "PopPicViewController.h"

@interface InviteSonViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView    *bgView;

@property (nonatomic, strong) UILabel   *coinLb;

@property (nonatomic, strong) UILabel   *numberLb;
@property (nonatomic, copy) NSArray *redPacketArray;
@property (nonatomic, assign) NSInteger myInvitedNum;

@end

@implementation InviteSonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self requestMyInvitedMember];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - net
- (void)requestMyInvitedMember {
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [YLNetworkInterface getShareRewardConfigListSuccess:^(NSDictionary *dataDic) {
        if ([dataDic[@"shareRewardList"] isKindOfClass:[NSArray class]]) {
            self.redPacketArray = dataDic[@"shareRewardList"];
        } else {
            [SVProgressHUD showInfoWithStatus:@"获取红包列表失败"];
        }
        self.myInvitedNum = [[NSString stringWithFormat:@"%@",dataDic[@"shareRewardCount"]] integerValue];
        [self setupUI];
        self.coinLb.text = [NSString stringWithFormat:@"%@", dataDic[@"receiveAllGold"]];
        self.numberLb.text = [NSString stringWithFormat:@"%@",dataDic[@"shareRewardCount"]];
        
    }];
}

- (void)refreshMyInvitedMember {
    [YLNetworkInterface getShareRewardConfigListSuccess:^(NSDictionary *dataDic) {
        self.coinLb.text = [NSString stringWithFormat:@"%@", dataDic[@"receiveAllGold"]];
        self.numberLb.text = [NSString stringWithFormat:@"%@",dataDic[@"shareRewardCount"]];
    }];
}

#pragma mark - func
- (void)clickedBtn {
    PopPicViewController *vc = [[PopPicViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UI
- (void)setupUI {
    
    self.navigationItem.title = @"万元大奖";
//    self.view.backgroundColor = XZRGB(0xf5fdf3);
    
    int count = (int)self.redPacketArray.count;
    int jj = count/3;
    int gg = count%3;
    if (gg != 0) {
        jj++;
    }
    
    CGFloat allH = 700+jj*160;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-NAVIGATIONBAR_HEIGHT)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(APP_FRAME_WIDTH, allH+50);
    [self.view addSubview:_scrollView];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, allH)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bgView];
    
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 421)];
    topImageView.image = SLImageName(@"PersonCenter_invite_bg");
    [_bgView addSubview:topImageView];
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(7.5, 270, APP_FRAME_WIDTH-15, 145+jj*160)];
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.masksToBounds = YES;
    centerView.layer.cornerRadius = 8.0f;
    [_bgView addSubview:centerView];
    
    UIView *centerView1 = [[UIView alloc] init];
    centerView1.backgroundColor = [UIColor whiteColor];
    centerView1.layer.masksToBounds = YES;
    centerView1.layer.cornerRadius = 8.0f;
    centerView1.layer.borderWidth = 1.0f;
    centerView1.layer.borderColor = XZRGB(0xF91525).CGColor;
    [centerView addSubview:centerView1];
    [centerView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(7.5);
        make.right.bottom.mas_equalTo(-7.5);
    }];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:SLImageName(@"PersonCenter_invite_btn_bg")];
    [_bgView addSubview:tempImageView];
    [tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(centerView).offset(-13);
    }];
    
    UILabel *lb = [UIManager initWithLabel:CGRectZero text:@"额外大奖" font:18 textColor:XZRGB(0xBD010C)];
    [tempImageView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(tempImageView);
        make.centerX.mas_equalTo(tempImageView.mas_centerX);
        make.centerY.mas_equalTo(tempImageView.mas_centerY).offset(-10);
    }];
    
    UILabel *lb1 = [UIManager initWithLabel:CGRectZero text:@"具体规则：邀请用户在注册完成7天内累计充值≥300元算一个有效用户数，累计达到以下对应人数则奖励相应的金币。" font:14 textColor:XZRGB(0x666666)];
    lb1.textAlignment = NSTextAlignmentLeft;
    lb1.numberOfLines = 0;
    [centerView1 addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(40);
        make.right.mas_equalTo(-18);
    }];
    
    // ---------- 红包UI --------------------------
    CGFloat width = (APP_FRAME_WIDTH-30)/3;
    WEAKSELF;
    for (int i = 0; i < count; i++) {
        int j = i/3;
        int g = i%3;
        InviteSonItemView *itemView = [[InviteSonItemView alloc] initWithFrame:CGRectMake(g*width, 110+j*160, width, 160)];
        itemView.myInvitedNum = self.myInvitedNum;
        [centerView1 addSubview:itemView];
        NSDictionary *dic = self.redPacketArray[i];
        [itemView setRedPacketData:dic];
        itemView.getRedPacketSuccess = ^{
            [weakSelf refreshMyInvitedMember];
        };
    }
    // ------------------------------------
    
    UIButton *shareBtn = [UIManager initWithButton:CGRectZero text:nil font:14.0 textColor:XZRGB(0x333333) normalBackGroudImg:@"PersonCenter_invite_btn" highBackGroudImg:nil selectedBackGroudImg:nil];
    [shareBtn addTarget:self action:@selector(clickedBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
        make.size.mas_equalTo(CGSizeMake(316, 62));
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 8.0f;
    bottomView.layer.borderWidth = 1.0f;
    bottomView.layer.borderColor = XZRGB(0xF91525).CGColor;
    [_bgView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-88);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.offset(168);
    }];
    
    UIImageView *tempImageView1 = [[UIImageView alloc] initWithImage:SLImageName(@"PersonCenter_invite_btn_bg")];
    [_bgView addSubview:tempImageView1];
    [tempImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(bottomView).offset(-13);
    }];
    
    UILabel *lb3 = [UIManager initWithLabel:CGRectZero text:@"我的邀请" font:18 textColor:XZRGB(0xBD010C)];
    [tempImageView1 addSubview:lb3];
    [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(tempImageView1);
        make.centerX.mas_equalTo(tempImageView1.mas_centerX);
        make.centerY.mas_equalTo(tempImageView1.mas_centerY).offset(-10);
    }];
    
    UIView *topLine1 = [[UIView alloc] init];
    topLine1.backgroundColor = XZRGB(0xe9e9e9);
    [bottomView addSubview:topLine1];
    [topLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(67);
        make.width.offset(1);
        make.centerX.equalTo(bottomView);
        make.height.offset(40);
    }];
    
    UILabel *leftLb = [UIManager initWithLabel:CGRectZero text:@"额外邀请（达标人数）" font:13 textColor:XZRGB(0x666666)];
    [bottomView addSubview:leftLb];
    [leftLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.top.mas_equalTo(68);
    }];

    self.numberLb = [UIManager initWithLabel:CGRectZero text:@"0" font:14 textColor:XZRGB(0x333333)];
    _numberLb.font = [UIFont boldSystemFontOfSize:14];
    [bottomView addSubview:_numberLb];
    [_numberLb mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(leftLb);
        make.top.mas_equalTo(90);
    }];

    UILabel *rightLb = [UIManager initWithLabel:CGRectZero text:@"额外奖励（金币）" font:13 textColor:XZRGB(0x666666)];
    [bottomView addSubview:rightLb];
    [rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-35);
        make.top.mas_equalTo(68);
    }];

    self.coinLb = [UIManager initWithLabel:CGRectZero text:@"0" font:18 textColor:XZRGB(0x333333)];
    _coinLb.font = [UIFont boldSystemFontOfSize:14];
    [bottomView addSubview:_coinLb];
    [_coinLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightLb);
        make.top.mas_equalTo(90);
    }];
    
    UILabel *lb2 = [UIManager initWithLabel:CGRectZero text:@"此数据只统计当前奖励数据，并非所有邀请奖励。" font:12 textColor:XZRGB(0x999999)];
    [_bgView addSubview:lb2];
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(-55);
    }];
    
}



@end
