//
//  attentionInfoHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/6.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface attentionInfoHandle : NSObject

@property (nonatomic ,strong) NSString *avgScore;  //评价成绩
@property (nonatomic ,strong) NSString *t_age;  //年龄
@property (nonatomic ,strong) NSString *t_city;  //城市
@property (nonatomic ,strong) NSString *t_autograph;
@property (nonatomic ,strong) NSString *t_cover_follow;
@property (nonatomic ,strong) NSString *t_cover_img;  //个性签名
@property (nonatomic ,strong) NSString *t_handImg;  //头像
@property (nonatomic ,assign) int t_id;  //被关注人编号
@property (nonatomic ,strong) NSString *t_nickName;  //昵称
@property (nonatomic ,assign) int pageCount;  //页码

//同城列表需要
@property (nonatomic ,assign) int t_state;  //用户状态 0.在线1.在聊2.离线
@property (nonatomic ,assign) int t_is_public;  //是否存在公共视频 0.无 1.存在

@property (nonatomic, assign) int isFollow; //是否我关注了他
@property (nonatomic, assign) int isCoverFollow; //是否他关注了我
@property (nonatomic, assign) int t_sex;
@property (nonatomic, assign) NSInteger t_create_time;
@property (nonatomic, assign) int t_role;

@end
