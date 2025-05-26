//
//  BanRecordingManager.m
//  beijing
//
//  Created by 黎 涛 on 2020/5/22.
//  Copyright © 2020 zhou last. All rights reserved.
//
// 限制录屏截屏manager

#import "BanRecordingManager.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "SLDefaultsHelper.h"
#import "YLAudioPlay.h"
#import "KJJPushHelper.h"
#import "WelcomeViewController.h"

@implementation BanRecordingManager

+ (instancetype)shareManager {
    static BanRecordingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BanRecordingManager alloc] init];
    });
    return manager;
}

// 3.0 新增截屏录屏限制
- (void)addBanScreenRecordingNotification {
    [YLNetworkInterface getVideoScreenshotStatusSuccess:^(NSDictionary *dataDic) {
        // 获取后台限制截屏的开关状态
        BOOL t_screenshot_video_switch = [[NSString stringWithFormat:@"%@", dataDic[@"t_screenshot_video_switch"]] boolValue];
        if (t_screenshot_video_switch == YES) {
            //增加截屏通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshotNotification) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
            
            if (@available(iOS 11.0, *)) {
                // 检测当前是否在录屏
                UIScreen *nowScreen = [UIScreen mainScreen];
                if (nowScreen.isCaptured == 1) {
                    [self exitApp];
                }
                // 增加录屏通知
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(screenshots:) name:UIScreenCapturedDidChangeNotification object:nil];
            }
        } else {
            [self removeBanScreenRecordingNotification];
        }
    }];
}

- (void)userDidTakeScreenshotNotification {
    if ([YLUserDefault userDefault].t_id == 0) return;
    //用户截屏标志
    NSString *temp = (NSString *)[SLDefaultsHelper getSLDefaults:@"userDidTakeScreenshotNotification_temp"];
    if (temp == nil) {
        //警告一次
        [SLDefaultsHelper saveSLDefaults:@"zaicijiepingjiubeifenghao" key:@"userDidTakeScreenshotNotification_temp"];
        [self showAlterView:@"涉及隐私内容，继续截屏将对你封号。"];
    } else {
        [YLNetworkInterface disableUser:[YLUserDefault userDefault].t_id success:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showAlterView:@"你因频繁截屏，已被封号。"];
            });
        }];
    }
}

- (void)showAlterView:(NSString *)msg {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if ([window.rootViewController isKindOfClass:[WelcomeViewController class]]) return;
    
    if([[YLAudioPlay shareInstance] playTime] > 0) {
        [[YLAudioPlay shareInstance] callEndPlay];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoIsOnHangupNoti" object:nil];
    [[AgoraManager shareManager] leaveChannel];
    [KJJPushHelper deleteAlias];
    [YLUserDefault saveUserDefault:@"0" t_id:@"0" t_is_vip:@"1" t_role:@"0"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"T_TOKEN"];
    WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
    
    window.rootViewController = welcomeVC;
    
    UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * knowAction =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertVc addAction:knowAction];
    [welcomeVC presentViewController:alertVc animated:YES completion:nil];
}

- (void)screenshots:(NSNotification *)not {
    if ([YLUserDefault userDefault].t_id == 0) return;
    UIScreen *screen1 = (UIScreen *)not.object;
    if (@available(iOS 11.0, *)) {
        if (screen1.isCaptured == 1) {
            [self exitApp];
        }
    }
}

- (void)exitApp {
    if ([YLUserDefault userDefault].t_id == 0) return;
    UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:@"提示" message:@"本App禁止录屏" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *knowAction =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //检测到录屏就直接杀死app
        [UIView animateWithDuration:.5f animations:^{
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            window.alpha = 0;
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"videoIsOnHangupNoti" object:nil];
            [[AgoraManager shareManager] leaveChannel];
            exit(0);
        }];
    }];
    [alertVc addAction:knowAction];
    [[SLHelper getCurrentVC] presentViewController:alertVc animated:YES completion:nil];
}

- (void)removeBanScreenRecordingNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenCapturedDidChangeNotification object:nil];
    }
}



@end
