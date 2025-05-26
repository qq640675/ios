//
//  WatchedModel.h
//  beijing
//
//  Created by 黎 涛 on 2019/7/10.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatchedModel : NSObject

@property (nonatomic , assign) NSInteger              t_id;
@property (nonatomic, assign) NSInteger t_cover_user_id;
@property (nonatomic, assign) NSInteger t_role;
@property (nonatomic , copy) NSString              * t_handImg;
@property (nonatomic , copy) NSString              * t_nickName;
@property (nonatomic , assign) int              isFollow;
@property (nonatomic , assign) NSInteger            t_create_time;
@property (nonatomic, copy) NSString *t_age;
@property (nonatomic, assign) int t_sex;

@property (nonatomic, assign) int isCoverFollow;

@end

NS_ASSUME_NONNULL_END
