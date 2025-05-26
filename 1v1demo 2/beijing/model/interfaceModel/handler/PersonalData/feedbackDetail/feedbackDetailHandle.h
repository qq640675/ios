//
//  feedbackDetailHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface feedbackDetailHandle : NSObject

@property (nonatomic ,strong) NSString *t_content;       //反馈内容
@property (nonatomic ,strong) NSString *t_create_time;    //反馈时间
@property (nonatomic ,strong) NSString *t_img_url;      //反馈图片
@property (nonatomic ,strong) NSString *t_handle_res;    //回复内容
@property (nonatomic ,strong) NSString *t_handle_time;    //回复时间
@property (nonatomic ,strong) NSString *t_handle_img;    //回复图片
@property (nonatomic ,assign) int t_is_handle;          //是否处理 0.未处理 1.已处理


@end
