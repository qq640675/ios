//
//  NewPersonViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/19.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "NewPersonViewController.h"
#import "NewPersonHeadView.h"
#import "UIButton+LXMImagePosition.h"
#import "personalCenterHandle.h"
#import "MeDynamicViewController.h"
#import "YLSettingController.h"
#import "YLPushManager.h"
#import "YLRechargeVipController.h"
#import "YLNWithDrawController.h"
#import "YLNAccountBalanceController.h"
#import "MessageSettingViewController.h"
#import "DynamicSettingViewController.h"
#import "YLApplyUnionController.h"
#import "YLUnionController.h"
#import "DPScrollNumberLabel.h"
#import "YLNCertifyController.h"
#import "YLEditPersonalController.h"
#import "YLSetupChargingItemsController.h"
#import "YLCertifyNowController.h"
#import "HelpCenterViewController.h"
#import "IndentiViewController.h"
#import "FaceUnityViewController.h"
#import "MyInvitedViewController.h"
#import "AnchorAuthViewController.h"
#import "MineSwicthTableViewCell.h"
#import "YLEditPhoneController.h"
#import "BeautyViewController.h"

@interface NewPersonViewController ()
{
    UIScrollView *scrollView;
    NewPersonHeadView *headView;
    
    int balanceNum;
    int withdrawNum;
    BOOL isFirst;
    
    MineSwicthTableViewCell *videoCell;
    MineSwicthTableViewCell *chatCell;
    MineSwicthTableViewCell *ppCell; //飘屏
    MineSwicthTableViewCell *rankCell;
}
//个人数据
@property (nonatomic, strong) personalCenterHandle      *personHandle;
@property (nonatomic, strong) UIView *balanceBGView;
@property (nonatomic, strong) DPScrollNumberLabel *balanceLabel;
@property (nonatomic, strong) UIView *withdrawBGView;
@property (nonatomic, strong) DPScrollNumberLabel *withdrawLabel;
@property (nonatomic, assign) int authenticationStatus;
@property (nonatomic, strong) UIButton *anchorBtn;


@end

@implementation NewPersonViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    isFirst = YES;
    [self setSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self getDataWithPerson];
    [self getDataWithAuthentication];
    [self getDataWithAnchorAddGuild];
    
    //防止接口限制
    [self performSelector:@selector(getDataWithRedPackage) withObject:nil afterDelay:1.0];
    
}

#pragma mark - net
- (void)getDataWithPerson {
    [YLNetworkInterface index:[YLUserDefault userDefault].t_id block:^(personalCenterHandle *handle) {
        [YLUserDefault saveRole:handle.t_role];
        [YLUserDefault saveVip:handle.t_is_vip];
        [YLUserDefault saveCity:handle.t_city];
        self.personHandle = handle;
       
        [SLDefaultsHelper saveSLDefaults:handle.nickName key:@"user_nick_name"];
        [SLDefaultsHelper saveSLDefaults:handle.handImg key:@"user_head_image"];
        
        [YLUserDefault saveNickName:handle.nickName];
        if (handle.handImg.length > 0 && ![handle.handImg containsString:@"null"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", handle.handImg]]]];
                [YLUserDefault saveHeadImage:image];
            });
        } else {
            [YLUserDefault saveHeadImage:[UIImage imageNamed:@"default"]];
        }
        
        [self->headView setHeaderData:handle];
        [self->videoCell setHandle:handle];
        [self->chatCell setHandle:handle];
        [self->ppCell setHandle:handle];
        [self->rankCell setHandle:handle];

        [self setBalanceAnimation];
    }];
}

- (void)getDataWithAuthentication {
    [YLNetworkInterface getUserIsIdentification:[YLUserDefault userDefault].t_id block:^(int certifyType) {
//        [self->headView setAnchorStatus:certifyType];
        self.authenticationStatus = certifyType;
        if (certifyType == 0) {
            [self.anchorBtn setTitle:@"申请审核中" forState:0];
        } else if (certifyType == 1) {
            [self.anchorBtn setTitle:@"收费设置" forState:0];
        } else {
            [self.anchorBtn setTitle:@"申请主播" forState:0];
        }
        [self.anchorBtn setImagePosition:2 spacing:12];
    }];
}

- (void)getDataWithRedPackage {
    [YLNetworkInterface getRedPacketCount:[YLUserDefault userDefault].t_id block:^(int total) {
        if (total > 0) {
            [YLNetworkInterface receiveRedPacket:[YLUserDefault userDefault].t_id block:^(receiveRedPacketHandle *handle) {
                [self getDataWithRedPackage];

                [self getDataWithPerson];
            }];
        }
    }];
}

- (void)setBalanceAnimation {
    int balance = [self.personHandle.amount intValue];
    int withdraw = [self.personHandle.extractGold intValue];
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

#pragma mark - subViews
- (void)setSubViews {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaBottomHeight)];
    scrollView.backgroundColor = UIColor.whiteColor;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    headView = [[NewPersonHeadView alloc] init];
    [scrollView addSubview:headView];
    
    [self balanceView];
    [self switchView];
    [self itemView];
}

- (void)balanceView {
    UIView *balanceBG = [[UIView alloc] initWithFrame:CGRectMake(0, headView.height, App_Frame_Width, 130)];
    balanceBG.backgroundColor = UIColor.whiteColor;
    [scrollView addSubview:balanceBG];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(App_Frame_Width/2-0.5, 45, 1, 30)];
    line.backgroundColor = XZRGB(0xebebeb);
    [balanceBG addSubview:line];
    
    UIButton *rechargeBtn = [UIManager initWithButton:CGRectMake(50, 65, 65, 30) text:@"充值" font:15 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    rechargeBtn.backgroundColor = XZRGB(0x02cfd1);
    rechargeBtn.layer.masksToBounds = YES;
    rechargeBtn.layer.cornerRadius = rechargeBtn.height/2;
    [rechargeBtn addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [balanceBG addSubview:rechargeBtn];
    
    UIButton *withdrawBtn = [UIManager initWithButton:CGRectMake(balanceBG.width-50-65, 65, 65, 30) text:@"提现" font:15 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];//0xae4ffd
    withdrawBtn.backgroundColor = XZRGB(0xf3bd03);
    withdrawBtn.layer.masksToBounds = YES;
    withdrawBtn.layer.cornerRadius = withdrawBtn.height/2;
    [withdrawBtn addTarget:self action:@selector(withdrawButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [balanceBG addSubview:withdrawBtn];
    
    UILabel *yeLabel = [UIManager initWithLabel:CGRectMake(0, 25, 50, 20) text:@"余额:" font:13 textColor:XZRGB(0x868686)];
    yeLabel.textAlignment = NSTextAlignmentRight;
    [balanceBG addSubview:yeLabel];
    
    _balanceBGView = [[UIView alloc] initWithFrame:CGRectMake(55, 15, balanceBG.width/2-80, 40)];
    [balanceBG addSubview:_balanceBGView];
    UITapGestureRecognizer *balanceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(balanceLabelClick)];
    [_balanceBGView addGestureRecognizer:balanceTap];
    
    UILabel *syLabel = [UIManager initWithLabel:CGRectMake(balanceBG.width/2, 25, 50, 20) text:@"收益:" font:13 textColor:XZRGB(0x868686)];
    syLabel.textAlignment = NSTextAlignmentRight;
    [balanceBG addSubview:syLabel];
    
//    UIImageView *yeJT = [[UIImageView alloc] initWithFrame:CGRectMake(balanceBG.width/2-20, 29, 12, 12)];
//    yeJT.image = [UIImage imageNamed:@"newcenter_img_jt"];
//    [balanceBG addSubview:yeJT];
    
    _withdrawBGView = [[UIView alloc] initWithFrame:CGRectMake(55+balanceBG.width/2, 15, balanceBG.width/2-80, 40)];
    [balanceBG addSubview:_withdrawBGView];
    UITapGestureRecognizer *syTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(syTap)];
    [_withdrawBGView addGestureRecognizer:syTap];
    
//    UIImageView *syJT = [[UIImageView alloc] initWithFrame:CGRectMake(balanceBG.width-30, 29, 12, 12)];
//    syJT.image = [UIImage imageNamed:@"newcenter_img_jt"];
//    [balanceBG addSubview:syJT];
    
    [UIManager minePageLineWithY:balanceBG.height-4 superView:balanceBG];
}

- (void)switchView {
    UIView *switchV = [[UIView alloc] initWithFrame:CGRectMake(0, headView.height+130, App_Frame_Width, 200)];
    switchV.backgroundColor = UIColor.whiteColor;
    [scrollView addSubview:switchV];
    
    videoCell = [[MineSwicthTableViewCell alloc] initWithFrame:CGRectMake(0, 20, App_Frame_Width, 40)];
    [videoCell setType:SwitchCellTypeVideo];
    [switchV addSubview:videoCell];
    
    chatCell = [[MineSwicthTableViewCell alloc] initWithFrame:CGRectMake(0, 60, App_Frame_Width, 40)];
    [chatCell setType:SwitchCellTypeChat];
    [switchV addSubview:chatCell];
    
    ppCell = [[MineSwicthTableViewCell alloc] initWithFrame:CGRectMake(0, 100, App_Frame_Width, 40)];
    [ppCell setType:SwitchCellTypePP];
    [switchV addSubview:ppCell];
    
    rankCell = [[MineSwicthTableViewCell alloc] initWithFrame:CGRectMake(0, 140, App_Frame_Width, 40)];
    [rankCell setType:SwitchCellTypeRank];
    [switchV addSubview:rankCell];
    
    [UIManager minePageLineWithY:switchV.height-4 superView:switchV];
}

- (void)itemView {
    NSArray *imgArr = @[@"mine_item_yqyj", @"mine_item_kthy", @"mine_item_sqzb",@"mine_item_wdgh", @"mine_item_mysz",@"mine_item_bdsj", @"mine_item_cjwt", @"mine_item_xtsz"];
    NSArray *titleArr = @[@"邀请有奖", @"开通会员", @"申请主播", @"我的公会", @"美颜设置", @"绑定手机", @"常见问题", @"系统设置"];
    CGFloat width = App_Frame_Width/3;
    for (int i = 0; i < imgArr.count; i ++) {
        UIButton *btn = [UIManager initWithButton:CGRectMake((i%3)*width, CGRectGetMaxY(headView.frame)+350+100*(i/3), width, 100) text:titleArr[i] font:15 textColor:XZRGB(0x868686) normalImg:imgArr[i] highImg:nil selectedImg:nil];
        btn.tag = 1234+i;
        [btn setImagePosition:2 spacing:12];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        if (i == 2) {
            self.anchorBtn = btn;
        }
    }
    
    scrollView.contentSize = CGSizeMake(App_Frame_Width, CGRectGetMaxY(headView.frame)+350+330);

}

#pragma mark - func
- (void)syTap {
    MyInvitedViewController *myInvite = [[MyInvitedViewController alloc] init];
    [self.navigationController pushViewController:myInvite animated:YES];
}

#pragma mark - func
- (void)balanceLabelClick {
    YLNAccountBalanceController *accountBalanceVC = [YLNAccountBalanceController new];
    accountBalanceVC.title = @"账号余额";
    [self.navigationController pushViewController:accountBalanceVC animated:YES];
}

- (void)rechargeButtonClick {
    YLRechargeVipController *rechargeVipVC = [YLRechargeVipController new];
    [self.navigationController pushViewController:rechargeVipVC animated:YES];
}

- (void)withdrawButtonClick {
    if (_personHandle.phoneIdentity == 0) {
        //未绑定手机号 先绑定手机号
        [LXTAlertView alertViewWithTitle:@"提示" message:@"为了你的账户安全，请绑定手机号" cancleTitle:@"取消" sureTitle:@"去绑定" sureHandle:^{
            YLEditPhoneController *editPhoneVC = [YLEditPhoneController new];
            editPhoneVC.title = @"绑定手机";
            [self.navigationController pushViewController:editPhoneVC animated:YES];
        }];
        return;
    }
    
    YLNWithDrawController *withdrawVC = [YLNWithDrawController new];
    withdrawVC.title  = @"提现";
    withdrawVC.balance= [NSString stringWithFormat:@"%@",_personHandle.extractGold];
    [self.navigationController pushViewController:withdrawVC animated:YES];
}


- (void)applyForAnchorButtonClick {
    
    if (_authenticationStatus == 1) {
        //认证过后设置收费情况
        YLSetupChargingItemsController *setchargeVC = [YLSetupChargingItemsController new];
        setchargeVC.title = @"收费设置";
        [self.navigationController pushViewController:setchargeVC animated:YES];
    } else {
        //未认证跳到认证界面
        if (_personHandle.t_sex == 1) {
            [SVProgressHUD showInfoWithStatus:@"暂未开通男主播功能！"];
        }else{
            AnchorAuthViewController *authVC = [[AnchorAuthViewController alloc] init];
            [self.navigationController pushViewController:authVC animated:YES];
        }
    }}

- (void)VIPButtonClick {
    [YLPushManager pushVipWithEndTime:_personHandle.endTime];
}

- (void)buttonClick:(UIButton *)sender {
    NSInteger index = sender.tag-1234;
    if (index == 0) {
        // 邀请有奖
        [YLPushManager pushInvite];
    } else if (index == 1) {
        [YLPushManager pushVipWithEndTime:_personHandle.endTime];
    } else if (index == 2) {
        // 申请主播
        [self applyForAnchorButtonClick];
    } else if (index == 3) {
        //公会
        if (_personHandle.isGuild == 0) {
            //未申请
            [self showUnionAlertView];
        }else if (_personHandle.isGuild == 1){
            //审核中
            [SVProgressHUD showInfoWithStatus:@"您的公会正在审核中"];
        }else if (_personHandle.isGuild == 2){
            //已通过审核
            YLUnionController *unionVC = [YLUnionController new];
            [self.navigationController pushViewController:unionVC animated:YES];
        }else{
            //下架
            [SVProgressHUD showInfoWithStatus:@"您的公会已下架,请联系客服!"];
        }
    } else if (index == 4) {
        BeautyViewController *faceUnityVC = [[BeautyViewController alloc] init];
        faceUnityVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController pushViewController:faceUnityVC animated:YES];
    } else if (index == 5) {
        // 绑定手机
        YLEditPhoneController *editPhoneVC = [YLEditPhoneController new];
        editPhoneVC.title = @"绑定手机";
        editPhoneVC.phoneStr = _personHandle.t_phone;
        [self.navigationController pushViewController:editPhoneVC animated:YES];
    } else if (index == 6) {
        //帮助
        HelpCenterViewController *vc = [[HelpCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 7) {
        //设置
        YLSettingController *settingVC = [YLSettingController new];
        settingVC.title = @"系统设置";
        settingVC.pcHandle = _personHandle;
        [self.navigationController pushViewController:settingVC animated:YES];
    } 
}

- (void)showUnionAlertView {
    [SLAlertController alertControllerWithStyle:UIAlertControllerStyleAlert controller:self alertControllerTitle:@"温馨提示" alertControllerMessage:@"建议旗下有10名以上主播的家族长（公会）申请，否则可能你的申请无法通过审核。" alertControllerSheetActionTitles:nil alertControllerSureActionTitle:nil alertControllerCancelActionTitle:@"确定" alertControllerSheetActionBlock:nil alertControllerAlertSureActionBlock:^{

    } alertControllerAlertCancelActionBlock:^{
        YLApplyUnionController *applyUnionVC = [YLApplyUnionController new];
        applyUnionVC.title = @"创建公会";
        [self.navigationController pushViewController:applyUnionVC animated:YES];
    }];
}

- (void)getDataWithAnchorAddGuild {
    WEAKSELF
    [YLNetworkInterface getAnchorAddGuild:[YLUserDefault userDefault].t_id block:^(anchorAddGuildHandle *handle) {
        NSString *somebody = handle.t_admin_name;
        NSString *somePublic = handle.t_guild_name;
        
        if (handle != nil && ![NSString isNullOrEmpty:somebody] && ![NSString isNullOrEmpty:somePublic]) {
            
            [SLAlertController alertControllerWithStyle:UIAlertControllerStyleAlert controller:self alertControllerTitle:@"温馨提示" alertControllerMessage:[NSString stringWithFormat:@"%@邀请您加入%@公会",somebody,somePublic] alertControllerSheetActionTitles:nil alertControllerSureActionTitle:@"接受" alertControllerCancelActionTitle:@"拒绝" alertControllerSheetActionBlock:nil alertControllerAlertSureActionBlock:^{
                [weakSelf postDataWithApplyGuild:handle.t_id isApply:1];
            } alertControllerAlertCancelActionBlock:^{
                [weakSelf postDataWithApplyGuild:handle.t_id isApply:0];
            }];
        }
    }];
}

- (void)postDataWithApplyGuild:(int)guildId isApply:(int)isApply {
    [YLNetworkInterface isApplyGuild:[YLUserDefault userDefault].t_id guildId:guildId isApply:isApply block:^(BOOL isSuccess) {
    }];
}


@end
