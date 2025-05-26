//
//  fansListHandle.h
//  beijing
//
//  Created by zhou last on 2018/8/31.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fansListHandle : NSObject

@property (nonatomic ,assign) int t_id;       //粉丝id
@property (nonatomic ,assign) int t_sex;      //性别

@property (nonatomic ,copy) NSString *balance;    //余额
@property (nonatomic ,assign) int grade;    //余额
@property (nonatomic ,assign) int goldfiles;  //金币等级
@property (nonatomic ,assign) int t_is_vip;   //vip等级

@property (nonatomic ,strong) NSString *t_create_time; //时间
@property (nonatomic ,strong) NSString *t_handImg; //头像
@property (nonatomic ,strong) NSString *t_nickName; //昵称

@property (nonatomic ,assign) int pageCount;   //页码

@property (nonatomic ,assign) int t_onLine; //在线状态
@property (nonatomic, copy) NSString *t_height;
@property (nonatomic, copy) NSString *t_autograph;
@property (nonatomic, copy) NSString *t_vocation;
@property (nonatomic, copy) NSString *t_age;



@end
