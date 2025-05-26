//
//  ChatLiveManager.m
//  beijing
//
//  Created by yiliaogao on 2019/2/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "ChatLiveManager.h"
#import "JChatConstants.h"
#import "DefineConstants.h"
#import "YLUserDefault.h"
#import "UIAlertCon+Extension.h"
#import "YLValidExtension.h"
#import "SLHelper.h"
#import "YLNetworkInterface.h"
#import "videochatInsuffiView.h"
#import "YLTapGesture.h"
#import "YLRechargeVipController.h"
#import "YLInsufficientManager.h"
#import "YLSocketExtension.h"
#import "LXTAlertView.h"
#import "UserChatLivingViewController.h"
#import "AnchorChatLivingViewController.h"

static ChatLiveManager *chatLiveManager = nil;

@implementation ChatLiveManager

+ (id)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!chatLiveManager) {
            chatLiveManager = [ChatLiveManager new];
        }
    });
    return chatLiveManager;
}

- (void)getVideoChatAutographWithOtherId:(int)otherId type:(int)videoType fail:(void (^ _Nullable)(void))fail {
    
    if (![[YLSocketExtension shareInstance] isConnected]) {
        [LXTAlertView alertViewDefaultOnlySureWithTitle:@"温馨提示" message:@"当前连接已断开，请重试"];
        [[YLSocketExtension shareInstance] disconnect];
        [[YLSocketExtension shareInstance] connectHost];
        return;
    }
    if (fail) {
        self.callFailBlock = fail;
    }
    
    _isUser = YES;
    if ([YLUserDefault userDefault].t_role == 1) {
        _isUser = NO;
    }
    
    if (_isUser) {
        //用户呼叫主播
        _userId  = [YLUserDefault userDefault].t_id;
        _anchorId = otherId;
    } else {
        //主播呼叫用户
        _userId  = otherId;
        _anchorId = [YLUserDefault userDefault].t_id;
    }
    
    if ([YLUserDefault userDefault].t_sex == 1 && [YLUserDefault userDefault].t_is_vip == 0) {
        [YLNetworkInterface vipSwitchWithAnchorId:otherId Success:^(int resultCode, NSString *message) {
            if (resultCode == 1) {
                [self chatWithOtherId:otherId type:videoType];
            } else if (resultCode == 2){
                [LXTAlertView alertViewDefaultWithTitle:@"提示" message:message sureHandle:^{
                    [self chatWithOtherId:otherId type:videoType];
                }];
            } else {
                [SVProgressHUD showInfoWithStatus:message];
            }
        }];
    } else {
        [self chatWithOtherId:otherId type:videoType];
    }
}

- (void)chatWithOtherId:(int)otherId type:(int)videoType {
    
    [SVProgressHUD show];
    _videoType = videoType;
    UIViewController *curController = [SLHelper getCurrentVC];
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [UIAlertCon_Extension seeWeixinOrPhone:@"此App会在视频聊天服务中访问您的相机权限" type:UIAlertControllerStyleAlert controller:curController delSel:^(UIAlertAction *okSel) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        } oktittle:@"去开启"];
        [SVProgressHUD dismiss];
        return;
    } else {
        BOOL isOpenMicro = [YLValidExtension judgeMicrophone];
        
        if (!isOpenMicro) {
            [UIAlertCon_Extension seeWeixinOrPhone:@"此App会在视频聊天服务中访问您的麦克风权限" type:UIAlertControllerStyleAlert controller:curController delSel:^(UIAlertAction *okSel) {
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                    [[UIApplication sharedApplication] openURL:settingsURL];
                }
            } oktittle:@"去开启"];
            [SVProgressHUD dismiss];
            return;
        }
    }
    
    WEAKSELF
    [YLNetworkInterface getVideoChatAutograph:_userId anchorId:_anchorId block:^(NSString *userSig, int roomId, int onlineState) {
        weakSelf.roomId = roomId;
        if (onlineState == 1 && weakSelf.isUser) {
            //不足一分钟，提醒充值
            [weakSelf showRechargeView];
            [SVProgressHUD dismiss];
        } else if (onlineState == -1 && weakSelf.isUser) {
            //余额不足，提醒充值
            [weakSelf noMoney];
        } else {
            //发起呼叫
            [weakSelf startChatLive];
        }
    }];
    
}

- (void)startChatLive {
    [LXTAlertView dismiss:^{
        UIViewController *nowVC = [SLHelper getCurrentVC];
        if (self.isUser) {
            //用户对主播
            WEAKSELF
            [YLNetworkInterface launchVideoUserId:self.userId coverLinkUserId:self.anchorId roomId:self.roomId chatType:self.videoType block:^(int code) {
                if (code == 1) {
                    NSLog(@"______bug测试-主动呼叫 用户呼叫主播接口 成功 弹起用户界面");
                    if ([nowVC isKindOfClass:[UserChatLivingViewController class]]) return;
                    UserChatLivingViewController *vc = [[UserChatLivingViewController alloc] init];
                    vc.roomId = weakSelf.roomId;
                    vc.anthorId = weakSelf.anchorId;
                    vc.isMeCallOther = YES;
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                    [nowVC presentViewController:nav animated:YES completion:nil];
                } else {
                    if (self.callFailBlock) {
                        self.callFailBlock();
                    }
                    if (code == -4) {
                        //余额不足
                        [weakSelf noMoney];
                    }
                }
            }];
        } else {
            //主播对用户
            WEAKSELF
            [YLNetworkInterface anchorLaunchVideoChat:self.anchorId userId:self.userId roomId:self.roomId chatType:self.videoType block:^(int code) {
                if (code == 1) {
                    NSLog(@"______bug测试-主动呼叫 主播呼叫用户接口 成功 弹起主播界面");
                    UIViewController *nowVC = [SLHelper getCurrentVC];
                    if ([nowVC isKindOfClass:[AnchorChatLivingViewController class]]) return;
                    AnchorChatLivingViewController *vc = [[AnchorChatLivingViewController alloc] init];
                    vc.roomId = weakSelf.roomId;
                    vc.userId = weakSelf.userId;
                    vc.isMeCallOther = YES;
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                    [nowVC presentViewController:nav animated:YES completion:nil];
                } else {
                    if (self.callFailBlock) {
                        self.callFailBlock();
                    }
                }
            }];
        }
    }];
    
}

- (void)showRechargeView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    bgView.tag = 100;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"videochatInsuffiView" owner:nil options:nil];
    videochatInsuffiView *suffiView = xibArray[0];
    [suffiView suffiCordius];
    [bgView addSubview:suffiView];
    
    [YLTapGesture addTaget:self sel:@selector(closeSuffiView) view:suffiView.closeBtn];
    //充值
    [YLTapGesture addTaget:self sel:@selector(inputRechargeVC) view:suffiView.rechargeBtn];
    //是否继续呼叫
    [YLTapGesture addTaget:self sel:@selector(judgeCalling) view:suffiView.callingNowBtn];
    
    [suffiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_WIDTH/2. - 310/2.);
        make.top.mas_equalTo(SCREEN_HEIGHT/2. - 149/2.);
        make.width.mas_equalTo(310);
        make.height.mas_equalTo(149);
    }];
}

- (void)noMoney {
    UIViewController *vc = [SLHelper getCurrentVC];
    [[YLInsufficientManager shareInstance] insufficientShow];
}


- (void)closeSuffiView {
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == 100) {
            [view removeFromSuperview];
        }
    }
}

- (void)inputRechargeVC {
    [self closeSuffiView];
    
    UIViewController *curController = [SLHelper getCurrentVC];
    
    YLRechargeVipController *vipVC = [YLRechargeVipController new];
    [curController.navigationController pushViewController:vipVC animated:NO];
}

- (void)judgeCalling {
    
    [self startChatLive];
    
    [self closeSuffiView];
}




@end
