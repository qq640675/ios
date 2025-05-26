//
//  distanceHandle.h
//  beijing
//
//  Created by zhou last on 2018/12/4.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface distanceHandle : NSObject

@property (nonatomic ,assign) int t_id;     //用户ID
@property (nonatomic ,assign) int t_onLine; //在线状态
@property (nonatomic ,assign) int t_role;   //角色
@property (nonatomic ,assign) int t_sex;   //性别
@property (nonatomic ,assign) int page;   //页码
@property (nonatomic, assign) BOOL isFollow;

@property (nonatomic ,strong) NSString *t_age;    //年龄
@property (nonatomic ,strong) NSString *t_nickName;  //昵称
@property (nonatomic ,strong) NSString *t_vocation;  //职业
@property (nonatomic ,strong) NSString *distance;    //距离
@property (nonatomic ,strong) NSString *t_autograph; //个性签名
@property (nonatomic ,strong) NSString *t_handImg;   //头像
@property (nonatomic, copy) NSString *t_height;
@property (nonatomic, assign) int t_is_vip;

@end

NS_ASSUME_NONNULL_END
