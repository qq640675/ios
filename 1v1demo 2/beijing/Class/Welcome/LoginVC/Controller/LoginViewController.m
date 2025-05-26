//
//  LoginViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/3/12.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LoginViewController.h"
#import "YLSexTypeViewController.h"
#import "XZTabBarController.h"
#import "SLAlertController.h"
#import "YLHelpCenterController.h"
#import "XZNavigationController.h"

#import "LoginMainView.h"
#import "LoginRegisterView.h"
#import "LoginVerificationView.h"
#import "KJJPushHelper.h"


@interface LoginViewController ()
<
LoginMainViewDelegate,
LoginPwdViewDelegate,
LoginPhoneViewDelegate,
LoginVerificationViewDelegate,
LoginRegisterViewDelegate
>


@property (nonatomic, strong) UIButton  *rightChangeBtn;

@property (nonatomic, strong) UIButton  *rightLoginBtn;

@property (nonatomic, strong) UIView    *rightLineView;

@property (nonatomic, strong) LoginMainView     *loginMainView;

@property (nonatomic, strong) LoginRegisterView *loginRegisterView;

@property (nonatomic, strong) LoginVerificationView *verificationView;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, copy) NSString    *phoneString;

@property (nonatomic, copy) NSString    *codeString;

@property (nonatomic, copy) NSString    *pwdString;

@property (nonatomic, assign) BOOL      isLogin;

@property (nonatomic, assign) BOOL      isRegister;

@property (nonatomic, assign) BOOL      isFindPwd;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    //返回
    UIButton *backBtn = [UIManager initWithButton:CGRectMake(6, SafeAreaTopHeight-44, 44, 44) text:nil font:12.0f textColor:[UIColor whiteColor] normalImg:@"nav_back" highImg:nil selectedImg:nil];
    [backBtn addTarget:self action:@selector(clickedBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //注册
    [self.view addSubview:self.rightChangeBtn];
    
    //分割线
    [self.view addSubview:self.rightLineView];
    _rightLineView.hidden = YES;
    
    //登录
    [self.view addSubview:self.rightLoginBtn];
    _rightLoginBtn.hidden = YES;
    
    //logo
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:IChatUImage(@"login_logo")];
    [self.view addSubview:logoImageView];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.rightChangeBtn.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    //主界面
    [self.view addSubview:self.loginMainView];
    _loginMainView.delegate = self;
    _loginMainView.loginPwdView.delegate   = self;
    _loginMainView.loginPhoneView.delegate = self;
    [_loginMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(SafeAreaTopHeight+136);
        make.size.mas_equalTo(CGSizeMake(App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight-136));
    }];
    
    
    //注册
    [self.view addSubview:self.loginRegisterView];
    _loginRegisterView.delegate = self;
    [_loginRegisterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(SafeAreaTopHeight+136);
        make.size.mas_equalTo(CGSizeMake(App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight-136));
    }];
    _loginRegisterView.hidden = YES;
    
    [self.view addSubview:self.verificationView];
    _verificationView.hidden = YES;
    
    _isLogin = YES;
    
}

- (void)setupVerifyImage:(UIImage *)image {
    self.verificationView.codeImageView.image = image;
}

- (void)setupLoginUI {
    _isLogin = YES;
    _isRegister = NO;
    _isFindPwd  = NO;
    _rightLineView.hidden = YES;
    _rightLoginBtn.hidden = YES;
    _loginRegisterView.hidden = YES;
    _loginMainView.hidden  = NO;
    _rightChangeBtn.hidden = NO;
}

#pragma mark - Net
- (void)postDataWithVerify:(NSString *)code {
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    WEAKSELF
    [YLNetworkInterface getVerifyCodeIsCorrectWithPhone:_phoneString verifyCode:code block:^(int codeInt) {
        if (codeInt == 1) {
            [YLNetworkInterface sendPhoneVerificationCode:weakSelf.phoneString sendVericationBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    [weakSelf didSelectLoginVerificationViewWithBgView];
                    [weakSelf custStartTimer];
                }
            } restype:1 verifyCode:code];
        }
    }];
}
- (void)postDataWithLoginPwd {
    [SVProgressHUD showWithStatus:@"正在登录中..."];
    WEAKSELF
    [YLNetworkInterface pwdLoginWithPhone:_phoneString password:_pwdString block:^(BOOL isSuccess, BOOL isHaveSex, BOOL suspend, NSString *errorMsg) {
        if (isSuccess) {
            
            [self custConnectSocket];
            
            
            [YLUserDefault savePhone:weakSelf.phoneString];
            
            
            if (!isHaveSex) {
                //没返回性别
                YLSexTypeViewController *vc = [YLSexTypeViewController new];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:vc animated:YES completion:nil];
            } else {
                
                XZTabBarController *vc = [XZTabBarController new];
                self.view.window.rootViewController = vc;
            }
        } else {
            if (suspend) {
                //被封号
                [SLAlertController alertControllerWithStyle:UIAlertControllerStyleAlert controller:self alertControllerTitle:nil alertControllerMessage:errorMsg alertControllerSheetActionTitles:nil alertControllerSureActionTitle:@"查看规则" alertControllerCancelActionTitle:@"取消" alertControllerSheetActionBlock:nil alertControllerAlertSureActionBlock:^{
                    //用户协议
                    YLHelpCenterController *vc = [YLHelpCenterController new];
                    vc.title   = @"用户协议书";
                    vc.urlPath = @"userment";
                    XZNavigationController *nav = [[XZNavigationController alloc]initWithRootViewController:vc];
                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:nav animated:YES completion:nil];
                } alertControllerAlertCancelActionBlock:nil];
            }
        }
    }];
}

//TODO, ipcodehandle - start
- (void)postDataWithLoginPhone_pre
{
    NSString *channelid = [SLHelper getPasteboardString];
    if (channelid != nil &&
        ![channelid isEqualToString:@""] &&
        ![channelid isEqualToString:@"0"])
    {
        [APIManager selfCode_request:^(id dataBody) {
            if (dataBody != nil &&
                ![dataBody isEqualToString:@""]) {
                [self postDataWithLoginPhone:dataBody];
           } else {
               [self postDataWithLoginPhone:@"0"];
           }
            
        } failed:^(NSString *error) {
            [self postDataWithLoginPhone:@"0"];
        }];
    }
    else
    {
        [self postDataWithLoginPhone:channelid];
    }
}


- (void)postDataWithLoginPhone:(NSString *)channelid {
    [SVProgressHUD showWithStatus:@"正在登录中..."];
    WEAKSELF
    [YLNetworkInterface login:_phoneString smsCode:_codeString t_system_version:[NSString defaultUserAgentString] t_ip_address:@"" t_channel:channelid loginBlock:^(BOOL isSuccess, BOOL isHaveSex, BOOL suspend, NSString *errorMsg) {
        if (isSuccess) {
            
            [self custConnectSocket];
            
            [YLUserDefault savePhone:weakSelf.phoneString];
            
            
            if (!isHaveSex) {
                //没返回性别
                YLSexTypeViewController *vc = [YLSexTypeViewController new];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:vc animated:YES completion:nil];
            } else {
                
                XZTabBarController *vc = [XZTabBarController new];
                self.view.window.rootViewController = vc;
            }
        } else {
            if (suspend) {
                //被封号
                [SLAlertController alertControllerWithStyle:UIAlertControllerStyleAlert controller:self alertControllerTitle:nil alertControllerMessage:errorMsg alertControllerSheetActionTitles:nil alertControllerSureActionTitle:@"查看规则" alertControllerCancelActionTitle:@"取消" alertControllerSheetActionBlock:nil alertControllerAlertSureActionBlock:^{
                    //用户协议
                    YLHelpCenterController *vc = [YLHelpCenterController new];
                    vc.title   = @"用户协议书";
                    vc.urlPath = @"userment";
                    XZNavigationController *nav = [[XZNavigationController alloc]initWithRootViewController:vc];
                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:nav animated:YES completion:nil];
                } alertControllerAlertCancelActionBlock:nil];
            }
        }
    }];
}
//TODO, ipcodehandle - end

//TODO, ipcodehandle - start
- (void)postDataWithRegister_pre {
    NSString *channelid = [SLHelper getPasteboardString];
    if (channelid != nil &&
        ![channelid isEqualToString:@""] &&
        ![channelid isEqualToString:@"0"])
    {
        // 如果为空，则获取自建邀请码
        [APIManager selfCode_request:^(id dataBody) {
            if (dataBody != nil &&
                ![dataBody isEqualToString:@""]) {
                [self postDataWithRegister:dataBody];
           } else {
               [self postDataWithRegister:@"0"];
           }
            
        } failed:^(NSString *error) {
            [self postDataWithRegister:@"0"];
        }];
    }
    else
    {
        [self postDataWithRegister:channelid];
    }
}

- (void)postDataWithRegister:(NSString *)channelid {
    [SVProgressHUD showWithStatus:@"正在注册中..."];
    WEAKSELF
    [YLNetworkInterface registerPwdWithPhone:_phoneString password:_pwdString smsCode:_codeString t_channel:channelid block:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf setupLoginUI];
            weakSelf.loginRegisterView.phoneTextField.text = nil;
            weakSelf.loginRegisterView.codeTextField.text = nil;
            weakSelf.loginRegisterView.pwdTextField.text = nil;
            [SVProgressHUD showInfoWithStatus:@"注册成功，请登录"];
        }
    }];
}
//TODO, ipcodehandle - end

- (void)postDataWithFindPwd {
    [SVProgressHUD showWithStatus:@"正在找回中..."];
    WEAKSELF
    [YLNetworkInterface findPwdWithPhone:_phoneString password:_pwdString smsCode:_codeString block:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf setupLoginUI];
            weakSelf.loginRegisterView.phoneTextField.text = nil;
            weakSelf.loginRegisterView.codeTextField.text = nil;
            weakSelf.loginRegisterView.pwdTextField.text = nil;
            [SVProgressHUD showInfoWithStatus:@"找回密码成功，请登录"];
        }
    }];
}


#pragma mark - Cust
- (void)custDownloadImage {
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/getVerify.html?phone=%@",INTERFACEADDRESS,_phoneString]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    [self performSelectorOnMainThread:@selector(setupVerifyImage:) withObject:image waitUntilDone:YES];
}

- (void)custConnectSocket {
    [KJJPushHelper setAlias:[YLUserDefault userDefault].t_id];
}

- (void)custShowVerifyView {
    if (_isLogin) {
        _phoneString = _loginMainView.loginPhoneView.phoneTextField.text;
    } else if (_isRegister) {
        _phoneString = _loginRegisterView.phoneTextField.text;
    } else {
        _phoneString = _loginRegisterView.phoneTextField.text;
    }
    
    //获取图形验证码
    dispatch_queue_t queue = dispatch_queue_create("yanzhen", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self custDownloadImage];
    });
    _verificationView.hidden = NO;
    _verificationView.textField.text = nil;
    [_verificationView.textField becomeFirstResponder];
}

- (void)custStartTimer {
    __block NSInteger second = 60;
    WEAKSELF
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second == 0) {
                if (weakSelf.isLogin) {
                    //验证码登录
                    weakSelf.loginMainView.loginPhoneView.codeBtn.enabled = YES;
                    [weakSelf.loginMainView.loginPhoneView.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                } else {
                    //注册或者找回密码
                    weakSelf.loginRegisterView.codeBtn.enabled = YES;
                    [weakSelf.loginRegisterView.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                }
                dispatch_cancel(weakSelf.timer);
            } else {
                NSString *strSecond = [NSString stringWithFormat:@"%ld秒",(long)second];
                if (weakSelf.isLogin) {
                    weakSelf.loginMainView.loginPhoneView.codeBtn.enabled = NO;
                    [weakSelf.loginMainView.loginPhoneView.codeBtn setTitle:strSecond forState:UIControlStateNormal];
                } else {
                    weakSelf.loginRegisterView.codeBtn.enabled = NO;
                    [weakSelf.loginRegisterView.codeBtn setTitle:strSecond forState:UIControlStateNormal];
                }
    
                second--;
            }
        });
    });
    dispatch_resume(_timer);
}

#pragma mark - Clicked Action
- (void)clickedRightBtn:(UIButton *)btn {
    [self.view endEditing:YES];
    if (btn.tag == 0) {
        //登录
        [self setupLoginUI];
        
    } else {
        
        //注册
        _isLogin = NO;
        _isRegister = YES;
        _isFindPwd  = NO;
        _loginRegisterView.hidden = NO;
        _loginMainView.hidden = YES;
        _rightLineView.hidden = YES;
        _rightChangeBtn.hidden= YES;
        _rightLoginBtn.hidden = NO;
        _rightLoginBtn.x = _rightChangeBtn.x;
        [_loginRegisterView.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    }
}

- (void)clickedBackBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Delegate
- (void)didSelectLoginPwdViewWithBtn:(NSInteger)btnTag {
    [self.view endEditing:YES];
    //忘记密码
    _isLogin = NO;
    _isRegister = NO;
    _isFindPwd  = YES;
    _rightLineView.hidden = NO;
    _rightLoginBtn.hidden = NO;
    _loginRegisterView.hidden = NO;
    _loginMainView.hidden  = YES;
    _rightChangeBtn.hidden = NO;
    _rightLoginBtn.x = App_Frame_Width-104;
    [_loginRegisterView.registerBtn setTitle:@"找回密码" forState:UIControlStateNormal];
}

- (void)didSelectLoginPhoneViewWithCodeBtn {
    [self custShowVerifyView];
}

- (void)didSelectLoginVerificationViewWithBgView {
    [self.view endEditing:YES];
    _verificationView.hidden = YES;
}

-  (void)didSelectLoginVerificationViewWithBtn:(NSString *)code {
    if (code == nil) {
        _verificationView.textField.text = nil;
        dispatch_queue_t queue = dispatch_queue_create("yanzhen", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            [self custDownloadImage];
        });
        
    } else {
        [self postDataWithVerify:code];
    }
}

- (void)didSelectLoginRegisterViewWithBtn:(UIButton *)btn {
    [self.view endEditing:YES];
    if (btn.tag == 0) {
        //获取验证码
        [self custShowVerifyView];
    } else {
        [self.view endEditing:YES];
        _phoneString = _loginRegisterView.phoneTextField.text;
        _codeString  = _loginRegisterView.codeTextField.text;
        _pwdString   = _loginRegisterView.pwdTextField.text;
        if (_isFindPwd) {
            //找回密码
            [self postDataWithFindPwd];
        } else {
            //注册
            //TODO, ipcodehandle - start
            [self postDataWithRegister_pre];
            //TODO, ipcodehandle - end
        }
        
    }
}

- (void)didSelectLoginMainViewLoginBtnWithPhone:(NSString *)phone code:(NSString *)code pwd:(NSString *)pwd {
    [self.view endEditing:YES];
    _phoneString = phone;
    _codeString  = code;
    _pwdString   = pwd;
    if (code.length == 0) {
        //账号密码登录
        [self postDataWithLoginPwd];
        
    } else {
        //手机验证码登录
        //TODO, ipcodehandle - start
        [self postDataWithLoginPhone_pre];
        //TODO, ipcodehandle - end
        
    }
}

#pragma mark - Lazy Load
- (UIButton *)rightChangeBtn {
    if (!_rightChangeBtn) {
        _rightChangeBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-50, SafeAreaTopHeight-44, 44, 44) text:@"注册" font:17.0f textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
        _rightChangeBtn.tag = 1;
        [_rightChangeBtn addTarget:self action:@selector(clickedRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightChangeBtn;
}

- (UIButton *)rightLoginBtn {
    if (!_rightLoginBtn) {
        _rightLoginBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-104, SafeAreaTopHeight-44, 44, 44) text:@"登录" font:17.0f textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
        [_rightLoginBtn addTarget:self action:@selector(clickedRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightLoginBtn;
}

- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] initWithFrame:CGRectMake(App_Frame_Width-54, SafeAreaTopHeight-30, 2, 16)];
        _rightLineView.backgroundColor = XZRGB(0xAE4FFD);
    }
    return _rightLineView;
}

- (LoginMainView *)loginMainView {
    if (!_loginMainView) {
        _loginMainView = [[LoginMainView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-200)];
    }
    return _loginMainView;
}

- (LoginRegisterView *)loginRegisterView {
    if (!_loginRegisterView) {
        _loginRegisterView = [[LoginRegisterView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-200)];
    }
    return _loginRegisterView;
}

- (LoginVerificationView *)verificationView {
    if (!_verificationView) {
        _verificationView = [[LoginVerificationView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
        _verificationView.delegate = self;
    }
    return _verificationView;
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
