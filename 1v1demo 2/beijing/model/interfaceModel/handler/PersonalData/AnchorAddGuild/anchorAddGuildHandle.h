//
//  anchorAddGuildHandle.h
//  beijing
//
//  Created by zhou last on 2018/9/15.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLBaseListModel.h"

@interface anchorAddGuildHandle : SLBaseListModel

@property (nonatomic ,assign) int t_id;  //公会编号
@property (nonatomic ,strong) NSString *t_admin_name; //公会拥有者
@property (nonatomic ,strong) NSString *t_guild_name; //公会名称

//公会主播贡献明细统计
@property (nonatomic ,assign) int t_devote_value;  //总贡献
@property (nonatomic ,assign) int toDay;           //今日贡献
@property (nonatomic ,strong) NSString *t_handImg;  //头像
@property (nonatomic ,strong) NSString *t_nickName; //昵称

//公会主播贡献明细列表
@property (nonatomic ,assign) int pageCount;       //页码
@property (nonatomic ,assign) int totalGold;       //贡献金币
@property (nonatomic ,assign) int t_change_category;       //公会贡献
@property (nonatomic ,strong) NSString *t_change_time; //昵称
@property (nonatomic ,assign) int totalCount;       //总人数
@property (nonatomic ,assign) int userCount; //首冲人数

@property (nonatomic ,assign) NSInteger type; //1奖励排行 2人数排行

@property (nonatomic ,assign) NSInteger index; //排行数字



@end
