//
//  YLEditPhoneController.m
//  beijing
//
//  Created by zhou last on 2018/8/17.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLEditPhoneController.h"
#import "YLNetworkInterface.h"
#import "YLValidExtension.h"
#import <SVProgressHUD.h>
#import "YLUserDefault.h"
#import "NSString+Extension.h"
#import "YLTapGesture.h"
#import "LoginVerificationView.h"
#import "XZTabBarController.h"

@interface YLEditPhoneController ()

<
LoginVerificationViewDelegate
>

@property (weak, nonatomic) IBOutlet UIButton *cericationBtn; //完成验证
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;//手机号
@property (weak, nonatomic) IBOutlet UITextField *cericateTextField;//验证码
@property (weak, nonatomic) IBOutlet UIButton *cerKeyButton;

@property (nonatomic, strong) LoginVerificationView     *verificationView;

@end

@implementation YLEditPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self customUI];
    
    if (self.phoneStr.length > 0 && ![self.phoneStr containsString:@"null"]) {
        UILabel *label = [UIManager initWithLabel:CGRectMake(15, 15, App_Frame_Width-30, 60) text:[NSString stringWithFormat:@"* 当前已绑定手机号：%@\n* 如需更换手机号请重新验证", self.phoneStr] font:15 textColor:XZRGB(0x666666)];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:label];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *tempView = [window viewWithTag:10086];
    tempView.hidden = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *tempView = [window viewWithTag:10086];
    tempView.hidden = NO;
    NSString *isOpen = (NSString *)[SLDefaultsHelper getSLDefaults:@"lock_mode_pwd_is_open_key"];
    if ([isOpen isEqualToString:@"0"]) {
        tempView.hidden = YES;
    }
    
}

#pragma mark ---- customUI
- (void)customUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [_cericationBtn.layer setCornerRadius:25.];
    [YLTapGesture tapGestureTarget:self sel:@selector(hideKeyBoard) view:self.view];
    
    [self.view addSubview:self.verificationView];
    _verificationView.hidden = YES;
    
    if (_isLock) {
        _phoneTextField.text = [YLUserDefault userDefault].phone;
        _phoneTextField.userInteractionEnabled = NO;
    }
}

#pragma mark ---- 隐藏键盘
- (void)hideKeyBoard
{
    [self.phoneTextField resignFirstResponder];
    [self.cericateTextField resignFirstResponder];
}

#pragma mark ---- 完成验证
- (IBAction)finishCericationBtnClciked:(id)sender {
    if(self.phoneTextField.text.length != 11){
        [SVProgressHUD showInfoWithStatus:@"手机号格式不正确!"];
        return;
    }
    
    if ([NSString isNullOrEmpty:self.cericateTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"验证码不能为空！"];
        return;
    }
    if (_isLock) {
        //解未成年锁
        [YLNetworkInterface verificationPhoneSmsCode:[YLUserDefault userDefault].t_id phone:self.phoneTextField.text smsCode:self.cericateTextField.text block:^(BOOL isSuccess) {
            [SLDefaultsHelper saveSLDefaults:@"" key:@"lock_mode_pwd_key"];
            [SLDefaultsHelper saveSLDefaults:@"0" key:@"lock_mode_pwd_is_open_key"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [SVProgressHUD showInfoWithStatus:@"设置成功"];
        }];
    } else {
        //绑定手机
        [YLNetworkInterface updatePhone:[YLUserDefault userDefault].t_id phone:self.phoneTextField.text smsCode:self.cericateTextField.text block:^(BOOL isSuccess) {
            if (isSuccess) {
//                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"t_phone_status"];
                [YLUserDefault savePhone:self.phoneTextField.text];
                if (self.isNeesLoadMain) {
                    [YLPushManager pushMainPage];
                } else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }];
    }
    
}

#pragma mark ---- 发送验证码

- (IBAction)sendcericationBtnClicked:(id)sender {
    if(self.phoneTextField.text.length != 11){
        [SVProgressHUD showInfoWithStatus:@"手机号格式不正确!"];
        return;
    }
    //0315
    [self.verificationView.codeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/getVerify.html?phone=%@",INTERFACEADDRESS,self.phoneTextField.text]] placeholderImage:nil];
    self.verificationView.hidden = NO;
    [self.verificationView.textField becomeFirstResponder];
    
    //    [self postDataWithVerify:@""];
    
}

- (void)didSelectLoginVerificationViewWithBgView {
    [self.view endEditing:YES];
    
    self.verificationView.hidden = YES;
}

-  (void)didSelectLoginVerificationViewWithBtn:(NSString *)code {
    if (code == nil) {
        //        self.verificationView.codeImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/getVerify.do?phone=%@",INTERFACEADDRESS,_phoneTextField.text]]]];
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/getVerify.html?phone=%@",INTERFACEADDRESS,_phoneTextField.text]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        [self performSelectorOnMainThread:@selector(setupVerifyImage:) withObject:image waitUntilDone:YES];
    } else {
        [self postDataWithVerify:code];
    }
}

- (void)setupVerifyImage:(UIImage *)image {
    self.verificationView.codeImageView.image = image;
}

- (void)postDataWithVerify:(NSString *)code {
    [SVProgressHUD showWithStatus:@"请稍后..."];
    int type = 2;
    if (_isLock) {
        type = 3;
    }
    //0315
    [YLNetworkInterface getVerifyCodeIsCorrectWithPhone:_phoneTextField.text verifyCode:code block:^(int codeInt) {
        [SVProgressHUD dismiss];
        if (codeInt == 1) {
            [YLNetworkInterface sendPhoneVerificationCode:self.phoneTextField.text sendVericationBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    [self didSelectLoginVerificationViewWithBgView];
                    __block NSInteger second = 60;
                    //(1)
                    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    //(2)
                    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
                    //(3)
                    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                    //(4)
                    dispatch_source_set_event_handler(timer, ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (second == 0) {
                                self.cerKeyButton.userInteractionEnabled = YES;
                                [self.cerKeyButton setTitle:[NSString stringWithFormat:@"点击获取验证码"] forState:UIControlStateNormal];
                                second = 60;
                                //(6)
                                dispatch_cancel(timer);
                            } else {
                                self.cerKeyButton.userInteractionEnabled = NO;
                                [self.cerKeyButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)second] forState:UIControlStateNormal];
                                second--;
                            }
                        });
                    });
                    //(5)
                    dispatch_resume(timer);
                }
            } restype:type verifyCode:code];
            
        }
    }];
}

- (LoginVerificationView *)verificationView {
    if (!_verificationView) {
        _verificationView = [[LoginVerificationView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
        _verificationView.delegate = self;
    }
    return _verificationView;
}

@end
