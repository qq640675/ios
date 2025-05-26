//
//  BeautyViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/4/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BeautyViewController.h"
#import "TiUIManager.h"
#import <TiSDK/TiSDK.h>
#import "UIAlertCon+Extension.h"
#import "YLValidExtension.h"
#import "FUCameraManager.h"
#import "FUDemoManager.h"

@interface BeautyViewController ()
<
AgoraRtcEngineDelegate
>

//本地自己的流
@property (nonatomic, strong) UIImageView *videoCanvasSelf;

//tiLive
//@property (nonatomic, strong) TiSDKManager   *tiSDKManager;

@property (nonatomic, strong) FUCameraManager *cameraManager;

@end

@implementation BeautyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dealloc {
    
    [FUDemoManager saveFUManager];
    
//    [self.tiSDKManager destroy];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWithVideoWindow];
    
//    [self performSelector:@selector(initWithTiLive) withObject:nil afterDelay:.3];
//
//    UIButton *backBtn = [UIManager initWithButton:CGRectMake(0, SafeAreaTopHeight-64, 88, 88) text:nil font:15.0f textColor:[UIColor clearColor] normalImg:@"PersonCenter_beauty_back" highImg:nil selectedImg:nil];
//    [backBtn addTarget:self action:@selector(clickedBackBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
//
   
    [SVProgressHUD dismiss];
    
    if ([FUDemoManager shared].supportBeauty){
        
        UIView *viewBeauty = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:viewBeauty];
        
        
        [[FUDemoManager shared] addDemoViewToView:viewBeauty originY:CGRectGetHeight(self.view.frame) - FUBottomBarHeight - FUSafaAreaBottomInsets()];
        
    }
}

- (void)clickedBackBtn {
  
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)initWithTiLive {
//    self.tiSDKManager = [[TiSDKManager alloc] init];
    
//    [[TiUIManager shareManager] setShowsDefaultUI:YES];
//    [[TiUIManager shareManager] loadToView:self.view forDelegate:nil];
}

- (void)initWithVideoWindow {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [UIAlertCon_Extension seeWeixinOrPhone:@"此App会在视频聊天服务中访问您的相机权限" type:UIAlertControllerStyleAlert controller:self delSel:^(UIAlertAction *okSel) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        } oktittle:@"去开启"];
        return;
    } else {
        BOOL isOpenMicro = [YLValidExtension judgeMicrophone];
        
        if (!isOpenMicro) {
            [UIAlertCon_Extension seeWeixinOrPhone:@"此App会在视频聊天服务中访问您的麦克风权限" type:UIAlertControllerStyleAlert controller:self delSel:^(UIAlertAction *okSel) {
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                    [[UIApplication sharedApplication] openURL:settingsURL];
                }
            } oktittle:@"去开启"];
            return;
        }
    }
    
    _videoCanvasSelf = [UIImageView new];
    _videoCanvasSelf.frame = self.view.bounds;
    
    [self.view addSubview:self.videoCanvasSelf];

    [self.cameraManager setLocalView:self.videoCanvasSelf];
    [self.cameraManager startCapture];
    
    
}

#pragma mark - FU camera
- (FUCameraManager *)cameraManager {
    if (!_cameraManager) {
        _cameraManager = [[FUCameraManager alloc] init];
        [_cameraManager setLocalView:self.videoCanvasSelf];
    }
    return _cameraManager;
}



@end
