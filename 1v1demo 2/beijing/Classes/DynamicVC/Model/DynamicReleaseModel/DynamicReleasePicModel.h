//
//  DynamicReleasePicModel.h
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

typedef  NS_ENUM(NSUInteger,FileDataType) {
    FileDataType_Pic = 0,//图片
    FileDataType_Video = 1,//视频
    FileDataType_Other = 2 //其他
};

NS_ASSUME_NONNULL_BEGIN

@interface DynamicReleasePicModel : SLBaseListModel

@property (nonatomic, strong) NSMutableArray    *picModelArray;

@property (nonatomic, assign) FileDataType      fileDataType;

@end

NS_ASSUME_NONNULL_END
