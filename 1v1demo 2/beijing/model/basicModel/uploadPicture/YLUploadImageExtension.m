//
//  YLUploadImageExtension.m
//  beijing
//
//  Created by zhou last on 2018/7/3.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLUploadImageExtension.h"
#import <QCloudCore/QCloudCore.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import "ZYTimeStamp.h"
#import "JChatConstants.h"

@interface YLUploadImageExtension ()


@property (nonatomic ,strong) YLUploadImageFinish uplodBlock;
@property (nonatomic, strong) QCloudCOSXMLUploadObjectRequest* uploadRequest;
@property (nonatomic, strong) NSData* uploadResumeData;

@end


@implementation YLUploadImageExtension

+ (id)shareInstance
{
    static YLUploadImageExtension *choosePicture = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!choosePicture) {
            choosePicture = [YLUploadImageExtension new];
        }
    });
    
    return choosePicture;
}

#pragma mark ---- 上传单张照片
- (void)uploadImage:(UIImage *)pickImage uplodImageblock:(YLUploadImageFinish)block
{
    _uplodBlock = block;
    NSString* tempPath = QCloudTempFilePathWithExtension(@"png");
        
    [UIImageJPEGRepresentation(pickImage, 1.0) writeToFile:tempPath atomically:YES];
    
    QCloudCOSXMLUploadObjectRequest* upload = [QCloudCOSXMLUploadObjectRequest new];
    upload.body = [NSURL fileURLWithPath:tempPath];
    upload.bucket =  [TencentApiDefault apiDefault].bucket;
    
    NSString *timeStamp =  [ZYTimeStamp getTimestampFromTime];
    
    int x = arc4random() % 10000;
    upload.object = [NSString stringWithFormat:@"%@%d.png",timeStamp,x];
    [self uploadFileByRequest:upload];
}

- (void) uploadFileByRequest:(QCloudCOSXMLUploadObjectRequest*)upload
{
    _uploadRequest = upload;
    __weak typeof(self) weakSelf = self;
    [upload setFinishBlock:^(QCloudUploadObjectResult *result, NSError * error) {
        weakSelf.uploadRequest = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
            } else {
                NSMutableDictionary *dic = (NSMutableDictionary *)[result qcloud_modelToJSONObject];
                self.uplodBlock(dic[@"Location"]);
            }
        });
    }];
    
    //    [upload setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            QCloudLogDebug(@"bytesSent: %i, totoalBytesSent %i ,totalBytesExpectedToSend: %i ",bytesSent,totalBytesSent,totalBytesExpectedToSend);
    //        });
    //    }];
    
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:upload];
}


#pragma mark ---- 上传多张照片
- (void)uploadKindsOfPictures:(NSMutableArray *)pictureArray block:(YLUploadImageFinish)block
{
    dispatch_queue_t queue =dispatch_get_global_queue(0,0);
    dispatch_group_t group =dispatch_group_create();
    
    __block int index = 0;
    __block NSString *uploadImagePath = @"";
    for (UIImage *image in pictureArray) {
        dispatch_group_enter(group);
        
        dispatch_group_async(group, queue, ^{
            [[YLUploadImageExtension shareInstance] uploadImage:image uplodImageblock:^(NSString *backImageUrl) {
            if (uploadImagePath.length == 0) {
                uploadImagePath = [uploadImagePath stringByAppendingString:backImageUrl];
                
                index ++;
                dispatch_group_leave(group);
            }else{
                uploadImagePath = [uploadImagePath stringByAppendingString:[NSString stringWithFormat:@",%@",backImageUrl]];
                
                index ++;
                dispatch_group_leave(group);
            }
            }];
        });
    }
    
    dispatch_group_notify(group,dispatch_get_main_queue(), ^{
        block(uploadImagePath);
    });
}


@end
