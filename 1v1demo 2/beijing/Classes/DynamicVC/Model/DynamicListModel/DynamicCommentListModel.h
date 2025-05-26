//
//  DynamicCommentListModel.h
//  beijing
//
//  Created by yiliaogao on 2019/1/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicCommentListModel : SLBaseListModel

@property (nonatomic, assign) NSInteger t_id;
@property (nonatomic, assign) NSInteger t_sex;//0:女 1:男
@property (nonatomic, assign) NSInteger t_create_time;
@property (nonatomic, assign) NSInteger comType;
@property (nonatomic, assign) NSInteger comId;

@property (nonatomic, copy) NSString    *t_handImg;
@property (nonatomic, copy) NSString    *t_nickName;
@property (nonatomic, copy) NSString    *t_comment;

@end

NS_ASSUME_NONNULL_END
