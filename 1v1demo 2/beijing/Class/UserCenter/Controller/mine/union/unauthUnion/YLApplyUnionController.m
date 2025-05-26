//
//  YLApplyUnionController.m
//  beijing
//
//  Created by zhou last on 2018/9/14.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLApplyUnionController.h"
#import "DefineConstants.h"
#import "YLTapGesture.h"
#import "applyUnionView.h"
#import <Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import "UIAlertCon+Extension.h"
#import "YLChoosePicture.h"
#import "YLUploadVideo.h"
#import "YLUploadImageExtension.h"
#import "YLNetworkInterface.h"
#import "NSString+Util.h"
#import <SVProgressHUD.h>
#import "YLUserDefault.h"
#import "YLHelpCenterController.h"

@interface YLApplyUnionController ()<UITextFieldDelegate>
{
    applyUnionView *unionView;
    BOOL isSel; //阅读协议选中状态
    UIImage *pictureImage;
}

@property (weak, nonatomic) IBOutlet UIScrollView *applyUnionScrollView;

@end

@implementation YLApplyUnionController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isSel = YES; //默认选中
    pictureImage = nil;
    [self applyUnionCustomUI];
}

#pragma mark ---- customUI
- (void)applyUnionCustomUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"applyUnionView" owner:nil options:nil];
    unionView = xibArray[0];
    [self.applyUnionScrollView addSubview:unionView];
    [self.applyUnionScrollView setContentSize:CGSizeMake(App_Frame_Width, 748)];
    
    [unionView unionCordius];
    
    [unionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(App_Frame_Width);
        make.height.mas_equalTo(748);
    }];
    
    [YLTapGesture tapGestureTarget:self sel:@selector(hideKeyBoard) view:self.view];
    //键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
    
    //delegate
    unionView.nameTextField.delegate = self;
    unionView.idcardTextField.delegate = self;
    unionView.mobileTextField.delegate = self;
    unionView.unionNameTextField.delegate = self;
    unionView.numberTextField.delegate = self;
    
    //action
    [unionView.uploadImageBtn.layer setCornerRadius:4.];
    [unionView.uploadImageBtn setClipsToBounds:YES];
    //确定申请
    [YLTapGesture addTaget:self sel:@selector(applyOkBtnBeClicked:) view:unionView.applyOkBtn];
    //新游山公会协议书
    [YLTapGesture tapGestureTarget:self sel:@selector(agreementTap:) view:unionView.unionAgreenmentLabel];
    //选中状态
    [YLTapGesture tapGestureTarget:self sel:@selector(selAgreementTap:) view:unionView.agreementBgView];
    //选择照片
    [YLTapGesture addTaget:self sel:@selector(selPictureBtnBeClicked:) view:unionView.uploadImageBtn];
}

#pragma mark ---- 隐藏键盘
- (void)hideKeyBoard
{
    [unionView.nameTextField resignFirstResponder];
    [unionView.idcardTextField resignFirstResponder];
    [unionView.mobileTextField resignFirstResponder];
    [unionView.unionNameTextField resignFirstResponder];
    [unionView.numberTextField resignFirstResponder];
}

#pragma mark ---- textField

- (void)keyboardHide:(NSNotification *)noti
{
    [self hideKeyBoard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark ---- 新游山公会协议书
- (void)agreementTap:(UITapGestureRecognizer *)tap
{
    YLHelpCenterController *helpcenterVC = [YLHelpCenterController new];
    helpcenterVC.title = @"新游山公会协议书";
    helpcenterVC.urlPath = @"userment";
    [self.navigationController pushViewController:helpcenterVC animated:YES];
}

#pragma mark ---- 选择照片
- (void)selPictureBtnBeClicked:(UIButton *)sender
{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [UIAlertCon_Extension seeWeixinOrPhone:@"此App会在上传图片服务中访问您的相机权限" type:UIAlertControllerStyleAlert controller:self delSel:^(UIAlertAction *okSel) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        } oktittle:@"去开启"];
    }else{
        [UIAlertCon_Extension alertViewChoosePictureOrCamera:@"上传您的真实正面照片给服务器审核" type:UIAlertControllerStyleActionSheet controller:self choosePicture:^(UIAlertAction *okSel) {
            [[YLChoosePicture shareInstance] choosePicture:self
                                              type:YLPickImageTypeAlbum
                                          pickBlock:^(UIImage *pickImage)
             {
                self->pictureImage = pickImage;
                [self->unionView.uploadImageBtn setImage:pickImage forState:UIControlStateNormal];
            }];
        } camera:^(UIAlertAction *okSel) {
            [[YLChoosePicture shareInstance] choosePicture:self
                                              type:YLPickImageTypeCamera
                                          pickBlock:^(UIImage *pickImage)
             {
                self->pictureImage = pickImage;
                [self->unionView.uploadImageBtn setImage:pickImage forState:UIControlStateNormal];
            }];
        }];
    }
}

#pragma mark ---- 阅读协议选中状态
- (void)selAgreementTap:(UITapGestureRecognizer *)tap
{
    if (isSel) {
        [unionView.selImgView setImage:[UIImage imageNamed:@"union_unsel"]];
    }else{
        [unionView.selImgView setImage:[UIImage imageNamed:@"union_sel"]];
    }
    isSel = !isSel;
}

/*
 //申请者姓名
 @property (weak, nonatomic) IBOutlet UITextField *nameTextField;
 //身份证号码
 @property (weak, nonatomic) IBOutlet UITextField *idcardTextField;
 //联系方式
 @property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
 //公会名称
 @property (weak, nonatomic) IBOutlet UITextField *unionNameTextField;
 //主播人数
 @property (weak, nonatomic) IBOutlet UITextField *numberTextField;
 */
#pragma mark ---- 确定申请
- (void)applyOkBtnBeClicked:(UIButton *)sender {
    if ([NSString isNullOrEmpty:unionView.nameTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"申请者姓名不能为空!"];
        return;
    }
    
    if ([NSString isNullOrEmpty:unionView.idcardTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"身份证号码不能为空!"];
        return;
    }
    
    if ([NSString isNullOrEmpty:unionView.mobileTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"联系方式不能为空!"];
        return;
    }
    
    if ([NSString isNullOrEmpty:unionView.unionNameTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"公会名称不能为空!"];
        
        return;
    }
    
    if ([NSString isNullOrEmpty:unionView.numberTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"主播人数不能为空!"];
        
        return;
    }
    
    if (pictureImage == nil) {
        [SVProgressHUD showInfoWithStatus:@"请选择照片"];
        
        return;
    }
    
    [self uploadDataToServer];
}

- (void)uploadDataToServer
{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
    view.backgroundColor = KBLACKCOLOR;
    view.alpha = .3;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    NSData * imageData = UIImageJPEGRepresentation(pictureImage,.5);
    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    if (base64.length == 0) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"图片转换不正确！"];
        [view removeFromSuperview];
        
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在提交数据..."];

    
    [[YLUploadImageExtension shareInstance] uploadImage:pictureImage uplodImageblock:^(NSString *backImageUrl) {
        if (backImageUrl.length == 0) {
            [view removeFromSuperview];
            [SVProgressHUD dismiss];
            
            [SVProgressHUD showInfoWithStatus:@"上传头像失败!"];
            
            return ;
        }
        
        [self verifyIdenInfo:view base64:base64 url:backImageUrl];
    }];
}

#pragma mark ---- 验证身份信息
- (void)verifyIdenInfo:(UIView *)view base64:(NSString *)base64 url:(NSString *)backImageUrl
{
//    [YLNetworkInterface veriIdentification:self->unionView.nameTextField.text idenNo:self->unionView.idcardTextField.text img:base64 block:^(BOOL isSuccess) {
//        if (isSuccess) {
            [YLNetworkInterface applyGuild:[YLUserDefault userDefault].t_id
                                 guildName:self->unionView.unionNameTextField.text
                                 adminName:self->unionView.nameTextField.text
                                adminPhone:self->unionView.mobileTextField.text
                              anchorNumber:[self->unionView.numberTextField.text intValue]
                                    idCard:self->unionView.idcardTextField.text
                                   handImg:backImageUrl
                                     block:^(BOOL isSuccess)
             {
                 [view removeFromSuperview];
                 
                 if (isSuccess) {
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             }];
//        }else{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [view removeFromSuperview];
//                [SVProgressHUD dismiss];
//                [SVProgressHUD showInfoWithStatus:@"请输入您真实的身份信息！"];
//            });
//        }
//    }];
}

@end
