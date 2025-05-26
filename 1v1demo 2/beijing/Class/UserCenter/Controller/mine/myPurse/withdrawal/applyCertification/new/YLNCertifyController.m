//
//  YLNCertifyController.m
//  beijing
//
//  Created by zhou last on 2018/10/28.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLNCertifyController.h"
#import "newCertifyView.h"
#import <Masonry.h>
#import "DefineConstants.h"
#import "YLTapGesture.h"
#import <AVFoundation/AVFoundation.h>
#import "UIAlertCon+Extension.h"
#import "YLChoosePicture.h"
#import "YLHelpCenterController.h"
#import <SVProgressHUD.h>
#import "YLUploadImageExtension.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "YLBasicView.h"
#import "YLCertifyNowController.h"

typedef enum
{
    YLNewCertifyTypeIDCard = 1,//身份证号
    YLNewCertifyTypeMyPicture,//主播的正面照片
}YLNewCertifyType;

@interface YLNCertifyController ()<UIScrollViewDelegate>
{
    NSString *myPicturePath;//认证主播的照片
    NSString *idcardPath;//认证主播的身份证
    newCertifyView *ncertifyView; //认证视图
    YLNewCertifyType newCertyType; //身份证号 主播的正面照片
}

@property (weak, nonatomic) IBOutlet UIScrollView *certifyScrollView;

@end

@implementation YLNCertifyController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self certifyCustomUI];
}

#pragma mark ---- certifyCustom
- (void)certifyCustomUI
{
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"newCertifyView" owner:nil options:nil];
    ncertifyView = xibArray[0];
    [self.certifyScrollView addSubview:ncertifyView];
    [ncertifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(App_Frame_Width);
        make.height.mas_equalTo(604);
    }];
    self.certifyScrollView.contentSize = CGSizeMake(App_Frame_Width, 604);
    self.certifyScrollView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endediting)];
    [self.certifyScrollView addGestureRecognizer:tap];
    [ncertifyView cordius];
    //上传身份证号
    [YLTapGesture tapGestureTarget:self sel:@selector(uploadIDCard) view:ncertifyView.idcardImgView];
    //上传本人正面照片
    [YLTapGesture tapGestureTarget:self sel:@selector(uploadPicture) view:ncertifyView.pictureImgView];
    //相遇绿色协议书
    [YLTapGesture tapGestureTarget:self sel:@selector(agreementViewTap) view:ncertifyView.agreementLabel];
    //立即认证
    [YLTapGesture addTaget:self sel:@selector(certifyNowBtnClicked:) view:ncertifyView.certiNowBtn];
}

- (void)endediting {
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark ---- 上传身份证号
- (void)uploadIDCard
{
    newCertyType = YLNewCertifyTypeIDCard;
    
    [self pictureSelect];
}

#pragma mark ---- 上传正面照片
- (void)uploadPicture
{
    newCertyType = YLNewCertifyTypeMyPicture;
   
    [self pictureSelect];
}

#pragma mark ----
- (void)pictureSelect
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
        [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeCamera pickBlock:^(UIImage *pickImage) {
            if (self->newCertyType == YLNewCertifyTypeIDCard){
                [self->ncertifyView.idcardImgView setImage:pickImage];
            }else{
                [self->ncertifyView.pictureImgView setImage:pickImage];
            }
        }];
    }
}

#pragma mark ---- 用户协议
- (void)agreementViewTap
{
    YLHelpCenterController *helpcenterVC = [YLHelpCenterController new];
    helpcenterVC.title = @"用户协议书";
    helpcenterVC.urlPath = @"userment";
    [self.navigationController pushViewController:helpcenterVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark ---- 立即认证
- (void)certifyNowBtnClicked:(UIButton *)sender
{

    UIImage *image_1 = ncertifyView.pictureImgView.image;
    UIImage *image_2 =[UIImage imageNamed:@"newcer_mypc_pz"];
    NSData *data_1 = UIImageJPEGRepresentation(image_1, 1.0);
    NSData *data_2 = UIImageJPEGRepresentation(image_2, 1.0);
    if ([data_1 isEqual:data_2]) {
        [SVProgressHUD showInfoWithStatus:@"请选择你的正面照"];
        return;
    }
//    if ([ncertifyView.pictureImgView.image isEqual:[UIImage imageNamed:@"newcer_mypc_pz"]]) {
//        [SVProgressHUD showInfoWithStatus:@"请选择你的正面照"];
//        return;
//    }
    
    if (ncertifyView.wechatTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入微信号"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在上传..."];
    
    [[YLUploadImageExtension shareInstance] uploadImage:ncertifyView.pictureImgView.image uplodImageblock:^(NSString *backImageUrl) {
        self->myPicturePath = backImageUrl;
        
        [YLNetworkInterface submitNewIdentificationData:[YLUserDefault userDefault].t_id t_weixin:[NSString stringWithFormat:@"%@", self->ncertifyView.wechatTF.text] t_user_photo:self->myPicturePath block:^(BOOL isSuccess) {
            [SVProgressHUD dismiss];
            
            if (isSuccess) {
                YLCertifyNowController *CertifyNowVC = [YLCertifyNowController new];
                CertifyNowVC.title = @"主播资料审核中";
                [self.navigationController pushViewController:CertifyNowVC animated:YES];
            }
        }];


    }];
    
}


@end
