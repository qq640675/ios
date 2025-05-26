//
//  personalCenterHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/9.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface personalCenterHandle : NSObject

@property (nonatomic ,strong) NSString *amount;    //总金额
@property (nonatomic ,strong) NSString *handImg;   //头像
@property (nonatomic ,strong) NSString *nickName;  //昵称
@property (nonatomic ,strong) NSString *endTime;  //时间
@property (nonatomic ,strong) NSString *t_idcard;  //新游山号
@property (nonatomic ,strong) NSString *t_phone; //手机
@property (nonatomic ,assign) int t_sex;  //性别
@property (nonatomic ,assign) int t_age;  //年龄
@property (nonatomic ,assign) int spprentice;//徒弟数


@property (nonatomic ,assign) int t_is_not_disturb;  //免打扰
@property (nonatomic, assign) NSInteger t_voice_switch; //语音
@property (nonatomic, assign) NSInteger t_text_switch;//私聊
@property (nonatomic, assign) NSInteger t_float_switch;//飘屏
@property (nonatomic, assign) NSInteger t_rank_switch;//榜单
@property (nonatomic ,assign) int t_is_vip;  //vip
@property (nonatomic ,assign) int t_role;  //是否是主播
@property (nonatomic ,assign) int isGuild;  //是否申请公会 0.未申请 1.审核中2.已通过
@property (nonatomic ,assign) int isApplyGuild; //是否加入公会 0.未加入 1.已加入
@property (nonatomic ,assign) int isCps;  //cps -1.未申请 0.审核中1.已通过 2.已下架
@property (nonatomic ,strong) NSString *guildName;  //公会名称(用户申请了公会或者加入了公会才会存在)
@property (nonatomic ,strong) NSString *t_autograph;  //个性签名
@property (nonatomic ,copy) NSString *extractGold;  //可提现金币
@property (nonatomic ,assign) NSInteger albumCount;
@property (nonatomic ,assign) NSInteger dynamCount;
@property (nonatomic ,assign) NSInteger followCount;

@property (nonatomic, assign) NSInteger videoIdentity;
@property (nonatomic, assign) NSInteger phoneIdentity;
@property (nonatomic, assign) NSInteger idcardIdentity;

@property (nonatomic, assign) NSInteger browerCount;
@property (nonatomic, assign) NSInteger likeMeCount;
@property (nonatomic, assign) NSInteger myLikeCount;
@property (nonatomic, assign) NSInteger eachLikeCount;

//lsl update start
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, assign) NSInteger goldLevel;
@property (nonatomic, copy) NSString *t_cover_img;
@property (nonatomic, copy) NSString *t_addres_url;
@property (nonatomic, copy) NSString *t_video_img;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *t_city;
@property (nonatomic ,copy) NSString *t_vocation;
//lsl update end 

@end
