//
//  XZTabBarController.m
//  XZ_WeChat
//
//  Created by 郭现壮 on 16/9/27.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import "XZTabBarController.h"
#import "XZNavigationController.h"
#import "DefineConstants.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "YLSocketExtension.h"
#import "YLAudioPlay.h"
#import "YLTabbarCenterView.h"
#import "YLTapGesture.h"
#import "YLTabBar.h"
#import "JChatConstants.h"
#import "MyRankAwardView.h"

#import "HomePageViewController.h"
#import "YLMessageController.h"
#import "NewPersonViewController.h"

#import "NewMessageAlertView.h"
#import "ChatViewController.h"
#import "UserChatLivingViewController.h"
#import "AnchorChatLivingViewController.h"
#import "RankViewController.h"
#import "DiscoverViewController.h"
#import "MansionJoinedViewController.h"
#import "MansionMyViewController.h"
#import "MansionVideoViewController.h"
#import "MansionCallMeViewController.h"
#import "VideoCommentViewController.h"


@interface XZTabBarController ()
{
    UITabBarItem *msgitem;

}

//@property (nonatomic, strong) YLTabBar *ylTabBar;

@end

@implementation XZTabBarController

- (instancetype)init
{
    if (self == [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnreadMsg) name:@"getUnReadMsgNoti" object:nil];
        //收到新消息的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewMessage:) name:@"TUIKitNotification_TIMMessageListener" object:nil];
        
        [self addCommentNot];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    HomePageViewController *mainPageVC = [HomePageViewController new];
    [self addChildVc:mainPageVC title:@"首页" image:@"tabbar_main" selectedImage:@"tabbar_main_sel"];

    DiscoverViewController *discoverVC = [[DiscoverViewController alloc] init];
    [self addChildVc:discoverVC title:@"动态" image:@"tabbar_live" selectedImage:@"tabbar_live_sel"];
//    if ([YLUserDefault userDefault].t_sex == 1) {
//        MansionMyViewController *discoverVC = [[MansionMyViewController alloc] init];
//        [self addChildVc:discoverVC title:@"1对2" image:@"tabbar_live" selectedImage:@"tabbar_live_sel"];
//    }

//    if ([YLUserDefault userDefault].t_sex == 0) {
//        MansionJoinedViewController *mansionJoinedVC = [[MansionJoinedViewController alloc] init];
//        [self addChildVc:mansionJoinedVC title:@"" image:@"" selectedImage:@""];
//    } else {
//        MansionMyViewController *mansionMyVC = [[MansionMyViewController alloc] init];
//        [self addChildVc:mansionMyVC title:@"" image:@"" selectedImage:@""];
//    }
    
    
    RankViewController *rankVC = [RankViewController new];
    rankVC.isHideBack = YES;
    [self addChildVc:rankVC title:@"排行榜" image:@"tabbar_rank" selectedImage:@"tabbar_rank_sel"];
    
    YLMessageController *messageVC = [YLMessageController new];
    [self addChildVc:messageVC title:@"消息" image:@"tabbar_message" selectedImage:@"tabbar_message_sel"];
    
    NewPersonViewController *mineVC = [NewPersonViewController new];
    [self addChildVc:mineVC title:@"我的" image:@"tabbar_mine" selectedImage:@"tabbar_mine_sel"];
    
//    self.ylTabBar = [[YLTabBar alloc] init];
//    [self setValue:_ylTabBar forKey:@"tabBar"];
//    [YLTapGesture addTaget:self sel:@selector(clickedCenterBtn) view:_ylTabBar.centerView.centerBtn];
        
    self.selectedIndex = 0;
    
    if (@available(iOS 10.0, *)) {
        [[UITabBar appearance] setUnselectedItemTintColor:XZRGB(0x32434d)];
    }
    
    [self getDataWithShareUrl];
    
    [self getDataWithTecentIMSig];
    
    [YLNetworkInterface getSounRecordingSwitchAndCache];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reconnectSocket];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestMyRankAward];
    });
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getUnreadMsg];
}

//- (void)clickedCenterBtn {
//    self.selectedIndex = 2;
//    [SLDefaultsHelper saveSLDefaults:@"0" key:@"isFirstMatching"];
//
//    _ylTabBar.centerView.centerLb.textColor = XZRGB(0xAE4FFD);
//}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
    childVc.tabBarItem.selectedImage = [IChatUImage(selectedImage) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.image = [IChatUImage(image) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = XZRGB(0x32434d);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = KDEFAULTCOLOR;
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    
    XZNavigationController *nav = [[XZNavigationController alloc] initWithRootViewController:childVc];
    nav.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:XZRGB(0x3f444d),NSFontAttributeName:[UIFont fontWithName:@"Arial" size:17]};
    [self addChildViewController:nav];
    
    if ([title isEqualToString:@"消息"]) {
        msgitem = childVc.tabBarItem;
    }
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    [self getRedPacketCountRequest];
//    _ylTabBar.centerView.centerLb.textColor = XZRGB(0x32434d);
//    
//    
//    if ([item.title isEqualToString:@"首页"]) {
//        self.selectedIndex = 0;
//    }else if ([item.title isEqualToString:@"消息"]){
//        self.selectedIndex = 3;
//        [[NewMessageAlertView shareView] stopAnimation];
//    }else if ([item.title isEqualToString:@"我的"]){
//        self.selectedIndex = 4;
//    }else if ([item.title isEqualToString:@"速配"]){
//        self.selectedIndex = 2;
//    }else{
//        //动态
//        self.selectedIndex = 1;
//        dynamicNewMsgRedImgView.hidden = YES;
//    }
    self.tabBar.tintColor = KDEFAULTCOLOR;
}

- (void)getUnreadMsg
{
    [YLNetworkInterface getUnreadMessage:[YLUserDefault userDefault].t_id block:^(int code, NSString *errorMsg, int mansionCount) {
        
        //获取未读计数
        int unReadCount = 0;
        NSArray *convs = [[TIMManager sharedInstance] getConversationList];
        for (TIMConversation *conv in convs) {
            if([conv getType] == TIM_SYSTEM){
                continue;
            } else if ([conv getType] == TIM_GROUP) {
                TIMGroupInfo *groupInfo = [[TIMGroupManager sharedInstance] queryGroupInfo:[conv getReceiver]];
                if (![groupInfo.groupType isEqualToString:@"Public"]) {
                    continue;
                }
            }
            unReadCount += [conv getUnReadMessageNum];
        }
        
        NSInteger count = code + unReadCount + mansionCount;
        
        if (count == 0) {
            self->msgitem.badgeValue = nil;
        } else if (count > 99){
            self->msgitem.badgeValue = @"99+";
        } else {
            self->msgitem.badgeValue = [NSString stringWithFormat:@"%ld",(long)count];
        }
    }];
}

- (void)postNewMessage:(NSArray *)msgs {
    NSMutableArray *receiveMessageArray = [NSMutableArray array];
    if (msgs.count > 0) {
        [receiveMessageArray addObject:msgs.firstObject];
        TIMMessage *msg = msgs.firstObject;
        TIMElem *elem = [msg getElem:0];
        if ([elem isKindOfClass:[TIMProfileSystemElem class]]) {
            //资料变更消息
            return;
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:receiveMessageArray forKey:@"receive_msg_info_key"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"receive_msg_notification" object:nil userInfo:dic];
        
        //判断是否是在前台,前台才播放消息声音和震动并且没有正在视频聊天
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if(state != UIApplicationStateBackground) {
            TIMConversation *conv = [msg getConversation];
            
            NSString *serviceids = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"serviceids"]];
            NSArray *ids = [serviceids componentsSeparatedByString:@","];
            NSString *identifier = [NSString stringWithFormat:@"%@", [conv getReceiver]];
            if ([conv getType] == TIM_C2C) {
                [[TIMFriendshipManager sharedInstance] getUsersProfile:@[identifier] forceUpdate:YES succ:nil fail:nil];
                if (![ids containsObject:identifier]) {
                    TIMUserProfile *user = [[TIMFriendshipManager sharedInstance] queryUserProfile:identifier];
                    if (user.gender == TIM_GENDER_UNKNOWN || (user.gender == TIM_GENDER_MALE && [YLUserDefault userDefault].t_sex == 1) || (user.gender == TIM_GENDER_FEMALE && [YLUserDefault userDefault].t_sex == 0)) {
                        return;
                    }
                }
            } else if ([conv getType] == TIM_GROUP) {
                TIMGroupInfo *groupInfo = [[TIMGroupManager sharedInstance] queryGroupInfo:identifier];
                if (![groupInfo.groupType isEqualToString:@"Public"]) return;
            }
            
            NSString *timSoundTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"TIM_SOUND_TIME"];
            if (!timSoundTimeStr) {
                timSoundTimeStr = [ToolManager getNowTimeTimestamp3];
                [[NSUserDefaults standardUserDefaults] setObject:timSoundTimeStr forKey:@"TIM_SOUND_TIME"];
            }
            NSInteger soundTime = [timSoundTimeStr integerValue];
            NSString *nowTimeStr = [ToolManager getNowTimeTimestamp3];
            NSInteger nowTime = [nowTimeStr integerValue];
            if (nowTime - soundTime > 1000) {
                BOOL connect = [YLUserDefault userDefault].connectOnLine;
                if (!connect) {
                    if (([YLUserDefault userDefault].msgVibrate && [conv getType] == TIM_C2C) || ([YLUserDefault userDefault].groupMsgVibrate && [conv getType] == TIM_GROUP)) {
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    }
                    
                    if (([YLUserDefault userDefault].msgAudio && [conv getType] == TIM_C2C) || ([YLUserDefault userDefault].groupMsgAudio && [conv getType] == TIM_GROUP)) {
                        [[YLAudioPlay shareInstance] callMSGPlay];
                    }
                }
                [[NSUserDefaults standardUserDefaults] setObject:nowTimeStr forKey:@"TIM_SOUND_TIME"];
            }
        }
    }
}

- (void)getNewMessage:(NSNotification *)notification {
    
    NSArray<TIMMessage *> *msgs = notification.object;
    [self postNewMessage:msgs];
    
    
    [self getUnreadMsg];
    
//    if ([YLUserDefault userDefault].t_role == 1) {
//        return;
//    }
    TIMMessage *msg = msgs.firstObject;
    TIMConversation *conv = [msg getConversation];
    if ([conv getType] != TIM_C2C) return; //不是单聊消息直接return
    
    UIViewController *curVC = [SLHelper getCurrentVC];
    if ([curVC isKindOfClass:[YLMessageController class]] || [curVC isKindOfClass:[ChatViewController class]] || [curVC isKindOfClass:[UserChatLivingViewController class]] || [curVC isKindOfClass:[AnchorChatLivingViewController class]] || [curVC isKindOfClass:[TUIChatController class]] || [curVC isKindOfClass:[MansionVideoViewController class]] || [curVC isKindOfClass:[MansionCallMeViewController class]]) {
        return;
    }
//    NSMutableArray *array = [[notification userInfo] objectForKey:@"receive_msg_info_key"];
    
    TIMElem *elem = [msg getElem:0];
    NSString *content;
    //文字消息
    if ([elem isKindOfClass:[TIMTextElem class]]) {
        TIMTextElem *textElem = (TIMTextElem *)elem;
        content = textElem.text;
    } else if ([elem isKindOfClass:[TIMImageElem class]]) {
        content = @"[图片]";
    } else if ([elem isKindOfClass:[TIMSoundElem class]]) {
        content = @"[语音]";
    } else if ([elem isKindOfClass:[TIMCustomElem class]]) {
        //自定义消息
        
        TIMCustomElem *customElem = (TIMCustomElem *)elem;
        NSString *jsonStr  = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
        if ([jsonStr hasPrefix:@"serverSend&&"]) {
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"serverSend&&" withString:@"{"];
        }
        NSDictionary *dic = [SLHelper dictionaryWithJsonString:jsonStr];
        NSString *type = dic[@"type"];
        if ([type isEqualToString:@"0"] || [type isEqualToString:@"1"]) {
            content  = @"[打赏礼物]";
        } else if ([type isEqualToString:@"video_connect"] || [type isEqualToString:@"video_unconnect_user"] || [type isEqualToString:@"video_unconnect_anchor"]) {
            content = @"[通话]";
        } else if ([type isEqualToString:@"voice"]) {
            content = @"[语音]";
        } else if ([type isEqualToString:@"picture"]) {
            content = @"[图片]";
        }
    }
    
    //判断是否是当前页面的用户发来的消息
    NSInteger msgUserId = [msg.sender integerValue];
    if (msgUserId < 10000 || msgUserId == [YLUserDefault userDefault].t_id+10000) {
        return;
    }
    
    [msg getSenderProfile:^(TIMUserProfile *profile) {
        if (profile) {
            NSString *nickName = profile.nickname;
            if (nickName.length == 0 || [nickName containsString:@"null"]) {
                nickName = [NSString stringWithFormat:@"聊友:%ld", (long)msgUserId];
            }
            NSDictionary *userDic = @{@"userId" : [NSString stringWithFormat:@"%ld", (long)msgUserId],
                                      @"userName" : [NSString stringWithFormat:@"%@", nickName],
                                      @"avater" : [NSString stringWithFormat:@"%@", profile.faceURL],
                                      @"text" : [NSString stringWithFormat:@"%@", content]
            };
//            [[NewMessageAlertView shareView] showWithAnimationWithParam:userDic];
        }
    }];
}

- (void)getDataWithShareUrl {
    [YLNetworkInterface getShareUrlAddress:^(NSDictionary *dic) {
        NSDictionary *dict = dic[@"m_object"];
        NSString *url = dict[@"shareUrl"];
        NSArray *bgImageUrlArray = dict[@"backgroundPath"];
        [SLDefaultsHelper saveSLDefaults:url key:@"common_share_url"];
        NSMutableString *all = [NSMutableString new];
        for (int i = 0; i < bgImageUrlArray.count; i++) {
            NSDictionary *data = bgImageUrlArray[i];
            NSString *str = data[@"t_img_path"];
            [all appendString:str];
            if (i < bgImageUrlArray.count - 1) {
                [all appendString:@","];
            }
        }
        [SLDefaultsHelper saveSLDefaults:all key:@"common_share_bg_img_url"];
    }];
}

- (void)getDataWithTecentIMSig {
    if ([[TIMManager sharedInstance] getLoginStatus] != 1) {
        [SLHelper TIMLoginSuccess:^{
            [self getUnreadMsg];
        } fail:nil];
    }
}

#pragma mark ---- socket
- (void)reconnectSocket
{
    if (![[YLSocketExtension shareInstance] isConnected]) {
        [[YLSocketExtension shareInstance] disconnect];
        [[YLSocketExtension shareInstance] connectHost];
    }
}

#pragma mark - my rank award
- (void)requestMyRankAward {
//    [YLNetworkInterface getUserRankInfoSuccess:^(NSArray *awardArray) {
//        if (awardArray.count > 0) {
//            MyRankAwardView *myAwardView = [[MyRankAwardView alloc] initWithY:APP_FRAME_HEIGHT-SafeAreaBottomHeight-40];
//            [myAwardView setMyDataWithRankArray:awardArray];
//            [self.view addSubview:myAwardView];
//        }
//    }];
}


#pragma mark - 视频评分
- (void)addCommentNot {
    //注册评分通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(starRateVC:) name:@"inputStarRateVCNoti" object:nil];
}

- (void)starRateVC:(NSNotification *)not {
    NSDictionary *roomDic = (NSDictionary *)not.userInfo;
    if ([[SLHelper getCurrentVC] isKindOfClass:[VideoCommentViewController class]]) {
        [[SLHelper getCurrentVC] dismissViewControllerAnimated:NO completion:^{
            [self goToStarVCWithDic:roomDic];
        }];
    } else {
        [self goToStarVCWithDic:roomDic];
    }
}

- (void)goToStarVCWithDic:(NSDictionary *)roomDic {
    VideoCommentViewController *commentVC = [[VideoCommentViewController alloc] init];
    commentVC.roomId = roomDic[@"roomId"];
    commentVC.otherUserId = [roomDic[@"id"] intValue];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:commentVC];
    navi.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:navi animated:YES completion:^{
        [YLUserDefault saveDic:@{}];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
