//
//  godnessInfoHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/6.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface godnessInfoHandle : NSObject

@property (nonatomic ,assign) int isFollow;       //是否关注 0.未关注 1.已关注
@property (nonatomic ,strong) NSArray *lable;       //标签
@property (nonatomic ,strong) NSArray *lunbotu;       //轮播图
@property (nonatomic ,strong) NSString *t_autograph;  //个性签名
@property (nonatomic ,strong) NSString *t_city;  //城市
@property (nonatomic ,strong) NSString *t_constellation;  //星座
@property (nonatomic ,strong) NSArray *anchorSetup;  //查看手机号，微信，视频聊天金币数
@property (nonatomic ,strong) NSString *t_handImg;  //头像
@property (nonatomic ,strong) NSString *t_height;  //身高
@property (nonatomic ,strong) NSString *t_login_time;  //登录时间
//@property (nonatomic, copy) NSString *t_last_request_time;//最近活跃时间
@property (nonatomic ,strong) NSString *t_nickName;  //昵称
@property (nonatomic ,assign) int  t_onLine;  //是否在线 0.在线1.离线
@property (nonatomic ,strong) NSString *t_phone;  //手机号
@property (nonatomic ,strong) NSString *t_reception;  //接听率
@property (nonatomic ,strong) NSString *t_vocation;  //职业
@property (nonatomic ,strong) NSString *t_weixin;  //微信
@property (nonatomic, copy) NSString *t_qq;
@property (nonatomic ,strong) NSString *t_weight;  //体重
@property (nonatomic ,assign) int totalCount;  //粉丝数
@property (nonatomic ,assign) int t_idcard;       //新游山号
@property (nonatomic ,assign) int isPhone;       //是否查看手机号
@property (nonatomic ,assign) int isWeixin;       //是否查看微信号
@property (nonatomic, assign) int isQQ;
@property (nonatomic ,assign) int t_age;   //年龄
@property (nonatomic ,assign) NSInteger t_role; //用户角色
@property (nonatomic ,assign) NSInteger t_sex;
@property (nonatomic ,copy) NSDictionary    *bigRoomData; //直播中

@property (nonatomic, copy) NSString *t_marriage;//婚姻
@property (nonatomic, assign) BOOL isGreet;//是否打过招呼

@property (nonatomic ,assign) int videoIdentity;       //是否查看微信号
@property (nonatomic, assign) int phoneIdentity;
@property (nonatomic ,assign) int idcardIdentity;   //年龄

@property (nonatomic, assign) BOOL t_is_vip;
@property (nonatomic, copy) NSString *t_score;
@property (nonatomic, assign) BOOL t_is_not_disturb;//视频开关  1开启
@property (nonatomic, copy) NSString *t_called_video;//接单量

@end
