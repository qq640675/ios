//
//  newAlbumHandle.h
//  beijing
//
//  Created by zhou last on 2018/10/30.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface newAlbumHandle : NSObject

@property (nonatomic ,assign) int t_id;  //文件编号
@property (nonatomic ,assign) int t_auditing_type;  //审核状态 0.未审核1.已审核2.审核失败
@property (nonatomic ,assign) int t_money;  //收费数
@property (nonatomic ,assign) int t_file_type;  //文件类型0.图片1.视频
@property (nonatomic ,assign) int total;  //当前月相册总数
@property (nonatomic ,strong) NSString *t_addres_url; //文件地址
@property (nonatomic ,strong) NSString *t_video_img; //视频封面
@property (nonatomic ,assign) int month;  //月
@property (nonatomic ,strong) NSMutableArray *albumArray; //相册数组
@property (nonatomic, assign) int t_is_first;




@end

NS_ASSUME_NONNULL_END
