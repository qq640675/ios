//
//  UserMatchingAnchorModel.h
//  beijing
//
//  Created by yiliaogao on 2019/2/19.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserMatchingAnchorModel : SLBaseListModel

@property (nonatomic, assign) NSUInteger    t_idcard;
@property (nonatomic, assign) NSUInteger    t_age;
@property (nonatomic, assign) NSUInteger    t_id;
@property (nonatomic, assign) NSUInteger    isFollow;
@property (nonatomic, assign) NSUInteger    roomId;

@property (nonatomic, copy) NSString        *t_handImg;
@property (nonatomic, copy) NSString        *t_nickName;
@property (nonatomic, copy) NSString        *t_city;
@property (nonatomic, copy) NSString        *t_autograph;
@property (nonatomic, copy) NSString        *t_vocation;
@property (nonatomic, copy) NSString        *rtmp;

@end

NS_ASSUME_NONNULL_END
