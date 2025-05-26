//
//  userCommentHandle.h
//  beijing
//
//  Created by zhou last on 2018/8/27.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userCommentHandle : NSObject

@property (nonatomic ,assign) int t_user_id;          //用户id
@property (nonatomic ,strong) NSString *t_label_name;          //标签名
@property (nonatomic ,strong) NSString *t_user_hand;          //头像
@property (nonatomic ,strong) NSString *t_user_nick;          //昵称


@end
