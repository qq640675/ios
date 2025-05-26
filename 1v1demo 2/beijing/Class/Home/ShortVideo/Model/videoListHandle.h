//
//  videoListHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/30.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface videoListHandle : NSObject

@property (nonatomic ,assign) int pageCount;               //总页码
@property (nonatomic ,strong) NSString *t_is_private;       //是否私密 0.否1.是
@property (nonatomic ,strong) NSString *t_handImg;          //用户头像
@property (nonatomic ,strong) NSString *t_money;            //视频价格
@property (nonatomic ,strong) NSString *t_addres_url;       //视频地址
@property (nonatomic ,strong) NSString *t_nickName;         //用户昵称
@property (nonatomic ,strong) NSString *t_title;            //视频标题
@property (nonatomic ,strong) NSString *t_video_img;        //视频封面
@property (nonatomic ,assign) int     is_see;              //是否已看过：0.未查看 1.已查看
@property (nonatomic ,assign) int     t_user_id;           //视频发布人编号
@property (nonatomic ,assign) int     t_id;           //视频编号


@end
