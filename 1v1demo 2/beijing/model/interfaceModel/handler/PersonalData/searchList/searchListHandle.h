//
//  searchListHandle.h
//  beijing
//
//  Created by zhou last on 2018/8/30.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface searchListHandle : NSObject

@property (nonatomic ,assign) int fansCount;      //粉丝数量
@property (nonatomic ,assign) int isFollow;       //是否关注：0.未关注 1.已关注
@property (nonatomic ,assign) int t_id;           //id
@property (nonatomic ,assign) int t_is_public;    //是否存在公共视频:0.不存在 1.存在
@property (nonatomic ,strong) NSString *t_handImg; //头像
@property (nonatomic ,strong) NSString *t_nickName;//用户昵称
@property (nonatomic ,assign) int t_state;        //状态0.在线1.在聊2.离线
@property (nonatomic ,assign) int t_role;

@property (nonatomic ,assign) int t_onLine;   

@end
