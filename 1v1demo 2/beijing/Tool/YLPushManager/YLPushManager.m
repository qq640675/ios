//
//  YLPushManager.m
//  beijing
//
//  Created by yiliaogao on 2019/3/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "YLPushManager.h"
#import "BaseView.h"
#import "UserInfoViewController.h"
#import "ServiceViewController.h"
#import "DetailViewController.h"
#import "ChatViewController.h"
#import "ServiceListViewController.h"
#import "ServiceChatViewController.h"
#import "InviteViewController.h"
#import "ReportViewController.h"
#import "VIPViewController.h"
#import "XZTabBarController.h"
#import "YLEditPhoneController.h"
#import "versionView.h"

@implementation YLPushManager

+ (void)pushAnchorDetail:(NSInteger)anchorId {
    if (anchorId > 0) {
        UIViewController *curVC = [SLHelper getCurrentVC];
        DetailViewController *anchorDetailVC = [[DetailViewController alloc] init];
        anchorDetailVC.anthorId = anchorId;
        [curVC.navigationController pushViewController:anchorDetailVC animated:YES];
    } else {
        [SVProgressHUD showInfoWithStatus:@"ID异常"];
    }
}

+ (void)pushUserInfo:(NSInteger)anchorId {
    [self pushAnchorDetail:anchorId];
//    if (anchorId > 0) {
//        UIViewController *curVC = [SLHelper getCurrentVC];
//        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
//        userInfoVC.anthorId = anchorId;
//        [curVC.navigationController pushViewController:userInfoVC animated:YES];
//    } else {
//        [SVProgressHUD showInfoWithStatus:@"ID异常"];
//    }
}

+ (void)pushFansDetail:(NSInteger)fansId {
    if (fansId > 0) {
        [self pushAnchorDetail:fansId];
    } else {
        [SVProgressHUD showInfoWithStatus:@"ID异常"];
    }
}

+ (void)bannerPushClass:(NSString *)jumpUrl {
    if ([jumpUrl hasPrefix:@"http"]) {
        //跳转到浏览器 safari
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:jumpUrl]];
        ServiceViewController *vc = [[ServiceViewController alloc] init];
        vc.navTitle = @"新游山";
        vc.urlStr = jumpUrl;
        UIViewController *nowVC = [SLHelper getCurrentVC];
        [nowVC.navigationController pushViewController:vc animated:YES];
    } else {
        //跳转内部页面
        UIViewController *curVC = [SLHelper getCurrentVC];
        id classVC = [[NSClassFromString(jumpUrl) alloc] init];
        UIViewController *vc = (UIViewController *)classVC;
        [curVC.navigationController pushViewController:vc animated:YES];
    }
}

+ (void)pushChatViewController:(NSInteger)otherId otherSex:(NSInteger)sex {
    NSString *serviceids = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"serviceids"]];
    NSArray *ids = [serviceids componentsSeparatedByString:@","];
    if ([ids containsObject:[NSString stringWithFormat:@"%ld", otherId]] || [ids containsObject:[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id]]) {
        [self pushServiceChatViewController:otherId];
    } else {
        if ([YLUserDefault userDefault].t_sex == 0 && [YLUserDefault userDefault].t_role == 0) {
            [SVProgressHUD showInfoWithStatus:@"认证主播才能给用户发消息"];
            return;
        }
        if (sex == [YLUserDefault userDefault].t_sex) {
            [SVProgressHUD showInfoWithStatus:@"暂未开放同性用户交流"];
        } else {
            [self pushChatViewController:otherId];
        }
    }
}

+ (void)pushChatViewController:(NSInteger)otherId {
    UIViewController *curVC = [SLHelper getCurrentVC];
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    chatVC.otherUserId = otherId;
    [curVC.navigationController pushViewController:chatVC animated:YES];
}

+ (void)pushServiceChatViewController:(NSInteger)otherId {
    UIViewController *curVC = [SLHelper getCurrentVC];
    ServiceChatViewController *chatVC = [[ServiceChatViewController alloc] init];
    chatVC.otherUserId = otherId;
    [curVC.navigationController pushViewController:chatVC animated:YES];
}

+ (void)pushService {
    UIViewController *curVC = [SLHelper getCurrentVC];
    ServiceListViewController *listVC = [[ServiceListViewController alloc] init];
    [curVC.navigationController pushViewController:listVC animated:YES];
}

//+ (void)pushService {
//    NSString *path = [YLUserDefault userDefault].qqCustomer;
//    if (path == nil) {
//        [SVProgressHUD showInfoWithStatus:@"客服信息错误，请联系管理员查看"];
//        return;
//    }
//    if ([path hasPrefix:@"http"]) {
//        // 53
//        ServiceViewController *vc = [[ServiceViewController alloc] init];
//        vc.navTitle = @"联系客服";
//        vc.urlStr = path;
//        UIViewController *nowVC = [SLHelper getCurrentVC];
//        [nowVC.navigationController pushViewController:vc animated:YES];
//    } else {
//        // QQ
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
//            NSString *openQQUrl = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[YLUserDefault userDefault].qqCustomer];
//            NSURL *url = [NSURL URLWithString:openQQUrl];
//            [[UIApplication sharedApplication] openURL:url];
//        } else {
//            [SVProgressHUD showInfoWithStatus:@"您的手机未安装QQ"];
//        }
//    }
//}

+ (void)pushInvite {
    InviteViewController *inviteVC = [[InviteViewController alloc] init];
    UIViewController *nowVC = [SLHelper getCurrentVC];
    [nowVC.navigationController pushViewController:inviteVC animated:YES];
}


+ (void)pushReportWithId:(NSInteger)userId {
    UIViewController *curVC = [SLHelper getCurrentVC];
    ReportViewController *reportVC = [[ReportViewController alloc] init];
    reportVC.otherUserId = userId;
    [curVC.navigationController pushViewController:reportVC animated:YES];
//    YLReportController *reportVC = [YLReportController new];
//    reportVC.title = @"举报";
//    reportVC.godId = _videoHandle.t_user_id;
//    [curVC.navigationController pushViewController:reportVC animated:YES];
}

+ (void)pushVipWithEndTime:(nullable NSString *)endTime {
    VIPViewController *vipVC = [[VIPViewController alloc] init];
    if (endTime) {
        vipVC.vipEndTime = endTime;
    }
    UIViewController *curVC = [SLHelper getCurrentVC];
    [curVC.navigationController pushViewController:vipVC animated:YES];
}



+ (void)pushMainPage {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    XZTabBarController *tabBarVC  = [XZTabBarController new];
    window.rootViewController = tabBarVC;
    
//    bool t_phone_status = [[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"t_phone_status"]] boolValue];
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    if (t_phone_status) {
//        XZTabBarController *tabBarVC  = [XZTabBarController new];
//        window.rootViewController = tabBarVC;
//    } else {
//
//        YLEditPhoneController *vc = [[YLEditPhoneController alloc] init];
//        vc.isNeesLoadMain = YES;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        [vc.navigationController setNavigationBarHidden:NO animated:YES];
//        vc.navigationItem.title = @"绑定手机号";
//        window.rootViewController = nav;
//    }
}


+ (void)appNeedUptateWithData:(NSDictionary *)dataDic {
    // xiugai
    return;
    
    BOOL isShowUpdate = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowUpdate"];
    if (isShowUpdate) return;
        
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", dataDic[@"t_download_url"]] forKey:@"APP_UPDATE_DOWNLOADURL"];
    //app强制更新
    UIView *blackView = [UIView new];
    blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    blackView.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
    [YLAppWindow addSubview:blackView];
    
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"versionView" owner:nil options:nil];
    versionView *version = xibArray[0];
    version.versionLabel.text = [NSString stringWithFormat:@"发现新版本V%@",[NSString stringWithFormat:@"%@", dataDic[@"t_version"]]];
    version.textView.text = dataDic[@"t_version_depict"];
    [YLAppWindow addSubview:version];
    
    [version mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(App_Frame_Width/2. - 130.);
        make.top.mas_equalTo(APP_Frame_Height/2. - 163.5);
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(327);
    }];
    
    [version.updateBtn addTarget:self action:@selector(clickedUpdateVersionBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowUpdate"];
}

+ (void)clickedUpdateVersionBtn {
    NSString *url = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_UPDATE_DOWNLOADURL"]];
    if (![NSString isNullOrEmpty:url]) {
        [NSString openScheme:url];
    }else{
        [SVProgressHUD showInfoWithStatus:@"下载地址有误"];
    }
}


@end
