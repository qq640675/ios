//
//  conversationHandle.h
//  beijing
//
//  Created by zhou last on 2018/10/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface conversationHandle : NSObject

@property (nonatomic ,assign) int t_id;  //id
@property (nonatomic ,assign) int t_idcard;  //新游山号
@property (nonatomic ,assign) int callType;  //呼叫类型：1.呼出 2.呼入
@property (nonatomic ,assign) int pageCount;  //总页码
@property (nonatomic ,assign) int t_role;

@property (nonatomic ,strong) NSString *t_handImg; //头像
@property (nonatomic ,strong) NSString *t_create_time; //头像
@property (nonatomic ,strong) NSString *t_call_time; //通话时间 为null 则电话未接听
@property (nonatomic ,strong) NSString *t_nickName; //昵称



@end

NS_ASSUME_NONNULL_END
