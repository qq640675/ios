//
//  AuthenticationPicViewController.m
//  beijing
//
//  Created by 黎 涛 on 2019/10/9.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "AuthenticationPicViewController.h"
#import "MJExtension.h"
#import "LXTAlertView.h"
#import "YLChoosePicture.h"
#import "YLUploadImageExtension.h"
#import "ToolManager.h"

typedef enum {
    PicTypeFront = 0,
    PicTypeBack,
} PicType;

@interface AuthenticationPicViewController ()

@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, assign) PicType picType;
@property (nonatomic, copy) NSString *frontImageUrl;
@property (nonatomic, copy) NSString *backImageUrl;

@end

@implementation AuthenticationPicViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"身份认证";
    [self setSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - subViews
- (void)setSubViews {
    UILabel *tipLabel = [UIManager initWithLabel:CGRectMake(0, 0, App_Frame_Width, 50) text:@"    请上传本人有效期内的身份证照片" font:15 textColor:XZRGB(0x333333)];
    tipLabel.backgroundColor = XZRGB(0xebebeb);
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipLabel];
    
    CGFloat gap = (App_Frame_Width-300)/4;
    _frontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(gap, 70, 150, 100)];
    _frontImageView.image = [UIImage imageNamed:@"rz_img_front"];
    _frontImageView.tag = 100;
    [self.view addSubview:_frontImageView];
    _frontImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapFront = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImageViewWithTap:)];
    [_frontImageView addGestureRecognizer:tapFront];
    
    UILabel *labelFront = [UIManager initWithLabel:CGRectMake(gap, 170, 150, 30) text:@"请上传身份证人像面" font:13 textColor:XZRGB(0x666666)];
    [self.view addSubview:labelFront];
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-150-gap, 70, 150, 100)];
    _backImageView.image = [UIImage imageNamed:@"rz_img_back"];
    _backImageView.tag = 200;
    [self.view addSubview:_backImageView];
    _backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImageViewWithTap:)];
    [_backImageView addGestureRecognizer:tapBack];
    
    UILabel *labelBack = [UIManager initWithLabel:CGRectMake(App_Frame_Width-150-gap, 170, 150, 30) text:@"请上传身份证国徽面" font:13 textColor:XZRGB(0x666666)];
    [self.view addSubview:labelBack];
    
    UILabel *tipL = [UIManager initWithLabel:CGRectMake(25, 240, App_Frame_Width-50, 80) text:@"1、请保证照片清晰；\n2、该照片仅用作认证，官方将对照片保密。" font:15 textColor:XZRGB(0x333333)];
    tipL.textAlignment = NSTextAlignmentLeft;
    tipL.numberOfLines = 0;
    [self.view addSubview:tipL];
    
    UIButton *btn = [ToolManager defaultMutableColorButtonWithFrame:CGRectMake((App_Frame_Width-290)/2, 400, 290, 40) title:@"提 交" isCycle:YES];
    [btn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - upload image
- (void)uploadImageViewWithTap:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    if (index == 100) {
        // 正面
        _picType = PicTypeFront;
    } else if (index == 200) {
        // 反面
        _picType = PicTypeBack;
    }
    [self uploadIdCardImage];
}

- (void)uploadIdCardImage {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [LXTAlertView alertViewDefaultWithTitle:@"提示" message:@"此功能需要访问您的相机权限" sureHandle:^{
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }];
    }else{
        [LXTAlertView alertActionWithTitle:nil message:nil actionArr:@[@"相机", @"相册"] actionHandle:^(int index) {
            if (index == 0) {
                [[YLChoosePicture shareInstance] choosePicture:self pickBlock:^(UIImage *pickImage) {
                    [self setIdCardIamge:pickImage];
                }];
            } else {
                [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeAlbum pickBlock:^(UIImage *pickImage) {
                    [self setIdCardIamge:pickImage];
                }];
            }
        }];
    }
}

- (void)setIdCardIamge:(UIImage *)image {
    [SVProgressHUD show];
    [[YLUploadImageExtension shareInstance] uploadImage:image uplodImageblock:^(NSString *backImageUrl) {
        [SVProgressHUD dismiss];
        if (self.picType == PicTypeFront) {
            self.frontImageView.image = image;
            self.frontImageUrl = backImageUrl;
        } else if (self.picType == PicTypeBack) {
            self.backImageView.image = image;
            self.backImageUrl = backImageUrl;
        }
    }];
}

#pragma mark - func
- (void)nextStep {
    if (self.frontImageUrl == nil) {
        [SVProgressHUD showInfoWithStatus:@"请上传身份证正面"];
        return;
    }
    if (self.backImageUrl == nil) {
        [SVProgressHUD showInfoWithStatus:@"请上传身份证反面"];
        return;
    }
    NSDictionary *param = @{@"userId" : @([YLUserDefault userDefault].t_id),
                            @"t_card_face" : [NSString stringWithFormat:@"%@", self.frontImageUrl],
                            @"t_card_back" : [NSString stringWithFormat:@"%@", self.backImageUrl],
                            @"t_type":@"3"
    };
    [SVProgressHUD show];
    [YLNetworkInterface submitIdentificationDataWithParam:param success:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
}


@end
