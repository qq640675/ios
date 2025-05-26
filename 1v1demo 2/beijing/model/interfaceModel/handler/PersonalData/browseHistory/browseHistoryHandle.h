//
//  browseHistoryHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/9.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface browseHistoryHandle : NSObject

@property (nonatomic ,assign) int t_id;     //用户id
@property (nonatomic ,strong) NSString *t_handImg;     //用户头像
@property (nonatomic ,strong) NSString *t_nickName;    //昵称
@property (nonatomic ,strong) NSString *t_create_time; //浏览时间
@property (nonatomic ,assign) int pageCount;     //页码

@end
