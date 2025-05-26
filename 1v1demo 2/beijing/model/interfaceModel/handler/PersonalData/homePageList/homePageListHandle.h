//
//  homePageListHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/6.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homePageListHandle : NSObject

@property (nonatomic ,strong) NSString *t_age;       //年龄
@property (nonatomic ,strong) NSString *t_city;       //所在地
@property (nonatomic ,strong) NSString *t_cover_img;  //封面图片
@property (nonatomic ,strong) NSString *t_handImg;   //头像
@property (nonatomic ,assign) int t_id;             //用户编号
@property (nonatomic ,strong) NSString *t_nickName;  //昵称
@property (nonatomic ,strong) NSString *t_vocation; //职业
@property (nonatomic ,assign) int t_is_public;      //该主播是否存在免费视频0.不存在1.存在
@property (nonatomic ,strong) NSString *t_score;     //评价
@property (nonatomic ,strong) NSString *t_state;     //主播状态(0.在线1.在聊2.离线)
@property (nonatomic ,assign) int t_user_type;     //
@property (nonatomic ,assign) int t_video_gold;     //视频聊天金币数
@property (nonatomic ,assign) int pageCount;       //页码
@property (nonatomic ,assign) int t_is_nominate;       //
@property (nonatomic ,strong) NSString *t_autograph;  //签名

@property (nonatomic, copy) NSString *t_addres_url; //视频地址


@end
