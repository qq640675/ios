//
//  newAnchorHandle.h
//  beijing
//
//  Created by zhou last on 2018/12/18.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface newAnchorHandle : NSObject

@property (nonatomic ,assign) int isFollow;   //是否关注
@property (nonatomic ,strong) NSString *t_age;      //年龄
@property (nonatomic ,assign) int t_id;      //主播id
@property (nonatomic ,assign) int t_idcard;      //id号
@property (nonatomic ,assign) int t_onLine;      //在线状态
@property (nonatomic ,assign) int t_role;      //是否是主播
@property (nonatomic ,assign) int t_sex;      //性别

@property (nonatomic ,strong) NSString *t_autograph;    //个性签名
@property (nonatomic ,strong) NSString *t_handImg;    //头像
@property (nonatomic ,strong) NSString *t_vocation;    //职业
@property (nonatomic ,strong) NSString *t_lat;    //经度
@property (nonatomic ,strong) NSString *t_lng;    //纬度
@property (nonatomic ,strong) NSString *t_nickName;  //昵称
@property (nonatomic ,strong) NSString *distance;    //距离

@end

NS_ASSUME_NONNULL_END
