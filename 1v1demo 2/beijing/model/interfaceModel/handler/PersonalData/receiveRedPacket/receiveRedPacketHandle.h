//
//  receiveRedPacketHandle.h
//  beijing
//
//  Created by zhou last on 2018/8/8.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface receiveRedPacketHandle : NSObject

@property (nonatomic ,strong) NSString *t_redpacket_content;       //红包
@property (nonatomic ,strong) NSString *t_redpacket_type;       //红包类型
@property (nonatomic ,assign) int t_redpacket_gold;       //红包金币
@property (nonatomic ,strong) NSString *t_create_time;       //时间
@property (nonatomic ,strong) NSString *t_handImg;       //头像
@property (nonatomic ,strong) NSString *t_nickName;       //昵称

@end
