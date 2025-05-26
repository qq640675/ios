//
//  YLChoosePicture.m
//  beijing
//
//  Created by zhou last on 2018/6/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLChoosePicture.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <Photos/PHPhotoLibrary.h>

@interface YLChoosePicture ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIViewController *selfVC;
    YLPickImageFinish pickImageBlock;
}

@property (nonatomic ,strong) UIImagePickerController *selPhotoImgPicker;

@end

@implementation YLChoosePicture

- (instancetype)init
{
    if (self == [super init]) {
        [self selPhotoImgPicker];
    }
    
    return self;
}

#pragma mark ---- 实例
+ (id)shareInstance
{
    static YLChoosePicture *choosePicture = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!choosePicture) {
            choosePicture = [YLChoosePicture new];
            
        }
    });
    
    return choosePicture;
}

#pragma mark ---- 选择图片或拍照
- (void)choosePicture:(UIViewController *)selfNav type:(YLPickImageType)type pickBlock:(YLPickImageFinish)pickBlock
{
    selfVC = selfNav;
    pickImageBlock = pickBlock;
    
    if (type == YLPickImageTypeAlbum) {
        //相册
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
        {
            // 无权限
        }else{
            [_selPhotoImgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            _selPhotoImgPicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [selfNav presentViewController:_selPhotoImgPicker animated:YES completion:nil];
        }
    }else{
        //拍照
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
        {
            // 无权限
        }else{
            [_selPhotoImgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            _selPhotoImgPicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            _selPhotoImgPicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [selfVC presentViewController:_selPhotoImgPicker animated:YES completion:nil];
        }
    }
}

- (void)choosePicture:(UIViewController *)selfNav pickBlock:(YLPickImageFinish)pickBlock {
    selfVC = selfNav;
    pickImageBlock = pickBlock;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {
        // 无权限
    }else{
        [_selPhotoImgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        _selPhotoImgPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        _selPhotoImgPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [selfVC presentViewController:_selPhotoImgPicker animated:YES completion:nil];
    }
}

#pragma mark ---- uiimagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *orgImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    pickImageBlock(orgImage);
    [selfVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [selfVC dismissViewControllerAnimated:YES completion:nil];
}

- (UIImagePickerController *)selPhotoImgPicker
{
    if (nil == _selPhotoImgPicker) {
        _selPhotoImgPicker = [[UIImagePickerController alloc] init];
        _selPhotoImgPicker.delegate = self;
        _selPhotoImgPicker.modalPresentationStyle = UIModalPresentationCustom;
        _selPhotoImgPicker.allowsEditing = YES;
        _selPhotoImgPicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    }
    return _selPhotoImgPicker;
}

@end
