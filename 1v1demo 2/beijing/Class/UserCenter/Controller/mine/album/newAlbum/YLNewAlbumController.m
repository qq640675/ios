//
//  YLNewAlbumController.m
//  beijing
//
//  Created by zhou last on 2018/7/11.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLNewAlbumController.h"
#import "YLTapGesture.h"
#import <SVProgressHUD.h>
#import "YLNetworkInterface.h"
#import "NSString+Extension.h"
#import "UIAlertCon+Extension.h"
#import "YLUploadImageExtension.h"
#import "YLUserDefault.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import "DefineConstants.h"
#import "SLAlertController.h"
#import "LFImagePickerController.h"
#import "SLHelper.h"
#import "YLUploadVideoManager.h"
#import "SLPickerViewController.h"

#define eulaKeyWindowView [UIApplication sharedApplication].keyWindow

typedef enum : NSUInteger {
    YLUploadTypePhoto,
    YLUploadTypeVideo,
} YLUploadType;

typedef void (^AlbumBlock)(BOOL isRead);


@interface YLNewAlbumController ()
<
LFAssetImageProtocol,
LFImagePickerControllerDelegate,
SLPickerViewControllerDelegate
>

{
    NSString *videoPictureUrlStr;
    YLUploadType type;
    NSString *uploadFileId;
    
    UIView *admitBgView;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressView;
//上传
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
//提交
@property (weak, nonatomic) IBOutlet UIButton *admitButton;
//标题
@property (weak, nonatomic) IBOutlet UITextField *tittleTextField;
//设置收费背景
@property (weak, nonatomic) IBOutlet UIView *setingBgView;
//设置收费高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeightSettingConstraint;
//收费提示
@property (weak, nonatomic) IBOutlet UILabel *zeroAlertLabel;

//sel
@property (weak, nonatomic) IBOutlet UIImageView *selImgView;
//协议
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
//eula
@property (weak, nonatomic) IBOutlet UIView *eulaBgView;
//视频本地路径
@property (nonatomic, copy) NSString  *videoPathString;
//视频本地封面路径
@property (nonatomic, copy) NSString  *videoImagePathString;

@property (nonatomic, strong) SLPickerViewController    *pickerViewController;

@property (nonatomic, copy) NSArray    *moneyArray;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@end

@implementation YLNewAlbumController


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    _progressView.hidden = YES;
    [_progressView stopAnimating];
    
    [self judgeOnLine];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == 0) {
        self.navigationItem.title = @"新建相册";
        type = YLUploadTypePhoto;
    } else {
        self.navigationItem.title = @"新建视频";
        type =YLUploadTypeVideo;
    }
    
    [self newAlbumCustom];
    
    [self getPrivatePhotoMoney];
}

#pragma mark ---- customUI
- (void)newAlbumCustom
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [_admitButton.layer setCornerRadius:4.];
    [_admitButton setClipsToBounds:YES];
    [_uploadButton.layer setCornerRadius:4.];
    [_uploadButton setClipsToBounds:YES];
    //隐藏键盘
    [YLTapGesture tapGestureTarget:self sel:@selector(hideKeyBoard) view:self.view];
    
    if ([YLUserDefault userDefault].eula) {
        [self.selImgView setImage:[UIImage imageNamed:@"vip_pay_sel"]];
        [self.agreeLabel setTextColor:XZRGB(0xFD49AA)];
    }else{
        [self.selImgView setImage:[UIImage imageNamed:@"vip_pay_unsel"]];
        [self.agreeLabel setTextColor:XZRGB(0x919191)];
    }
    
    [self setupPickerViewController];
}

- (void)setupPickerViewController {
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerViewController.view];
    _pickerViewController.view.hidden = YES;
}

- (void)getPrivatePhotoMoney {
    [YLNetworkInterface dynamicPrivatePhotoMoney:[YLUserDefault userDefault].t_id block:^(NSMutableArray *listArray) {
        if ([listArray count] > 0) {
            self.moneyArray = listArray;
            self.pickerViewController.pickerDataArray = self.moneyArray;
        }
    }];
}

#pragma mark ---- 判断
- (void)judgeOnLine
{
    if ([YLUserDefault userDefault].t_role != 1) {
        //非主播
        self.setingBgView.hidden = YES;
        self.HeightSettingConstraint.constant = 0;
    } else {
        self.setingBgView.hidden = NO;
        self.HeightSettingConstraint.constant = 43;
        
    }
}


#pragma mark ----
- (void)hideKeyBoard
{
    [_tittleTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)clickedMoneyBtn:(id)sender {
    [self.view endEditing:YES];
    _pickerViewController.view.hidden = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark ---- 点击上传
- (IBAction)uploadButtonBeClicked:(id)sender {
    
    if ([self isMediaTypeOpen]) {
        LFImagePickerController *imagePicker = [[LFImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        //根据需求设置
        imagePicker.allowTakePicture = NO;
        imagePicker.maxVideosCount = 1; /** 解除混合选择- 要么1个视频，要么9个图片 */
        imagePicker.supportAutorotate = NO; /** 适配横屏 */
        imagePicker.allowPickingGif = NO; /** 支持GIF */
        imagePicker.allowPickingLivePhoto = NO; /** 支持Live Photo */
        imagePicker.maxVideoDuration = 15; /** 30秒视频 */
        if (self.type == 0) {
            imagePicker.allowPickingVideo = NO;
        } else {
            imagePicker.allowPickingImage = NO;
        }
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
            imagePicker.syncAlbum = YES; /** 实时同步相册 */
        }
        imagePicker.doneBtnTitleStr = @"确定"; //最终确定按钮名称
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

- (void)lf_imagePickerController:(LFImagePickerController *)picker didFinishPickingResult:(NSArray<LFResultObject *> *)results {
    
    for (NSInteger i = 0; i < results.count; i++) {
        LFResultObject *result = results[i];
        if ([result isKindOfClass:[LFResultImage class]]) {
            type = YLUploadTypePhoto;
            LFResultImage *resultImage = (LFResultImage *)result;
            [_uploadButton setImage:resultImage.originalImage forState:UIControlStateNormal];
        } else {
            type = YLUploadTypeVideo;
            LFResultVideo *resultVideo = (LFResultVideo *)result;
            if (resultVideo.data.length/1024/1024 > 50) {
                [SVProgressHUD showInfoWithStatus:@"视频过大,请重新选择"];
                return;
            }
            NSString *videoPath = [SLHelper tempVideoFilePathWithExtension];
            
            NSURL *newVideoUrl = [NSURL fileURLWithPath:videoPath];
            [SLHelper convertVideoQuailtyWithInputURL:resultVideo.url outputURL:newVideoUrl completeHandler:nil];
            
            self.videoPathString = videoPath;
            self.videoImagePathString = [SLHelper tempImageFilePathWithExtension:resultVideo.coverImage];
            
            [_uploadButton setImage:resultVideo.coverImage forState:UIControlStateNormal];
            
            
            
        }
    }
    
}

#pragma mark ---- 提交
- (IBAction)admitButtonBeClicked:(id)sender {

    if ([self.uploadButton.currentImage isEqual:[UIImage imageNamed:@"newAlbum_upload"]]) {
        
        [SVProgressHUD showInfoWithStatus:@"请选择视频或照片"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    self.view.userInteractionEnabled = NO;
    if (self->type == YLUploadTypePhoto) {
        //图片
        [[YLUploadImageExtension shareInstance] uploadImage:self.uploadButton.currentImage uplodImageblock:^(NSString *backImageUrl) {
            self->videoPictureUrlStr = backImageUrl;
            [self createAlbum:0 fileId:@"" videoImg:@""];
            
        }];
    } else {
        //视频
        //获取签名
        [YLNetworkInterface getVoideSignBlock:^(NSString *token) {
            if (token.length == 0) {
                [SVProgressHUD showInfoWithStatus:@"上传视频失败"];
                self.view.userInteractionEnabled = YES;
                return ;
            }
            
            //上传视频
            [[YLUploadVideoManager shareInstance] uploadVideoWithPath:self.videoPathString coverPath:self.videoImagePathString signature:token finishBlock:^(TXPublishResult *publishResult) {
                if (publishResult.retCode == 0) {
                    self->videoPictureUrlStr = publishResult.videoURL;
                    [self createAlbum:1 fileId:publishResult.videoId videoImg:publishResult.coverURL];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"上传视频失败"];
                    self.view.userInteractionEnabled = YES;
                }
            }];
        }];
    }
}



- (void)didSLPickerViewControllerSureBtn:(NSInteger)row {
    _pickerViewController.view.hidden = YES;
    _moneyLabel.text = _moneyArray[row];
}

- (void)didSLPickerViewControllerCancelBtn {
    _pickerViewController.view.hidden = YES;
}

#pragma mark ---- 创建相册
- (void)createAlbum:(int)type fileId:(NSString *)fileId videoImg:(NSString *)videoImg
{
    if (type == YLUploadTypePhoto) {
        //图片
        
    }else{
        //视频
        if ([self.uploadButton.currentImage isEqual:[UIImage imageNamed:@"newAlbum_upload"]]) {
            [SVProgressHUD showInfoWithStatus:@"请选择视频或图片"];
            return;
        }
    }
    
    [YLNetworkInterface addMyPhotoAlbum:[YLUserDefault userDefault].t_id t_title:_tittleTextField.text url:videoPictureUrlStr type:type gold:[_moneyLabel.text intValue] fileId:fileId video_img:videoImg block:^(BOOL isSuccess) {
        [self->admitBgView removeFromSuperview];
        if (isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

- (BOOL)isMediaTypeOpen {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        [SLAlertController alertControllerWithStyle:UIAlertControllerStyleAlert controller:self alertControllerTitle:@"温馨提示" alertControllerMessage:@"相机或相册权限未开启，是否去开启？" alertControllerSheetActionTitles:nil alertControllerSureActionTitle:@"去开启" alertControllerCancelActionTitle:@"取消" alertControllerSheetActionBlock:nil alertControllerAlertSureActionBlock:^{
            
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
            
        } alertControllerAlertCancelActionBlock:nil];
        return NO;
    }
    return YES;
}

- (SLPickerViewController *)pickerViewController {
    if (!_pickerViewController) {
        _pickerViewController  = [[SLPickerViewController alloc] init];
        _pickerViewController.view.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        _pickerViewController.pickerDataUnit = @"金币";
        _pickerViewController.delegate = self;
        [_pickerViewController setupUI];
    }
    return _pickerViewController;
}

@end
