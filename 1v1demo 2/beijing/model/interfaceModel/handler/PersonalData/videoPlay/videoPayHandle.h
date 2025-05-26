//
//  videoPayHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/24.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface videoPayHandle : NSObject

@property (nonatomic ,assign) int isSee;                  //是否查看过微信 0.未查看 1.已查看
@property (nonatomic ,strong) NSArray *labels;            //标签集
@property (nonatomic ,strong) NSString *t_addres_url;      //视频地址
@property (nonatomic ,strong) NSString *t_age;            //年龄
@property (nonatomic ,strong) NSString *t_city;            //所在城市
@property (nonatomic ,strong) NSString *t_handImg;         //用户头像
@property (nonatomic ,strong) NSString *t_nickName;        //用户昵称
@property (nonatomic ,assign) NSInteger t_score;           //用户评分
@property (nonatomic ,strong) NSString *t_video_img;       //视频封面地址
@property (nonatomic ,strong) NSString *t_weixin;          //微信号
@property (nonatomic ,strong) NSString *t_weixin_gold;   //查看微信金币数
@property (nonatomic ,strong) NSString *t_tittle;          //视频标题
@property (nonatomic ,assign) int t_see_count;            //视频查看次数
@property (nonatomic ,assign) int laudtotal;              //点赞数
@property (nonatomic ,assign) int isFollow;               //是否关注 0:未关注 1：已关注
@property (nonatomic ,assign) int t_onLine;               //在线状态 0.在线1.在聊2.离线
@property (nonatomic ,assign) int videoGold;               //视频金币
@property (nonatomic ,assign) int isLaud;                 //当前用户是否给查看人点赞 0:未点赞 1.已点赞

@property (nonatomic, assign) NSInteger t_sex;
@property (nonatomic, assign) NSInteger t_voice_gold;
@property (nonatomic, copy) NSString *fans;

@property (nonatomic ,copy) NSDictionary    *bigRoomData;

@end
