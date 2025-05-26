//
//  HomePageViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/1/19.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "HomePageViewController.h"
//vc
#import "RankViewController.h"
#import "YLSearchController.h"
#import "YLNAttentionController.h"
#import "YLAppointMentController.h"
#import "NearViewController.h"
#import "RecommendViewController.h"
#import "NewPeopleViewController.h"
#import "ChooseChatViewController.h"
#import "LockOpenTempViewController.h"
#import "LaunchAdvViewController.h"
#import "FreeMessageAlertView.h"
#import "ChatGroundViewController.h"
#import "YLDynamicViewController.h"
#import "MansionJoinedViewController.h"
#import "MansionMyViewController.h"
#import "HomeSendMessageAlertView.h"
#import "YLEPPickerController.h"
#import "UIButton+WebCache.h"

//tool
#import "versionView.h"
#import "YLTapGesture.h"
#import <SPPageMenu.h>
#import "LockPwdTempView.h"
#import "BanPactAlertView.h"
#import "FirstRechargeView.h"

#import "YLUserDefault.h"
#import "WelcomeViewController.h"
#import "KJJPushHelper.h"
#import "FullScreenNotView.h"
#import "NewMessageAlertView.h"
#import "AppDelegate.h"

@interface HomePageViewController ()
<
UIScrollViewDelegate,
SPPageMenuDelegate
>

{
    BOOL isLoaded;
    NSArray *tagArray;
    UIButton *topBtn;
    
    NSInteger cityIndex;
    NSString *cityName;
    NewPeopleViewController *cityVC;
    
    NSDictionary *btnbBannerInfo;
    UIButton *suspensionB;
    BOOL isShowPopPic;
}

@property (nonatomic, strong) NSMutableArray *pageMenuTitleArray;

@property (nonatomic, strong) NSMutableArray *myChildVCArray;

@property (nonatomic, strong) SPPageMenu *pageMenu;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy) NSString    *appDownUrl;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor   = [UIColor whiteColor];
    isLoaded = NO;
    isShowPopPic = NO;
    [self getDataWithMyInfo];
    [(AppDelegate*)[UIApplication sharedApplication].delegate initTencentOss];
    [(AppDelegate*)[UIApplication sharedApplication].delegate initAgora];
    [self settingUserNotification];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self freeMessage];
        [self getSystemConfig];
    });
    
    [self addNoti];
    
    [[TIMGroupManager sharedInstance] getGroupList:nil fail:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    [self getDataWithVersion];
    [self getServiceIds];
    
    if (isLoaded == NO) {
        [self getHomePageTopTable];
    }
    [self getDataWithImSensitiveWorld];
    
    [self getOrcWords];
    [self getManagerGold];
}

- (void)getManagerGold{
    [YLNetworkInterface getManagerGold:[YLUserDefault userDefault].t_id block:^(NSString *token) {
        [SLDefaultsHelper saveSLDefaults:token key:@"managerGold"];
    }];
}

#pragma mark - not
- (void)addNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPage) name:@"UserRoleBecomeTrue" object:nil];
}

- (void)reloadPage {
    // 角色变成1之后 重新加载首页
    if ([YLUserDefault userDefault].t_id > 0) {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self getHomePageTopTable];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 弹窗  悬浮窗
- (void)requestAndShowBanPact {
    [YLNetworkInterface getNewBannerListSuccess:^(NSDictionary *data) {
        if ([data[@"suspensionMap"] isKindOfClass:[NSDictionary class]]) {
            //悬浮窗按钮
            NSDictionary *suspensionMap = data[@"suspensionMap"];
            BOOL bannerStatus = [[NSString stringWithFormat:@"%@", suspensionMap[@"bannerStatus"]] boolValue];
            if (bannerStatus) {
                self->btnbBannerInfo = suspensionMap[@"bannerInfo"];
                self->suspensionB = [UIButton buttonWithType:0];
                self->suspensionB.frame = CGRectMake(5, APP_Frame_Height-SafeAreaBottomHeight-160, 60, 60);
                [self->suspensionB sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self->btnbBannerInfo[@"t_img_url"]]] forState:0];
                [self->suspensionB addTarget:self action:@selector(bannerButtonClick) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self->suspensionB];
                
                UIButton *closeB = [UIManager initWithButton:CGRectMake(5+12.5, CGRectGetMaxY(self->suspensionB.frame)+5, 25, 25) text:@"" font:1 textColor:nil normalImg:@"close_little" highImg:nil selectedImg:nil];
                [closeB addTarget:self action:@selector(removeSuspensionButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:closeB];
            }
        }
        if ([data[@"popupMap"] isKindOfClass:[NSDictionary class]] && !self->isShowPopPic) {
            //图片弹窗
            NSDictionary *popupMap = data[@"popupMap"];
            BOOL bannerStatus = [[NSString stringWithFormat:@"%@", popupMap[@"bannerStatus"]] boolValue];
            if (bannerStatus) {
                self->isShowPopPic = YES;
                NSDictionary *bannerInfo = popupMap[@"bannerInfo"];
                BanPactAlertView *view = [[BanPactAlertView alloc] init];
                [view showWithImageUrl:[NSString stringWithFormat:@"%@", bannerInfo[@"t_img_url"]] pactUrl:[NSString stringWithFormat:@"%@", bannerInfo[@"t_link_url"]]];
            }
        }
    }];
}

- (void)removeSuspensionButton:(UIButton *)sender {
    [suspensionB removeFromSuperview];
    [sender removeFromSuperview];
}

- (void)bannerButtonClick {
    [YLPushManager bannerPushClass:[NSString stringWithFormat:@"%@", btnbBannerInfo[@"t_link_url"]]];
}

#pragma mark - 获取领取奖励
- (void)getSystemConfig {
    [YLNetworkInterface getSystemConfigAndSave];
}

#pragma mark - 非会员每日赠送私信条数
- (void)freeMessage {
    [YLNetworkInterface privateLetterNumberSuccess:^(bool isCase, NSString *num, bool isGold, NSString *goldNum) {
        if (isCase == 1 || isGold == 1) {
            FreeMessageAlertView *alertView = [[FreeMessageAlertView alloc] init];
            [alertView showWithNum:num isCase:isCase goldNum:goldNum isGold:isGold];
        }
    }];
}

#pragma mark - 首充
- (void)requestFirstRecharge {
    [YLNetworkInterface getFirstChargeInfoSuccess:^(NSDictionary *dataDic) {
        UIButton *rechargeBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-28, APP_Frame_Height-SafeAreaBottomHeight-200, 28, 100) text:@"" font:1 textColor:nil normalImg:@"first_recharge_btn" highImg:nil selectedImg:nil];
        [rechargeBtn addTarget:self action:@selector(firstRechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rechargeBtn];
    }];
}

- (void)firstRechargeButtonClick {
    FirstRechargeView *view = [[FirstRechargeView alloc] init];
    [view show];
}

#pragma mark -- UI
- (void)initWithPageMenu {
    cityIndex = -1;
    cityName = @"";
    isLoaded = YES;
    
    //搜索
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:IChatUImage(@"main_search") forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(App_Frame_Width - 44, SafeAreaTopHeight-44, 44, 44);
    [searchBtn addTarget:self action:@selector(clickedSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    self.myChildVCArray = [NSMutableArray new];
    self.pageMenuTitleArray = [NSMutableArray array];
    NSInteger selectedItemIndex = 0;
    for (int i = 0; i < tagArray.count; i ++) {
        @autoreleasepool {
            NSDictionary *dic = tagArray[i];
            NSString *name = dic[@"t_ad_table_name"];
            
            NSString *t_ad_table_target = dic[@"t_ad_table_target"];
            if ([t_ad_table_target isEqualToString:@"0"]) {
                // 新人
                [self.pageMenuTitleArray addObject:name];
                [self newPeopleVCWithType:0];
            } else if ([t_ad_table_target isEqualToString:@"1"]) {
                // 推荐
                [self.pageMenuTitleArray addObject:name];
//                selectedItemIndex = i;
                [self recommendVC];
            } else if ([t_ad_table_target isEqualToString:@"2"]) {
                // 活跃
                [self.pageMenuTitleArray addObject:name];
                [self newPeopleVCWithType:2];
            } else if ([t_ad_table_target isEqualToString:@"3"]) {
                // 女神
                [self.pageMenuTitleArray addObject:name];
                selectedItemIndex = i;
                [self newPeopleVCWithType:3];
            } else if ([t_ad_table_target isEqualToString:@"4"] && [YLUserDefault userDefault].t_role == 1) {
                // 粉丝
                [self.pageMenuTitleArray addObject:name];
                [self fansVC];
            } else if ([t_ad_table_target isEqualToString:@"5"] && [YLUserDefault userDefault].t_role != 1) {
                // 关注
                [self.pageMenuTitleArray addObject:name];
                [self attentionVC];
            } else if ([t_ad_table_target isEqualToString:@"6"]) {
                // 视频
                [self.pageMenuTitleArray addObject:name];
                [self videoVC];
            } else if ([t_ad_table_target isEqualToString:@"7"]) {
                // 附近
//                [self.pageMenuTitleArray addObject:name];
//                [self nearbyVC];
                cityIndex = i;
                cityName = [NSString stringWithFormat:@"%@", [YLUserDefault userDefault].t_city];
//                [self.pageMenuTitleArray addObject:cityName];
                SPPageMenuButtonItem *item = [SPPageMenuButtonItem itemWithTitle:cityName image:[UIImage imageNamed:@"HomePage_city_temp"] imagePosition:SPItemImagePositionRight];
                [self.pageMenuTitleArray addObject:item];
                [self newPeopleVCWithType:5];
            } else if ([t_ad_table_target isEqualToString:@"8"] && [YLUserDefault userDefault].t_sex == 1) {
                // 选聊
                [self.pageMenuTitleArray addObject:name];
                ChooseChatViewController *chatVC = [[ChooseChatViewController alloc] init];
                [self addChildViewController:chatVC];
                [_myChildVCArray addObject:chatVC];
            } else if ([t_ad_table_target isEqualToString:@"9"]) {
                // 聊场
                [self.pageMenuTitleArray addObject:name];
                ChatGroundViewController *chatGroudVC = [[ChatGroundViewController alloc] init];
                [self addChildViewController:chatGroudVC];
                [_myChildVCArray addObject:chatGroudVC];
//                selectedItemIndex = i;
            } else if ([t_ad_table_target isEqualToString:@"10"]) {
                // 社区
                [self.pageMenuTitleArray addObject:name];
                YLDynamicViewController *dynamicVC = [[YLDynamicViewController alloc] init];
                [self addChildViewController:dynamicVC];
                [_myChildVCArray addObject:dynamicVC];
            } else if ([t_ad_table_target isEqualToString:@"11"]) {
                // 1v2
                [self.pageMenuTitleArray addObject:name];
                if ([YLUserDefault userDefault].t_sex == 0) {
                    MansionJoinedViewController *mansionJoinedVC = [[MansionJoinedViewController alloc] init];
                    [self addChildViewController:mansionJoinedVC];
                    [_myChildVCArray addObject:mansionJoinedVC];
                } else {
                    MansionMyViewController *mansionMyVC = [[MansionMyViewController alloc] init];
                    [self addChildViewController:mansionMyVC];
                    [_myChildVCArray addObject:mansionMyVC];
                }
            } else if ([t_ad_table_target hasPrefix:@"http"]) {
                // 广告
                [self.pageMenuTitleArray addObject:name];
                [self advVCWithUrl:t_ad_table_target];
            }
        }
    }
    
    CGRect frame = CGRectMake(0, SafeAreaTopHeight-44, App_Frame_Width-44, 44);
    self.pageMenu = [SPPageMenu pageMenuWithFrame:frame trackerStyle:SPPageMenuTrackerStyleLineAttachment];
    _pageMenu.dividingLine.hidden = YES;
    _pageMenu.selectedItemTitleColor   = XZRGB(0x3f3b48);
    _pageMenu.selectedItemTitleFont    = [UIFont boldSystemFontOfSize:24.0f];
    _pageMenu.unSelectedItemTitleColor = XZRGB(0x3f3b48);
    _pageMenu.unSelectedItemTitleFont  = [UIFont systemFontOfSize:16.0f];
    _pageMenu.trackerWidth = 8;
    _pageMenu.trackerFollowingMode = SPPageMenuTrackerStyleRoundedRect;
    [_pageMenu setTrackerHeight:4 cornerRadius:2];
    _pageMenu.tracker.backgroundColor = XZRGB(0x3f3b48);
    _pageMenu.bridgeScrollView = self.scrollView;
    _pageMenu.spacing = 13;
    [self.view addSubview:_pageMenu];
    
    [_pageMenu setItems:_pageMenuTitleArray selectedItemIndex:selectedItemIndex];
    _pageMenu.delegate = self;
    _scrollView.contentOffset = CGPointMake(App_Frame_Width*_pageMenu.selectedItemIndex, 0);
    _scrollView.contentSize = CGSizeMake(_pageMenuTitleArray.count*App_Frame_Width, 0);
    [self.view addSubview:self.scrollView];
    
//    if (cityName.length > 0) {
//        SPPageMenuButtonItem *item = [SPPageMenuButtonItem itemWithTitle:cityName image:[UIImage imageNamed:@"HomePage_city_temp"] imagePosition:SPItemImagePositionRight];
//        item.imageTitleSpace = 5;
//        [_pageMenu setItem:item forItemAtIndex:cityIndex];
//    }
    
    if ([YLUserDefault userDefault].t_role == 1 || [YLUserDefault userDefault].t_is_vip == 0) {
        //我要置顶
        topBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-84, APP_Frame_Height-SafeAreaBottomHeight-SafeAreaTopHeight-20, 84, 77) text:nil font:12.0f textColor:[UIColor whiteColor] normalImg:@"HomePage_top" highImg:nil selectedImg:nil];
        [topBtn addTarget: self action:@selector(clickedTopBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:topBtn];
    }
    
    
    
    
    [self requestFirstRecharge];
    [self requestAndShowBanPact];
}

- (void)advVCWithUrl:(NSString *)url {
    LaunchAdvViewController *advVC = [[LaunchAdvViewController alloc] init];
    advVC.advUrl = url;
    advVC.fromType = 1;
    [self addChildViewController:advVC];
    [_myChildVCArray addObject:advVC];
}

- (void)attentionVC {
    YLNAttentionController *fansVC = [[YLNAttentionController alloc] init];
    fansVC.isHomePage = YES;
    [self addChildViewController:fansVC];
    [_myChildVCArray addObject:fansVC];
}

- (void)fansVC {
    NearViewController *nearbyVC = [[NearViewController alloc] init];
    nearbyVC.isBoyUser = YES;
    [self addChildViewController:nearbyVC];
    [_myChildVCArray addObject:nearbyVC];
}

- (void)recommendVC {
    RecommendViewController *vc = [[RecommendViewController alloc] init];
    [self addChildViewController:vc];
    [_myChildVCArray addObject:vc];
}

- (void)newPeopleVCWithType:(NSInteger)type {
    NewPeopleViewController *vc = [[NewPeopleViewController alloc] init];
    vc.type = type;
    if (type == 5) {
        vc.selectedCity = cityName;
        cityVC = vc;
    }
    [self addChildViewController:vc];
    [_myChildVCArray addObject:vc];
}

- (void)videoVC {
    YLAppointMentController *videoVC = [[YLAppointMentController alloc]initNav:self];
    [self addChildViewController:videoVC];
    [_myChildVCArray addObject:videoVC];
}

- (void)nearbyVC {
    NearViewController *nearbyVC = [[NearViewController alloc] init];
    nearbyVC.isBoyUser = NO;
    [self addChildViewController:nearbyVC];
    [_myChildVCArray addObject:nearbyVC];
}

- (void)addViewWithLockTempView {
    [LXTAlertView dismiss:^{
        LockOpenTempViewController *lockTempView = [[LockOpenTempViewController alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:lockTempView];
    }];
}

- (void)addViewWithLockPwdTempView {
    [LXTAlertView dismiss:^{
        LockPwdTempView *lockTempView = [[LockPwdTempView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
        lockTempView.tag = 10086;
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:lockTempView];
    }];
}

#pragma mark -- Net
- (void)getHomePageTopTable {
    WEAKSELF;
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [YLNetworkInterface getAdTableWithType:2 userId:[YLUserDefault userDefault].t_id page:1 timeout:20 success:^(NSArray *dataAttay) {
        [SVProgressHUD dismiss];
        if (dataAttay.count > 0) {
            for (int i = 0; i < dataAttay.count; i ++) {
                if (![dataAttay[i] isKindOfClass:[NSDictionary class]]) {
                    self->isLoaded = NO;
                    [SVProgressHUD showInfoWithStatus:@"数据异常"];
                    return ;
                }
            }
           
            self->tagArray = dataAttay;
            [weakSelf initWithPageMenu];
        } else {
            self->isLoaded = NO;
            [SVProgressHUD showInfoWithStatus:@"标签列表为空"];
        }
    } fail:^{
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"T_TOKEN"];
        WelcomeViewController *loginVC = [WelcomeViewController new];
        self.view.window.rootViewController = loginVC;
        
        [[TIMManager sharedInstance] logout:nil fail:nil];
        [YLUserDefault saveUserDefault:@"0" t_id:@"0" t_is_vip:@"1" t_role:@"0"];
        [SVProgressHUD showInfoWithStatus:@"Ip被封禁"];
        
        self->isLoaded = NO;
    }];
}

//- (void)getDataWithQQ {
//    [YLNetworkInterface getServiceQQ:[YLUserDefault userDefault].t_id block:^(NSDictionary *dic) {
//        if (dic) {
//            NSString *qq = dic[@"m_object"];
//            [YLUserDefault saveQQCustomer:qq];
//        }
//    }];
//}

- (void)getServiceIds {
    [YLNetworkInterface getServiceIdSuccess:^(NSArray *idArray) {
        if (idArray == nil) return;
        NSString *ids;
        for (int i = 0; i < idArray.count; i ++) {
            NSDictionary *dic = idArray[i];
            if (i == 0) {
                ids = [NSString stringWithFormat:@"%@", dic[@"t_id"]];
            } else {
                ids = [NSString stringWithFormat:@"%@,%@", ids, dic[@"t_id"]];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:ids forKey:@"serviceids"];
    }];
}

- (void)getDataWithVersion {
    return;
    [YLNetworkInterface getIosVersion:[YLUserDefault userDefault].t_id block:^(NSString *t_version, NSString *t_download_url, NSString *t_version_depict) {
        
        self.appDownUrl = t_download_url;
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        if (![app_Version isEqualToString:t_version]) {
            UIView *blackView = [UIView new];
            blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
            blackView.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
            [YLAppWindow addSubview:blackView];
            
            NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"versionView" owner:nil options:nil];
            versionView *version = xibArray[0];
            version.versionLabel.text = [NSString stringWithFormat:@"发现新版本V%@",t_version];
            version.textView.text = t_version_depict;
            [YLAppWindow addSubview:version];
            
            [version mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(App_Frame_Width/2. - 130.);
                make.top.mas_equalTo(APP_Frame_Height/2. - 163.5);
                make.width.mas_equalTo(260);
                make.height.mas_equalTo(327);
            }];
            
            [YLTapGesture addTaget:self sel:@selector(clickedUpdateVersionBtn) view:version.updateBtn];
        }
    }];
}

- (void)getDataWithMyInfo {
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    WEAKSELF
    [YLNetworkInterface index:[YLUserDefault userDefault].t_id block:^(personalCenterHandle *handle) {
        [SVProgressHUD dismiss];
        if (handle != nil) {
            
            [YLUserDefault saveRole:handle.t_role];
            [YLUserDefault saveVip:handle.t_is_vip];
            [YLUserDefault saveNickName:handle.nickName];
            [YLUserDefault saveCity:handle.t_city];
            if (self->cityIndex > 0 && [self->cityName containsString:@"null"]) {
                self->cityName = handle.t_city;
                SPPageMenuButtonItem *item = [self.pageMenu itemAtIndex:self->cityIndex];
                [self.pageMenu setItem:item forItemAtIndex:self->cityIndex];
            }
            if (handle.handImg.length > 0 && ![handle.handImg containsString:@"null"]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", handle.handImg]]]];
                    [YLUserDefault saveHeadImage:image];
                });
            } else {
                [YLUserDefault saveHeadImage:[UIImage imageNamed:@"default"]];
            }
//            [weakSelf initWithPageMenu];
             
             
            if (handle.t_sex == 1) {
                //  男性 TIM_GENDER_MALE         = 1,
                [[TIMFriendshipManager sharedInstance] modifySelfProfile:@{TIMProfileTypeKey_Gender:@(TIM_GENDER_MALE)} succ:nil fail:nil];
            } else {
                //  女性  TIM_GENDER_FEMALE       = 2,
                [[TIMFriendshipManager sharedInstance] modifySelfProfile:@{TIMProfileTypeKey_Gender:@(TIM_GENDER_FEMALE)} succ:nil fail:nil];
            }
            
            
            //判断未成年模式是否弹出
            NSString *isLockShow = (NSString *)[SLDefaultsHelper getSLDefaults:@"lock_mode_pwd_temp_is_show"];
            if (![isLockShow isEqualToString:@"1"]) {
                
                [weakSelf addViewWithLockTempView];
                
                [SLDefaultsHelper saveSLDefaults:@"1" key:@"lock_mode_pwd_temp_is_show"];
            } else {
                
                NSString *isLockPwd = (NSString *)[SLDefaultsHelper getSLDefaults:@"lock_mode_pwd_is_open_key"];
                if ([isLockPwd isEqualToString:@"1"]) {
                    //弹窗接锁
                    [weakSelf addViewWithLockPwdTempView];
                }
            }
            
            
        }
    }];
}

- (void)getDataWithImSensitiveWorld {
    [YLNetworkInterface getDataWithImSensitiveWorld:[YLUserDefault userDefault].t_id block:^(NSDictionary *dic) {
        if (dic) {
            NSString *str = dic[@"m_object"];
            if (str.length > 0) {
                NSString *allSensitiveWorld = str;
                if ([allSensitiveWorld hasSuffix:@"|"]) {
                    allSensitiveWorld = [str substringToIndex:str.length-1];
                }
                [SLDefaultsHelper saveSLDefaults:allSensitiveWorld key:@"ImSensitiveWorldAllStr"];
            }
        }
    }];
}

- (void)getOrcWords {
    [YLNetworkInterface getDataWithOcrFilter:[YLUserDefault userDefault].t_id block:^(NSDictionary *dic) {
        if (dic) {
            NSString *str = dic[@"m_object"];
            if (str.length > 0) {
                NSString *allSensitiveWorld = str;
                [SLDefaultsHelper saveSLDefaults:allSensitiveWorld key:@"ocrWord"];
            }
        }
    }];
}


#pragma mark -- Action
- (void)clickedTopBtn {
    [UIView animateWithDuration:1.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self->topBtn.y = -100;
    } completion:^(BOOL finished) {
        self->topBtn.y = APP_Frame_Height;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self->topBtn.y = APP_Frame_Height-SafeAreaBottomHeight-SafeAreaTopHeight-20;
        } completion:nil];
        [YLNetworkInterface getAnthorTopping:[YLUserDefault userDefault].t_id block:^(NSDictionary *dic) {

        }];
    }];
    
}
//- (void)clickedRankBtn {
//    RankViewController *rankVC = [[RankViewController alloc] init];
//    rankVC.isHideBack = NO;
//    [self.navigationController pushViewController:rankVC animated:YES];
//}

- (void)clickedSearchBtn {
    YLSearchController *searchVC = [YLSearchController new];
    [self.navigationController pushViewController:searchVC animated:YES];
}


- (void)clickedUpdateVersionBtn {
    if (![NSString isNullOrEmpty:_appDownUrl]) {
        [NSString openScheme:_appDownUrl];
    }else{
        [SVProgressHUD showInfoWithStatus:@"下载地址有误"];
    }
}

- (void)settingUserNotification {
    if (![SLHelper isUserNotificationEnable]) {
        [SLAlertController alertControllerWithStyle:UIAlertControllerStyleAlert controller:self alertControllerTitle:@"温馨提示" alertControllerMessage:@"请前往设置开启通知权限,您将接到更多小哥哥、小姐姐来电哟~" alertControllerSheetActionTitles:nil alertControllerSureActionTitle:@"去开启" alertControllerCancelActionTitle:@"下次再说" alertControllerSheetActionBlock:nil alertControllerAlertSureActionBlock:^{
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [NSString openScheme:UIApplicationOpenSettingsURLString];
            }
        } alertControllerAlertCancelActionBlock:nil];
    }
}

- (void)showCityPicker
{
    [[YLEPPickerController shareInstance]customUI];
    
    [[YLEPPickerController shareInstance] reloadPickerViewData:YLEditPersonalTypeCity block:^(NSString *tittle) {
        SPPageMenuButtonItem *item = [self.pageMenu itemAtIndex:self->cityIndex];
        item.title = tittle;
        self->cityName = tittle;
        [self->cityVC refreshListWithCity:tittle];
        [self.pageMenu setItem:item forItemAtIndex:self->cityIndex];
    }];
}

#pragma mark -- Delegate
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {

    if (cityName.length > 0) {
        if (toIndex == cityIndex) {
            if (fromIndex == cityIndex) {
                [self showCityPicker];
            }
            SPPageMenuButtonItem *item = [_pageMenu itemAtIndex:cityIndex];
            item.image = [UIImage imageNamed:@"HomePage_city_temp_sel"];
            [_pageMenu setItem:item forItemAtIndex:cityIndex];
        } else {
            SPPageMenuButtonItem *item = [_pageMenu itemAtIndex:cityIndex];
            item.image = [UIImage imageNamed:@"HomePage_city_temp"];
            [_pageMenu setItem:item forItemAtIndex:cityIndex];
        }
    }
    
    
    if (!self.scrollView.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [self.scrollView setContentOffset:CGPointMake(App_Frame_Width * toIndex, 0) animated:NO];
        } else {
            [self.scrollView setContentOffset:CGPointMake(App_Frame_Width * toIndex, 0) animated:YES];
        }
    }
    
    if (_myChildVCArray.count <= toIndex) {return;}
    
    UIViewController *targetViewController = _myChildVCArray[toIndex];
    if ([targetViewController isKindOfClass:[MansionMyViewController class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MansionPageClick" object:@"1"];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MansionPageClick" object:@"0"];
    }
    
    int isChat = 0;
    if ([_pageMenuTitleArray[toIndex] isKindOfClass:[NSString class]]) {
        NSString *title = _pageMenuTitleArray[toIndex];
        
        if ([title isEqualToString:@"选聊"]) {
            isChat = 1;
        }
    }
    
    
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGEMUNECHANGED" object:nil userInfo:@{@"isChat" : @(isChat)}];
        return;
    }
    
    targetViewController.view.frame = CGRectMake(App_Frame_Width * toIndex, 0, App_Frame_Width, self.scrollView.height);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGEMUNECHANGED" object:nil userInfo:@{@"isChat" : @(isChat)}];
    [_scrollView addSubview:targetViewController.view];
}

#pragma mark -- Lazyload
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+1, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight-1)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return  _scrollView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
