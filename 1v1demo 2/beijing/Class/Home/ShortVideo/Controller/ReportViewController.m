//
//  ReportViewController.m
//  Qiaqia
//
//  Created by 刘森林 on 2021/3/3.
//  Copyright © 2021 yiliaogaoke. All rights reserved.
//

#import "ReportViewController.h"
#import "SLPlaceHolderTextView.h"
#import "SLAlertController.h"
#import "YLChoosePicture.h"
#import "LoginVerificationView.h"
#import "UIAlertCon+Extension.h"
#import "PhotoListModel.h"
#import "YLUploadImageExtension.h"
#import "LFImagePickerController.h"

@interface ReportViewController ()
<
LoginVerificationViewDelegate,
LFImagePickerControllerDelegate
>

@property (nonatomic, strong) LoginVerificationView *verificationView;

@property (nonatomic, strong) SLPlaceHolderTextView *textView;

@property (nonatomic, strong) UIButton  *addImageBtn;

@property (nonatomic, strong) UIButton  *codeBtn;

@property (nonatomic, strong) UITextField   *phoneTextField;

@property (nonatomic, strong) UITextField   *codeTextField;

@property (nonatomic, strong) NSMutableArray    *imageModelArray;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *countryCode;

@property (nonatomic, assign) NSInteger         uploadImageIndex;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"投诉";
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupUI {
    self.textView = [[SLPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, SafeAreaTopHeight, App_Frame_Width-20, 100)];
    _textView.placeholder = @"投诉内容（至少10个字符）";
    _textView.placeholderColor = XZRGB(0x666666);
    _textView.textColor = XZRGB(0x333333);
    _textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_textView];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+120, App_Frame_Width, 1)];
    lineV.backgroundColor = XZRGB(0xebebeb);
    [self.view addSubview:lineV];
    
    UILabel *lb = [UIManager initWithLabel:CGRectZero text:@"上传图片（至少1张）" font:14.0f textColor:UIColor.blackColor];
    [self.view addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.equalTo(lineV.mas_bottom).offset(10);
    }];
    
    CGFloat width = (App_Frame_Width-10)/3;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+(i%3)*width, SafeAreaTopHeight+160+(i/3)*125, width-10, 115)];
        imageView.backgroundColor = XZRGB(0x999999);
        imageView.tag = 100+i;
        imageView.hidden = YES;
        [self.view addSubview:imageView];
        
        UIButton *deleteBtn = [UIManager initWithButton:CGRectZero text:nil font:1 textColor:nil normalImg:@"Dynamic_release_delete" highImg:nil selectedImg:nil];
        deleteBtn.tag = 1000+i;
        [deleteBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.hidden = YES;
        [self.view addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imageView);
            make.top.equalTo(imageView);
        }];
        
    }
    
    self.addImageBtn = [UIManager initWithButton:CGRectMake(10, SafeAreaTopHeight+160, width-10, 115) text:nil font:1 textColor:nil normalBackGroudImg:@"Dynamic_release_add" highBackGroudImg:nil selectedBackGroudImg:nil];
//    [UIManager initWithButton:CGRectMake(10, SafeAreaTopHeight+160, width-10, 115) text:nil font:1 textColor:nil normalImg:@"Dynamic_release_add" highImg:nil selectedImg:nil];
    [_addImageBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addImageBtn];
    
    UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+285, App_Frame_Width, 1)];
    lineV1.backgroundColor = XZRGB(0xebebeb);
    [self.view addSubview:lineV1];
    
    UILabel *lb1 = [UIManager initWithLabel:CGRectZero text:@"联系方式" font:14.0f textColor:UIColor.blackColor];
    [self.view addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.equalTo(lineV1.mas_bottom).offset(10);
    }];

    UILabel *lb2 = [UIManager initWithLabel:CGRectZero text:@"手机号：" font:14.0f textColor:XZRGB(0x333333)];
    [self.view addSubview:lb2];
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.equalTo(lb1.mas_bottom).offset(15);
    }];
    
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _phoneTextField.placeholder = @"请输入手机号码（必填）";
    _phoneTextField.keyboardType= UIKeyboardTypeNumberPad;
    _phoneTextField.font = [UIFont systemFontOfSize:15];
    _phoneTextField.textColor = XZRGB(0x333333);
    [self.view addSubview:_phoneTextField];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lb2.mas_right).offset(10);
        make.centerY.mas_equalTo(lb2);
        make.size.mas_equalTo(CGSizeMake(App_Frame_Width-60, 40));
    }];
    
    UILabel *lb3 = [UIManager initWithLabel:CGRectZero text:@"验证码：" font:14.0f textColor:XZRGB(0x333333)];
    [self.view addSubview:lb3];
    [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.equalTo(lb2.mas_bottom).offset(15);
    }];
    
    self.codeTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _codeTextField.placeholder = @"请输入验证码";
    _codeTextField.keyboardType= UIKeyboardTypeNumberPad;
    _codeTextField.font = [UIFont systemFontOfSize:15];
    _codeTextField.textColor = XZRGB(0x333333);
    [self.view addSubview:_codeTextField];
    [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lb3.mas_right).offset(10);
        make.centerY.mas_equalTo(lb3);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    self.codeBtn = [UIManager initWithButton:CGRectZero text:@"获取验证码" font:14 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
    _codeBtn.clipsToBounds = YES;
    _codeBtn.layer.cornerRadius = 5.0f;
    _codeBtn.backgroundColor = KDEFAULTCOLOR;
    _codeBtn.tag = 10087;
    [_codeBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_codeBtn];
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.centerY.mas_equalTo(lb3);
        make.size.mas_equalTo(CGSizeMake(95, 30));
    }];
    
    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+400, App_Frame_Width, 1)];
    lineV2.backgroundColor = XZRGB(0xebebeb);
    [self.view addSubview:lineV2];
    
    UIButton *commitBtn = [UIManager initWithButton:CGRectZero text:@"提交" font:17.0f textColor:[UIColor whiteColor] normalBackGroudImg:@"insufficient_coin_pay" highBackGroudImg:nil selectedBackGroudImg:nil];
    commitBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    [commitBtn addTarget:self action:@selector(clickedCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).offset(-50);
        make.size.mas_equalTo(CGSizeMake(App_Frame_Width-30, 59));
    }];
    
    self.imageModelArray = [NSMutableArray new];
    
    _uploadImageIndex = 0;
    
    [self.view addSubview:self.verificationView];
    _verificationView.hidden = YES;
}

- (void)setupVerifyImage:(UIImage *)image {
    self.verificationView.codeImageView.image = image;
}

- (void)updateImage {

    for (int i = 0; i < [_imageModelArray count]; i++) {
        PhotoListModel *pModel = _imageModelArray[i];
        UIImageView *imageView = [self.view viewWithTag:100+i];
        UIButton *deleteBtn = [self.view viewWithTag:1000+i];
        imageView.hidden = NO;
        deleteBtn.hidden = NO;

        if (pModel.image)
        {
            imageView.image = pModel.image;
        }
    }
    
    if ([_imageModelArray count] < 3) {
        _addImageBtn.hidden = NO;
        UIImageView *imageView = [self.view viewWithTag:_imageModelArray.count+100];
        _addImageBtn.x = imageView.x;
        _addImageBtn.y = imageView.y;
    } else {
        _addImageBtn.hidden = YES;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)clickedBtn:(UIButton *)btn {
    if (btn.tag == 0) {
        //添加图片
        [self presentAlertController];
    }
    else if (btn.tag == 10087) {
        //获取验证码
        if (_phoneTextField.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确格式的手机号码"];
            return;
        }
        [self custShowVerifyView];
    }
    else {
        [_imageModelArray removeObjectAtIndex:btn.tag-1000];
        
        for (UIView *view in self.view.subviews) {
            if (view.tag > 99) {
                view.hidden = YES;
            }
        }
        
        [self updateImage];
    }
}

- (void)clickedCommitBtn {
    if (_textView.text.length < 10) {
        [SVProgressHUD showInfoWithStatus:@"投诉内容最少10个字符"];
        return;
    }
    if (_textView.text.length > 100) {
        [SVProgressHUD showInfoWithStatus:@"投诉内容最多100个字符"];
        return;
    }
    if (_imageModelArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"至少上传一张图片"];
        return;
    }
    if (_phoneTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if (_codeTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
    }
    
    [self uploadImageToYun];
}

- (void)presentAlertController {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [UIAlertCon_Extension seeWeixinOrPhone:@"此功能需要访问您的相机权限" type:UIAlertControllerStyleAlert controller:self delSel:^(UIAlertAction *okSel) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        } oktittle:@"去开启"];
    }else{
        [self setupImagePickerPic];
//        [UIAlertCon_Extension alertViewChoosePictureOrCamera:@"选择图片"
//                                              type:UIAlertControllerStyleActionSheet
//                                         controller:self
//                                       choosePicture:^(UIAlertAction *okSel)
//         {
//             [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeAlbum pickBlock:^(UIImage *pickImage) {
//                 PhotoListModel  *model = [PhotoListModel new];
//                 model.image = pickImage;
//                 [self.imageModelArray addObject:model];
//
//                 [self updateImage];
//             }];
//         } camera:^(UIAlertAction *okSel) {
//             [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeCamera pickBlock:^(UIImage *pickImage) {
//                 PhotoListModel  *model = [PhotoListModel new];
//                 model.image = pickImage;
//                 [self.imageModelArray addObject:model];
//
//                 [self updateImage];
//             }];
//         }];
    }
}

- (void)setupImagePickerPic {
    NSUInteger picCount = 3 - [_imageModelArray count];
    LFImagePickerController *imagePicker = [[LFImagePickerController alloc] initWithMaxImagesCount:picCount delegate:self];
    //根据需求设置
    imagePicker.allowPickingVideo = NO;
//    imagePicker.allowTakePicture = NO;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        imagePicker.syncAlbum = YES; /** 实时同步相册 */
    }
    imagePicker.doneBtnTitleStr = @"确定"; //最终确定按钮名称
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)lf_imagePickerController:(LFImagePickerController *)picker didFinishPickingResult:(NSArray<LFResultObject *> *)results {
    for (NSInteger i = 0; i < results.count; i++) {
        LFResultObject *result = results[i];
        if ([result isKindOfClass:[LFResultImage class]]) {
            LFResultImage *resultImage = (LFResultImage *)result;
            PhotoListModel  *model = [PhotoListModel new];
            model.image = resultImage.originalImage;
            [self.imageModelArray addObject:model];
        }
    }
    [self updateImage];
}

#pragma mark - Cust Delegate
- (void)didSelectLoginVerificationViewWithBgView {
    [self.view endEditing:YES];
    _verificationView.hidden = YES;
}

- (void)didSelectLoginVerificationViewWithBtn:(NSString *_Nullable)code {
    if (code == nil) {
        _verificationView.textField.text = nil;
        _phone = _phoneTextField.text;
        dispatch_queue_t queue = dispatch_queue_create("yanzhen—1", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            [self custDownloadImage];
        });

    } else {
        [self getDataWithVerify:code];
    }
}

#pragma mark - Net
- (void)getDataWithVerify:(NSString *)verifyCode {
    //校验图形验证码
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    [YLNetworkInterface getVerifyCodeIsCorrectWithPhone:_phoneTextField.text verifyCode:verifyCode block:^(int codeInt) {
        [SVProgressHUD dismiss];
        if (codeInt == 1) {
            [YLNetworkInterface sendPhoneVerificationCode:self.phoneTextField.text sendVericationBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    [self didSelectLoginVerificationViewWithBgView];
                    [self custStartTimer];
                }
            } restype:3 verifyCode:verifyCode];
        }
    }];
    
}



- (void)postDataWithReport {
    [SVProgressHUD showWithStatus:@"正在提交中..."];
    
    NSString *imagePath = @"";
    for ( int i = 0 ; i < _imageModelArray.count; i ++) {
        PhotoListModel *model = _imageModelArray[i];
        if (imagePath.length == 0) {
            imagePath = model.imgUrl;
        } else {
            imagePath = [imagePath stringByAppendingFormat:@",%@", model.imgUrl];
        }
    }
    [YLNetworkInterface saveComplaintWithCoverUserId:(int)self.otherUserId comment:_textView.text img:imagePath phone:self.phoneTextField.text tcode:self.codeTextField.text block:^(BOOL isSuccess) {
        
        if (isSuccess) {
            [SVProgressHUD showInfoWithStatus:@"举报成功,平台将会在24小时之内进行核实处理"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


- (void)uploadImageToYun {

    [SVProgressHUD showWithStatus:@"正在上传中..."];

    __block PhotoListModel *model = _imageModelArray[_uploadImageIndex];

    [[YLUploadImageExtension shareInstance] uploadImage:model.image uplodImageblock:^(NSString *backImageUrl) {
        model.imgUrl = backImageUrl;

        if (self.uploadImageIndex == [self.imageModelArray count] - 1) {

            dispatch_async(dispatch_get_main_queue(), ^{
                //上传到服务器
                [self postDataWithReport];
            });

        } else {
            self.uploadImageIndex ++;
            [self uploadImageToYun];
        }
    }];
    
}

#pragma mark - Custom
- (void)custStartTimer {
    __block NSInteger second = 60;
    
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second == 0) {
                //验证码登录
                self.codeBtn.enabled = YES;
                [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                dispatch_cancel(self.timer);
            } else {
                NSString *strSecond = [NSString stringWithFormat:@"%ld秒",(long)second];
                self.codeBtn.enabled = NO;
                [self.codeBtn setTitle:strSecond forState:UIControlStateNormal];
                second--;
            }
        });
    });
    dispatch_resume(_timer);
}

- (void)custShowVerifyView {
    //获取图形验证码
    [self.verificationView.codeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/getVerify.html?phone=%@",INTERFACEADDRESS,self.phoneTextField.text]] placeholderImage:nil];
    self.verificationView.hidden = NO;
    [self.verificationView.textField becomeFirstResponder];
    
}

- (void)custDownloadImage {
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/getVerify.html?phone=%@",INTERFACEADDRESS,_phoneTextField.text]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    [self performSelectorOnMainThread:@selector(setupVerifyImage:) withObject:image waitUntilDone:YES];
    
}

- (LoginVerificationView *)verificationView {
    if (!_verificationView) {
        _verificationView = [[LoginVerificationView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
        _verificationView.delegate = self;
    }
    return _verificationView;
}


@end
