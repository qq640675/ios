//
//  DynamicMsgListModel.h
//  beijing
//
//  Created by yiliaogao on 2019/1/18.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicMsgListModel : SLBaseListModel

@property (nonatomic, assign) NSInteger t_id;
@property (nonatomic, assign) NSInteger t_dynamic_id;
@property (nonatomic, assign) NSInteger dynamic_type;
@property (nonatomic, assign) NSInteger t_create_time;

@property (nonatomic, copy)   NSString  *t_nickName;
@property (nonatomic, copy)   NSString  *t_handImg;
@property (nonatomic, copy)   NSString  *t_comment;
@property (nonatomic, copy)   NSString  *t_cover_img_url;
@property (nonatomic, copy)   NSString  *dynamic_com;

@end

NS_ASSUME_NONNULL_END
