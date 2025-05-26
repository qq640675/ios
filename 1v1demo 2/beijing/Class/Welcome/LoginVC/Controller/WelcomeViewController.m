//
//  WelcomeViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/2/1.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "YLHelpCenterController.h"
#import "XZNavigationController.h"
#import "YLSexTypeViewController.h"
#import "XZNavigationController.h"
#import "XZTabBarController.h"
#import "KJJPushHelper.h"
#import "UIAlertCon+Extension.h"
#import "imLoginExtension.h"
#import "JChatConstants.h"
#import "YLSocketExtension.h"

#import <WXApi.h>
#import <WechatAuthSDK.h>
#import "WXApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface WelcomeViewController ()
<
WechatAuthAPIDelegate,
WXApiManagerDelegate,
TencentSessionDelegate,
TencentLoginDelegate
>

@property (nonatomic ,strong) TencentOAuth *tencentOAuth;
@property (nonatomic, assign) BOOL isAgree;

@end

@implementation WelcomeViewController


#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"t_phone_status"];
    
    [SLHelper savePasteboardString];
    
    //微信
    [WXApiManager sharedManager].delegate = self;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ISSHOWEDMESSAGEALERT"];
    
    
    [self agreementView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isProhibition) {
        //被封号
        [self showAlertViewController:@"您因违反平台相关内容规定,已被封号！"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[YLSocketExtension shareInstance] disconnect];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
#pragma mark - private
// 隐私协议
- (void)agreementView {
    self.isAgree = NO;
    
    UIView *agreeV = [[UIView alloc] initWithFrame:CGRectZero];
    agreeV.clipsToBounds = YES;
    [self.view addSubview:agreeV];
    [agreeV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-SafeAreaBottomHeight+29);
            make.height.mas_equalTo(30);
            make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UIButton *agreeB = [UIManager initWithButton:CGRectZero text:@"" font:1 textColor:nil normalImg:@"privacy_box" highImg:nil selectedImg:@"privacy_box_sel"];
    [agreeB addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [agreeV addSubview:agreeB];
    [agreeB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *label_1 = [UIManager initWithLabel:CGRectZero text:@"我已阅读并同意" font:12 textColor:UIColor.whiteColor];
    [agreeV addSubview:label_1];
    [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(agreeB.mas_right);
            make.top.bottom.mas_equalTo(0);
    }];
    
    UILabel *xieyiL = [UIManager initWithLabel:CGRectZero text:@"《用户协议》" font:12 textColor:UIColor.whiteColor];
    UITapGestureRecognizer *tap_xieyi = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xieyiButtonClick)];
    xieyiL.font = [UIFont boldSystemFontOfSize:12];
    xieyiL.userInteractionEnabled = YES;
    [xieyiL addGestureRecognizer:tap_xieyi];
    [agreeV addSubview:xieyiL];
    [xieyiL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label_1.mas_right);
            make.top.bottom.mas_equalTo(0);
    }];
    
    UILabel *label_2 = [UIManager initWithLabel:CGRectZero text:@"和" font:12 textColor:UIColor.whiteColor];
    [agreeV addSubview:label_2];
    [label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(xieyiL.mas_right);
            make.top.bottom.mas_equalTo(0);
    }];
    
    UILabel *yinsiL = [UIManager initWithLabel:CGRectZero text:@"《隐私政策》" font:12 textColor:UIColor.whiteColor];
    UITapGestureRecognizer *tap_yinsi = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yinsiButtonClick)];
    yinsiL.font = [UIFont boldSystemFontOfSize:12];
    yinsiL.userInteractionEnabled = YES;
    [yinsiL addGestureRecognizer:tap_yinsi];
    [agreeV addSubview:yinsiL];
    [yinsiL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label_2.mas_right);
            make.top.bottom.right.mas_equalTo(0);
    }];
}

- (void)agreeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _isAgree = sender.selected;
}

- (void)xieyiButtonClick {
    //用户协议
    YLHelpCenterController *helpcenterVC = [YLHelpCenterController new];
    helpcenterVC.title = @"用户协议";
    helpcenterVC.urlPath = @"userment";
    XZNavigationController *nav = [[XZNavigationController alloc]initWithRootViewController:helpcenterVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)yinsiButtonClick {
    //隐私协议
    YLHelpCenterController *helpcenterVC = [YLHelpCenterController new];
    helpcenterVC.title = @"隐私政策";
    helpcenterVC.urlPath = @"private";
    XZNavigationController *nav = [[XZNavigationController alloc]initWithRootViewController:helpcenterVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
- (void)showAlertViewController:(NSString *)msg {
    [SLAlertController alertControllerWithStyle:UIAlertControllerStyleAlert controller:self alertControllerTitle:nil alertControllerMessage:msg alertControllerSheetActionTitles:nil alertControllerSureActionTitle:@"查看规则" alertControllerCancelActionTitle:@"取消" alertControllerSheetActionBlock:nil alertControllerAlertSureActionBlock:^{
        //用户协议
        YLHelpCenterController *vc = [YLHelpCenterController new];
        vc.title   = @"用户协议书";
        vc.urlPath = @"userment";
        XZNavigationController *nav = [[XZNavigationController alloc]initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    } alertControllerAlertCancelActionBlock:nil];
}

- (IBAction)clickedBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (!_isAgree) {
        [SVProgressHUD showInfoWithStatus:@"请先阅读并同意《用户协议》和《隐私政策》"];
        return;
    }
    if (btn.tag == 111) {
        //手机登录
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
    } else if (btn.tag == 222) {
        //微信登录
        [self wechatLoginViewTap];
    } else if (btn.tag == 333) {
        //QQ登录
        [SVProgressHUD showErrorWithStatus:@"测试版本，请使用手机号登录"];
        //[self QQLoginViewTap];
    } else {
        //用户协议
        YLHelpCenterController *helpcenterVC = [YLHelpCenterController new];
        helpcenterVC.title = @"用户协议书";
        helpcenterVC.urlPath = @"userment";
        XZNavigationController *nav = [[XZNavigationController alloc]initWithRootViewController:helpcenterVC];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark ---- 微信登录
- (void)wechatLoginViewTap {
    if ([WXApi isWXAppInstalled])
    {
        [self sendAuthRequestScope:@"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"@"" State:@"xxx" OpenID:@"" InViewController:self];
    }
}

// //TODO, ipcodehandle - start
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    
    NSString *channelid = [SLHelper getPasteboardString];
    if (channelid != nil &&
        ![channelid isEqualToString:@""] &&
        ![channelid isEqualToString:@"0"])
    {
        [APIManager selfCode_request:^(id dataBody) {
            if (dataBody != nil &&
                ![dataBody isEqualToString:@""]) {
                
                    [self wechatRegist:response.code t_channel:dataBody];
           } else {
               
                   [self wechatRegist:response.code t_channel:@"0"];
           }
            
        } failed:^(NSString *error) {
            
                [self wechatRegist:response.code t_channel:@"0"];
        }];
    }
    else
    {
        [self wechatRegist:response.code t_channel:channelid];
    }
    
}

- (void)wechatRegist:(NSString *)code t_channel:(NSString *)channelid
{
    [YLNetworkInterface newWechatLogin:code t_channel:channelid block:^(BOOL isSuccess, BOOL isHaveSex, BOOL suspend, NSString *errorMsg) {
        if (isSuccess) {
            [self socketConnect];
            if (!isHaveSex) {
                //没返回性别
                YLSexTypeViewController *sexTypeVC = [YLSexTypeViewController new];
                sexTypeVC.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:sexTypeVC animated:YES completion:nil];
            } else {

                [YLPushManager pushMainPage];
            }
        }else{
            if (suspend) {
                //被封号
                [self showAlertViewController:errorMsg];
            }
        }
    }];
}
//TODO, ipcodehandle - end

/*
#pragma mark ----获取oppenid token
- (void)getAccessToken:(NSString *)code
{
    [YLNetworkInterface getAccess_token:code wechatBlock:^(NSString *access_token, NSString *openid, NSString *refresh_token) {
        [self checkToken:access_token openId:openid];
    }];
}

#pragma mark ----检验token是否可用
- (void)checkToken:(NSString*)accessToken openId:(NSString *)opendId
{
    if (![NSString isNullOrEmpty:accessToken] && ![NSString isNullOrEmpty:opendId]) {
        [YLNetworkInterface checkAccess_token:accessToken oppenId:opendId block:^(BOOL isSuccess) {
            if (isSuccess) {
                [self getWechatUserInfo:accessToken openId:opendId];
            }
        }];
    }else{
        [SVProgressHUD showInfoWithStatus:@"未获取微信授权"];
    }
}

#pragma mark ----获取微信个人信息
- (void)getWechatUserInfo:(NSString *)accessToken openId:(NSString *)openId
{
    dispatch_queue_t queue = dispatch_queue_create("我的个人资料", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    
    if (![NSString isNullOrEmpty:openId]) {
        dispatch_async(queue, ^{
            [YLNetworkInterface getWechatInfoOpenId:openId acesstoken:accessToken block:^(NSString *nickname, NSString *headimgurl, NSString *province, int sex, NSString *city) {
                
//                dispatch_async(queue, ^{
//                    [YLNetworkInterface wechatLogin:openId nickName:nickname handImg:headimgurl t_system_version:[NSString defaultUserAgentString] ipAddress:[NSString getWANIP] block:^(BOOL isSuccess, BOOL isHaveSex, BOOL suspend, NSString *errorMsg) {
//                        if (isSuccess) {
//                            [self socketConnect];
//
//
//
//                            if (!isHaveSex) {
//                                //没返回性别
//                                YLSexTypeViewController *sexTypeVC = [YLSexTypeViewController new];
//                                sexTypeVC.modalPresentationStyle = UIModalPresentationFullScreen;
//                                [self presentViewController:sexTypeVC animated:YES completion:nil];
//                            } else {
//
//                                [YLPushManager pushMainPage];
//                            }
//                        }else{
//                            if (suspend) {
//                                //被封号
//                                [self showAlertViewController:errorMsg];
//                            }
//                        }
//                    }];
//                });
            }];
        });
    }else{
        [SVProgressHUD showErrorWithStatus:@"未获取微信信息,请换种方式登录"];
    }
}

*/

- (void)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = scope;
    req.state = state;
    
    [WXApi sendAuthReq:req viewController:viewController delegate:[WXApiManager sharedManager] completion:nil];

}

#pragma mark ---- QQ登录
- (void)QQLoginViewTap {
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:bascicQQAppId andDelegate:self];
    self.tencentOAuth.authMode = kAuthModeClientSideToken;
    [self.tencentOAuth authorize:[self getPermissions] inSafari:NO];
    
}

- (NSMutableArray *)getPermissions {
    NSMutableArray * g_permissions = [[NSMutableArray alloc] initWithObjects:kOPEN_PERMISSION_GET_USER_INFO,
                                      kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                      kOPEN_PERMISSION_ADD_ALBUM,
                                      kOPEN_PERMISSION_ADD_TOPIC,
                                      kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                      kOPEN_PERMISSION_GET_INFO,
                                      kOPEN_PERMISSION_GET_OTHER_INFO,
                                      kOPEN_PERMISSION_LIST_ALBUM,
                                      kOPEN_PERMISSION_UPLOAD_PIC,
                                      kOPEN_PERMISSION_GET_VIP_INFO,
                                      kOPEN_PERMISSION_GET_VIP_RICH_INFO, nil];
    
    return g_permissions;
}

- (void)tencentDidLogin {
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length]) {
        [self.tencentOAuth getUserInfo];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"登录不成功"];
    }
}



- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth
                   withPermissions:(NSArray *)permissions {
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [self.tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}


#pragma mark ----获取QQ个人信息

//TODO, ipcodehandle - start
- (void)getUserInfoResponse:(APIResponse *)response {
    NSDictionary *jsonDic = [response jsonResponse];
    
    UIImageView *headImgView = [UIImageView new];
    [headImgView sd_setImageWithURL:[NSURL URLWithString:jsonDic[@"figureurl_qq_2"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [YLUserDefault saveHeadImage:image];
        [headImgView removeFromSuperview];
    }];
    
    NSString *channelid = [SLHelper getPasteboardString];
    if (channelid != nil &&
        ![channelid isEqualToString:@""] &&
        ![channelid isEqualToString:@"0"])
    {
        [APIManager selfCode_request:^(id dataBody) {
            if (dataBody != nil &&
                ![dataBody isEqualToString:@""]) {
                [self qqregist:jsonDic t_channel:dataBody];
           } else {
               [self qqregist:jsonDic t_channel:@"0"];
           }
            
        } failed:^(NSString *error) {
            [self qqregist:jsonDic t_channel:@"0"];
        }];
    }
    else
    {
        [self qqregist:jsonDic t_channel:channelid];
    }
}

- (void)qqregist:(NSDictionary *)jsonDic t_channel:(NSString *)channelid
{
    dispatch_queue_t queue = dispatch_queue_create("我的个人资料", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        if (![NSString isNullOrEmpty:self.tencentOAuth.openId]) {
            [YLNetworkInterface qqLoginOpenId:self.tencentOAuth.openId nickName:jsonDic[@"nickname"] handImg:jsonDic[@"figureurl_qq_2"] city:jsonDic[@"city"] t_system_version:[NSString defaultUserAgentString] ipaddress:[NSString getWANIP] t_channel:channelid block:^(BOOL isSuccess, BOOL isHaveSex, BOOL suspend, NSString *errorMsg) {
                if (isSuccess) {
                    [self socketConnect];
                    
                    if (!isHaveSex) {
                        //没返回性别
                        YLSexTypeViewController *sexTypeVC = [YLSexTypeViewController new];
                        sexTypeVC.modalPresentationStyle = UIModalPresentationFullScreen;
                        [self presentViewController:sexTypeVC animated:YES completion:nil];
                    } else {
                        [YLPushManager pushMainPage];
                    }
                } else {
                    if (suspend) {
                        //被封号
                        [self showAlertViewController:errorMsg];
                    }
                }
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"未获取微信信息,请换种方式登录"];
        }
    });
}
//TODO, ipcodehandle - end

- (void)tencentDidNotNetWork:(BOOL)cancelled {
    if (cancelled)
    {
        [SVProgressHUD showErrorWithStatus:@"用户取消登录"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }
}


- (void)socketConnect {
    
    [KJJPushHelper setAlias:[YLUserDefault userDefault].t_id];
}

//- (void)backGroundImageViewAnimation:(NSString *)animationX {
//
//    [UIView animateWithDuration:8.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.backGroundImageView.x = [animationX floatValue];
//    } completion:^(BOOL finished) {
//        if (finished) {
//            CGFloat fX = 0;
//            if (self.backGroundImageView.x == 0.0) {
//                fX = App_Frame_Width-800.0;
//            } else {
//                fX = 0.0;
//            }
//            NSString *strX = [NSString stringWithFormat:@"%.0f",fX];
//            [self performSelector:@selector(backGroundImageViewAnimation:) withObject:strX afterDelay:1.0];
//        }
//    }];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
