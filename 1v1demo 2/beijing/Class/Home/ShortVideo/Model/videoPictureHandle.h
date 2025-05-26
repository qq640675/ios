//
//  videoPictureHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface videoPictureHandle : NSObject

@property (nonatomic ,strong) NSString *t_addres_url;       //图片或者视频地址
@property (nonatomic ,assign) int     t_file_type;         //文件类型 0.图片 1.视频
@property (nonatomic ,strong) NSString *t_handImg;          //头像地址
@property (nonatomic ,assign) int t_id;                    //数据编号
@property (nonatomic ,assign) int t_is_private;            //是否私密：0.否1.是
@property (nonatomic ,assign) int is_see;                  //是否查看：0.否1.是
@property (nonatomic ,strong) NSString *t_money;            //金币(可能为空)
@property (nonatomic ,strong) NSString *t_nickName;         //昵称
@property (nonatomic ,strong) NSString *t_title;            //标题
@property (nonatomic ,strong) NSString *t_video_img;        //视频封面
@property (nonatomic ,assign) int pageCount;              //页码

@end
