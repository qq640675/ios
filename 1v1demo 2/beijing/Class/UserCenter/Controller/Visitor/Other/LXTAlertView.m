//
//  LXTAlertView.m
//  
//
//  Created by 黎涛 on 2019/2/26.
//  Copyright © 2019 XY. All rights reserved.
//

#import "LXTAlertView.h"
#import "DefineConstants.h"
#import "YLRechargeVipController.h"
#import "VoiceVipAlertView.h"

@implementation LXTAlertView

+ (void)alertViewDefaultOnlySureWithTitle:(NSString *)title
                                  message:(NSString *)message
{
    [self alertViewWithTitle:title message:message cancleTitle:nil sureTitle:@"确定" sureHandle:nil];
}

+ (void)alertViewDefaultOnlySureWithTitle:(NSString *)title
                                  message:(NSString *)message
                               sureHandle:(void(^)(void))sure
{
    [self alertViewWithTitle:title message:message cancleTitle:nil sureTitle:@"确定" sureHandle:^{
        if (sure)
        {
            sure();
        }
    }];
}

+ (void)alertViewDefaultWithTitle:(NSString *)title
                          message:(NSString *)message
                       sureHandle:(void(^)(void))sure
{
    [self alertViewWithTitle:title message:message cancleTitle:@"取消" sureTitle:@"确定" sureHandle:^{
        if (sure)
        {
            sure();
        }
    }];
}

+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
               cancleTitle:(nullable NSString *)cancleTitle
                 sureTitle:(NSString *)sureTitle
                sureHandle:(nullable void(^)(void))sure
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sure)
        {
            sure();
        }
    }];
    if (![cancleTitle isEqualToString:@""] && cancleTitle != nil && ![cancleTitle isKindOfClass:[NSNull class]])
    {
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:cancleAction];
        [cancleAction setValue:XZRGB(0x666666) forKey:@"_titleTextColor"];
    }
    
    [alertC addAction:sureAction];
    [sureAction setValue:XZRGB(0x333333) forKey:@"_titleTextColor"];
    
    UIViewController *nowVC = [self getCurrentViewController];
    nowVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [nowVC presentViewController:alertC animated:YES completion:nil];
}

+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
               cancleTitle:(nullable NSString *)cancleTitle
                 sureTitle:(NSString *)sureTitle
                sureHandle:(nullable void(^)(void))sure
              cancleHandle:(nullable void(^)(void))cansle
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sure) {
            sure();
        }
    }];
    if (![cancleTitle isEqualToString:@""] && cancleTitle != nil && ![cancleTitle isKindOfClass:[NSNull class]])
    {
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cansle) {
                cansle();
            }
        }];
        [alertC addAction:cancleAction];
        [cancleAction setValue:XZRGB(0x666666) forKey:@"_titleTextColor"];
    }
    
    [alertC addAction:sureAction];
    [sureAction setValue:XZRGB(0x333333) forKey:@"_titleTextColor"];
    
    UIViewController *nowVC = [self getCurrentViewController];
    nowVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [nowVC presentViewController:alertC animated:YES completion:nil];
}

+ (void)alertActionWithTitle:(nullable NSString *)title
                     message:(nullable NSString *)message
                   actionArr:(NSArray<NSString *> *)actionArr
                actionHandle:(void(^)(int index))sure
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:cancleAction];
    for (int i = 0; i < actionArr.count; i ++)
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (sure)
            {
                sure(i);
            }
        }];
        [alertC addAction:action];
    }
    
    //修改所有按钮的颜色
    alertC.view.tintColor = [UIColor blackColor];
    UIViewController *nowVC = [self getCurrentViewController];
    nowVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [nowVC presentViewController:alertC animated:YES completion:nil];
}


// 非VIP使用功能提示
+ (void)vipAlertWithContent:(NSString *)content {
    NSString *message = [NSString stringWithFormat:@"\n%@功能只有VIP用户才能使用", content];
    if ([content containsString:@"VIP"]) {
        message = content;
    }
    [self alertViewWithTitle:@"温馨提示" message:message cancleTitle:@"暂不开通" sureTitle:@"开通VIP" sureHandle:^{
        [YLPushManager pushVipWithEndTime:nil];
    }];
}

+ (void)videoVIPAlert {
    VoiceVipAlertView *view = [[VoiceVipAlertView alloc] init];
    [view show];
}

+ (void)vipWithContet:(NSString *)content {
    VoiceVipAlertView *view = [[VoiceVipAlertView alloc] init];
    [view showWithContent:content];
}


+ (void)dismiss:(void (^)(void))handle {
    UIViewController *nowVC = [self getCurrentViewController];
    if ([nowVC isKindOfClass:[UIAlertController class]]) {
        [nowVC dismissViewControllerAnimated:NO completion:^{
            if (handle) {
                handle();
            }
        }];
    } else {
        if (handle) {
            handle();
        }
    }
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentViewControllerFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentViewControllerFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController])
    {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]])
    {
        // 根视图为UITabBarController
        currentVC = [self getCurrentViewControllerFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        // 根视图为UINavigationController
        currentVC = [self getCurrentViewControllerFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else
    {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

@end
