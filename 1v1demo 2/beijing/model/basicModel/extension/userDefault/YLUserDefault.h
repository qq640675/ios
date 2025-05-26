//
//  YLUserDefault.h
//  beijing
//
//  Created by zhou last on 2018/7/2.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YLUserDefault : NSObject

@property (nonatomic ,assign) int gold;
@property (nonatomic ,assign) int t_id;
@property (nonatomic ,assign) int t_role;
@property (nonatomic ,assign) int t_sex;
@property (nonatomic ,assign) BOOL t_is_vip;
@property (nonatomic ,assign) int roomId;
@property (nonatomic ,assign) BOOL isFirstInstall;
@property (nonatomic ,assign) BOOL appOnBack;//是否在后台
@property (nonatomic ,assign) BOOL connectOnLine;//是否在通话
@property (nonatomic ,assign) BOOL socketOnLine;//socket是否在线
@property (nonatomic ,assign) BOOL eula;//是否同意协议
@property (nonatomic ,assign) BOOL online; //上线
@property (nonatomic ,assign) BOOL openLocalVideo; //是否开启本地流
@property (nonatomic ,assign) BOOL msgAudio;//消息提示音
@property (nonatomic ,assign) BOOL msgVibrate;//消息提示震动
@property (nonatomic ,assign) BOOL groupMsgAudio;//群消息提示音
@property (nonatomic ,assign) BOOL groupMsgVibrate;//群消息提示震动


@property (nonatomic ,strong) UIImage *headImage;
@property (nonatomic ,strong) NSString *phone;
@property (nonatomic ,strong) NSString *style;
@property (nonatomic ,strong) NSString *qqCustomer;
@property (nonatomic ,strong) NSDictionary *socketdic;
@property (nonatomic, copy) NSString *t_nickName;
@property (nonatomic, copy) NSString *t_city;



+ (YLUserDefault *)userDefault;

//保存用户信息
+ (void)saveUserDefault:(NSString *)gold t_id:(NSString *)t_id t_is_vip:(NSString *)t_is_vip t_role:(NSString *)t_role;

//性别
+ (void)saveSex:(NSString *)t_sex;

+ (void)saveNickName:(NSString *)nickName;

//电话
+ (void)savePhone:(NSString *)phone;

//第一次安装应用
+ (void)saveAppInstall:(BOOL)isFirst;

//主播风格
+ (void)saveStyle:(NSString *)style;

//本地视频流
+ (void)saveLocalVideo:(BOOL)isLocal;

//消息提示音
+ (void)saveMsgAudio:(BOOL)isOn;

//消息震动
+ (void)saveMsgVibrate:(BOOL)isOn;

//群消息提示音
+ (void)saveGroupMsgAudio:(BOOL)isOn;

//群消息震动
+ (void)saveGroupMsgVibrate:(BOOL)isOn;

//连接状态
+ (void)saveConnet:(BOOL)isConnect;

//房间号信息
+ (void)saveAppOnBack:(BOOL)isOn roomId:(int)roomId socketOnLine:(BOOL)socketOnLine;

//头像
+ (void)saveHeadImage:(UIImage *)image;

//角色
+ (void)saveRole:(int)t_role;

//vip
+ (void)saveVip:(BOOL)t_is_vip;



//客服qq
+ (void)saveQQCustomer:(NSString *)qqNum;

//协议
+ (void)saveEULA:(BOOL)EULA;

//在线状态
+ (void)saveOnLine:(NSString *)online;

+ (void)saveDic:(NSDictionary *)dic;

+ (void)saveCity:(NSString *)city;

@end
