//
//  AppDelegate.m
//  beijing
//
//  Created by zhou last on 2018/7/18.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "AppDelegate.h"
#import "XZTabBarController.h"
#import <QCloudCore/QCloudCore.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <WXApi.h>
#import "WXApiManager.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "YLSocketExtension.h"
#import "YLJsonExtension.h"

#import <JPUSHService.h>
#import "imLoginExtension.h"
#import "KJJPushHelper.h"
#import "YLSexTypeViewController.h"

#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "sqlite_interface.h"

#import "YLAudioPlay.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "YLStarRateController.h"
#import "SLHelper.h"
#import "AnchorChatLivingViewController.h"
#import "UserChatLivingViewController.h"
#import "WelcomeViewController.h"

#import "JChatConstants.h"
#import "TUIKit.h"

//启动广告
#import "LaunchAdvImageView.h"
#import "LaunchAdvViewController.h"

#import "UITextViewWorkaround.h"
#import "MansionVideoViewController.h"
#import "MansionCallMeViewController.h"
#import "AgoraManager.h"
#import "YLEditPhoneController.h"
#import <TiSDK/TiSDK.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "FUDemoManager.h"

@interface AppDelegate ()
<

QCloudSignatureProvider,
QCloudCredentailFenceQueueDelegate,
WXApiDelegate,
QQApiInterfaceDelegate,
TencentSessionDelegate,
UNNotificationContentExtension,
JPUSHRegisterDelegate,
TIMUserStatusListener
>

{
    NSDictionary *backDic;//后台接收到的推送
}
@property (nonatomic, strong) QCloudCredentailFenceQueue* credentialFenceQueue;

@property(nonatomic,strong)TencentOAuth *tencentOAuth;
@property (nonatomic, assign) BOOL isLoadTabbar;
@property (nonatomic, assign) BOOL isNeedLoadThirdSetup;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"agora version:%@", [AgoraRtcEngineKit getSdkVersion]);
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowUpdate"];
    [UITextViewWorkaround executeWorkaround];
    [self.window makeKeyAndVisible];
    
    
    
    //监听音乐是否被打断
    AudioSessionInitialize(NULL, NULL, interruptionListenner, (__bridge void*)self);
    
    [[UIButton appearance] setExclusiveTouch:YES];
    [[UIView appearance] setExclusiveTouch:YES];
    
    SVProgressHUD.defaultStyle = SVProgressHUDStyleDark;
    SVProgressHUD.minimumDismissTimeInterval = 2.0;
    
    self.isLoadTabbar = NO;
    self.isNeedLoadThirdSetup = NO;
    //美颜
//    [FUDemoManager setupFUSDK];
//    NSString *v3Path = [[NSBundle mainBundle] pathForResource:@"v3" ofType:@"bundle"];
//    [[FURenderer shareRenderer] setupWithDataPath:v3Path authPackage:g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];
//    [FUUserDefault setDefaultFU];
//    [FUUserDefault setFUManager];
//
//    [[TiSDK shareInstance] initSDK:@"4d85f5ec09bd4faab7acdc1b71059d7f" withDelegate:nil];
    
    [[TiSDK shareInstance] initSDK:@"" withDelegate:nil];

    [[AipOcrService shardService] authWithAK:@"GKrutmd2QFGIxskZeaq3NupG" andSK:@"AeplaDGP27W8Nm2vBbTfiG5eFgEq5rH4"];
    
    //地图
    [AMapServices sharedServices].apiKey = amapKey;
    
    /** 腾讯云IM */
    TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
    config.sdkAppId = [bascicTecentCloudIMAppId intValue];
    config.disableLogPrint = YES;
    config.logLevel = 6;
    [[TIMManager sharedInstance] initSdk:config];
    //用户
    TIMUserConfig *userConfig = [[TIMUserConfig alloc] init];
    userConfig.userStatusListener = self;
    [[TIMManager sharedInstance] setUserConfig:userConfig];
    
    [[TUIKit sharedInstance] setupWithAppId:(long)bascicTecentCloudIMAppId];
    
    NSLog(@"%ld", (long)QCloudCOSXMLService.version);
    [[SandPayGateService shared] setIsLogEnable:YES];
    [YLUserDefault saveConnet:NO];
    
    if (![YLUserDefault userDefault].isFirstInstall) {
        [YLUserDefault saveMsgVibrate:YES];
        [YLUserDefault saveMsgAudio:NO];
        [YLUserDefault saveGroupMsgVibrate:YES];
        [YLUserDefault saveGroupMsgAudio:NO];
        [YLUserDefault saveAppInstall:YES];
    }
    
//    if ([YLUserDefault userDefault].t_id > 0) {
//        [self loadAdvImage];
//    } else {
//        [self inputTabBar];
//    }
    [self goThirdSetup:launchOptions];
    
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|UNAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
    }];
    
    //腾讯im推送
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    

//    [self setupCOSXMLShareService];
//    self.credentialFenceQueue = [QCloudCredentailFenceQueue new];
//    self.credentialFenceQueue.delegate = self;


    //向微信注册
    //向微信注册
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
         
    }];
   
    [WXApi registerApp:bascicWechatAppId universalLink:wechatuniversalLink];

    [self networkStateChange];
    [self shareRegist];

    [self initTencentOss];//加载对象存储配置
    self.credentialFenceQueue = [QCloudCredentailFenceQueue new];
    self.credentialFenceQueue.delegate = self;
    
    //jpush
    [KJJPushHelper setupWithOption:launchOptions appKey:bascicJGAppKey channel:nil apsForProduction:YES advertisingIdentifier:nil];
    [JPUSHService setLogOFF];
    
    //JPush 监听登陆成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kJPushnetworkDidLogin:)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
    
    //向微信注册支持的文件类型
//    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
//
//    [WXApi registerAppSupportContentFlag:typeFlag];


    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setNeedsLayout];
    
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    
    if (@available(iOS 13.0, *)) {
        
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback  error:nil];
    
    
//    [YLNetworkInterface getTemporaryIP];//获取是否需要使用临时访问地址
    
    return YES;
}

/**
 *  登录成功，设置别名，移除监听
 *
 *  @param notification 信息
 */
- (void)kJPushnetworkDidLogin:(NSNotification *)notification {

    //本处用的token做为别名
    [KJJPushHelper setAlias:[YLUserDefault userDefault].t_id];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kJPFNetworkDidLoginNotification
                                                  object:nil];
}


//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    [QQApiInterface handleOpenURL:url delegate:self];
//
//    if ([url.host isEqualToString:@"oauth"]) {
//        //微信
//        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//    }else{
//        //qq
//        return [TencentOAuth HandleOpenURL:url];
//    }
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    [QQApiInterface handleOpenURL:url delegate:self];
//
//    if ([url.host isEqualToString:@"oauth"] || [url.host isEqualToString:@"pay"]) {
//        //微信
//        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//    }else{
//        //qq
//        return [TencentOAuth HandleOpenURL:url];
//    }
//}

#pragma mark - adv image
- (void)loadAdvImage {
    WEAKSELF;
    LaunchAdvImageView *advImageV = [[LaunchAdvImageView alloc] init];
    advImageV.jumpButtonClick = ^{
        [weakSelf inputTabBar];
    };
    advImageV.advImageClick = ^(NSString * _Nonnull urlString) {
        [weakSelf loadAdv:urlString];
    };
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    [self.window.rootViewController.view addSubview:vc.view];

    [YLNetworkInterface getAdTableWithType:1 userId:0 page:1 timeout:5 success:^(NSArray *dataAttay) {
        if (dataAttay.count == 0) {
            [self inputTabBar];
        } else {
            if ([dataAttay[0] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *advDic = dataAttay[0];
                if (advDic[@"t_ad_table_url"] != nil && ![advDic[@"t_ad_table_url"] isKindOfClass:[NSNull class]]) {
                    NSString *advImageUrl = advDic[@"t_ad_table_url"];
                    if (advImageUrl.length > 0) {
                        // 有广告图片链接
                        [self.window.rootViewController.view addSubview:advImageV];
                        advImageV.imageUrl = advImageUrl;
                        if (advDic[@"t_ad_table_target"] != nil && ![advDic[@"t_ad_table_target"] isKindOfClass:[NSNull class]]) {
                            NSString *advUrl = advDic[@"t_ad_table_target"];
                            if (advUrl.length > 0 && [advUrl hasPrefix:@"http"]) {
                                // 有广告点击链接
                                advImageV.advUrl = advUrl;
                            }
                        }
                    }
                }
            } else {
                [self inputTabBar];
            }
        }
    } fail:^{
        [self inputTabBar];
    }];
}

- (void)loadAdv:(NSString *)advUrl {
    WEAKSELF;
    LaunchAdvViewController *advVC = [[LaunchAdvViewController alloc] init];
    advVC.fromType = 0;
    advVC.advUrl = advUrl;
    advVC.cancleBlock = ^{
        [weakSelf inputTabBar];
    };
    self.window.rootViewController = advVC;
}

#pragma mark ----
- (void)inputTabBar
{
    if ([YLUserDefault userDefault].t_id == 0) {
        WelcomeViewController *loginVC = [WelcomeViewController new];
        self.window.rootViewController = loginVC;
    }else{
        NSString *strSex = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"t_sex"];
        if ([strSex integerValue] == -1) {
            YLSexTypeViewController *sexTypeVC = [YLSexTypeViewController new];
            self.window.rootViewController = sexTypeVC;
        } else {
            
            [KJJPushHelper setAlias:[YLUserDefault userDefault].t_id];

            //更新登录时间
            [YLNetworkInterface upLoginTime:[YLUserDefault userDefault].t_id block:^(BOOL isSuccess) {
            }];

            XZTabBarController *tabBarVC  = [XZTabBarController new];
            self.window.rootViewController = tabBarVC;
            self.isLoadTabbar = YES;
            [self judgeToIsOnVideo];
            
//            bool t_phone_status = [[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"t_phone_status"]] boolValue];
//            if (t_phone_status) {
//                XZTabBarController *tabBarVC  = [XZTabBarController new];
//                self.window.rootViewController = tabBarVC;
//                self.isLoadTabbar = YES;
//                [self judgeToIsOnVideo];
//            } else {
//                YLEditPhoneController *vc = [[YLEditPhoneController alloc] init];
//                vc.isNeesLoadMain = YES;
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//                [vc.navigationController setNavigationBarHidden:NO animated:YES];
//                vc.navigationItem.title = @"绑定手机号";
//                self.window.rootViewController = nav;
//            }
            
            
        }
    }
}

#pragma mark ---- 分享
- (void)shareRegist {
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:bascicQQAppId appkey:bascicQQAppKey enableUniversalLink:NO universalLink:nil];

        //微信
        [platformsRegister setupWeChatWithAppId:bascicWechatAppId appSecret:bascicWechatSecret universalLink:wechatuniversalLink];
    }];
}

#pragma mark ---- 检查网络

- (void)networkStateChange
{
    // 1.检测wifi状态
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                [SVProgressHUD showInfoWithStatus:@"没有网络,请检查网络连接!"];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                if (self.isNeedLoadThirdSetup == YES)
                {
                    self.isNeedLoadThirdSetup = NO;
                    
                    [self loadThirdSetup:NO withIsLoadBar:NO withOptions:nil];
                }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                if (self.isNeedLoadThirdSetup == YES)
                {
                    self.isNeedLoadThirdSetup = NO;
                    
                    [self loadThirdSetup:NO withIsLoadBar:NO withOptions:nil];
                }
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}


#pragma mark ---- 极光推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    [KJJPushHelper registerDeviceToken:deviceToken];
    self.deviceToken = deviceToken;
}

-(void) initTencentOss{
    [YLNetworkInterface getTencentTempApiData:^(NSDictionary *dataDic) {
        if(dataDic != nil){
            
            [TencentApiDefault saveTmpAppid:dataDic[@"t_app_id"]];
            [TencentApiDefault saveTmpRegion:dataDic[@"t_region"]];
            [TencentApiDefault saveTmpBucket:dataDic[@"t_bucket"]];
            [TencentApiDefault saveTmpSecretId:dataDic[@"t_secret_id"]];
            [TencentApiDefault saveTmpSecretKey:dataDic[@"t_secret_key"]];
            [self setupCOSXMLShareService];
        }
        
    }];
}

-(void)initAgora{
//    [YLNetworkInterface getAgoraAppId:^(NSDictionary *dic) {
//        if(dic != nil){
//            [AgoraApiDefault saveTmpAppid:dic[@"appId"]];
//            
//            NSString *agoraid = [AESUtil decrypt:dic[@"appId"] withKey:@"e06ecadca77b16e3d2a924e7e7ad2de1e1a7413b7ed65cbd1bb40dc0ff2f34a2"];
//            NSLog(@"%@",agoraid);
//        }
//        
//        
//    }];
}

#pragma mark ------ 上传到腾讯云
- (void) fenceQueue:(QCloudCredentailFenceQueue *)queue requestCreatorWithContinue:(QCloudCredentailFenceQueueContinue)continueBlock
{
    QCloudCredential* credential = [QCloudCredential new];
    [YLNetworkInterface getTencentTempApiData:^(NSDictionary *dataDic) {
        if(dataDic != nil){
            QCloudCredential* credential = [QCloudCredential new];
            credential.secretID = dataDic[@"t_secret_id"];;
            credential.secretKey = dataDic[@"t_secret_key"];
            
            credential.expirationDate = [NSDate dateWithTimeIntervalSinceNow:2*60*60];
            credential.token =dataDic[@"sessionToken"];
            
            [TencentApiDefault saveTmpAppid:dataDic[@"t_app_id"]];
            [TencentApiDefault saveTmpRegion:dataDic[@"t_region"]];
            [TencentApiDefault saveTmpBucket:dataDic[@"t_bucket"]];
            
            QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
            continueBlock(creator, nil);
            
        }
        
    }];
//    QCloudCredential* credential = [QCloudCredential new];
//    credential.secretID = bascicTecentCloudSecretID;
//    credential.secretKey = bascicTecentCloudSecretKEY;
//    credential.experationDate = [NSDate dateWithTimeIntervalSince1970:1504183628];
//    credential.token = @"";
//    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
//    continueBlock(creator, nil);
}

- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSMutableURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    
#ifdef USE_TEMPERATE_SECRET
    [self.credentialFenceQueue performAction:^(QCloudAuthentationCreator *creator, NSError *error) {
        if (error) {
            continueBlock(nil, error);
        } else {
            QCloudSignature* signature =  [creator signatureForData:urlRequst];
            continueBlock(signature, nil);
        }
    }];
#else
    QCloudCredential* credential = [QCloudCredential new];

//    credential.secretID = bascicTecentCloudSecretID;
//    credential.secretKey = bascicTecentCloudSecretKEY;
    
    credential.secretID = [TencentApiDefault apiDefault].tmpSecretId;
    credential.secretKey = [TencentApiDefault apiDefault].tmpSecretKey;
    
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
#endif
}

- (void) setupCOSXMLShareService {
    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];

//    configuration.appID = bascicTecentCloudAppId;
    configuration.appID = [TencentApiDefault apiDefault].appid;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];

//    endpoint.regionName = bascicRegion;
    endpoint.regionName = [TencentApiDefault apiDefault].region;
    configuration.endpoint = endpoint;
    
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];

}


-(void)didReceiveJPushNotification:(NSDictionary *)notiDict{
    //在这里统一处理接收通知的处理，notiDict为接收到的所有数据

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    // Required,For systems with less than or equal to iOS6
    [KJJPushHelper handleRemoteNotification:userInfo completion:nil];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [KJJPushHelper handleRemoteNotification:userInfo completion:completionHandler];
    [JPUSHService handleRemoteNotification:userInfo];

 
    if ([YLUserDefault userDefault].msgVibrate) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    if ([YLUserDefault userDefault].msgAudio) {
        [[YLAudioPlay shareInstance] callMSGPlay];
    }
    

    [self judgeToIsOnVideo];
    
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [KJJPushHelper showLocalNotificationAtFront:notification];
    
    return;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options NS_AVAILABLE_IOS(9_0) {
    if ([url.absoluteString hasPrefix:bascicWechatAppId]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];;
    }
    if ([url.host isEqualToString:@"oauth"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    } else {
        return [TencentOAuth HandleOpenURL:url];
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    [WXApi handleOpenUniversalLink:userActivity delegate:[WXApiManager sharedManager]];
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        if (url && [TencentOAuth CanHandleUniversalLink:url]) {

            [TencentOAuth HandleUniversalLink:url];

            return [TencentOAuth HandleUniversalLink:url];
         }
    }
    return YES;
}


#pragma mark ------ 上传到腾讯云
//- (void) fenceQueue:(QCloudCredentailFenceQueue *)queue requestCreatorWithContinue:(QCloudCredentailFenceQueueContinue)continueBlock
//{
//    QCloudCredential* credential = [QCloudCredential new];
//    credential.secretID = bascicTecentCloudSecretID;
//    credential.secretKey = bascicTecentCloudSecretKEY;
//    credential.expirationDate = [NSDate dateWithTimeIntervalSince1970:1504183628];
////    credential.experationDate = [NSDate dateWithTimeIntervalSince1970:1504183628];
//    credential.token = @"";
//    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
//    continueBlock(creator, nil);
//    
//}

//- (void) signatureWithFields:(QCloudSignatureFields*)fileds
//                     request:(QCloudBizHTTPRequest*)request
//                  urlRequest:(NSMutableURLRequest*)urlRequst
//                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
//{
//#ifdef USE_TEMPERATE_SECRET
//    [self.credentialFenceQueue performAction:^(QCloudAuthentationCreator *creator, NSError *error) {
//        if (error) {
//            continueBlock(nil, error);
//        } else {
//            QCloudSignature* signature =  [creator signatureForData:urlRequst];
//            continueBlock(signature, nil);
//        }
//    }];
//#else
//    QCloudCredential* credential = [QCloudCredential new];
//
//    credential.secretID = bascicTecentCloudSecretID;
//    credential.secretKey = bascicTecentCloudSecretKEY;
//    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
//    QCloudSignature* signature =  [creator signatureForData:urlRequst];
//    continueBlock(signature, nil);
//#endif
//}

//- (void) setupCOSXMLShareService {
//    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
//
//    configuration.appID = bascicTecentCloudAppId;
//    configuration.signatureProvider = self;
//    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
//
//    endpoint.regionName = bascicRegion;
//    configuration.endpoint = endpoint;
//    
//    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
//    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
//
//}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    if (![YLUserDefault userDefault].connectOnLine) {
        //在没有视频通话的的情况下，进入后台播放无声音乐，保持后台挂起
        [[YLAudioPlay shareInstance] startPlayNoVoiceMP3];
        //停止视频的播放
        [[NSNotificationCenter defaultCenter] postNotificationName:@"enterBackgroundStopAudio" object:nil];
        //停止一键匹配的自动呼叫
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPAUTOCALL" object:nil];
    }
    
    
    
    UIApplication* app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadCount;
    
    
    TIMBackgroundParam  *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:unReadCount];
    [[TIMManager sharedInstance] doBackground:param succ:^() {
        
    } fail:^(int code, NSString * err) {
        
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application cancelAllLocalNotifications];
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if (![[YLSocketExtension shareInstance] isConnected] && [YLUserDefault userDefault].t_id > 0 && _isLoadTabbar) {
        [[YLSocketExtension shareInstance] disconnect];
        [[YLSocketExtension shareInstance] connectHost];
    }
    
    [[YLAudioPlay shareInstance] stopPlayNoVoiceMP3];
    
    [[TIMManager sharedInstance] doForeground:^() {
        
    } fail:^(int code, NSString * err) {
        
    }];
    
    
   [self judgeToIsOnVideo];
    
    return;
}

- (void)judgeToIsOnVideo
{
    
    if (self.isLoadTabbar == NO) {
        return;
    }
    if ([YLUserDefault userDefault].socketOnLine) {
        backDic = [YLUserDefault userDefault].socketdic;
    }
    
    if (![[backDic allKeys] containsObject:@"connectUserId"]&& ![[backDic allKeys] containsObject:@"roomId"]) {
        dispatch_queue_t queue = dispatch_queue_create("标识符", DISPATCH_QUEUE_CONCURRENT);
        //使用异步函数封装三个任务
        dispatch_async(queue, ^{
            if ([YLUserDefault userDefault].connectOnLine) {
                return;
            }
            
            if ([YLUserDefault userDefault].socketOnLine) {
                return;
            }
            
            BOOL onBack = [YLUserDefault userDefault].appOnBack;
            
            if (!onBack) {
                //在后台才处理
                return;
            }
            
            if ([YLUserDefault userDefault].t_id == 0) {
                return;
            }
            [YLNetworkInterface getUuserCoverCal:[YLUserDefault userDefault].t_id block:^(NSDictionary *dic) {
                if (dic.allKeys.count != 0) {
                    
                    int roomId = [dic[@"roomId"] intValue];
                    
                    int coverLinkUserId = [dic[@"coverLinkUserId"] intValue];
                    int connectUserId = [dic[@"connectUserId"] intValue];
                    int satisfy = [dic[@"satisfy"] intValue];
                    
                    if (connectUserId == [YLUserDefault userDefault].t_id) {
                        connectUserId = coverLinkUserId;
                    }
                    
                    NSDictionary *mudic = @{@"connectUserId":[NSString stringWithFormat:@"%d",connectUserId],@"satisfy":[NSString stringWithFormat:@"%d",satisfy],@"roomId":[NSString stringWithFormat:@"%d",roomId]};
                    
                    int mid = [[NSString stringWithFormat:@"%@", dic[@"mid"]] intValue];
                    if (roomId != -1)
                    {
                        if (mid == 30022 || mid == 30023) {
                            // 府邸视频
                            [self toNewComingVideoViewControllerWithParam:dic mid:mid];
                            return;
                        }
                        [YLUserDefault saveDic:mudic];
                        [YLUserDefault saveConnet:YES];
                        NSLog(@"______bug测试-delegate-1111111111111");
                        [self curControllerPresentVC:mudic];
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"对方已挂断"];
                        return;
                    }
                    
                }
            }];
        });
        return;
    }
    
    if ([backDic count]) {
        if ([[backDic allKeys] containsObject:@"connectUserId"] && [[backDic allKeys] containsObject:@"roomId"]) {
            
            int roomId = [backDic[@"roomId"] intValue];
            BOOL onBack = [YLUserDefault userDefault].appOnBack;
            
            if (!onBack) {
                //在后台才处理
                return;
            }
            
            NSInteger dicTime = [backDic[@"nowTime"] integerValue];
            NSInteger nowTime = [[SLHelper getNowTimeTimestamp] integerValue];
            NSLog(@"___dicTime:%ld    nowTime:%ld", (long)dicTime, (long)nowTime);
            if (nowTime - dicTime > 30) {
                // 时间已经超过30秒  不再弹出
                return;
            }
            
            BOOL connect = [YLUserDefault userDefault].connectOnLine;
            
            if (!connect) {
                if (roomId != -1)
                {
                    int mid = [[NSString stringWithFormat:@"%@", backDic[@"mid"]] intValue];
                    if (mid == 30022 || mid == 30023) {
                        // 府邸视频
                        [self toNewComingVideoViewControllerWithParam:backDic mid:mid];
                        return;
                    }
                    
                    [YLUserDefault saveDic:backDic];
                    [YLUserDefault saveConnet:YES];
                    NSLog(@"______bug测试-delegate-222222222222");
                    [self curControllerPresentVC:backDic];
                }else{
                    [SVProgressHUD showInfoWithStatus:@"对方已挂断"];
                }
            }
        }
    }
}

- (void)toNewComingVideoViewControllerWithParam:(NSDictionary *)dic mid:(int)mid{
    [LXTAlertView dismiss:^{
        UIViewController *nowVC = [SLHelper getCurrentVC];
        if ([nowVC isKindOfClass:[MansionVideoViewController class]] || [nowVC isKindOfClass:[MansionCallMeViewController class]]) {
            return;
        }
        MansionChatType chatType = MansionChatTypeVideo;
        if (mid == 30023) {
            chatType = MansionChatTypeVoice;
        }
        MansionVideoViewController *videoVC = [[MansionVideoViewController alloc] init];
        videoVC.isNewComing = YES;
        videoVC.ownerId = [[NSString stringWithFormat:@"%@", dic[@"connectUserId"]] intValue];
        videoVC.mansionRoomId = [[NSString stringWithFormat:@"%@", dic[@"mansionRoomId"]] intValue];
        videoVC.roomId = [[NSString stringWithFormat:@"%@", dic[@"roomId"]] intValue];
        videoVC.chatType = chatType;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:videoVC];
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [nowVC presentViewController:navi animated:YES completion:nil];
    }];
}

- (void)curControllerPresentVC:(NSDictionary *)dic {
    
    [LXTAlertView dismiss:^{
        UIViewController *controller = [SLHelper getCurrentVC];
        if ([YLUserDefault userDefault].t_role == 1) {
            //弹出主播接听窗口
            NSLog(@"______bug测试-弹出主播界面 appdelegate dic%@", dic);
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
            NSLog(@"______bug测试-弹出用户界面 appdelegate dic%@", dic);
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


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [YLUserDefault saveAppOnBack:YES roomId:-1 socketOnLine:NO];
    [YLUserDefault saveConnet:NO];
    [[AgoraManager shareManager] leaveChannel];
}


#pragma mark - 腾讯云 im登录状态
- (void)onForceOffline {
    
    [YLNetworkInterface logout:[YLUserDefault userDefault].t_id block:^(BOOL isSuccess) {
        if (isSuccess) {
            [KJJPushHelper deleteAlias];
            
            [YLUserDefault saveUserDefault:@"0" t_id:@"0" t_is_vip:@"1" t_role:@"0"];
            
            WelcomeViewController *loginVC = [WelcomeViewController new];
            self.window.rootViewController = loginVC;
            
            //被踢下线
            [SLAlertController alertControllerWithStyle:UIAlertControllerStyleAlert controller:loginVC alertControllerTitle:@"温馨提示" alertControllerMessage:@"您的帐号于另一台手机上登录,请重新登录" alertControllerSheetActionTitles:nil alertControllerSureActionTitle:nil alertControllerCancelActionTitle:@"知道了" alertControllerSheetActionBlock:nil alertControllerAlertSureActionBlock:nil alertControllerAlertCancelActionBlock:nil];
        }
    }];
    
    
}

- (void)onReConnFailed:(int)code err:(NSString*)err {
    //链接失败
    [self getDataWithTecentIMSig];
    
}

- (void)onUserSigExpired {
    //验证过期
    [self getDataWithTecentIMSig];
}

- (void)getDataWithTecentIMSig {
    if ([YLUserDefault userDefault].t_id < 1) {
        return;
    }
    [SLHelper TIMLoginSuccess:nil fail:nil];
    
}

void uncaughtExceptionHandler(NSException *exception) {
    
    // Crash日志
    NSArray *stackArry= [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"\n\n----------------------------------------Crash----------------------------------------\nException name:%@\nException reason:%@\nException stack :%@\n----------------------------------------Crash----------------------------------------\n",name,reason,stackArry];
    NSLog(@"%@", exceptionInfo);
    // Internal error reporting
    
}

void interruptionListenner(void* inClientData, UInt32 inInterruptionState)
{
    AppDelegate* pTHIS = (__bridge AppDelegate*)inClientData;
    if (pTHIS) {
        if (kAudioSessionBeginInterruption == inInterruptionState) {
            //开始打断打断处理
            
        }
        else if (inInterruptionState == kAudioSessionEndInterruption)
        {
            [[YLAudioPlay shareInstance] startPlayNoVoiceMP3];
        }
        
    }
}

- (void)loadThirdSetup:(Boolean)isLoadAdv withIsLoadBar:(Boolean)isLoadBar withOptions:(NSDictionary *)launchOptions {
    
    [YLNetworkInterface getThirdSetupAction:5 success:^(NSDictionary *dataInfo) {

        if (dataInfo != nil) {
           
            if ([YLThirdSetup thirdDefault].btkey_ios_ver == nil ||
                ![[YLThirdSetup thirdDefault].btkey_ios_ver isEqualToString:[NSString stringWithFormat:@"%d",[(NSNumber *)dataInfo[@"t_btkey_ios_ver"] intValue]]])
            {
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",[(NSNumber *)dataInfo[@"t_btkey_ios_ver"] intValue]] forKey:@"t_btkey_ios_ver"];
                [[NSUserDefaults standardUserDefaults] setValue:dataInfo[@"t_btkey_ios_file"] forKey:@"t_btkey_ios_file"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            
            [self initThirdSetup];
            
        }
    
        if (isLoadAdv == NO) {
            if (isLoadBar == YES)
            {
                [self inputTabBar];
            }
        } else {
            
            [self loadAdvImage];
        }
    } fail:^{
        self.isNeedLoadThirdSetup = NO;
        
        [self initThirdSetup];
        
        if (isLoadBar == YES)
        {
            [self inputTabBar];
        }
    }];
}

- (void)initThirdSetup
{
    // 美颜加载
    [FUDemoManager setupFUSDK:[YLThirdSetup thirdDefault].btkey_ios_file];
}


- (void)goThirdSetup:(NSDictionary *)launchOptions
{
    
    if ([YLUserDefault userDefault].t_id > 0) {
//        [self loadAdvImage];
        [self loadThirdSetup:YES withIsLoadBar:YES withOptions:launchOptions];
    } else {
//        [self inputTabBar];
        [self loadThirdSetup:NO withIsLoadBar:YES withOptions:launchOptions];
    }
    
}

@end
