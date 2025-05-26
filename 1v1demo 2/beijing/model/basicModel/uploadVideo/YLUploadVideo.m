//
//  YLUploadVideo.m
//  beijing
//
//  Created by zhou last on 2018/7/14.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLUploadVideo.h"
#import "TXUGCPublish.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import "TXUGCPublishListener.h"
#import <SVProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface YLUploadVideo ()<TXVideoPublishListener,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    YLChooseVideoFinish chooseVideoBlock;
    YLUploadVideoFinish uploadVideoBlock;
}

@property (nonatomic, strong) NSString* uploadTempFilePath;

@end

@implementation YLUploadVideo
{
    TXUGCPublish   *_videoPublish;
    TXPublishParam   *_videoPublishParams;
}


+ (id)shareInstance
{
    static YLUploadVideo *choosePicture = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!choosePicture) {
            choosePicture = [YLUploadVideo new];
        }
    });
    
    return choosePicture;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self customVideo];
}



#pragma mark ---- customVideo
- (void)customVideo
{
  //@"A13HbkDQNTsYDVuDBOAkRJZaSZVzZWNyZXRJZD1BS0lETmdwb2NLSFR5SlRYUThOM0VFN3JRbzM2M3FVMU1kaWUmY3VycmVudFRpbWVTdGFtcD0xNTMxNTM0MjE1JmV4cGlyZVRpbWU9MTUzMTcwNzAxNSZyYW5kb209OTc5MjIwMzc4";
}

- (void)customPickerController:(UIViewController *)selfVC Block:(YLChooseVideoFinish)block
{
    chooseVideoBlock = block;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    NSString *requiredMediaType1 = ( NSString *)kUTTypeMovie;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType1,nil];
    [picker setMediaTypes: arrMediaTypes];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [selfVC presentViewController:picker animated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    NSURL *newVideoUrl ; //一般.mp4
    NSString* tempPath = [self TempFilePathWithExtension:@"mp4"];
    newVideoUrl = [NSURL fileURLWithPath:tempPath];
    
    chooseVideoBlock(tempPath);
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
    
    [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
}

- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 self.uploadTempFilePath = [outputURL path];
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
     }];
}

-(NSString *) TempFilePathWithExtension:(NSString*) extension{
    NSString* fileName = [NSString stringWithFormat:@"%@.mp4",[NSUUID UUID].UUIDString];
    NSString* path = NSTemporaryDirectory();
    path = [path stringByAppendingPathComponent:fileName];
    return path;
}

- (void)uploadVideo:(NSString *)videoPath sign:(NSString *)sign block:(YLUploadVideoFinish)block
{
    uploadVideoBlock = block;
    
    if (!videoPath) {
        [SVProgressHUD showInfoWithStatus:@"没有选择文件！！！"];
        return;
    }
    
    if(_videoPublish == nil) {
        _videoPublish = [[TXUGCPublish alloc] initWithUserID:@"carol_ios"];
        _videoPublish.delegate = self;
    }
    
    TXPublishParam *videoPublishParams = [[TXPublishParam alloc] init];
    videoPublishParams.signature  = sign;
    videoPublishParams.coverPath  = nil;
    videoPublishParams.videoPath  = videoPath;
    [_videoPublish publishVideo:videoPublishParams];
    
//    [SVProgressHUD showWithStatus:@"正在上传视频..."];
}


-(void) onPublishComplete:(TXPublishResult*)result
{
    [SVProgressHUD dismiss];

    if (result.retCode == 0) {
        [SVProgressHUD showInfoWithStatus:@"上传视频完成"];
        uploadVideoBlock(result.videoURL,YES,result.videoId);
    }else{
        uploadVideoBlock(@"",NO,@"");
        [SVProgressHUD showInfoWithStatus:@"上传视频失败"];
    }

}

+(UIImage*)getCoverImage:(NSString*)outMovieURL{
    
    AVURLAsset *asset =[[AVURLAsset alloc] initWithURL:[NSURL URLWithString:outMovieURL] options:nil];

    NSParameterAssert(asset);

    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];

    assetImageGenerator.appliesPreferredTrackTransform = YES;

    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;



    CGImageRef thumbnailImageRef = NULL;

    NSError *thumbnailImageGenerationError = nil;

    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(2*15, 15) actualTime:NULL error:&thumbnailImageGenerationError];



    if (!thumbnailImageRef)

        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);



    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;


    return thumbnailImage;
    
}

@end
