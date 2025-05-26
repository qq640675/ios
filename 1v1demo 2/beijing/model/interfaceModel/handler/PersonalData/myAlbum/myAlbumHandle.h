//
//  myAlbumHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/11.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myAlbumHandle : NSObject

@property (nonatomic ,strong) NSString *t_addres_url;         //文件地址
@property (nonatomic ,strong) NSString *t_auditing_type;         //文件状态 0.审核中1.已通过2.审核失败 (私密图片存在)
@property (nonatomic ,strong) NSString *t_file_type;         //文件类型:0.图片 1.视频
@property (nonatomic ,strong) NSString *t_id;              //文件编号
@property (nonatomic ,strong) NSString *t_is_private;         //是否私密 0.否 1.是
@property (nonatomic ,strong) NSString *t_money;         //金币 (私密图片存在)
@property (nonatomic ,strong) NSString *t_title;         //文件标题
@property (nonatomic ,strong) NSString *t_video_img;         //视频封面



@end
