//
//  YLManageAccountController.m
//  beijing
//
//  Created by zhou last on 2018/8/16.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLManageAccountController.h"
#import "NSString+Extension.h"
#import "DefineConstants.h"
#import "YLTapGesture.h"
#import <SVProgressHUD.h>
#import "YLNetworkInterface.h"
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "YLUserDefault.h"
#import "UIAlertCon+Extension.h"
#import "YLChoosePicture.h"
#import "YLUploadImageExtension.h"
#import "LoginVerificationView.h"

//微信授权
#import <WechatAuthSDK.h>
#import "WXApiManager.h"


@interface YLManageAccountController ()<WechatAuthAPIDelegate,WXApiManagerDelegate,LoginVerificationViewDelegate>
{
    NSString *headPath;
    BOOL isExtractAuth;
}


@property (weak, nonatomic) IBOutlet UITextField *cericateTextField;//验证码
@property (weak, nonatomic) IBOutlet UIButton *cerKeyButton;
@property (weak, nonatomic) IBOutlet UIView *viewSms;
@property (nonatomic, strong) LoginVerificationView     *verificationView;


//安全修改
@property (weak, nonatomic) IBOutlet UIButton *safeUpdateBtn;
//去授权
@property (weak, nonatomic) IBOutlet UILabel *toAuthLabel;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
//支付宝账号或微信账号
@property (weak, nonatomic) IBOutlet UILabel *wechatzfLabel;
//账户输入框
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
//账户姓名
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//温馨提示
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
//温馨提示高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
//授权页面
@property (weak, nonatomic) IBOutlet UIView *authBgView;
//收款码提示
@property (weak, nonatomic) IBOutlet UILabel *codeTipLabel;
//收款码提示
@property (weak, nonatomic) IBOutlet UIButton *addCodeBtn;


@end

@implementation YLManageAccountController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isExtractAuth = NO;
    
    self.viewSms.hidden = YES;
    
    [self accountCustomUI];
}

#pragma mark ---- customUI
- (void)accountCustomUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [WXApiManager sharedManager].delegate = self;

    self.title = [NSString stringWithFormat:@"管理%@钱包",self.tittleName];
    [_safeUpdateBtn.layer setCornerRadius:22.];
    [self.headImgView.layer setCornerRadius:15.];
    [self.headImgView setClipsToBounds:YES];
    self.wechatzfLabel.text = [NSString stringWithFormat:@"%@账户:",self.tittleName];
    self.codeTipLabel.text = [NSString stringWithFormat:@"上传%@收款码:",self.tittleName];
    
    if ([self.tittleName isEqualToString:@"微信"]) {
        if (_handle) {
            self.nameTextField.text = _handle.t_real_name;
            self.accountTextField.text = _handle.t_account_number;
            headPath = _handle.t_head_img;
        }
    }else{

        if (_handle) {
            self.accountTextField.enabled = NO;
//            self.cericateTextField.enabled = NO;
//            self.cerKeyButton.enabled = NO;
            self.nameTextField.text = _handle.t_real_name;
            self.accountTextField.text = _handle.t_account_number;
        }else{
            self.accountTextField.enabled = YES;
//            self.cericateTextField.enabled = YES;
//            self.cerKeyButton.enabled = YES;
        }
    }
    
    if (_handle) {
        self.nameTextField.enabled = NO;
        self.accountTextField.enabled = NO;
//        self.cericateTextField.enabled = NO;
//        self.cerKeyButton.enabled = NO;
        if (![NSString isNullOrEmpty:_handle.t_head_img]) {
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:_handle.t_head_img]];
            self.toAuthLabel.hidden = YES;
        }else{
            self.toAuthLabel.hidden = NO;
        }
        
        UIImageView *codeImgView = [UIImageView new];
        [codeImgView sd_setImageWithURL:[NSURL URLWithString:_handle.qrCode] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.addCodeBtn setBackgroundImage:image forState:UIControlStateNormal];
            [self.addCodeBtn setImage:nil forState:UIControlStateNormal];

        }];
        
        [self.safeUpdateBtn setTitle:@"安全修改" forState:UIControlStateNormal];
    }else{
        [self.safeUpdateBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    

    
    NSString *warningStr = [NSString stringWithFormat:@"温馨提示:\n\n1.请填写%@中绑定银行卡时填写的真实姓名(请不要填写昵称)；\n2.为了保证顺利提现,30天内不要更换其他账号,否则会导致提现不通过；\n3.我们承诺不会向任何人透露您的个人信息。",self.tittleName];
    CGSize size = [warningStr sizeWithMaxWidth:App_Frame_Width - 30 andFont:PingFangSCFont(14)];
    _heightConstraint.constant = size.height + 40;
    _warningLabel.text = warningStr;
    
    [YLTapGesture tapGestureTarget:self sel:@selector(hideKeyboard) view:self.view];
    
    
    [self.view addSubview:self.verificationView];
    _verificationView.hidden = YES;
    
    
    [YLNetworkInterface has_extractauth:[YLUserDefault userDefault].t_id block:^(BOOL isSuccess) {
       if (isSuccess) {
           isExtractAuth = YES;
           
           self.viewSms.hidden = NO;
       }
       else
       {
           isExtractAuth = NO;
       }
   }];
}

#pragma mark ---- 隐藏键盘
-(void)hideKeyboard
{
    [_nameTextField resignFirstResponder];
    [_accountTextField resignFirstResponder];
    [self.cericateTextField resignFirstResponder];
}

- (IBAction)clickedAddPicBtn:(id)sender {
    
    [self hideKeyboard];
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [UIAlertCon_Extension seeWeixinOrPhone:@"上传收款码访问你的相册权限" type:UIAlertControllerStyleAlert controller:self delSel:^(UIAlertAction *okSel) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        } oktittle:@"去开启"];
    } else {
        [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeAlbum pickBlock:^(UIImage *pickImage) {
            [self.addCodeBtn setBackgroundImage:pickImage forState:UIControlStateNormal];
            [self.addCodeBtn setImage:nil forState:UIControlStateNormal];
        }];
    }
}

#pragma mark ---- 安全修改
- (IBAction)safeUpdateBtnClicked:(id)sender {
    
    if ([self.safeUpdateBtn.currentTitle isEqualToString:@"安全修改"]) {
        if ([self.tittleName isEqualToString:@"支付宝"]) {
            self.accountTextField.enabled = YES;
        }else{
            self.accountTextField.enabled = YES;
        }
        self.nameTextField.enabled = YES;
        self.accountTextField.enabled = YES;
//        self.cericateTextField.enabled = YES;
//        self.cerKeyButton.enabled = YES;
        
        [self.safeUpdateBtn setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        if (isExtractAuth == YES)
        {
            if ([NSString isNullOrEmpty:self.cericateTextField.text]) {
                [SVProgressHUD showInfoWithStatus:@"短信验证码为空"];
                return;
            }
        }
        
        
        if ([NSString isNullOrEmpty:self.nameTextField.text]) {
            [SVProgressHUD showInfoWithStatus:@"请输入您的真实姓名"];
            return;
        }
        
        if ([self.tittleName isEqualToString:@"微信"]) {
            //微信
            if ([NSString isNullOrEmpty:self.accountTextField.text]) {
                [SVProgressHUD showInfoWithStatus:@"请输入您的微信账号"];
                return;
            }
            
            if ([_addCodeBtn currentBackgroundImage] == nil) {
                [SVProgressHUD showInfoWithStatus:@"请上传您的微信收款码"];
                return;
            }
            
            [self modifyPutForwardData:1 headImage:@"" accountNumber:self.accountTextField.text nickName:self.accountTextField.text withSmscode:self.cericateTextField.text];
        }else{
            //支付宝
            if ([NSString isNullOrEmpty:self.accountTextField.text]) {
                [SVProgressHUD showInfoWithStatus:@"请输入您的支付宝账户"];
                return;
            }
            
            if ([_addCodeBtn currentBackgroundImage] == nil) {
                [SVProgressHUD showInfoWithStatus:@"请上传您的支付宝收款码"];
                return;
            }
            
            [self modifyPutForwardData:0 headImage:@"" accountNumber:self.accountTextField.text nickName:self.accountTextField.text withSmscode:self.cericateTextField.text];
        }
    }
}

#pragma mark ---- 微信->更新提现资料接口
- (void)modifyPutForwardData:(int)type headImage:(NSString *)headPath accountNumber:(NSString *)accountNumber nickName:(NSString *)nickName withSmscode:(NSString *)smscode
{
    //上传图片
    [[YLUploadImageExtension shareInstance] uploadImage:[_addCodeBtn currentBackgroundImage] uplodImageblock:^(NSString *backImageUrl) {
        [YLNetworkInterface modifyPutForwardData:[YLUserDefault userDefault].t_id t_real_name:self.nameTextField.text t_nick_name:nickName t_account_number:accountNumber t_type:type t_head_img:headPath qrCodeUrl:backImageUrl withSmscode:smscode block:^(BOOL isSuccess) {
            if (isSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
    
}



#pragma mark ---- 发送验证码

- (IBAction)sendcericationBtnClicked:(id)sender {

    //0315
    [self.verificationView.codeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/getVerify.html?phone=%d",INTERFACEADDRESS,[YLUserDefault userDefault].t_id]] placeholderImage:nil];
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
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/getVerify.html?phone=%d",INTERFACEADDRESS,[YLUserDefault userDefault].t_id]];
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

    //0315
    [YLNetworkInterface getVerifyCodeIsCorrectWithPhone:[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id] verifyCode:code block:^(int codeInt) {
        [SVProgressHUD dismiss];
        if (codeInt == 1) {
            [YLNetworkInterface sendMoneyCode:[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id] sendVericationBlock:^(BOOL isSuccess) {
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
            }];
            
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
