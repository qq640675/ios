//
//  PersonalDataHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/2.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalDataHandle : NSObject


@property (nonatomic ,strong) NSArray *lable; //标签数组
@property (nonatomic ,strong) NSString *t_autograph; //个性签名
@property (nonatomic ,strong) NSString *t_city;
@property (nonatomic ,strong) NSString *t_constellation;
@property (nonatomic ,strong) NSString *t_height;
@property (nonatomic ,strong) NSString *t_nickName;
@property (nonatomic ,strong) NSString *t_phone;
@property (nonatomic ,strong) NSString *t_synopsis;
@property (nonatomic ,strong) NSString *t_vocation;
@property (nonatomic ,strong) NSString *t_weight;
@property (nonatomic ,strong) NSString *t_weixin;
@property (nonatomic ,strong) NSString *t_qq;
@property (nonatomic ,strong) NSString *t_age;
@property (nonatomic ,strong) NSString *t_handImg;
@property (nonatomic ,strong) NSString *lables;
@property (nonatomic ,strong) NSString *t_addres_url;//视频地址
@property (nonatomic ,strong) NSString *t_video_img;//视频封面地址
@property (nonatomic ,strong) NSArray  *coverList; //封面数组
@property (nonatomic ,strong) NSString *balance;  //用户余额

@property (nonatomic ,assign) int t_idcard; //新游山号
@property (nonatomic ,assign) int t_role; //用户角色:0.普通用户 1.主播
@property (nonatomic ,assign) int t_onLine; //是否在线 0.在线1.离线
@property (nonatomic ,assign) int goldLevel;//用户等级
@property (nonatomic ,strong) NSString *t_reception;//接听率
@property (nonatomic ,strong) NSString *t_label_name;//标签名称
@property (nonatomic ,assign) int t_user_lable_id; //标签ID
@property (nonatomic ,strong) NSString *t_login_time;//登录时间

@property (nonatomic, copy) NSString *t_marriage;

//lsl update start
@property (nonatomic, copy) NSString *t_cover_img;
//lsl update end 

@property (nonatomic, assign) NSUInteger    isFollow;


@end
