//
//  rankingHandle.h
//  beijing
//
//  Created by zhou last on 2018/9/30.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface rankingHandle : NSObject

@property (nonatomic ,assign) int t_id;      //用户编号
@property (nonatomic ,assign) long long gold;      //金币数
@property (nonatomic ,assign) int t_idcard;  //新游山号
@property (nonatomic ,assign) long long newGold; //距离上一名多少金币

@property (nonatomic ,strong) NSString *t_handImg; //头像
@property (nonatomic ,strong) NSString *t_nickName; //昵称

//主播收益详情
@property (nonatomic ,assign) int t_change_category;  //1.文字聊天 2.视频聊天 3.私密照片 4.私密照片 5.查看手机 6.查看微信
@property (nonatomic, assign) int t_role;
@property (nonatomic, assign) BOOL t_rank_switch;//排行榜隐身了的  神秘人
@property (nonatomic, assign) int rankNum;
@property (nonatomic, assign) int t_rank_gold;//奖励金币数
@property (nonatomic, assign) BOOL t_is_receive;//是否领取
@property (nonatomic, assign) int rankRewardId;


@property (nonatomic, assign) NSInteger t_rank_reward_type;
@property (nonatomic, assign) NSInteger t_rank_time_type;
@property (nonatomic, assign) int t_rank_sort;
@property (nonatomic, copy) NSString *t_title;


@end

NS_ASSUME_NONNULL_END
