//
//  sytemMsgHandle.h
//  beijing
//
//  Created by zhou last on 2018/8/7.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sytemMsgHandle : NSObject

@property (nonatomic ,strong) NSString *t_create_time;       //消息时间
@property (nonatomic ,strong) NSString *t_id;                //消息id
@property (nonatomic ,strong) NSString *t_is_see;            //是否查看
@property (nonatomic ,strong) NSString *t_message_content;   //消息内容
@property (nonatomic ,assign) int     pageCount;            //页码
@property (nonatomic, copy) NSString *t_message_url;

@end
