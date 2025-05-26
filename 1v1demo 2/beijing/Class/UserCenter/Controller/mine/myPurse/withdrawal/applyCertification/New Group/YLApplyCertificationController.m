//
//  YLApplyCertificationController.m
//  beijing
//
//  Created by zhou last on 2018/6/19.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLApplyCertificationController.h"
#import "YLApplyCertiView.h"
#import "DefineConstants.h"
#import <Masonry.h>
#import "YLTapGesture.h"
#import "UIAlertCon+Extension.h"
#import "YLChoosePicture.h"
#import "YLBasicView.h"
#import "YLUploadImageExtension.h"
#import "NSString+Extension.h"
#import <SVProgressHUD.h>
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "YLEditPersonalController.h"
#import "YLHelpCenterController.h"
#import <AVFoundation/AVFoundation.h>

@interface YLApplyCertificationController ()
{
    YLApplyCertiView *applyCerView;
    NSString *base64;
    UIImage *pictureImage; //照片
}

@property (weak, nonatomic) IBOutlet UIScrollView *applyCertificateScrollView;

@end

@implementation YLApplyCertificationController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    pictureImage = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self applyCustomUI];
}

#pragma mark ---- customUI
- (void)applyCustomUI
{
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"YLApplyCertiView" owner:nil options:nil];
    applyCerView = xibArray[0];
    [_applyCertificateScrollView addSubview:applyCerView];
    
    _applyCertificateScrollView.contentSize = CGSizeMake(App_Frame_Width, 730);
    
    [applyCerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(App_Frame_Width);
        make.height.mas_equalTo(APP_Frame_Height);
    }];
    
    //上传形象图片
    [applyCerView.uploadPhotoButton.layer setCornerRadius:4.];
    [applyCerView.uploadPhotoButton setClipsToBounds:YES];
    [applyCerView.uploadPhotoButton addTarget:self action:@selector(uploadFigureImage) forControlEvents:UIControlEventTouchUpInside];
    //提交认证
    [applyCerView.admitButton addTarget:self action:@selector(admitApplyCertification) forControlEvents:UIControlEventTouchUpInside];
    //隐藏键盘
    [YLTapGesture tapGestureTarget:self sel:@selector(hideKeyBoard) view:self.view];
    //键盘弹出
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    
    NSString *str = @"认证即代表您已经阅读并同意《平台绿色协议书》";
    
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName
                            value:XZRGB(0xF31269)
                            range:[str rangeOfString:@"平台绿色协议书"]];
    applyCerView.agreementLabel.attributedText = attrDescribeStr;
    
    //协议书
    [YLTapGesture tapGestureTarget:self sel:@selector(agreementTap:) view:applyCerView.agreementLabel];
}

#pragma mark ---- 协议书
- (void)agreementTap:(UITapGestureRecognizer *)tap
{
    YLHelpCenterController *helpcenterVC = [YLHelpCenterController new];
    helpcenterVC.title = @"用户协议书";
    helpcenterVC.urlPath = @"userment";
    [self.navigationController pushViewController:helpcenterVC animated:YES];
}

#pragma mark ---- 键盘弹出
- (void)keyboardShow:(NSNotification *)noti
{
    NSDictionary *info = [noti userInfo];
    // keyboardHeight 为键盘高度
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
//    if (IS_iPhone_4S || IS_iPhone_5) {
        CGRect rect =  self.view.frame;
        rect.origin.y = - keyboardSize.height;
        self.view.frame = rect;
//    }
}


#pragma mark ---- 上次形象图片
- (void)uploadFigureImage
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [UIAlertCon_Extension seeWeixinOrPhone:@"此功能会在选择您的正面照片作为主播认证的审核资料服务中访问您的相机权限" type:UIAlertControllerStyleAlert controller:self delSel:^(UIAlertAction *okSel) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        } oktittle:@"去开启"];
    } else {
        [UIAlertCon_Extension alertViewChoosePictureOrCamera:@"请选择您的正面照片作为主播认证的审核资料" type:UIAlertControllerStyleActionSheet controller:self choosePicture:^(UIAlertAction *okSel) {
            [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeAlbum pickBlock:^(UIImage *pickImage) {
                self->pictureImage = pickImage;
                
                [self->applyCerView.uploadPhotoButton setImage:pickImage  forState:UIControlStateNormal];
            }];
        } camera:^(UIAlertAction *okSel) {
            [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeCamera pickBlock:^(UIImage *pickImage) {
                self->pictureImage = pickImage;
                [self->applyCerView.uploadPhotoButton setImage:pickImage  forState:UIControlStateNormal];
            }];
        }];
    }
}

#pragma mark ---- 上传图片
- (void)uploadPicture:(UIImage *)pickerImage
{
    UIView *view = [UIView new];
    view.frame = self.view.bounds;
    view.backgroundColor = KBLACKCOLOR;
    view.alpha = .3;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
//    [SVProgressHUD showWithStatus:@"修改资料中..."];
    [SVProgressHUD showWithStatus:@"请稍候..."];
    
    [applyCerView.uploadPhotoButton setImage:[YLBasicView imageCompressFitSizeScale:pickerImage targetSize:CGSizeMake(100, 66)] forState:UIControlStateNormal];
    
    NSData * imageData = UIImageJPEGRepresentation(pickerImage,.5);
    base64 = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    if (base64.length == 0) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"图片转换不正确！"];
        [view removeFromSuperview];
        
        return;
    }
    
    [[YLUploadImageExtension shareInstance] uploadImage:pickerImage uplodImageblock:^(NSString *backImageUrl) {
        [YLNetworkInterface veriIdentification:self->applyCerView.realNameTextField.text idenNo:self->applyCerView.idcardTextField.text img:self->base64 block:^(BOOL isSuccess) {
        if (isSuccess) {
        [YLNetworkInterface submitIdentificationData:[YLUserDefault userDefault].t_id t_user_hand:backImageUrl t_nam:self->applyCerView.realNameTextField.text t_id_card:self->applyCerView.idcardTextField.text block:^(BOOL isSuccess) {
        if (isSuccess) {
            [view removeFromSuperview];
            [SVProgressHUD dismiss];

            YLEditPersonalController *editPersonalVC = [YLEditPersonalController new];
            editPersonalVC.title = @"编辑资料";
            [self.navigationController pushViewController:editPersonalVC animated:YES];
        }
        }];
        }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"请输入您真实的身份信息！"];
        });
        }
        }];
    }];
}

#pragma mark ---- 隐藏键盘
- (void)hideKeyBoard
{
    [applyCerView.realNameTextField resignFirstResponder];
    [applyCerView.idcardTextField resignFirstResponder];
}


#pragma mark ---- 提交认证
- (void)admitApplyCertification
{
    if ([NSString isNullOrEmpty:applyCerView.realNameTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"真实姓名不能为空！"];
        
        return;
    }
    
    if ([NSString isNullOrEmpty:applyCerView.idcardTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"身份证号不能为空！"];
        
        return;
    }
    
    if (pictureImage == nil) {
        [SVProgressHUD showInfoWithStatus:@"请选择你的正面照"];
        
        return;
    }
    
    [self uploadPicture:pictureImage];
}

@end
