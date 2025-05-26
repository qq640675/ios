//
//  YLSocketExtension.m
//  beijing
//
//  Created by zhou last on 2018/7/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLSocketExtension.h"

#import "YLJsonExtension.h"
#import "UIAlertCon+Extension.h"
#import "NSString+Extension.h"
#import "YLAudioPlay.h"
#import "UIAlertCon+Extension.h"
#import "WelcomeViewController.h"
#import <SVProgressHUD.h>
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "NSString+Util.h"
#import "YLHelpCenterController.h"
#import "DefineConstants.h"
#import "BaseView.h"
#import "UserChatLivingViewController.h"
#import "AnchorChatLivingViewController.h"
#import "FullScreenNotView.h"
#import "LXTAlertView.h"
#import "KJJPushHelper.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#include <netdb.h>
#include <arpa/inet.h>
#import "MansionVideoViewController.h"
#import "MansionCallMeViewController.h"
#import "VideoWarningAlertView.h"


@interface YLSocketExtension ()
{
    
    int connectNum;
}

@property (nonatomic ,strong) YLSocketBlock socketBlock;
@property (nonatomic, assign) BOOL      isUserChatLive;
@property (nonatomic, strong) VideoWarningAlertView *alertView;

@end

@implementation YLSocketExtension

#pragma mark ---- 实例
+ (id)shareInstance
{
    static YLSocketExtension *socket = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!socket) {
            socket = [YLSocketExtension new];
        }
    });
    
    return socket;
}

- (void)connectHost {
    _clientSocket = nil;
    if (![self.clientSocket isConnected]) {
        struct hostent *host = gethostbyname([SOCKETIP UTF8String]);
        NSString *socketIp = @"";
        if (host != NULL) {
            socketIp = [NSString stringWithUTF8String:inet_ntoa(*((struct in_addr*)host->h_addr_list[0]))];
        }
        [self.clientSocket connectToHost:socketIp onPort:12580 withTimeout:-1 error:nil];
    }
}


- (GCDAsyncSocket *)clientSocket {
    if (!_clientSocket) {
        _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _clientSocket;
}

#pragma mark - GCDAsynSocket Delegate
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if(err){
        NSLog(@"___socket 断开连接 error:%@", err);
        if (connectNum > 10) {
            connectNum = 0;
//            [SVProgressHUD showInfoWithStatus:@"当前连接已超时，视频语音通话功能暂无法使用，请稍后再试"];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reConnectSocketFiveMinute) object:nil];
            [self performSelector:@selector(reConnectSocketFiveMinute) withObject:nil afterDelay:300];
        } else {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reConnectSocketSixSecond) object:nil];
            [self performSelector:@selector(reConnectSocketSixSecond) withObject:nil afterDelay:6];
        }
    }
}

- (void)reConnectSocketSixSecond {
    [self connectHost];
    connectNum ++;
}

- (void)reConnectSocketFiveMinute {
    [self connectHost];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"___socket 连接成功");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reConnectSocketFiveMinute) object:nil];
    connectNum = 0;
    
    [self.clientSocket performBlock:^{
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue < 16.0) {
            [self.clientSocket enableBackgroundingOnSocket];
        }
        if ([YLUserDefault userDefault].t_id > 0) {
            NSDictionary *dic = @{@"mid":[NSNumber numberWithInt:30001],
                                  @"userId":[NSNumber numberWithInt:[YLUserDefault userDefault].t_id],
                                  @"t_is_vip":[NSNumber numberWithInt:[YLUserDefault userDefault].t_is_vip],
                                  @"t_role":[NSNumber numberWithInt:[YLUserDefault userDefault].t_role],
                                  @"t_sex":[NSNumber numberWithInt:[YLUserDefault userDefault].t_sex]};
            NSString *jsonStr = [YLJsonExtension jsonStrWitNSDictonary:dic];
            NSMutableData *mudata = [NSString encodeSocket:jsonStr];
            
            [self.clientSocket writeData:mudata withTimeout:-1 tag:0];
        }
        [self.clientSocket readDataWithTimeout:-1 tag:0];
    }];
}

- (void)unReceivePingMessage {
//    [SVProgressHUD showInfoWithStatus:@"当前连接已断开，正在重新连接..."];
    [self connectHost];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSUInteger len = [data length];
    
    
    if (len >= 12) {
        NSData *bodyData = [data subdataWithRange:NSMakeRange(8, len - 12)];
        
        NSString * str = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
        
        if ([str isEqualToString:@"0x11"]) {
            NSMutableData *mudata = [NSString encodeSocket:@"01010"];

            [self.clientSocket writeData:mudata withTimeout:-1 tag:0];
            [self.clientSocket readDataWithTimeout:-1 tag:0];
            
//            NSLog(@"___socket PingPong ~");
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(unReceivePingMessage) object:nil];
            [self performSelector:@selector(unReceivePingMessage) withObject:nil afterDelay:35.0];
        }else{
            NSDictionary *dic = [YLJsonExtension dictionaryWithJsonString:str];
            int mid = [dic[@"mid"] intValue];
            NSLog(@"___socket mid:%d", mid);
            if (mid == 30002) {
                //socket 登录成功
            } else if (mid == 30003) {
                //打招呼模拟消息
                [self sendMessage:dic];
                
            } else if(mid == 30004) {
                //用户连主播
                if ([dic allKeys].count != 0) {
                    int roomId = [dic[@"roomId"] intValue];
                    [[YLAudioPlay shareInstance] callPlay];
                    [[YLAudioPlay shareInstance] startAlertSound];
                    
                    [self performSelector:@selector(stopVideoPlayer) withObject:nil afterDelay:29.0f];
                    
                    UIApplicationState state = [UIApplication sharedApplication].applicationState;
                    BOOL result = (state == UIApplicationStateBackground);
                    
                    BOOL connect = [YLUserDefault userDefault].connectOnLine;
                    
                    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [mutDic setObject:[SLHelper getNowTimeTimestamp] forKey:@"nowTime"];
                    [YLUserDefault saveDic:mutDic];
                    
                    if (!connect) {
                        if (!result) {
                            _isUserChatLive = YES;
                            
                            [YLUserDefault saveConnet:YES];

                            //前端
                            [YLUserDefault saveAppOnBack:NO roomId:roomId socketOnLine:YES];
                            
                            [self curControllerPresentVC:dic];

                        }else{
                            //后台
                            [YLUserDefault saveAppOnBack:YES roomId:roomId socketOnLine:YES];
                            [self addlocalNotificationForNewVersion:@"有视频电话"];
                        }
                    }
                }
            } else if (mid == 30005) {
                //视频挂断
                NSLog(@"视频挂断——————30005");
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:[YLUserDefault userDefault].socketdic];
                [mutDic setObject:@"" forKey:@"roomId"];
                [YLUserDefault saveDic:mutDic];
                [YLUserDefault saveAppOnBack:NO roomId:-1 socketOnLine:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"videoIsOnHangupNoti" object:nil];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopVideoPlayer) object:nil];
                [self performSelector:@selector(stopVideoPlayer) withObject:nil afterDelay:.5f];

            } else if (mid == 30006) {
                //被封号
                if([[YLAudioPlay shareInstance] playTime] > 0) {
                    [[YLAudioPlay shareInstance] callEndPlay];
                }
                [[AgoraManager shareManager] leaveChannel];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"videoIsOnHangupNoti" object:nil];
                [KJJPushHelper deleteAlias];
                [YLUserDefault saveUserDefault:@"0" t_id:@"0" t_is_vip:@"1" t_role:@"0"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"T_TOKEN"];
                UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                WelcomeViewController *vc = [[WelcomeViewController alloc] init];
                vc.isProhibition = YES;
                window.rootViewController = vc;
                
            }else if(mid == 30007){
                [self getRedPacketCountRequest];
            }else if(mid == 30008){
                //主播连用户
                NSLog(@"___30008:%@",dic);
                if ([dic allKeys].count != 0) {
                    BOOL connect = [YLUserDefault userDefault].connectOnLine;
                    if (connect == YES) {
                        return;
                    }
                    int roomId = [dic[@"roomId"] intValue];

                    UIApplicationState state = [UIApplication sharedApplication].applicationState;
                    BOOL result = (state == UIApplicationStateBackground);
                    
                    _isUserChatLive = NO;
                    
                    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [mutDic setObject:[SLHelper getNowTimeTimestamp] forKey:@"nowTime"];
                    [YLUserDefault saveDic:mutDic];
                    
                    [[YLAudioPlay shareInstance] callPlay];
                    [[YLAudioPlay shareInstance] startAlertSound];
                    
                    [self performSelector:@selector(stopVideoPlayer) withObject:nil afterDelay:29.0f];
                    
                    if (!connect) {
                        if (!result) {
                            
                            [YLUserDefault saveConnet:YES];
                            //前端
                            [YLUserDefault saveAppOnBack:NO roomId:roomId socketOnLine:YES];
                            
                            [self curControllerPresentVC:dic];
                            
                        }else{
                            //后台
                            [YLUserDefault saveAppOnBack:YES roomId:roomId socketOnLine:YES];
                            [self addlocalNotificationForNewVersion:@"有视频电话"];
                        }
                    }
                }
            } else if (mid == 30010) {
                //余额不足
                [[NSNotificationCenter defaultCenter] postNotificationName:@"liveInsuffiveNoti" object:nil];
            } else if (mid == 30009) {
                //动态红点
                [SLDefaultsHelper saveSLDefaults:@"1" key:@"DynamicNewMsgNumber"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DynamicNewMsgNotification" object:nil];
            } else if (mid == 30012) {
                //接通视频的时候下发消息
                NSString *msg = [NSString stringWithFormat:@"%@",dic[@"msgContent"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatLivingSystemMsgNotification" object:msg];
                
            } else if (mid == 30013) {
                //主播开启速配的时候下发消息
                NSString *msg = [NSString stringWithFormat:@"%@",dic[@"msgContent"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AnchorMatchingSystemMsgNotification" object:msg];
                
            } else if (mid == 30014) {
                //大房间人数
                NSString *msg = [NSString stringWithFormat:@"%@,|_%@",dic[@"userCount"],dic[@"sendUserName"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BigRoomUserCountNotification" object:msg];
            } else if (mid == 30017) {
                // 公屏推送
                [[FullScreenNotView shareView] showWithAnimationWithParam:dic];
            }else if (mid == 30021) {
                //视频警告
                NSString *content = dic[@"content"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RECIEVEVIDEOWARNING" object:content];
            } else if (mid == 30022) {
                // 1V2房间 视频 通知连线  用户呼叫主播
                [self mansionNewSocket:dic type:MansionChatTypeVideo];
            } else if (mid == 30024) {
                //一对二挂断
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MASIONVIDEOHANGUP" object:nil];
            } else if (mid == 31000) {
                //依图警告提示
                [self showPulpAlertView];
            }
            
            [self.clientSocket readDataWithTimeout:-1 tag:0];
        }
    }
}

- (void)showPulpAlertView {
    if (!_alertView) {
        _alertView = [[VideoWarningAlertView alloc] init];
        [_alertView showWithContent:@"违规警告】你可能存在添加微信/QQ等第三方联系方式进行诈骗的行为，请你遵守《新游山严令禁止条约》，否则会被封号！！！"];
        
        [self performSelector:@selector(disalert) withObject:nil afterDelay:5];
    }
}

- (void)disalert
{
    if (_alertView) {
        [_alertView removeFromSuperview];
        _alertView = nil;
    }
}

- (void)mansionNewSocket:(NSDictionary *)dic type:(MansionChatType)type {
    NSLog(@"___ %@", dic);
    if ([dic allKeys].count == 0) {
        return;
    }
    [self performSelector:@selector(stopVideoPlayer) withObject:nil afterDelay:29.0f];
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateBackground);
    
    BOOL connect = [YLUserDefault userDefault].connectOnLine;
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mutDic setObject:[SLHelper getNowTimeTimestamp] forKey:@"nowTime"];
    [YLUserDefault saveDic:mutDic];
                    
    if (connect) {
        return;
    }
    if (!result) {
        [YLUserDefault saveConnet:YES];
        //前端
        [YLUserDefault saveAppOnBack:NO roomId:0 socketOnLine:YES];
        
        [self toNewComingVideoViewControllerWithParam:dic type:type];
    } else {
        [YLUserDefault saveAppOnBack:YES roomId:0 socketOnLine:YES];
        NSString *tip = @"有府邸视频电话";
        if (type == MansionChatTypeVoice) {
            tip = @"有府邸语音电话";
        }
        [self addlocalNotificationForNewVersion:tip];
    }
}

#pragma mark - mansion
- (void)toNewComingVideoViewControllerWithParam:(NSDictionary *)dic type:(MansionChatType)type{
    [[YLAudioPlay shareInstance] callPlay];
    [[YLAudioPlay shareInstance] startAlertSound];
    [LXTAlertView dismiss:^{
        UIViewController *nowVC = [SLHelper getCurrentVC];
        if ([nowVC isKindOfClass:[MansionVideoViewController class]] || [nowVC isKindOfClass:[MansionCallMeViewController class]]) {
            return;
        }
        MansionVideoViewController *videoVC = [[MansionVideoViewController alloc] init];
        videoVC.isNewComing = YES;
        videoVC.ownerId = [[NSString stringWithFormat:@"%@", dic[@"connectUserId"]] intValue];
        videoVC.mansionRoomId = [[NSString stringWithFormat:@"%@", dic[@"mansionRoomId"]] intValue];
        videoVC.roomId = [[NSString stringWithFormat:@"%@", dic[@"roomId"]] intValue];
        videoVC.chatType = type;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:videoVC];
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [nowVC presentViewController:navi animated:YES completion:nil];
    }];
}

#pragma mark - mansion - -

- (void)getRedPacketCountRequest
{
    dispatch_queue_t queue = dispatch_queue_create("获取未拆开的红包", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface getRedPacketCount:[YLUserDefault userDefault].t_id block:^(int total) {
            if (total != 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"YouHaveNewRedPackageNoti" object:[NSString stringWithFormat:@"%d",total]];
            }
        }];
    });
}

- (void)stopVideoPlayer {
    [[YLAudioPlay shareInstance] callEndNoSoundsPaly];
    [[YLAudioPlay shareInstance] stopDisplayLink];
}

- (void)disconnect
{
    [self.clientSocket disconnect];
}

- (void)curControllerPresentVC:(NSDictionary *)dic {
    [LXTAlertView dismiss:^{
        UIViewController *controller = [SLHelper getCurrentVC];
        if (self.isUserChatLive) {
            //弹出主播接听窗口
            NSLog(@"______bug测试-弹出主播界面 收到socket：%@", dic);
            UIViewController *nowVC = [SLHelper getCurrentVC];
            if ([nowVC isKindOfClass:[AnchorChatLivingViewController class]]) return;
            AnchorChatLivingViewController *vc = [[AnchorChatLivingViewController alloc] init];
            vc.roomId   = [dic[@"roomId"] intValue];
            vc.userId = [dic[@"connectUserId"] intValue];
            vc.isMeCallOther = NO;
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [controller presentViewController:navi animated:YES completion:nil];
            
        } else {
            //弹出用户接听窗口
            NSLog(@"______bug测试-弹出用户界面 收到socket：%@", dic);
            UIViewController *nowVC = [SLHelper getCurrentVC];
            if ([nowVC isKindOfClass:[UserChatLivingViewController class]]) return;
            UserChatLivingViewController *vc = [[UserChatLivingViewController alloc] init];
            vc.roomId   = [dic[@"roomId"] intValue];
            vc.anthorId = [dic[@"connectUserId"] intValue];
            vc.isMeCallOther = NO;
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [controller presentViewController:navi animated:YES completion:nil];
        }
    }];
}

- (void)sendMessage:(NSDictionary *)dic {
    NSInteger otherId = [dic[@"activeUserId"] integerValue];
    
    NSString *identifier = [NSString stringWithFormat:@"%ld",otherId+10000];
    //创建聊天
    TIMConversation *c2cConversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:identifier];
    //发送消息
    TIMTextElem *textElem = [[TIMTextElem alloc] init];
    [textElem setText:dic[@"msgContent"]];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:textElem];
    
    [c2cConversation sendMessage:msg succ:nil fail:nil];
    
}


- (void)addlocalNotificationForNewVersion:(NSString *)title {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = title;
        content.body = @"赶快去接听吧";
        content.badge = @1;
        content.sound = [UNNotificationSound defaultSound];
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"XMSWNotification" content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            
        }];
        
    }
    
}

- (BOOL)isConnected {
    return self.clientSocket.isConnected;
}

@end
