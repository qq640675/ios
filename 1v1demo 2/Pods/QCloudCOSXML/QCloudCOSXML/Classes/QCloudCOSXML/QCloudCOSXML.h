//
//  QCloudCOSXML.h
//  Pods
//
//  Created by Dong Zhao on 2017/5/2.
//
//

#ifndef QCloudCOSXML_h
#define QCloudCOSXML_h

#import "QCloudCOSXMLService.h"
#import "QCloudCOSXMLService+Transfer.h"
#import "QCloudCOSXMLService+Manager.h"
#import "QCloudCOSXMLEndPoint.h"
#import "QCloudGetServiceRequest.h"
#import "QCloudPutBucketRequest.h"
#import "QCloudGetBucketRequest.h"
#import "QCloudHeadBucketRequest.h"
#import "QCloudDeleteBucketCORSRequest.h"
#import "QCloudPutBucketACLRequest.h"
#import "QCloudGetBucketACLRequest.h"
#import "QCloudGetBucketLocationRequest.h"
#import "QCloudPutBucketCORSRequest.h"
#import "QCloudGetBucketCORSRequest.h"
#import "QCloudDeleteBucketRequest.h"
#import "QCloudPutBucketLoggingRequest.h"
#import "QCloudGetBucketLoggingRequest.h"
#import "QCloudPutBucketTaggingRequest.h"
#import "QCloudGetBucketTaggingRequest.h"
#import "QCloudDeleteBucketTaggingRequest.h"
#import "QCloudPutBucketInventoryRequest.h"
#import "QCloudGetBucketInventoryRequest.h"
#import "QCloudDeleteBucketInventoryRequest.h"
#import "QCloudListBucketInventoryConfigurationsRequest.h"
#import "QCloudSelectObjectContentRequest.h"
#import "QCloudCreateBucketConfiguration.h"
#import "QCloudGetGenerateSnapshotRequest.h"
#import "QCloudPutBucketAccelerateRequest.h"
#import "QCloudGetBucketAccelerateRequest.h"
#import "QCloudListBucketMultipartUploadsRequest.h"
#import "QCloudPutBucketLifecycleRequest.h"
#import "QCloudGetBucketLifecycleRequest.h"
#import "QCloudDeleteBucketLifeCycleRequest.h"
#import "QCloudLifecycleConfiguration.h"
#import "QCloudLifecycleRule.h"
#import "QCloudPutBucketVersioningRequest.h"
#import "QCloudGetBucketVersioningRequest.h"
#import "QCloudBucketReplicationConfiguation.h"
#import "QCloudPutBucketReplicationRequest.h"
#import "QCloudGetBucketReplicationRequest.h"
#import "QCloudDeleteBucketReplicationRequest.h"
#import "QCloudPutBucketWebsiteRequest.h"
#import "QCloudGetBucketWebsiteRequest.h"
#import "QCloudDeleteBucketWebsiteRequest.h"
#import "QCloudGetPresignedURLRequest.h"
#import "QCloudPutBucketDomainRequest.h"
#import "QCloudGetBucketDomainRequest.h"

#import "QCloudUploadPartCopyRequest.h"
#import "QCloudCOSXMLCopyObjectRequest.h"
#import "QCloudPostObjectRestoreRequest.h"
#import "QCloudRestoreRequest.h"
#import "QCloudListObjectVersionsRequest.h"
#import "QCloudGetObjectACLRequest.h"
#import "QCloudPutObjectRequest.h"
#import "QCloudInitiateMultipartUploadRequest.h"
#import "QCloudCOSTransferMangerService.h"
#import "QCloudAbortMultipfartUploadRequest.h"
#import "QCloudUploadPartRequest.h"
#import "QCloudCompleteMultipartUploadRequest.h"
#import "QCloudCOSXMLUploadObjectRequest.h"
#import "QCloudCOSXMLDownloadObjectRequest.h"
#import "QCloudUploadObjectResult.h"
#import "QCloudPutObjectACLRequest.h"
#import "QCloudDeleteObjectRequest.h"
#import "QCloudDeleteMultipleObjectRequest.h"
#import "QCloudListMultipartRequest.h"
#import "QCloudDeleteObjectInfo.h"
#import "QCloudDeleteInfo.h"
#import "QCloudLogManager.h"
#import "QCloudHeadObjectRequest.h"
#import "QCloudGetObjectRequest.h"
#import "QCloudGetObjectRequest+Custom.h"
#import "QCloudPutObjectRequest+Custom.h"
#import "QCloudOptionsObjectRequest.h"
#import "QCloudCopyObjectResult.h"
#import "QCloudPutObjectCopyRequest.h"
#import "QCloudAppendObjectRequest.h"
#import "QCloudGetBucketRefererRequest.h"
#import "QCloudPutBucketRefererRequest.h"
#import "QCloudGetBucketPolicyRequest.h"
#import "QCloudPutBucketPolicyRequest.h"
#import "QCloudDeleteBucketPolicyRequest.h"
#import "QCloudBucketPolicyResult.h"

//数据万象

#import "QCloudCIPicRecognitionRequest.h"
#import "QCloudQRCodeRecognitionRequest.h"
#import "QCloudCICloudDataOperationsRequest.h"
#import "QCloudGetFilePreviewRequest.h"
#import "QCloudGetFilePreviewHtmlRequest.h"
#import "QCloudCOSXMLService+ImageHelper.h"
#import "QCloudPutObjectWatermarkRequest.h"
#import "QCloudPutObjectWatermarkResult.h"
#import "QCloudPutObjectTaggingRequest.h"
#import "QCloudGetObjectTaggingRequest.h"
#import "QCloudDeleteObjectTaggingRequest.h"
#import "QCloudPutBucketIntelligentTieringRequest.h"
#import "QCloudGetBucketIntelligentTieringRequest.h"
#import "QCloudGetVideoRecognitionRequest.h"
#import "QCloudPostVideoRecognitionRequest.h"
#import "QCloudGetDescribeMediaBucketsRequest.h"
#import "QCloudGetMediaInfoRequest.h"
#import "QCloudGetAudioRecognitionRequest.h"
#import "QCloudPostAudioRecognitionRequest.h"
#import "QCloudGetTextRecognitionRequest.h"
#import "QCloudPostTextRecognitionRequest.h"
#import "QCloudGetDocRecognitionRequest.h"
#import "QCloudPostDocRecognitionRequest.h"
#import "QCloudGetWebRecognitionRequest.h"
#import "QCloudPostWebRecognitionRequest.h"
#import "QCloudBatchimageRecognitionRequest.h"

#endif /* QCloudCOSXML_h */

