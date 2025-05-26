//
//  DynamicListModel.h
//  beijing
//
//  Created by yiliaogao on 2018/12/27.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"
#import "DynamicFileModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicListModel : SLBaseListModel

@property (nonatomic, assign) NSInteger t_id;
@property (nonatomic, assign) NSInteger t_sex;
@property (nonatomic, assign) NSInteger t_age;
@property (nonatomic, assign) NSInteger t_dynamicId;
@property (nonatomic, assign) NSInteger t_create_time;
@property (nonatomic, assign) NSInteger t_praiseCount;
@property (nonatomic, assign) NSInteger t_commentCount;

@property (nonatomic, assign) BOOL      isPraise;
@property (nonatomic, assign) BOOL      isFollow;
@property (nonatomic, assign) BOOL      isOpen;
@property (nonatomic, assign) BOOL      isHaveAddress;
//自己看自己的动态
@property (nonatomic, assign) BOOL      isMine;

//主播详情动态
@property (nonatomic, assign) BOOL      isAnchorDetail;

@property (nonatomic, copy) NSString    *t_content;
@property (nonatomic, copy) NSString    *t_address;
@property (nonatomic, copy) NSString    *t_nickName;
@property (nonatomic, copy) NSString    *t_handImg;

@property (nonatomic, copy) NSArray     *fileArrays;



@end

NS_ASSUME_NONNULL_END
