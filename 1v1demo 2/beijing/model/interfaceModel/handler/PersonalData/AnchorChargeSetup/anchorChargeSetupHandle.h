//
//  anchorChargeSetupHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/13.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface anchorChargeSetupHandle : NSObject

@property (nonatomic ,strong) NSString *t_user_id;         //数据编号
@property (nonatomic ,strong) NSString *t_phone_gold;         //查看手机号金币
@property (nonatomic ,strong) NSString *t_private_photo_gold;         //私密照片金币
@property (nonatomic ,strong) NSString *t_private_video_gold;         //文件地址
@property (nonatomic ,strong) NSString *t_text_gold;         //文字私聊
@property (nonatomic ,strong) NSString *t_video_gold;         //视频聊天
@property (nonatomic, copy) NSString *t_voice_gold;
@property (nonatomic ,strong) NSString *t_weixin_gold;         //查看微信号金币
@property (nonatomic, copy) NSString *t_qq_gold;

//请求后台收费设置数据
@property (nonatomic ,assign) int t_project_type;  // 5.视频聊天6.文字聊天7.查看手机号8.查看微信号9查看私密照片10.查看私密视频
@property (nonatomic ,strong) NSString *t_extract_ratio;   //收费设置范围

@end
