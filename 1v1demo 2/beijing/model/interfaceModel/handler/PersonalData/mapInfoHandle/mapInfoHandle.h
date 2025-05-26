//
//  mapInfoHandle.h
//  beijing
//
//  Created by zhou last on 2018/12/18.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface mapInfoHandle : NSObject

@property (nonatomic ,assign) int t_onLine;   //在线状态 0.在线 1.离线
@property (nonatomic ,assign) int t_sex;   //性别
@property (nonatomic ,assign) int t_user_id;   //用户id
@property (nonatomic ,strong) NSString *t_lat;    //经度
@property (nonatomic ,strong) NSString *t_lng;    //纬度
@property (nonatomic ,strong) NSString *t_handImg;    //头像
@property (nonatomic ,strong) NSString *title;    //


@end

NS_ASSUME_NONNULL_END
