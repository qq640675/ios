//
//  YLFeedbackController.m
//  beijing
//
//  Created by zhou last on 2018/6/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLFeedbackController.h"
#import <Masonry.h>
#import "DefineConstants.h"
#import "UIAlertCon+Extension.h"
#import <AVFoundation/AVCaptureDevice.h>
#import "YLChoosePicture.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import <SVProgressHUD.h>
#import "YLNetworkInterface.h"
#import "YLUploadImageExtension.h"
#import "YLValidExtension.h"
#import "YLTapGesture.h"
#import "YLHistoryFeedBackController.h"

@interface YLFeedbackController ()<UITextViewDelegate>

//添加
@property (nonatomic ,strong) UIButton *addPictureButton;

@property (nonatomic ,strong) NSMutableArray *pictureMutableArray;
//选择照片白色背景
@property (weak, nonatomic) IBOutlet UIView *selPictureWhiteView;
//输入框
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
//电话
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
//提交反馈
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
//历史反馈
@property (weak, nonatomic) IBOutlet UIView *historyFeedBackView;

@end

@implementation YLFeedbackController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addPictureButton];
    //customUI
    [self feedbackCustomUI];
}

#pragma mark ---- customUI
- (void)feedbackCustomUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _pictureMutableArray = [NSMutableArray array];
    
    _inputTextView.textColor = IColor(177, 177, 177);
    _inputTextView.text     = @"输入您的反馈";
    _inputTextView.delegate = self;
    _inputTextView.font    = PingFangSCFont(14);
    
    [_feedbackButton.layer setCornerRadius:4.];
    _feedbackButton.titleLabel.font = PingFangSCFont(16);
    
    //隐藏键盘
    [YLTapGesture tapGestureTarget:self sel:@selector(hideKeyBoard) view:self.view];
    //查看历史反馈
    [YLTapGesture tapGestureTarget:self sel:@selector(historyFeedBackViewTap:) view:self.historyFeedBackView];
}

#pragma mark ---- 隐藏键盘
- (void)hideKeyBoard
{
    [_inputTextView resignFirstResponder];
}

#pragma mark ---- 历史反馈
- (void)historyFeedBackViewTap:(UITapGestureRecognizer *)tap
{
    YLHistoryFeedBackController *historyFeedBackVC = [YLHistoryFeedBackController new];
    historyFeedBackVC.title = @"历史反馈";
    [self.navigationController pushViewController:historyFeedBackVC animated:YES];
}

#pragma mark ---- 提交反馈事件
- (IBAction)feedbackButtonBeClicked:(id)sender {
    [_inputTextView resignFirstResponder];
    [_mobileTextField resignFirstResponder];
    if (_inputTextView.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"输入框不能为空!!!"];
        
        return;
    }
    
    if (_mobileTextField.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"电话号码格式不对!!!"];
        
        return;
    }
    
    if (_pictureMutableArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"照片不能为空!!!"];
        
        return;
    }
    
    //上传照片
    [SVProgressHUD showWithStatus:@"正在上传照片..."];
    [[YLUploadImageExtension shareInstance] uploadKindsOfPictures:_pictureMutableArray block:^(NSString *backImageUrl) {
        [SVProgressHUD dismiss];
        if (backImageUrl.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"照片不能为空"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"照片上传成功"];
            [YLNetworkInterface addFeedbackUserId:[YLUserDefault userDefault].t_id phone:self.mobileTextField.text content:self.inputTextView.text t_img_url:backImageUrl block:^(BOOL isSuccess) {
            }];
        }
    }];
}

- (UIButton *)addPictureButton
{
    if (_addPictureButton == nil) {
        _addPictureButton = [self createButtonImage:[UIImage imageNamed:@"report_Uploadevidence"] frame:CGRectMake(15., 12, 50., 50.)];
        [_addPictureButton addTarget:self action:@selector(choosePictureOrCameraButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        //添加按钮
        [self.selPictureWhiteView addSubview:_addPictureButton];
    }
    
    return _addPictureButton;
}

- (UIButton *)createButtonImage:(UIImage *)image frame:(CGRect)frame
{
    UIButton  *button = [UIButton new];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = frame;
    //添加按钮
    
    return button;
}

#pragma mark ---- 选择图片或拍照
- (void)choosePictureOrCameraButtonBeClicked:(UIButton *)sender
{
    [_inputTextView resignFirstResponder];
    [_mobileTextField resignFirstResponder];
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [UIAlertCon_Extension seeWeixinOrPhone:@"此App会在上传您的照片作为意见反馈的证据服务中访问您的相机权限" type:UIAlertControllerStyleAlert controller:self delSel:^(UIAlertAction *okSel) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        } oktittle:@"去开启"];
    }else{
        [UIAlertCon_Extension alertViewChoosePictureOrCamera:@"上传您的照片作为意见反馈的证据"
                                                        type:UIAlertControllerStyleActionSheet
                                                  controller:self
                                               choosePicture:^(UIAlertAction *okSel)
         {
             [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeAlbum pickBlock:^(UIImage *pickImage) {
                 [self.pictureMutableArray addObject:pickImage];
                 
                 [self pictureUpload];
             }];
         } camera:^(UIAlertAction *okSel) {
             [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeCamera pickBlock:^(UIImage *pickImage) {
                 [self.pictureMutableArray addObject:pickImage];
                 
                 [self pictureUpload];
             }];
         }];
    }
}

#pragma mark ---- 上传图片布局
- (void)pictureUpload
{
    for (UIView *view in [self.selPictureWhiteView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int index = 0; index < self.pictureMutableArray.count; index ++) {
        UIButton *button = [self createButtonImage:self.pictureMutableArray[index] frame:CGRectMake(15. + 65 * index, 12, 50., 50.)];
        //添加按钮
        [button.layer setCornerRadius:4.];
        [button setClipsToBounds:YES];
        [self.selPictureWhiteView addSubview:button];
    }
    
    if (IS_iPhone_5 || IS_iPhone_4S) {
        [self pictureArray:4];
    }else{
        [self pictureArray:5];
    }
}

- (void)pictureArray:(int)count
{
    if (self.pictureMutableArray.count < count) {
        UIButton *button = [self createButtonImage:[UIImage imageNamed:@"report_Uploadevidence"] frame:CGRectMake(15. + self.pictureMutableArray.count * 65, 12, 50, 50)];
        [button addTarget:self action:@selector(choosePictureOrCameraButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selPictureWhiteView addSubview:button];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"输入您的反馈";
        textView.textColor = IColor(177, 177, 177);
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"输入您的反馈"]){
        textView.text = @"";
        textView.textColor = IColor(39, 39, 39);
    }
}


@end
