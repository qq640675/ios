//
//  DynamicFileModel.h
//  beijing
//
//  Created by yiliaogao on 2018/12/28.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicFileModel : SLBaseListModel

@property (nonatomic, assign) NSInteger t_id;
@property (nonatomic, assign) NSInteger t_file_type;
@property (nonatomic, assign) NSInteger t_gold;

@property (nonatomic, copy) NSString    *t_cover_img_url;
@property (nonatomic, copy) NSString    *t_file_url;
@property (nonatomic, copy) NSString    *t_video_time;

@property (nonatomic, assign) BOOL      isConsume;
@property (nonatomic, assign) BOOL      isPrivate;

@end

NS_ASSUME_NONNULL_END
