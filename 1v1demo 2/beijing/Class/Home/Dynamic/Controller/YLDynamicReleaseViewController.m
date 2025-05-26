//
//  YLDynamicReleaseViewController.m
//  beijing
//
//  Created by yiliaogao on 2018/12/25.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "YLDynamicReleaseViewController.h"
#import "LFImagePickerController.h"
#import "HVideoViewController.h"
#import "DynamicAddressViewController.h"

//tool
#import "DynamicReleaseTableViewDataSource.h"
#import "DynamicPicModel.h"
#import "DynamicVideoModel.h"
#import "YLUploadVideoManager.h"
#import "YLUploadImageExtension.h"
#import "SLAlertController.h"
#import "SLPickerViewController.h"
#import <QCloudCOSXML/QCloudCOSXML.h>

@interface YLDynamicReleaseViewController ()
<
DynamicReleasePicTableViewCellDelegate,
LFAssetImageProtocol,
LFImagePickerControllerDelegate,
SLPickerViewControllerDelegate
>
{
    BOOL isAutoExamine;
}

@property (nonatomic, strong) SLPickerViewController    *pickerViewController;

@property (nonatomic, strong) DynamicReleaseListModel   *selectedListModel;
@property (nonatomic, strong) DynamicReleaseTextModel   *textModel;
@property (nonatomic, strong) DynamicReleasePicModel    *picModel;
@property (nonatomic, strong) DynamicReleaseListModel   *addressModel;
@property (nonatomic, strong) DynamicAddressListModel   *addressListModel;

@property (nonatomic, strong) TXPublishResult *publishResult;

@property (nonatomic, strong) UIButton *naviRightBtn;

@property (nonatomic, copy) NSArray    *moneyArray;

@property (nonatomic, assign) NSInteger actionMoneyTag;




@end

@implementation YLDynamicReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"发布动态";
    isAutoExamine = NO;
    
    [self getPrivatePhotoMoney];
    
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark -- UI
- (void)setupUI {
    //设置navigationBar rightBtn
    self.naviRightBtn = [UIManager initWithButton:CGRectMake(0, 0, 50, 22) text:@"发布" font:14.0f textColor:[UIColor whiteColor] normalImg:nil highImg:nil selectedImg:nil];
    _naviRightBtn.backgroundColor = XZRGB(0xAE4FFD);
    _naviRightBtn.clipsToBounds = YES;
    _naviRightBtn.layer.cornerRadius = 4;
    [_naviRightBtn addTarget:self action:@selector(clickedNaviRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_naviRightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    [self createTableView];
}

- (void)initTableDatasource {
    
    SLTableViewCellBlock cellBlock = ^(SLBaseTableViewCell *cell, SLBaseListModel *model) {
        [self forCellDelegate:cell listModel:model];
    };
    
    self.dataSource = [[DynamicReleaseTableViewDataSource alloc] initWithCellBlock:cellBlock];
    
    self.baseTableView.dataSource = self.dataSource;
    self.baseTableView.tableFooterView = [UIView new];
    
    [self setupTableFrame];
    
    [self initTableData];
}

- (void)setupTableFrame {
    self.baseTableView.height = APP_Frame_Height;
}

- (void)initTableData {
    self.dataSource.sections = [NSMutableArray new];
    SLTableViewSectionModel *secModel = [SLTableViewSectionModel new];
    //文字
    self.textModel = [DynamicReleaseTextModel new];
    _textModel.content = @"";
    [secModel.listModels addObject:_textModel];
    //图片或者视频
    self.picModel = [DynamicReleasePicModel new];
    _picModel.fileDataType = FileDataType_Pic;
    _picModel.picModelArray = [NSMutableArray new];
    
    [secModel.listModels addObject:_picModel];
    //操作菜单
    DynamicReleaseListModel *listModel = [DynamicReleaseListModel new];
    listModel.listTitle = @"所在位置";
    listModel.listImageName = @"Dynamic_release_location";
    listModel.listSelectedImageName = @"Dynamic_release_location_selected";
    listModel.listType = 0;
    listModel.listDesc = @"";
    self.addressModel = listModel;
    [secModel.listModels addObject:listModel];
    
    [self.dataSource.sections addObject:secModel];
    
    [self.baseTableView reloadData];
    
    [self setupPickerViewController];
}

- (void)setupPickerViewController {
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerViewController.view];
    _pickerViewController.view.hidden = YES;
}

#pragma mark -- Net
- (void)getPrivatePhotoMoney {
    [YLNetworkInterface dynamicPrivatePhotoMoney:[YLUserDefault userDefault].t_id block:^(NSMutableArray *listArray) {
        if ([listArray count] > 0) {
            self.moneyArray = listArray;
            self.pickerViewController.pickerDataArray = self.moneyArray;
        }
    }];
}

- (void)postDataWithDynamic {
    
    NSMutableArray *fileArray = [NSMutableArray new];
    for (int i = 0; i < [_picModel.picModelArray count]; i++) {
        if (_isVideo) {
            //视频
            DynamicVideoModel *model = _picModel.picModelArray[i];
            NSInteger isPrivate = 1;
            NSInteger gold = [model.money integerValue];
            if ([model.title isEqualToString:@"收费"] || [model.title isEqualToString:@"0"] ) {
                isPrivate = 0;
            }
            NSDictionary *dic = @{@"fileType":@(1),@"t_cover_img_url":_publishResult.coverURL,@"fileUrl":_publishResult.videoURL,@"t_video_time":[SLHelper getMMSSFromSS:[NSString stringWithFormat:@"%lu",(unsigned long)model.videoSec]],@"fileId":_publishResult.videoId,@"t_is_private":@(isPrivate),@"gold":@(gold)};
            [fileArray addObject:dic];
        } else {
            //图片
            DynamicPicModel *model = _picModel.picModelArray[i];
            NSInteger isPrivate = 1;
            NSInteger gold = [model.money integerValue];
            if ([model.title isEqualToString:@"收费"] || [model.title isEqualToString:@"0"] ) {
                isPrivate = 0;
            }
            NSDictionary *dic = @{@"fileType":@(0),@"t_cover_img_url":@"",@"fileUrl":model.imageUrl,@"t_video_time":@"",@"fileId":@"",@"t_is_private":@(isPrivate),@"gold":@(gold)};
            [fileArray addObject:dic];
        }
    }

    id obj = fileArray;
    
    if ([fileArray count] == 0) {
        obj = @"";
    }
    
    [YLNetworkInterface releaseDynamicData:[YLUserDefault userDefault].t_id content:_textModel.content address:_addressModel.listDesc isVisible:_selectedListModel.listType-1 files:obj block:^(BOOL isSuccess) {
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled = YES;
        if (isSuccess) {
            if (isAutoExamine == YES)
            {
                [SVProgressHUD showInfoWithStatus:@"发布成功"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"发布成功，等待审核"];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}

- (void)postDataWithVideo {
    DynamicVideoModel *model = [self.picModel.picModelArray firstObject];
    //获取签名
    [YLNetworkInterface getVoideSignBlock:^(NSString *token) {
        if (token.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"上传视频失败"];
            self.view.userInteractionEnabled = YES;
            return ;
        }

        //上传视频
        [[YLUploadVideoManager shareInstance] uploadVideoWithPath:model.videoPath coverPath:model.videoImagePath signature:token finishBlock:^(TXPublishResult *publishResult) {
            if (publishResult.retCode == 0) {
                self.publishResult = publishResult;
//                [self postDataWithDynamic];
                [self requestAutoExamineSetup];
            } else {
                [SVProgressHUD showInfoWithStatus:@"上传视频失败！"];
                self.view.userInteractionEnabled = YES;
            }
        }];
    }];
}

- (void)postDataWithImage {
    NSMutableArray *images = [NSMutableArray new];
    for (int i = 0; i < [_picModel.picModelArray count]; i++) {
        DynamicPicModel *model = _picModel.picModelArray[i];
        [images addObject:model.image];
    }

    [[YLUploadImageExtension shareInstance] uploadKindsOfPictures:images block:^(NSString *backImageUrl) {
        if (backImageUrl.length > 0) {
            NSArray *urls = [backImageUrl componentsSeparatedByString:@","];
            for (int i = 0; i < [self.picModel.picModelArray count]; i++) {
                DynamicPicModel *model = self.picModel.picModelArray[i];
                model.imageUrl = urls[i];
            }
//            [self postDataWithDynamic];
            [self requestAutoExamineSetup];
        } else {
            [SVProgressHUD showInfoWithStatus:@"上传图片失败！"];
            self.view.userInteractionEnabled = YES;
        }

    }];
}


#pragma mark -- Action
- (void)clickedNaviRightBtn {
    // TODO, add 2th control
    [self.view endEditing:YES];
    if (_textModel.content.length == 0 && _picModel.picModelArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入文字或者上传图片、视频～"];
        return;
    }
    if (_textModel.content.length > 1000) {
        [SVProgressHUD showInfoWithStatus:@"文字不能超过1000字～"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在发布..."];
    
    self.view.userInteractionEnabled = NO;
    if (_picModel.picModelArray.count == 0) {
//        [self postDataWithDynamic];
        [self requestAutoExamineSetup];
    } else {
        if (self.isVideo) {
            //上传视频
            [self postDataWithVideo];
        } else {
            //上传图片
            [self postDataWithImage];
        }
    }
}


#pragma mark -- Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)clickedTableCell:(SLBaseListModel *)listModel {
    if ([listModel isKindOfClass:[DynamicReleaseListModel class]]) {
        DynamicReleaseListModel *model = (DynamicReleaseListModel *)listModel;
        if (model.listType == ReleaseListType_Location) {
            //地址
            [self pushAddressVC];
        } else {
            if (!model.isSelected) {
                self.selectedListModel.isSelected = NO;
                model.isSelected = YES;
                self.selectedListModel = model;
                [self.baseTableView reloadData];
            }
        }
    }
}

- (void)didSelectDynamicReleasePicTableViewCellBtn:(NSUInteger)btnTag {
    [self.view endEditing:YES];
    if (btnTag == 10) {
        //添加图片
        if ([self isMediaTypeOpen]) {
            [SLAlertController alertControllerWithStyle:UIAlertControllerStyleActionSheet controller:self alertControllerTitle:@"请选择" alertControllerMessage:nil alertControllerSheetActionTitles:@[@"相机",@"手机相册"] alertControllerSureActionTitle:nil alertControllerCancelActionTitle:@"取消" alertControllerSheetActionBlock:^(UIAlertAction *didSelectAction) {
                NSString *selectTitle = [NSString stringWithFormat:@"%@",didSelectAction];
                if ([selectTitle isEqualToString:@"相机"]) {
                    [self setupImagePickerCamera];
                } else {
                    [self setupImagePickerPic];
                }
            } alertControllerAlertSureActionBlock:nil alertControllerAlertCancelActionBlock:nil];
        }
    } else if (btnTag > 99 && btnTag < 1000) {
        //删除图片
        [self deletePicModel:btnTag];
    } else {
        //设置金币
        _actionMoneyTag = btnTag;
        _pickerViewController.view.hidden = NO;
    }
}


- (void)forCellDelegate:(SLBaseTableViewCell *)tableCell listModel:(SLBaseListModel *)listModel {
    if ([tableCell isKindOfClass:[DynamicReleasePicTableViewCell class]]) {
        DynamicReleasePicTableViewCell *cell = (DynamicReleasePicTableViewCell *)tableCell;
        cell.delegate = self;
    }
}

- (void)didSLPickerViewControllerSureBtn:(NSInteger)row {
    _pickerViewController.view.hidden = YES;
    [self updatePicModel:_moneyArray[row]];
}

- (void)didSLPickerViewControllerCancelBtn {
    _pickerViewController.view.hidden = YES;
}

- (void)lf_imagePickerController:(LFImagePickerController *)picker didFinishPickingResult:(NSArray<LFResultObject *> *)results {
    NSMutableArray *imageOrVideos = [NSMutableArray new];
    for (NSInteger i = 0; i < results.count; i++) {
        LFResultObject *result = results[i];
        if ([result isKindOfClass:[LFResultImage class]]) {
            LFResultImage *resultImage = (LFResultImage *)result;
            [imageOrVideos addObject:resultImage.originalImage];
        } else {
            //视频
            self.isVideo = YES;
            LFResultVideo *resultVideo = (LFResultVideo *)result;
            
            if (resultVideo.data.length/1024/1024 > 50) {
                [SVProgressHUD showInfoWithStatus:@"视频过大，请重新选择！"];
                return;
            }
            DynamicVideoModel *model = [DynamicVideoModel new];
            model.image = resultVideo.coverImage;
            model.title = @"收费";
            model.money = @"0";
            model.videoPath = [SLHelper tempVideoFilePathWithExtension];
            model.videoImagePath = [SLHelper tempImageFilePathWithExtension:model.image];
            model.videoSec = resultVideo.duration+1;
            model.videoSize = resultVideo.data.length/1024/1024;
            
            NSURL *newVideoUrl = [NSURL fileURLWithPath:model.videoPath];
            [SLHelper convertVideoQuailtyWithInputURL:resultVideo.url outputURL:newVideoUrl completeHandler:nil];
            
            [imageOrVideos addObject:model];
        }
    }
    [self addPicModel:imageOrVideos];
    
    
    
}

#pragma mark -- Cust
- (void)pushAddressVC {
    DynamicAddressViewController *addressVC = [[DynamicAddressViewController alloc] init];
    addressVC.selectedAddressListModel = _addressListModel;
    __weak typeof(self) weakSelf = self;
    addressVC.DidSelectAddressBlock = ^(DynamicAddressListModel *model,NSString *curLocationCity) {
        if ([model.name isEqualToString:@"不显示位置"]) {
            weakSelf.addressModel.listTitle  = @"所在位置";
            weakSelf.addressModel.isSelected = NO;
            weakSelf.addressModel.listDesc = @"";
            weakSelf.addressListModel = nil;
        } else {
            weakSelf.addressModel.isSelected = YES;
            weakSelf.addressModel.listTitle = model.name;
            weakSelf.addressModel.listDesc = model.name;
            if (curLocationCity.length > 0) {
                weakSelf.addressModel.listDesc = [NSString stringWithFormat:@"%@ · %@",curLocationCity,model.name];
            }
            weakSelf.addressListModel = model;
        }
        
        [weakSelf.baseTableView reloadData];
    };
    addressVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:addressVC animated:YES completion:nil];
}

- (void)setupImagePickerPic {
    NSUInteger picCount = 9 - [_picModel.picModelArray count];
    LFImagePickerController *imagePicker = [[LFImagePickerController alloc] initWithMaxImagesCount:picCount delegate:self];
    //根据需求设置
    if ([_picModel.picModelArray count] > 0) {
        //如果选了照片就不能选择视频
        imagePicker.allowPickingVideo = NO;
    }
    imagePicker.allowTakePicture = NO;
    imagePicker.maxVideosCount = 1; /** 解除混合选择- 要么1个视频，要么9个图片 */
    imagePicker.supportAutorotate = NO; /** 适配横屏 */
    imagePicker.allowPickingGif = NO; /** 支持GIF */
    imagePicker.allowPickingLivePhoto = NO; /** 支持Live Photo */
    imagePicker.maxVideoDuration = 15; /** 30秒视频 */
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        imagePicker.syncAlbum = YES; /** 实时同步相册 */
    }
    imagePicker.doneBtnTitleStr = @"确定"; //最终确定按钮名称
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)setupImagePickerCamera {
    HVideoViewController *videoVC = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
    videoVC.HSeconds = 15;//设置可录制最长时间
    if ([_picModel.picModelArray count] > 0) {
        //如果选了照片就不能录制视频
        videoVC.HSeconds = 1;
        videoVC.labelTipTitle.text = @"点击拍照";
    }
    videoVC.takeBlock = ^(id item, UIImage *coverImage, NSUInteger sec, NSUInteger size) {
        if ([item isKindOfClass:[NSURL class]]) {
            //视频
            self.isVideo = YES;
            NSData *imageData = UIImageJPEGRepresentation(coverImage, 0.6);
            
            DynamicVideoModel *model = [DynamicVideoModel new];
            model.image = [UIImage imageWithData:imageData];
            model.title = @"收费";
            model.money = @"0";
            model.videoSize= size;
            model.videoSec = sec+1;
            model.videoPath = [SLHelper tempVideoFilePathWithExtension];
            model.videoImagePath = [SLHelper tempImageFilePathWithExtension:model.image];
            
            NSURL *newVideoUrl = [NSURL fileURLWithPath:model.videoPath];
            [SLHelper convertVideoQuailtyWithInputURL:(NSURL *)item outputURL:newVideoUrl completeHandler:nil];
            NSArray *array = [[NSArray alloc] initWithObjects:model, nil];
            [self addPicModel:array];
        } else {
            //图片
            UIImage *pickImage = (UIImage *)item;
            NSData  *imageData = UIImageJPEGRepresentation(pickImage, 0.6);
            NSArray *array = [[NSArray alloc] initWithObjects:[UIImage imageWithData:imageData], nil];
            [self addPicModel:array];
        }
    };
    videoVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoVC animated:YES completion:nil];
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


- (void)addPicModel:(NSArray *)images {
    if (_isVideo) {
        //视频
        [_picModel.picModelArray addObjectsFromArray:images];
        _picModel.fileDataType = FileDataType_Video;
    } else {
        //图片
        for (int i = 0; i < [images count]; i++) {
            DynamicPicModel *model = [DynamicPicModel new];
            model.image = images[i];
            model.title = @"收费";
            model.money = @"0";
            [_picModel.picModelArray addObject:model];
        }
    }
    _picModel.cellHeight = 0.0f;
    [self.baseTableView reloadData];
}

- (void)deletePicModel:(NSUInteger)tag {
    [_picModel.picModelArray removeObjectAtIndex:tag-100];
    _picModel.cellHeight = 0.0f;
    [self.baseTableView reloadData];
}

- (void)updatePicModel:(NSString *)money {
    if (_isVideo) {
        DynamicVideoModel *model = _picModel.picModelArray[_actionMoneyTag-1000];
        model.money = money;
        model.title = money;
    } else {
        DynamicPicModel *model = _picModel.picModelArray[_actionMoneyTag-1000];
        model.money = money;
        model.title = money;
    }
    [self.baseTableView reloadData];
}

#pragma mark -- Lazy loading
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

- (void)requestAutoExamineSetup {
    [YLNetworkInterface requestAutoExamineSetup:^{
        // 第一步校验文本
        // 第二步校验图片
        // 第三步校验视频
        isAutoExamine = YES;
        [self AutoExamine_text];
//        NSString *strResult = [self resultAutoExamine];
//        if ([strResult isEqualToString:@""])
//        {
//            [self postDataWithDynamic];
//        }
//        else
//        {
//            self.view.userInteractionEnabled = YES;
//            [SVProgressHUD showInfoWithStatus:[@"发布失败，自动审核不通过: "  stringByAppendingString:strResult]];
//        }
    } fail:^{
        isAutoExamine = NO;
        [self postDataWithDynamic];
    }];
}

- (void)showfailautoexamine:(NSString *)strResult
{
    self.view.userInteractionEnabled = YES;
    [SVProgressHUD showInfoWithStatus:[@"发布失败，自动审核不通过: "  stringByAppendingString:strResult]];
}


- (void)AutoExamine_text
{
    if (_textModel.content == nil ||
        [_textModel.content isEqualToString:@""])
    {
        if (_picModel.picModelArray.count == 0) {
            [self postDataWithDynamic];
        }
        else
        {
            if (self.isVideo) {
                [self AutoExamine_video];
            }
            else
            {
                [self AutoExamine_pic];
            }
        }
    }
    else
    {
        QCloudPostTextRecognitionRequest * request = [[QCloudPostTextRecognitionRequest alloc]init];
        
        // content:纯文本信息
        // object:对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
        // url:文本文件的完整链接
        // 单次请求只能使用 Object 、Content、Url 中的一个。
        // 当选择 Object、Url 时，审核结果为异步返回，可通过 查询文本审核任务结果 API 接口获取返回结果。
        // 当选择 Content 时，审核结果为同步返回，可通过 响应体 查看返回结果。
        request.content = _textModel.content;
        
        // 存储桶名称，格式为 BucketName-APPID
        request.bucket = [TencentApiDefault apiDefault].bucket;
        
        // 文件所在地域
        request.regionName = [TencentApiDefault apiDefault].region;
        
        // 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
        //    request.bizType = BizType;
        
        request.finishBlock = ^(QCloudPostTextRecognitionResult * outputObject, NSError *error) {
            // outputObject 提交审核反馈信息 包含用于查询的job id，详细字段请查看api文档或者SDK源码
            // QCloudPostTextRecognitionResult 类；
            
            if (outputObject != nil &&
                outputObject.State != nil)
            {
                if ([outputObject.State isEqualToString:@"Success"])
                {
                    if (outputObject.Result == 0)
                    {
                        if (_picModel.picModelArray.count == 0) {
                            [self postDataWithDynamic];
                        }
                        else
                        {
                            if (self.isVideo) {
                                [self AutoExamine_video];
                            }
                            else
                            {
                                [self AutoExamine_pic];
                            }
                        }
                    }
                    else
                    {
                        [self showfailautoexamine:@"文本审核失败"];
                    }
                }
                if ([outputObject.State isEqualToString:@"Failed"])
                {
                    //                [self showfailautoexamine:outputObject.Message];
                    [self showfailautoexamine:@"文本审核失败"];
                }
            }
        };
        [[QCloudCOSXMLService defaultCOSXML] PostTextRecognition:request];
    }
}

- (void)AutoExamine_pic
{
    NSMutableArray *input = [NSMutableArray new];
    
    NSMutableArray *fileArray = [NSMutableArray new];
    for (int i = 0; i < [_picModel.picModelArray count]; i++) {
        
        //图片
        DynamicPicModel *model = _picModel.picModelArray[i];
        
        // 待审核的图片对象
        QCloudBatchRecognitionImageInfo * input1 = [QCloudBatchRecognitionImageInfo new];
        input1.Url = model.imageUrl;
        [input addObject:input1];
    }
    
    QCloudBatchimageRecognitionRequest * request = [[QCloudBatchimageRecognitionRequest alloc]init];
    
    request.bucket =  [TencentApiDefault apiDefault].bucket;
    request.regionName =  [TencentApiDefault apiDefault].region;
    
    // 待审核的图片对象数组
    request.input = input;
    
    // 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
    //    request.bizType = BizType;
    
    [request setFinishBlock:^(QCloudBatchImageRecognitionResult * _Nullable result, NSError * _Nullable error) {
        // outputObject 审核结果，详细字段请查看api文档或者SDK源码
        // QCloudBatchImageRecognitionResult 类；
        
        NSArray <QCloudBatchImageRecognitionResultItem *> *list = result.JobsDetail;
        
        int intSuccessCount = 0;
        
        for (int i = 0; i < list.count; i++)
        {
            QCloudBatchImageRecognitionResultItem *objItem = [list objectAtIndex:i];
            
            // 值为 Submitted（已提交审核）、Failed（审核失败）其中一个。
            if (objItem != nil &&
                objItem.State != nil)
            {
                if ([objItem.State isEqualToString:@"Success"])
                {
                    if (objItem.Result == 0)
                    {
                        intSuccessCount += 1;
                    }
                }
            }
        }
        
        if (intSuccessCount == list.count)
        {
            [self postDataWithDynamic];
        }
        else
        {
            [self showfailautoexamine:@"图片审核失败"];
        }
    }];
    [[QCloudCOSXMLService defaultCOSXML] BatchImageRecognition:request];
}

- (void)AutoExamine_video
{
    QCloudPostVideoRecognitionRequest *request = [[QCloudPostVideoRecognitionRequest alloc]init];

    // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
    request.url = _publishResult.videoURL;

    request.bucket =  [TencentApiDefault apiDefault].bucket;
    request.regionName = [TencentApiDefault apiDefault].region;

    // 截帧模式。Interval 表示间隔模式；Average 表示平均模式；Fps 表示固定帧率模式。
    // Interval 模式：TimeInterval，Count 参数生效。当设置 Count，未设置 TimeInterval 时，表示截取所有帧，共 Count 张图片。
    // Average 模式：Count 参数生效。表示整个视频，按平均间隔截取共 Count 张图片。
    // Fps 模式：TimeInterval 表示每秒截取多少帧，Count 表示共截取多少帧。
    request.mode = QCloudVideoRecognitionModeFps;

    // 视频截帧频率，范围为(0.000, 60.000]，单位为秒，支持 float 格式，执行精度精确到毫秒
    request.timeInterval = 1;

    // 视频截帧数量，范围为(0, 10000]。
    request.count = 10;

    // 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
//    request.bizType = @"BizType";

    // 用于指定是否审核视频声音，当值为 0 时：表示只审核视频画面截图；值为1时：表示同时审核视频画面截图和视频声音。默认值为 0。
    request.detectContent = YES;

    request.finishBlock = ^(QCloudPostVideoRecognitionResult * outputObject, NSError *error) {
    // outputObject 提交审核反馈信息 包含用于查询的 job id，详细字段请查看 api 文档或者 SDK 源码
    // QCloudPostVideoRecognitionResult 类；
        
//         Submitted（已提交审核）、Snapshoting（视频截帧中）、Success（审核成功）、Failed（审核失败）、Auditing（审核中）其中一个
        
        if (outputObject != nil &&
            outputObject.State != nil)
        {
            if ([outputObject.State isEqualToString:@"Submitted"] || [outputObject.State isEqualToString:@"Success"])
            {
                [self postDataWithDynamic];
            }
            if ([outputObject.State isEqualToString:@"Failed"])
            {
                [self showfailautoexamine:@"视频审核失败"];
            }
        }
    };
    [[QCloudCOSXMLService defaultCOSXML] PostVideoRecognition:request];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@synthesize assetImage;

@end
